#!/usr/bin/env perl

use strict;
use warnings;
use feature qw(say);
use experimental qw(signatures);

use DBI;
use Getopt::Long;
use File::Basename qw(dirname);
use File::Path qw(make_path);
use Time::Piece;

exit unless $ENV{'HISTFILE'};

my $database = $ENV{'HISTFILE'} . '.db';

my $database_dir = dirname($database);

make_path($database_dir);

my $dbh = DBI->connect("dbi:SQLite:dbname=$database", undef, undef, {
    RaiseError => 1,
    PrintError => 0,
});

my ( $current_schema_version ) = $dbh->selectrow_array('PRAGMA schema_version');

$dbh->do(<<'END_SQL');
CREATE TABLE IF NOT EXISTS history (
    hostname,
    session_id, -- shell PID
    timestamp integer not null,
    tz_offset integer,
    history_id, -- $HISTCMD
    cwd,
    entry,
    duration,
    exit_status
);
END_SQL

my ( $post_create_table_schema_version ) = $dbh->selectrow_array('PRAGMA schema_version');

# we created the table, so set the user_version
if($current_schema_version != $post_create_table_schema_version) {
    $dbh->do('PRAGMA user_version = 2');
}

$dbh->do('CREATE INDEX IF NOT EXISTS history_timestamp_idx ON history(timestamp)');

# XXX detect shell exit?

my $insert_sth = $dbh->prepare(<<'END_SQL');
INSERT INTO history (hostname, session_id, timestamp, tz_offset, history_id, cwd, entry) VALUES (:hostname, :session_id, :timestamp, :tz_offset, :history_id, :cwd, :entry);
END_SQL

my $print_oid;

GetOptions(
  'print-oid' => \$print_oid,
) or die "unable to process command line";

my ( $hostname, $session_id, $timestamp, $history_id, $cwd, $entry ) = @ARGV;

chomp $entry;

$insert_sth->bind_param(':hostname'   => $hostname);
$insert_sth->bind_param(':session_id' => $session_id);
$insert_sth->bind_param(':timestamp'  => $timestamp);
$insert_sth->bind_param(':tz_offset'  => localtime->tzoffset);
$insert_sth->bind_param(':history_id' => $history_id);
$insert_sth->bind_param(':cwd'        => $cwd);
$insert_sth->bind_param(':entry'      => $entry);

$insert_sth->execute;

if($print_oid) {
    say $insert_sth->last_insert_id;
}
