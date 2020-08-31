#! /usr/bin/env raku

my %MM_for = flat map { $_, .key.substr(0,3) => .value },
(
    'January'  => 1,    'February' => 2,    'March'    => 3,
    'April'    => 4,    'May'      => 5,    'June'     => 6,
    'July'     => 7,    'August'   => 8,    'Sepember' => 9,
    'October'  => 10,   'November' => 11,   'December' => 12,
);

constant INVALID-DATE = '[Invalid date]';

grammar DateStr {

    token ISO   { ^  <Year=YYYY>  <sep> <Month> <sep> <Day>   $ }
    token UK    { ^  <Day>        <sep> <Month> <sep> <Year>  $ }
    token US    { ^  <Month>      <sep> <Day>   <sep> <Year>  $ }

    token DD    { \d ** 1..2         }
    token Day   { <DD>               }

    token MM    { \d ** 1..2         }
    token MMM   { <{ keys %MM_for }> }
    token Month { <MM> || <MMM>      }

    token YY    { \d ** 2            }
    token YYYY  { \d ** 4            }
    token Year  { <YYYY> || <YY>     }

    token sep   { <[-/.,\s]>+        }
}

# Read dates in, identify them, and convert them...
while get() -> $input {

    # Parse possible date formats...
    my $ISO_date = decode_date( $input ~~ /<DateStr::ISO>/ );
    my $UK_date  = decode_date( $input ~~ /<DateStr::UK> / );
    my $US_date  = decode_date( $input ~~ /<DateStr::US> / );

    # Report ambiguous dates...
    if $UK_date && $US_date && $UK_date ne $US_date {
        say "\t[Ambiguous]: $UK_date or $US_date";
        next;
    }

    # Otherwise, detect the first non-ambiguous date and print it...
    with first *.defined, $ISO_date, $UK_date, $US_date, INVALID-DATE {
        say "\t$^date";
    }
}

# Convert a grammar match into a Date object...
sub decode_date ($match) {
    # No match --> no Date object...
    return Nil if !$match;

    # Get the matching data and unpack the year, month, and day...
    my $date = $match.values[0];
    my ($year, $month, $day) = $date<Year Month Day>».Str;

    # Guess the year if it's YY format...
    if $date<Year><YY>   { $year += $year < 50 ?? 2000 !! 1900; }

    # Convert named months to month numbers...
    if $date<Month><MMM> { $month = %MM_for{$month} }

    # Build the new Date object (if possible, may fail if date invalid)...
    return try { Date.new($year, $month, $day) }
}
