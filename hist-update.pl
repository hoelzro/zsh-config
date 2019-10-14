#!/usr/bin/env perl

use strict;
use warnings;
use feature qw(say);
use experimental qw(signatures);

use DBI;
use File::Basename qw(dirname);
use File::Path qw(make_path);

exit unless $ENV{'HISTFILE'};

my ( undef, undef, undef, $day, $month, $year ) = localtime;

$month++;
$year += 1_900;

# XXX you *could* have a command that runs over midnight and thus tries to update the wrong DB
my $database = sprintf('%s.d/%04d-%02d-%02d.db', $ENV{'HISTFILE'},
    $year, $month, $day);

my $database_dir = dirname($database);

make_path($database_dir);

my $dbh = DBI->connect("dbi:SQLite:dbname=$database", undef, undef, {
    RaiseError => 1,
    PrintError => 0,
}); # XXX don't freak out if you can't connect

my ( $hostname, $session_id, $target_history_id, $current_time, $exit_status ) = @ARGV;

my $update_sth = $dbh->prepare(<<'END_SQL');
UPDATE history SET duration = :current_time - timestamp, exit_status = :status
WHERE hostname   = :hostname
AND   session_id = :session_id
AND   history_id = :history_id

AND duration IS NULL
END_SQL

# XXX bind types?
$update_sth->bind_param(':hostname'     => $hostname);
$update_sth->bind_param(':session_id'   => $session_id);
$update_sth->bind_param(':history_id'   => $target_history_id);
$update_sth->bind_param(':current_time' => $current_time);
$update_sth->bind_param(':status'       => $exit_status);

$update_sth->execute;
