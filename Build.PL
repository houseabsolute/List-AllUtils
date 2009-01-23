use strict;
use warnings;

use 5.008;

use Module::Build;


my $builder = Module::Build->new
    ( module_name        => 'List::AllUtils',
      license            => 'perl',
      requires           => { 'perl'            => '5.008',
                              'List::Util'      => '1.19',
                              'List::MoreUtils' => '0.22',
                            },
      build_requires     => { 'Test::More' => '0',
                            },
      create_readme      => 1,
      sign               => 1,
    );

$builder->create_build_script();
