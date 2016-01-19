#!/usr/bin/perl -w

use warnings;
use strict;

# remove duplicate BLAST matches in the same db sequence

my $mincov = 50.0;

my $lasta = "";
my $lastb = "";

while (<>)
{
    if (/^\#/)
    {
        $lasta = "";
        $lastb = "";
    }
    else
    {
        my @cols = split /\t/;
        
        my $a = $cols[0];
        my $b = $cols[1];
        my $c = $cols[2];
        my $d = $cols[6];
        my $e = $cols[7];
        
        my $qc = 0.0;
        
        if ($a =~ /\/(\d+)\-(\d+)$/)
        {
            my $cov = $e - $d + 1;
            my $len = ($1 < $2) ? $2 - $1 + 1 : $1 - $2 + 1;
            $qc = 100.0 * $cov / $len;
        }
        
        if ($qc >= $mincov)
        {

            if (($a ne $lasta) || ($b ne $lastb))
            {
                printf "%s\t%s\t%.1lf\t%.1lf\n", $a, $b, $c, $qc;
                $lasta = $a;
                $lastb = $b;
            }
        }
    }
}
