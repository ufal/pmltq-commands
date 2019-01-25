package PMLTQ::Command::initdb;

# ABSTRACT: Initialize empty database

use PMLTQ::Base 'PMLTQ::Command';

has usage => sub { shift->extract_usage };


use File::Basename 'dirname';
use File::Spec ();
use File::ShareDir 'dist_dir';
my $local_shared_dir = File::Spec->catdir(dirname(__FILE__), File::Spec->updir, File::Spec->updir, File::Spec->updir, 'share');
my $shared_dir = eval { dist_dir(__PACKAGE__) };
# Assume installation
if (-d $local_shared_dir or !$shared_dir) {
  $shared_dir = $local_shared_dir;
}
sub shared_dir { $shared_dir }


sub run {
  my $self = shift;

  my $config = $self->config;
  my $dbh    = $self->sys_db;

  $dbh->do("CREATE DATABASE \"$config->{db}->{name}\";") or die $dbh->errstr;
  $dbh->disconnect;

  $dbh = $self->db;
  $self->run_sql_from_file( 'init.sql', File::Spec->catfile( shared_dir(), 'sql' ), $dbh );
  $dbh->disconnect;
}

=head1 SYNOPSIS

  pmltq initdb <treebank_config>

=head1 DESCRIPTION

Initialize empty database.

=head1 OPTIONS

=head1 PARAMS

=over 5

=item B<treebank_config>

Path to configuration file. If a treebank_config is --, config is readed from STDIN.

=back

=cut

1;
