#!/usr/bin/perl -w
#
# Get current swap usage for all running processes
#
#
# Author = 
#
# Parses pids in /proc, collects the name from /proc/$pid/comm and 
# calculates the swapsize from /proc/$pid/smaps
# 
# Warning: Needs root permissions to read swap values, will otherwise return 0.
# If you don't trust this, learn some Perl and check the code :-)
# Something I'd suggest you to do anyway!
use strict;
my $overall = 0;
my $dirname = "/proc";
my %names = ();
my %swaps = ();
my $processname = '';
my $pidnumber = '';
my $swapsizenumber = '';
# Open /proc directory and parse for PIDs and store them in hash.
opendir(DIR, $dirname) or die "Couldn't open $dirname: $!";
while ( defined ( my $pid = readdir DIR )){
  next unless $pid =~ /^\d+$/;  # PIDs are digits only, skip the rest
  if (-d "$dirname/$pid") {
    $names{$pid} = &read_processname_from($pid);
    $swaps{$pid} = &get_swapsize_from($pid);
  }
}
closedir(DIR);

format STDOUT =
@<<<<<< | @<<<<< | @<<<<<<<<<<<<<<< |
$pidnumber,$swapsizenumber,$processname
.

print "-------------------------------------\n";
print "Processes and their swapsizes\n";
print "-------------------------------------\n";
print " PID    |  SWAP   | PROCESSNAME |\n";
print "-------------------------------------\n";
my @pids = sort { $swaps{$a} <=> $swaps{$b} } (keys %swaps);
foreach my $pid ( @pids ){
  $pidnumber = $pid;
  $processname = $names{$pid};
  $swapsizenumber = $swaps{$pid};
  $overall += $swapsizenumber;
  write(STDOUT);
}
print "-------------------------------------\n";
print "Overall Swap used: $overall KiB\n";
exit 0;
sub read_processname_from {
  my $pid = shift;
  my $procnamefile = "$dirname/$pid/comm";
  open (FH, $procnamefile) or die "Can't open $procnamefile: $!";
  my $procname = <FH>;
  chomp $procname;
  close(FH);
  return $procname;
}
sub get_swapsize_from {
  my $pid = shift;
  my $sum = 0;
  my $smapsfile = "$dirname/$pid/smaps";
  open (FH, $smapsfile) or die "Can't open $smapsfile: $!";
  while (<FH>){
    next unless /^Swap/;
    $_ =~ m/^Swap:\s+(\d+)\s+kB*$/;
    my $swapsize = $1;
    $sum += $swapsize;
 }
 close (FH);
 return $sum;
}
