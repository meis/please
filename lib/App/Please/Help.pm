package App::Please::Help;
use v5.10;
use strict;
use warnings;

sub new {
    my ($class, $root) = @_;

    my $self = { root => $root };
    bless $self, $class;

    return $self;
}

sub text {
    my ($self) = @_;

    my $text = "Usage: $0 <task> [options]. ";

    if ($self->{root}->is_empty) {
        $text .= "There are no available tasks.";
    }
    else {
        $text .= "Available tasks:\n\n";
        $text .= $self->_print_group($self->{root}, 0);
    }

    return $text;
}

sub _print_group {
    my ($self, $group, $level) = @_;

    my $text = '';
    my $indentation = $self->_get_indentation_for_level($level);

    for my $sub_group (@{ $group->groups }) {
        $text .= $indentation . $sub_group->name . ":\n";
        $text .= $self->_print_group($sub_group, $level + 1);
        $text .= "\n";
    }
    for my $task (@{ $group->tasks }) {
        $text .= $indentation . $task->name . "\n";
    }

    return $text;
}

sub _get_indentation_for_level {
    my ($self, $level) = @_;

    return " " x $level
}

1;
