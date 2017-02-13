#!/usr/bin/perl -l

use strict;
use warnings;

use Device::SerialPort;
use Time::HiRes qw(usleep nanosleep);
system("rm ./sentChars.hex");
my $filename = './output.hex';
my $port = Device::SerialPort->new("/dev/ttyUSB1");

$port->baudrate(9600); # Configure this to match your device
$port->databits(8);
$port->parity("none");
$port->stopbits(1);
$port->handshake("none");   

open (my $output, '>', './sentChars.hex');

open (my $filehandler, '<:raw', $filename);
binmode($filehandler);
binmode($output);
local $/ = \1;

while( read($filehandler, my $byte, 1 )){
        $port->write($byte);
	say $output $byte;
        usleep(2000);
}
close $filehandler;
close $output;
