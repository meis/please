package App::Please::Task;
use v5.10;
use strict;
use warnings;
use autodie;

use File::Basename;

sub new {
    my ($class, $path) = @_;

    return undef unless (-f $path);
    return undef unless (-X $path);

    my $self = {
        name => basename($path),
        path => $path,
    };

    bless $self, $class;

    return $self;
}

sub name { shift->{name} }
sub path { shift->{path} }

1;
