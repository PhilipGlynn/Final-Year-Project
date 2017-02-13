#!/usr/bin/perl -l

use strict;
use warnings;

use Device::SerialPort;
use Time::HiRes qw(usleep nanosleep);

my $filename = './output.hex';
my $port = Device::SerialPort->new("/dev/ttyUSB1");

$port->baudrate(9600); # Configure this to match your device
$port->databits(8);
$port->parity("none");
$port->stopbits(1);
$port->handshake("none");   

open (my $filehandler, '<:raw', $filename);
binmode($filehandler);

while( read($filehandler, my $byte, 1 )){
        $port->write($byte);
        usleep(2000);
}
close $filehandler;
