use ExtUtils::MakeMaker;

print "Checking for ExtUtils::F77 ..";
eval {
    use ExtUtils::F77;
};
if ($@) {
    print " failed\n";
    $missing_modules++;
} else {
    print " ok\n";
}

if ($missing_modules) {
    print "One or more required modules is missing, won't continue\n";
}

my @libdirs = ('/usr/lib');
my @incdirs = ('/usr/include');

sub fe {
    my($fn,@dirs) = @_;
    foreach (@dirs) {
	return 1 if -e "$_/$fn";
    }
    return 0;
}

my $libs = '';
foreach (@libdirs) {
    $libs .= " -L$_";
}

# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
	      'NAME'	     => 'Statistics::Lmoments',
	      'VERSION_FROM' => 'Lmoments.pm',
	      'LIBS'	     => ["$libs " . ExtUtils::F77->runtime],
	      'DEFINE'	     => '',
	      'INC'	     => '',
	      'MYEXTLIB'     => 'lmoments/libclmoments$(LIB_EXT) lmoments/liblmoments$(LIB_EXT) -lc'
	      );

sub MY::postamble {
'
$(MYEXTLIB): lmoments/Makefile
	cd lmoments && $(MAKE) $(PASTHRU)
';
}
