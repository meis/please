#!/usr/bin/env perl
use v5.10;
use strict;
use warnings;
use File::Temp qw/tempdir/;
use Test::More;

use App::Please::Root;

use constant CLASS => 'App::Please::Help';
use_ok(CLASS);

subtest 'On empty directory' => sub {
    my $empty_dir = File::Temp->newdir(CLEANUP => 1);
    my $root = App::Please::Root->new($empty_dir);

    ok(my $help = CLASS->new($root), 'new() returns an object');
    isa_ok($help, CLASS, 'help');

    my $expected = "Usage: $0 <task> [options]. There are no available tasks.";
    is($help->text, $expected, 'returns the expected text');
};

subtest 'On non-empty directory' => sub {
    my $scenario = 't/scenarios/1/tasks';
    my $root = App::Please::Root->new($scenario);

    ok(my $help = CLASS->new($root), 'new() returns an object');
    isa_ok($help, CLASS, 'help');

    my $expected = <<"END";
Usage: $0 <task> [options]. Available tasks:

config:
 file

work
END
    is($help->text, $expected, 'returns the expected text');
};

done_testing;
