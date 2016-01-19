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
    if ($name =~ /^chimera/)
    {
        $chimeras++;
    }
    else
    {
        $nonchimeras++;
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
    
    if ($name =~ /^chimera/)
    {
        if ($class eq 'Y')
        {
            $tp++;
        }
        else
        { 
            if ($class eq 'N')
            {
                $fn++;
            }
            else
            {
                $fn++;
            }
        }
    }
    else
    {
        if ($class eq 'Y')
        {
            $fp++;
        }
        else
        {
            if ($class eq 'N')
            {
                $tn++;
            }
            else
            {
                $tn++;
            }
        }
    }

    printf("%lf\t%lf\n", $fp / $nonchimeras, $tp / $chimeras);
}
close FILE;
