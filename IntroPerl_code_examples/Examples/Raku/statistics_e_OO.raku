#! /usr/bin/env perl6
use v6;

class StatList is List {
   method mean_a () {
      sub sum { [+] self }
      return sum() / self.elems;
   }

   method mean_g () {
      sub product { [*] self }
      return product() ** (1/self.elems)
   }

   method mode () {
      sub frequencies { self.Bag                             }
      sub list_elems  { frequencies.pairs                     }
      sub max_freq    { frequencies.values.max                }
      sub max_vals    { list_elems.grep: {.value == max_freq} }

      return max_vals».key;
   }

   method median () {
    sub sorted { self.sort }
    return sorted.elems %% 2 ?? StatList.new(|sorted.[*/2, */2-1]).mean_a()
                             !!               sorted.[*/2]
   }
}

my $list = StatList.new(1, 1, 3, 4, 4, 4, 4, 5, 5, 5, 7, 7, 12, 12, 1, 7, 7, 99);

say 'mean (a) = ', $list.mean_a;
say 'mean (g) = ', $list.mean_g;
say '    mode = ', $list.mode;
say '  median = ', $list.median;

