#!/usr/bin/perl
use strict;
use warnings;

if(scalar(@ARGV)!=3){
    printArgsErr();
    exit(1);
}

my $revHash=$ARGV[0];
my $repoPath=$ARGV[1];
my $filePath=$ARGV[2];
my $overedHeader=0;

my $lineNum;
open(IN,"cd $repoPath; git --no-pager diff -w -U0 $revHash^ $revHash -- $filePath |");
while(<IN>){
    my $line=$_;
    if($line=~/^@@\s-(\d+)(,\d+)?\s\+(\d+)(,\d+)?\s@@/){
        $overedHeader=1;
        $lineNum=$3;
        next;
    }
    if($overedHeader==0){
        next;
    }
    if($line!~/^\+/){
        next;
    }
    print("$lineNum\n");
    $lineNum++;
}
close(IN);

#
# SUB ROUTINE
#
sub printArgsErr{
    my $errMes="* * * * * ERROR * * * * *\n";
    $errMes.="wrong number of arguments.\n";
    $errMes.="please type arguments as below.\n";
    $errMes.="perl addedLineNumbers.pl <revHash> <repoPath> <filePath>\n";
    print($errMes);
}