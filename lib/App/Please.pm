package App::Please;
use v5.10;
use strict;
use warnings;

use constant TASKS_PATH => './tasks';

my $task = shift @ARGV;
my $task_path = TASKS_PATH . "/$task";

if (-e $task_path && -X $task_path) {
    system($task_path, @ARGV);
}
else {
    die "$task is not a task";
}

1;
