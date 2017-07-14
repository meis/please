#!/usr/bin/env perl
use v5.10;
use strict;
use warnings;
use File::Temp qw/tempdir/;
use Test::More;

use constant CLASS => 'App::Please::RootFinder';
use_ok(CLASS);

subtest 'find_from_method' => sub {
    subtest 'On non existing directory' => sub {
        my $non_existing_dir = 'non_existing_dir';

        is(CLASS->find_from($non_existing_dir), undef, 'returns undef');
    };

    subtest 'On empty directory' => sub {
        my $empty_dir = File::Temp->newdir(CLEANUP => 1);

        is(CLASS->find_from($empty_dir), undef, 'returns undef');
    };

    subtest 'When "tasks" is at the same level' => sub {
        my $scenario = 't/scenarios/1';
        my $expected = 't/scenarios/1/tasks';

        is(CLASS->find_from($scenario), $expected, 'returns "tasks" directory');
    };

    subtest 'When "tasks" is one level below' => sub {
        my $scenario = 't/scenarios/1/tasks/config';
        my $expected = 't/scenarios/1/tasks';

        is(CLASS->find_from($scenario), $expected, 'returns "tasks" directory');
    };
};

done_testing;
