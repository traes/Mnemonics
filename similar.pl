#!/usr/bin/perl
use strict;
use Text::Levenshtein;

# 27/09/2015 Thomas Raes (thomas.raes@pandora.be)

# Script to find words that are similar to a given word
# The input should be passed as the argument of the script
# Example: tarabeza (arabic) -> trapeze (dutch)  

# To generate a mnemonics dictionary, run aspell -l nl dump master > words

# read words
open(WORDS,"<words") or die $!;
my @words = <WORDS>;
close(WORDS);
chomp(@words);

# get input
my $input = $ARGV[0];

# calculate distances
my %distance;
map {$distance{$_} = Text::Levenshtein::distance($_,$input)} @words;
my @sorted = sort {$distance{$a} <=> $distance{$b}} @words;

# show results
my $first_n = 20;
map {print "$_\n"} @sorted[0..$first_n];
