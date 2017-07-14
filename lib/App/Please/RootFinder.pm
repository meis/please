package App::Please::RootFinder;
use v5.10;
use strict;
use warnings;
use autodie;

use File::Basename;

use constant ROOT_DIR_NAME => 'tasks';

sub find_from {
    my ($class, $path) = @_;

    return undef unless -d $path;

    do {
        my $candidate = "$path/" . ROOT_DIR_NAME;
        return $candidate if -d $candidate;

        $path = dirname $path;
    } while $path && $path ne '/';

    return undef;
}

1;
