 #!/usr/bin/perl
use warnings;
$var=s\/([0-9a-f]{2})\/print chr hex $1\/gie;
print($var);
