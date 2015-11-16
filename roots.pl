#!/usr/bin/perl

# 16/05/2015 Thomas Raes (thomas.raes@pandora.be)

# Script to generate mnemonics for remembering arabic word roots
# When given a string of root, it finds an existing word with those consontants in dictionary
# Example: "tbn" -> "autobaan" 

# To generate a mnemonics dictionary, run: aspell -l nl dump master > words

use strict;

# read the possible mnemonics from file
open(WORDS,"<words") or die $!;
my @words = <WORDS>;
close(WORDS);
chomp(@words);

# create_regex($root,$strict)
# setting strict to 1 creates better matches, but fewer (or none)
sub create_regex
{
	# args
	my $root = $_[0];
	my $strict = $_[1];
	
	# build regex
	my $vowels = "[aeiou]";
	my $regex = "^$vowels*"; # word may start with vowels

	# add root to regex
	for my $c (split(//,$root))
	{
		$regex .= "$c$vowels*"; # each consonant may be followed by vowels
	}

	# if strict, no more consonants should follow
	if($strict == 1)
	{
		$regex .= "\$"; # the word should end here
	}

	# return result
	return $regex;
}

# find("tbn") -> list of mnemonics for "tbn"
sub find
{
	# args
	my $root = pop;
	
	# find mnemonics using strict regex
	my $strict = 1;
	my $regex = create_regex($root,$strict);
	my @matches = grep {$_ =~ /$regex/} @words;

	# if no matches found, try again using non-strict regex
	if(scalar(@matches) == 0)
	{
		$strict = 0;
		$regex = create_regex($root,$strict);
		@matches = grep {$_ =~ /$regex/} @words;
	}
	
	# return result
	return sort {length($a) <=> length($b)} @matches;
}

# get root as argument, print results
my @result = find($ARGV[0]);
my $n = 20; # only show n first matches
my @nfirst = grep {length($_) > 1} @result[0..$n];
map {print "$_\n"} @nfirst;

