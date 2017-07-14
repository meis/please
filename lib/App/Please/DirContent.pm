package App::Please::DirContent;
use v5.10;
use strict;
use warnings;
use autodie;

sub get {
    my ($class, $path) = @_;

    opendir my ($dh), $path;
    my @contents = grep { $_ ne '.' && $_ ne '..' } readdir $dh;
    closedir $dh;

    return \@contents;
}

1;
