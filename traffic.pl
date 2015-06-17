#!/usr/bin/perl -Tw

package multithreadediptraverse;

use strict;

use threads;

use threads::shared;

use Thread::Semaphore;

use IO::Socket;

use Fcntl;

my $threadcnt : shared = 0;

my $sem = new Thread::Semaphore(50); # number of simultaneous connections

my ($i, $j, $k, $l);

# main loop

# alternatively use

# for my $dummy (1..1000)

while(1)

{

# generate random IPs and check if they're allowed

$i = 1 + int rand 253;

$j = 1 + int rand 253;

$k = 1 + int rand 253;

$l = 1 + int rand 253;

next unless(isValidIP($i, $j, $k, $l));

# try to create a new thread, and detach it immediately

$sem->down(1);

threads->create(\&child, $i, $j, $k, $l)->detach();

}

# wait for all threads to finish (avoid "A thread exited while $n threads were running")

select(undef,undef,undef,rand 1) while($threadcnt>0);

# finds out if an IP number is valid,

# i.e. it should be neither blacklisted nor non-routable

sub isValidIP

{

my($i,$j,$k,$l) = @_;

# skip rfc1918 IPs

if($i==10 || $i==172 && $j>=16 && $j<=31 || $i==192 && $j==168) { return 0 }

# and other blacklisted IPs maybe...

# elsif(...)

else { return 1 }

}

sub child

{

{ lock($threadcnt); ++$threadcnt; }

my $host = join ('.', @_);

# unless we have root-rights don't use privileged ports; remember there's no port 0 ;-)

my $port = ($> == 0 ? 1 + int rand 65534 : 1025 + int rand (65535-1025));

# alternatively use a limited list of ports

# my @portlist = qw(21 22 25 53 80 110 443);

# $port = $portlist[rand @portlist];

print "thread count: $threadcnt, thread id:".threads->self->tid.", connecting at $host:$port\n";

my $remote = IO::Socket::INET->new(

Proto => 'tcp',

PeerAddr => $host,

PeerPort => $port,

Timeout => 5,

);

# print "Cannot connect to $host:$port\n" if(!$remote);

print "Connected to $host:$port\n" if($remote);

undef $remote;

{ lock($threadcnt); --$threadcnt; }

$sem->up(1);

}