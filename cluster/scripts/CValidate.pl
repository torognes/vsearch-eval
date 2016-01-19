#!/usr/bin/perl

use strict;
use Getopt::Long;

my $tFile;

GetOptions("cfile=s"   => \$tFile,"sfile=s");

my @cluster = ();

open(FILE,"$tFile") or die "Can't open $tFile\n";

my $line = <FILE>;
my $i = 0;
while($line = <FILE>){
    chomp($line);

    my @tokens = split(/\t/,$line);
    shift(@tokens);
    my $j = 0;
 
    foreach my $tok(@tokens){
    #print "$j $tok\n";
        $cluster[$i][$j] = $tok;
        $j++;
    }
    $i++;
}

close(FILE);


printf("%f,%f,%f,%f,%f\n",recall(@cluster),precision(@cluster),nmi(@cluster),randindex(@cluster),adjrandindex(@cluster));

sub precision(){
    my @cluster = @_;
    my $nN = 0;
    my $nC = scalar(@cluster);
    my $nK = scalar(@{$cluster[0]});
    my $precision = 0;

    for(my $i = 0; $i < $nC; $i++){
        my $maxS = 0;

        for(my $j = 0; $j < $nK; $j++){
            if($cluster[$i][$j] > $maxS){
                $maxS = $cluster[$i][$j];
            }
       
            $nN += $cluster[$i][$j];
        }
        $precision += $maxS;
    } 

    return $precision/$nN;
}

sub recall(){
    my @cluster = @_;
    my $nN = 0;
    my $nC = scalar(@cluster);
    my $nK = scalar(@{$cluster[0]});
    my $recall = 0;

    for(my $i = 0; $i < $nK; $i++){
        my $maxS = 0;

        for(my $j = 0; $j < $nC; $j++){
            if($cluster[$j][$i] > $maxS){
                $maxS = $cluster[$j][$i];
            }
       
            $nN += $cluster[$j][$i];
        }
     
        $recall += $maxS;
    } 

    return $recall/$nN;
}

sub choose2{
    my $N = shift;
    my $ret = $N*($N - 1);

    return int($ret/2);
}

sub randindex{
    my @cluster = @_;
    my @ktotals = ();
    my @ctotals = ();
    my $nN = 0;
    my $nC = scalar(@cluster);
    my $nK = scalar(@{$cluster[0]});
    my $cComb = 0;
    my $kComb = 0;
    my $kcComb = 0;
 
    for(my $i = 0; $i < $nK; $i++){
        $ktotals[$i] = 0;
        for(my $j = 0; $j < $nC; $j++){
            $ktotals[$i]+=$cluster[$j][$i];
        }
        $nN += $ktotals[$i];
        $kComb += choose2($ktotals[$i]);
    }
         
  
    for(my $i = 0; $i < $nC; $i++){
        $ctotals[$i] = 0;
        for(my $j = 0; $j < $nK; $j++){
            $ctotals[$i]+=$cluster[$i][$j];
        }
        $cComb += choose2($ctotals[$i]); 
    }

    for(my $i = 0; $i < $nC; $i++){
        for(my $j = 0; $j < $nK; $j++){
            $kcComb += choose2($cluster[$i][$j]);
        }
    }

    my $nComb = choose2($nN);

    return ($nComb - $cComb - $kComb + 2*$kcComb)/$nComb;

}

sub adjrandindex{
    my @cluster = @_;
    my @ktotals = ();
    my @ctotals = ();
    my $nN = 0;
    my $nC = scalar(@cluster);
    my $nK = scalar(@{$cluster[0]});
    my $cComb = 0;
    my $kComb = 0;
    my $kcComb = 0;
 
    for(my $i = 0; $i < $nK; $i++){
        $ktotals[$i] = 0;
        for(my $j = 0; $j < $nC; $j++){
            $ktotals[$i]+=$cluster[$j][$i];
        }
        $nN += $ktotals[$i];
        $kComb += choose2($ktotals[$i]);
    }
         
  
    for(my $i = 0; $i < $nC; $i++){
        $ctotals[$i] = 0;
        for(my $j = 0; $j < $nK; $j++){
            $ctotals[$i]+=$cluster[$i][$j];
        }
        $cComb += choose2($ctotals[$i]); 
    }

    for(my $i = 0; $i < $nC; $i++){
        for(my $j = 0; $j < $nK; $j++){
            $kcComb += choose2($cluster[$i][$j]);
        }
    }

    my $nComb = choose2($nN);
 
    my $temp = ($kComb*$cComb)/$nComb;

    my $ret = $kcComb - $temp;

    return $ret/(0.5*($cComb + $kComb) - $temp);

}



sub nmi{
    my @cluster = @_;
    my @ktotals = ();
    my @ctotals = ();
    my $nN = 0;
    my $nC = scalar(@cluster);
    my $nK = scalar(@{$cluster[0]});
    my $HC = 0.0;
    my $HK = 0.0;

    for(my $i = 0; $i < $nK; $i++){
        $ktotals[$i] = 0;
        for(my $j = 0; $j < $nC; $j++){
            $ktotals[$i]+=$cluster[$j][$i];
        }
        $nN += $ktotals[$i];
    }
         
  
    for(my $i = 0; $i < $nC; $i++){
        $ctotals[$i] = 0;
        for(my $j = 0; $j < $nK; $j++){
            $ctotals[$i]+=$cluster[$i][$j];
        }
        my $dFC = $ctotals[$i]/$nN;
        $HC += -$dFC*log($dFC);
    }

    for(my $i = 0; $i < $nK; $i++){
        my $dFK = $ktotals[$i]/$nN;
        $HK += -$dFK*log($dFK);
    }
  
  
    my $NMI = 0.0;

    for(my $i = 0; $i < $nK; $i++){
        my $NMII = 0.0;

        for(my $j = 0; $j < $nC; $j++){
            my $dF = ($nN*$cluster[$j][$i])/($ctotals[$j]*$ktotals[$i]);
            if($dF > 0.0){
                $NMII += $cluster[$j][$i]*log($dF);
            }
        }
        $NMII /= $nN;
        $NMI += $NMII;
    }

    return (2.0*$NMI)/($HC + $HK);
}
