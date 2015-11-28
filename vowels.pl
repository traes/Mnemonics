#!/usr/bin/perl

# 28/11/2015 Thomas Raes (thomas.raes@pandora.be)

# Script for generating vowel sequence mnemonics

# For example, we want to remember to vowel changes in the conjugation of the german verb "kommen":
# er kommt -> O
# er kam -> A
# er ist gekommen -> O

# -> we need to remember the sequence "oao"
# running this script looks for words with that contains the same vowel sequence (e.g. "tornado")


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
	my $filler = "[bcdfghklmnpqrstvwxz]";
	my $regex = "^$filler*"; # word may start with vowels

	# add root to regex
	for my $c (split(//,$root))
	{
		$regex .= "$c$filler*"; # each consonant may be followed by vowels
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
	my $strict = 0;
	my $regex = create_regex($root,$strict);
	my @matches = grep {$_ =~ /$regex/} @words;

	# return result
	return sort {length($a) <=> length($b)} @matches;

}

my @result = find($ARGV[0]);

map {print "$_\n"} @result[0..40];
