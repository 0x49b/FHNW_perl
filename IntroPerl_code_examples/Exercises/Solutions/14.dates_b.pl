#! /usr/bin/env perl

use 5.020;
use warnings;
use experimental qw< signatures smartmatch >;

# Translate month names to numerical equivalents...
my %MM_for = (
    'January'  => 1,
    'February' => 2,
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

my %DATE_FORMAT = (
   ISO => qr{ ^  (?<year>  $YYYY)  $SEP  (?<month> $MON)  $SEP  (?<day>  $DD  )  $ }x,
   US  => qr{ ^  (?<month> $MON )  $SEP  (?<day>   $DD )  $SEP  (?<year> $YEAR)  $ }x,
   UK  => qr{ ^  (?<day>   $DD  )  $SEP  (?<month> $MON)  $SEP  (?<year> $YEAR)  $ }x,
);

# Standard format for outputting ISO dates...
my $ISO_FORMAT = '%04d-%02d-%02d';


# Read dates in, identify them, and convert them...
while (my $input = readline()) {
    my %std_date;

    # Detect and decode various date formats...
    FORMAT:
    for my $next_format (keys %DATE_FORMAT) {
        if ( $input =~ $DATE_FORMAT{$next_format} ) {
            my %date = %+;
            next FORMAT unless is_valid(\%date);
            $std_date{$next_format} = normalize_date(\%date);
        }
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
        print "\t[Invalid data or unknown date format]\n";
    }
}


# Convert a date to ISO format...
sub normalize_date ($date_ref) {
    # Guess the right century offset for 2-digit years...
    my $century = $date_ref->{year} > 100 ? 0
                : $date_ref->{year} > 50  ? 1900
                :               2000
                ;

    # Apply offsets and translations, then format in ISO style...
    return sprintf( $ISO_FORMAT,
                    $century + $date_ref->{year},
                    $MM_for{$date_ref->{month}} // $date_ref->{month},
                    $date_ref->{day}
                  );
}

# Is a date (in the correct format) actually a valid date?
sub is_valid ($date_ref) {

    # Decode the month from named months...
    $date_ref->{month} = $MM_for{$date_ref->{month}} // $date_ref->{month};

    # No month has fewer than 1 or more than 31 days...
    return 0 if $date_ref->{day} < 1 ||  $date_ref->{day} > 31;

    # "30 days hath September, April, June, and November..."
    return 0 if $date_ref->{month} ~~ [9,4,6,11] && $date_ref->{day} > 30;

    # February depends on whether it's a leap year (which is complicated)....
    if ($date_ref->{month} == 2) {
        my $feb_max = 28;
           $feb_max = 29 if $date_ref->{year} %   4 == 0;
           $feb_max = 28 if $date_ref->{year} % 100 == 0;
           $feb_max = 29 if $date_ref->{year} % 400 == 0;

        return 0 if $date_ref->{day} > $feb_max;
    }

    # Otherwise, we're good...
    return 1;
}
