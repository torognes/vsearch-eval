#!/usr/bin/perl -w

use strict;
use warnings;

die "Too few arguments" if scalar @ARGV < 2;

my $taxfilename = $ARGV[0];
my $ucfilename = $ARGV[1];

my %taxa;
my %amp2tax;
my %cluster;

open T, $taxfilename;
while (<T>)
{
    chomp;
    my ($amp, $tax) = split /\t/;
    $amp2tax{$amp} = $tax;
}
close T;

open UC, $ucfilename;
while (<UC>)
{
    chomp;
    my @cols = split /\t/;
    my $linetype = $cols[0];
    my $clusterid = $cols[1];
    my $amp = $cols[8];

    my $abundance = 1;
    if ($amp =~ /;size=(\d+);$/)
    {
        $abundance = $1;
    }

    my $tax = $amp2tax{$amp};
    $tax = "Unassigned" if ! defined $tax;
    $taxa{$tax} = 1;

    if ($linetype eq "S")
    {
        $cluster{$clusterid}{$tax} = $abundance;
    }

    if ($linetype eq "H")
    {
        $cluster{$clusterid}{$tax} += $abundance;
    }
}
close UC;

my @alltax = sort keys %taxa;

print "OTUs_vs_Taxa";
for my $tax (@alltax)
{
    print "\t$tax";
}
print "\n";

for my $clusterid (sort {$a <=> $b} keys %cluster)
{
    print $clusterid + 1;
    for my $tax (@alltax)
    {
        my $count = $cluster{$clusterid}{$tax};
        $count = 0 if ! defined $count;
        print "\t$count";
    }
    print "\n";
}
