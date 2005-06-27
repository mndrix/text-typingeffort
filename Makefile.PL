use 5.006;
use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    NAME              => 'Text::TypingEffort',
    VERSION_FROM      => 'lib/Text/TypingEffort.pm', # finds $VERSION
    PREREQ_PM         => {    # e.g., Module::Name => 1.1
        'Test::More' => 0.31,
    },
    EXE_FILES         => ['scripts/effort'],
    ($] >= 5.005 ?     ## Add these new keywords supported since 5.005
      (ABSTRACT_FROM  => 'lib/Text/TypingEffort.pm', # retrieve abstract from module
       AUTHOR         => 'Michael Hendricks <michael@palmcluster.org>') : ()),
);
