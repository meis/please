package App::Please;
use v5.10;
use strict;
use warnings;

use File::Basename;

use App::Please::Help;
use App::Please::Root;
use App::Please::RootFinder;

my $task_name = shift @ARGV;
my $root_path = App::Please::RootFinder->find_from(dirname $0);
my $root = App::Please::Root->new($root_path);

if (my $task = $root->get_task($task_name)) {
    system($task->path, @ARGV);
}
# We provide a default help task
elsif ($task_name eq 'help') {
    say App::Please::Help->new($root)->text;
}
else {
    die "$task_name is not a task";
}

1;
