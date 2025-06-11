#!/usr/bin/env perl

use strict;
use warnings;
use feature qw(say);
use experimental qw(signatures);

use DBI;
use Getopt::Long;
use File::Basename qw(dirname);
use File::Path qw(make_path);

exit unless $ENV{'HISTFILE'};

my $target_oid;

GetOptions(
  'oid=i' => \$target_oid,
) or die "unable to process command line";

my ( $hostname, $session_id, $target_history_id, $current_time, $exit_status ) = @ARGV;

my $database = $ENV{'HISTFILE'} . '.db';
my $database_dir = dirname($database);

make_path($database_dir);

my $dbh = DBI->connect("dbi:SQLite:dbname=$database", undef, undef, {
    RaiseError => 1,
    PrintError => 0,
}); # XXX don't freak out if you can't connect

if(defined($target_oid)) {
  my $update_sth = $dbh->prepare(<<'END_SQL');
UPDATE history SET duration = :current_time - timestamp, exit_status = :status
WHERE oid = :oid
END_SQL

  # XXX bind types?
  $update_sth->bind_param(':oid'          => $target_oid);
  $update_sth->bind_param(':current_time' => $current_time);
  $update_sth->bind_param(':status'       => $exit_status);

  $update_sth->execute;
} else {
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
}
