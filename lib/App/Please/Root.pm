package App::Please::Root;
use v5.10;
use strict;
use warnings;
use autodie;

use App::Please::DirContent;
use App::Please::Task;
use App::Please::Group;

sub new {
    my ($class, $path) = @_;

    die "$path does not exists" unless -d $path;

    my $content = App::Please::DirContent->get($path);

    my $self = {
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

    return $self;
}

sub groups { shift->{groups} }
sub tasks { shift->{tasks} }
sub is_empty { return ! @{ $_[0]->groups || $_[0]->tasks || [] } }

sub get_task {
    my ($self, $task) = @_;

    my @namespaces = split('/', $task);
    my $task_name = pop @namespaces;

    my $group = $self;
    while (@namespaces) {
        my $next_group = shift @namespaces;

        $group = (grep {$_->name eq $next_group } @{$group->groups})[0];
        return undef unless $group;
    }

    return (grep {$_->name eq $task_name} @{$group->tasks})[0];
}

1;

