#!/usr/bin/perl -w

use warnings;
use strict;

my $filename = shift;

my $chimeras = 0.0;
my $nonchimeras = 0.0;

open(FILE, $filename) or die "Cannot open file";
while (<FILE>)
{
    chomp;
    my ($name, $class) = split /\t/;

    my $abundance = 1;
    if ($name =~ /;size=([0-9]+);/)
    {
        $abundance = $1;
    }

    if ($name =~ /^chimera/)
    {
        $chimeras += $abundance;
    }
    else
    {
        $nonchimeras += $abundance;
    }
}
close FILE;

# count true and false positives and negatives
my $tp = 0.0;
my $fp = 0.0;
my $tn = 0.0;
my $fn = 0.0;

printf("%lf\t%lf\n", $fp / $nonchimeras, $tp / $chimeras);

open(FILE, $filename) or die "Cannot open file";
while (<FILE>)
{
    chomp;
    my ($name, $class) = split /\t/;
    
    my $abundance = 1;
    if ($name =~ /;size=([0-9]+);/)
    {
        $abundance = $1;
    }

    if ($name =~ /^chimera/)
    {
        if ($class eq 'Y')
        {
            $tp += $abundance;
        }
        else
        { 
            if ($class eq 'N')
            {
                $fn += $abundance;
            }
            else
            {
                $fn += $abundance;
            }
        }
    }
    else
    {
        if ($class eq 'Y')
        {
            $fp += $abundance;
        }
        else
        {
            if ($class eq 'N')
            {
                $tn += $abundance;
            }
            else
            {
                $tn += $abundance;
            }
        }
    }

    printf("%lf\t%lf\n", $fp / $nonchimeras, $tp / $chimeras);
}
close FILE;
