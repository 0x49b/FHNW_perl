#! /usr/bin/env perl6

grammar LaTeX {

    rule document  { ^ <element>* $                            }
    rule element   { <command> | <literal>                     }
    rule command   { \\  <name=.literal>  <options>?  <args>?  }
    rule options   { '['  <option>* % ','  ']'                 }
    rule args      { '{'  <element>*  '}'                      }

    token option   { <+lit-char-[,]>+                          }
    token literal  { <+lit-char>+                              }

    token lit-char { <+ :Block('Basic Latin') - [\[\]$&%#_{}~^] - space> }
}

grammar LᵃTₑX is LaTeX {

    token lit-char { <LaTeX::lit-char> | <:!Block('Basic Latin')>    }
}

my $example = q:to<END-OF-EXAMPLE>;

    \documentclass[a4paper,11pt]{article}
    \usepackage{latexsym}
    \author{D. Cøñwaÿ}
    \title{Parsing \LᵃTₑX{}}
    \begin{document}
    \maketitle
    \tableofcontents
    \section{Description}
    ...is easy \footnote{But not \emph{𝒏𝒆𝒄𝒆𝒔𝒔𝒂𝒓𝒊𝒍𝒚} simple}.
    \end{document}

END-OF-EXAMPLE

say $example ~~ / <LᵃTₑX::document> /;

