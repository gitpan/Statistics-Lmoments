# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl test.pl'

######################### We start with some black magic to print on failure.

# Change 1..1 below to 1..last_test_to_print .
# (It may become useful if the test is moved to ./t subdirectory.)

BEGIN { $| = 1; print "1..1\n"; }
END {print "not ok 1\n" unless $loaded;}
use Statistics::Lmoments qw(:all);
$loaded = 1;
print "ok 1\n";

######################### End of black magic.

# Insert your test code below (better if it prints "ok 13"
# (correspondingly "not ok 13") depending on the success of chunk 13
# of the test code):

$test = 1;

### Basic tests

my @x = (81,95,62,118,106,82,70,228,112,125,
	 120,142,80,83,46,109,61,81,93,97,76,
	 100,106,90,61,147,101,85,79,69,81,112,
	 85,87,41,94,82,90,62,69,115,80,51);

@x = sort {$a<=>$b} @x;

my @data;
while (<DATA>) {
    chomp;
    s/^\s+//;
    my @l = split /\s+/;
    push @data,[@l];
}
my $test = 2;

my $xmom;
#for ('lmr','lmu','pwm') {
for ('lmu') {
    $xmom = &Statistics::Lmoments::sam($_,\@x, 5);
    mtest(@{$xmom});
}

foreach (@Statistics::Lmoments::distributions) {
    next if /^KAP/;
    my $para = &Statistics::Lmoments::pel($_,$xmom);
    mtest($_);
    mtest(@{$para});
    my $x = 100;
    my $F = &Statistics::Lmoments::cdf($_,$x,$para);
    mtest($F);
}

sub mtest {
    my $l = unshift @data;
    my $ok = 1;
    for (0..$#$l) {
	$ok = 0 if substr($l->[$_],0,5) ne substr($_[$_],0,5);
    }
    print $ok ? "ok $test\n" : "not ok $test\n";
    $test++;
}

__DATA__
91.953488372093 15.9966777408638 0.193769470404984 0.26067168148317 0.11581803788323
EXP
  59.9601328903655 31.9933554817276
  0.713926272041227
GAM
  10.2649340788394 8.95802035023783
  0.646585619709846
GEV
  78.2533989127234 22.2818760102919 -0.0367630513904581
  0.681592367311941
GLO
  86.9483822073972 15.0268409700099 -0.193769470404984
  0.690563042375168
GNO
  86.4294402286626 26.5218727694868 -0.400115615095075
  0.679213919684008
GPA
  54.3496070856366 50.7927164766959 0.350730688935283
  0.660280306522962
GUM
  78.6323161342588 23.078327647443
  0.672882896787571
NOR
  91.953488372093 28.3533730634886
  0.611715798860428
PE3
  91.953488372093 29.5931549021284 1.17305970202737
  0.674774966021191
WAK
  37.0296491939387 254.346049562025 6.58181356397096 16.4282664177941 0.23149723658706
  0.720191568599643

