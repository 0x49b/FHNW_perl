#! /usr/bin/env perl

use 5.020;
use warnings;
use experimental 'signatures';

# Translate month names to numerical equivalents...
my %MM_for = (
    'January'  => 1,
    'Febuary'  => 2,
    'March'    => 3,
    'April'    => 4,
    'May'      => 5,
    'June'     => 6,
    'July'     => 7,
    'August'   => 8,
    'Sepember' => 9,
    'October'  => 10,
    'November' => 11,
    'December' => 12,
);

# Add 3-letter abbreviations ('Jan', 'Feb', 'Mar', etc.)...
my @abbrevs = map {substr($_,0,3)} keys %MM_for;
@MM_for{@abbrevs} = values(%MM_for);


# Patterns to match various components of dates...

my $MMM = join('|', reverse sort keys %MM_for);

my $YYYY = qr{ \d{4}                    }x;
my $YEAR = qr{ \d{2,4}                  }x;
my $MON  = qr{ 1[0-2] | 0?[1-9] | $MMM  }x;
my $DD   = qr{ 0?[1-9] | [12]\d | 3[01] }x;

my $SEP  = qr{ [-/., ]+ }x;

my $ISO_DATE = qr{ ^ ($YYYY) $SEP ($MON) $SEP ($DD)   $ }x;
my $US_DATE  = qr{ ^ ($MON)  $SEP ($DD)  $SEP ($YEAR) $ }x;
my $UK_DATE  = qr{ ^ ($DD)   $SEP ($MON) $SEP ($YEAR) $ }x;

# Standard format for outputting ISO dates...
my $ISO_FORMAT = '%04d-%02d-%02d';


# Read dates in, identify them, and convert them...
while (my $input = readline()) {
    my %std_date;

    # Detect and decode ISO date...
    if ( my ($year, $month, $day) = $input =~ m{$ISO_DATE}) {
        $std_date{'ISO'} = normalize_date($year, $month, $day);
    }

    # Detect and decode UK-style date...
    if ( my ($day, $month, $year) = $input =~ m{$UK_DATE}) {
        $std_date{'UK'} = normalize_date($year, $month, $day);
    }

    # Detect and decode US-style date...
    if ( my ($month, $day, $year) = $input =~ m{$US_DATE}) {
        $std_date{'US'} = normalize_date($year, $month, $day);
    }

    # Report ambiguous dates...
    if (keys %std_date > 1 && $std_date{'US'} ne $std_date{'UK'}) {
        print "\t[Ambiguous]: $std_date{'US'} or $std_date{'UK'}\n";
    }

    # Report unambiguous dates...
    elsif (keys %std_date > 0) {
        print "\t", (values %std_date)[0], "\n";
    }

    # Report unknown input...
    else {
        print "\t[Unknown date format]\n";
    }
}

sub normalize_date ($year, $month, $day) {
    # Guess the right century offset for 2-digit years...
    my $century = $year > 100 ? 0
                : $year > 50  ? 1900
                :               2000
                ;

    # Apply offsets and translations, then format in ISO style...
    return sprintf( $ISO_FORMAT,
                    $century + $year,
                    $MM_for{$month} || $month,
                    $day
                  );
}
