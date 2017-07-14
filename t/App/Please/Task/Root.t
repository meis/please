#!/usr/bin/env perl
use v5.10;
use strict;
use warnings;
use File::Temp qw/tempdir/;
use Test::More;

use constant CLASS => 'App::Please::Root';
use_ok(CLASS);

subtest 'On non existing directory' => sub {
    eval {
        CLASS->new('non-existing-dir');
    };
    like($@, qr/does not exists/, 'new() raises an error');
};

subtest 'On empty directory' => sub {
    my $empty_dir = File::Temp->newdir(CLEANUP => 1);

    ok(my $root = CLASS->new($empty_dir), 'new() returns an object');
    isa_ok($root, CLASS, 'root');

    ok($root->is_empty, 'is empty');
};

subtest 'On non-empty directory' => sub {
    my $scenario = 't/scenarios/1/tasks';

    ok(my $root = CLASS->new($scenario), 'new() returns an object');
    isa_ok($root, CLASS, 'root');

    isnt($root->is_empty, 'is not empty');

    ok($root->get_task('work'), 'has "work" task');
    ok($root->get_task('config/file'), 'has "config/file" task');

    ok(! $root->get_task('not-work'), 'has no "not-work" task (! -X)');
    ok(! $root->get_task('non-existant'), 'has no "non-existant" task (! -e)');
};

done_testing;
