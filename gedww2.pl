#!/usr/bin/perl

#War.pl - Takes a gedcom file and uses it to calculate age ranges of members during WWII
#Outputs these to STDOUT

unless ($ARGV[0]) {
	unless ( -e $ARGV[0] ) {
		print "Usage: $0 <file> - Where <file> is a valid gedcom file\n";
		exit -1;
	}
}
open (GED, "< $ARGV[0]") || die ("Can't open $ARGV[0] - $!");
PERSON:
while (<GED>) {
	chomp;
	if ($_=~m/^1 NAME (.*)/) {
		$name = $1;
		$name=~s/[^\w ]//g;
		$name=~s/\s+/ /g;
	}
	elsif ($_=~m/^1 BIRT/) {
		$inbirt = 1;
	}
	elsif ($_=~m/^2 DATE (.*)/) {
		if ($inbirt) {
			$date = $1;
			if ($date=~m/(\d{4})/) {
				if ($1 < 1938) {
					my $warage1 = 1939-$1;
					my $warage2 = $warage1 + 7;
					if ($warage2 > 90) {
						undef $inbirt;
						next PERSON;
					}
					print "$name ($warage1 - $warage2)\n";
				}
			}
			undef $inbirt;
		}
	}

}
close (GED);
