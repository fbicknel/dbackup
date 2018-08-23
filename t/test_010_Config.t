#!/usr/bin/env perl
use strict;
use warnings;
use Test::More;
use Test::Trap;

use lib qw(lib);
require_ok('Backup::Duplicity');

my $obj = trap { new_ok('Backup::Duplicity' => [qw(one two three)]) };

is($trap->exit,   1, "Expect call with bad args to exit 1");
is($trap->stdout, "No config file specified\n", "stdout consistent");

$obj = new_ok('Backup::Duplicity' => ["--config", "t/data/test_01.conf"]);
is($obj->config, "t/data/test_01.conf", "Config file name");
is($obj->older_than, "7D", "Default older_than parameter");

done_testing();
