#!/usr/bin/env perl
use v5.10;
use strict;
use warnings;
use File::Temp qw/tempdir/;
use Test::More;

use constant CLASS => 'App::Please::Group';
use_ok(CLASS);

subtest 'On non existing directory' => sub {
    is(CLASS->new('non-existing-dir'), undef, 'new() returns undef');
};

subtest 'On empty directory' => sub {
    my $empty_dir = File::Temp->newdir(CLEANUP => 1);
    my $group;

    is(CLASS->new($empty_dir->dirname), undef, 'new() returns undef');
};

subtest 'On non-empty directory' => sub {
    my $scenario = 't/scenarios/1/tasks';
    my $group;

    ok($group = CLASS->new($scenario), 'new() returns an object');
    isa_ok($group, CLASS, 'group');

    ok($group->get_task('work'), 'has "work" task');
    ok($group->get_task('config/file'), 'has "config/file" task');

    ok(! $group->get_task('not-work'), 'has no "not-worwork" task (! -X)');
    ok(! $group->get_task('non-existant'), 'has no "non-existant" task (! -e)');
};

done_testing;
