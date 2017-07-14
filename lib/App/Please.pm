package App::Please;
use v5.10;
use strict;
use warnings;

use File::Basename;

use App::Please::RootFinder;

my $task = shift @ARGV;
my $path = dirname $0;
my $root = App::Please::RootFinder->find_from($path);
my $task_path = "$root/$task";

if (-e $task_path && -X $task_path) {
    system($task_path, @ARGV);
}
else {
    die "$task is not a task";
}

1;
