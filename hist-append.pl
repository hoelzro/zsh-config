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

my $database = sprintf('%s.d/%04d-%02d-%02d.db', $ENV{'HISTFILE'},
    $year, $month, $day);

my $database_dir = dirname($database);

make_path($database_dir);

my $dbh = DBI->connect("dbi:SQLite:dbname=$database", undef, undef, {
    RaiseError => 1,
    PrintError => 0,
});

$dbh->do(<<'END_SQL');
CREATE TABLE IF NOT EXISTS history (
    hostname,
    session_id, -- shell PID
    timestamp,
    history_id, -- $HISTCMD
    cwd,
    entry
);
END_SQL

# XXX detect shell exit?

# other data:
#   time to run
#   exit status

my $insert_sth = $dbh->prepare(<<'END_SQL');
INSERT INTO history VALUES (:hostname, :session_id, :timestamp, :history_id, :cwd, :entry);
END_SQL

my ( $hostname, $session_id, $timestamp, $history_id, $cwd, $entry ) = @ARGV;

chomp $entry;

$insert_sth->bind_param(':hostname'   => $hostname);
$insert_sth->bind_param(':session_id' => $session_id);
$insert_sth->bind_param(':timestamp'  => $timestamp);
$insert_sth->bind_param(':history_id' => $history_id);
$insert_sth->bind_param(':cwd'        => $cwd);
$insert_sth->bind_param(':entry'      => $entry);

$insert_sth->execute;
