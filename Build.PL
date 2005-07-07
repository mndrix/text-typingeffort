use Module::Build;
# See perldoc Module::Build for details of how this works

my $build = Module::Build->new
    ( module_name     => 'Text::TypingEffort',
      license         => 'perl',
      build_requires  => {
          'Test::More'     => 0.31,
      },
      script_files    => [
        'scripts/effort.pl',
      ],
      create_makefile_pl => 'traditional',
    );

$build->create_build_script;
