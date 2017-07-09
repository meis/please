package App::Please::Group;
use v5.10;
use strict;
use warnings;
use autodie;

use File::Basename;
use App::Please::Task;

sub new {
    my ($class, $path) = @_;

    return undef unless (-d $path);

    my $self = {
        name => basename($path),
        path => $path,
        content => $class->_get_content($path),
    };

    bless $self, $class;

    $self->{groups} = $self->_get_groups();
    $self->{tasks} = $self->_get_tasks();

    # Empty groups are not groups
    return @{$self->groups} || @{$self->tasks} ? $self : undef;
}

sub name { shift->{name} }
sub path { shift->{path} }
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

sub _get_content {
    my ($class, $path) = @_;

    opendir my ($dh), $path;
    my @contents = grep { $_ ne '.' && $_ ne '..' } readdir $dh;
    closedir $dh;

    return \@contents;
}

sub _get_groups {
    my $self = shift;

    return [
        grep { $_ }
        map {
            App::Please::Group->new($self->path . "/$_")
        } @{ $self->{content} }
    ];
}

sub _get_tasks {
    my $self = shift;

    return [
        grep { $_ }
        map {
            App::Please::Task->new($self->path . "/$_")
        } @{ $self->{content} }
    ];
}

1;
