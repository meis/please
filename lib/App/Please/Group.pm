package App::Please::Group;
use v5.10;
use strict;
use warnings;
use autodie;

use File::Basename;

use App::Please::DirContent;
use App::Please::Task;

sub new {
    my ($class, $path) = @_;

    return undef unless (-d $path);

    my $content = App::Please::DirContent->get($path);

    my $self = {
        name => basename($path),
        path => $path,
        groups => [
            grep { $_ }
            map { App::Please::Group->new("$path/$_") } @$content
        ],
        tasks => [
            grep { $_ }
            map { App::Please::Task->new("$path/$_") } @$content
        ],
    };

    bless $self, $class;

    # Empty groups are not groups
    return @{$self->groups} || @{$self->tasks} ? $self : undef;
}

sub name { shift->{name} }
sub path { shift->{path} }
sub groups { shift->{groups} }
sub tasks { shift->{tasks} }

1;
