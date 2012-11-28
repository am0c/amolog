#!/usr/bin/env perl
use warnings;
use strict;

BEGIN {
  if ($ENV{DEVELOPMENT}) { use lib 'lib' }
}

use Amolog::Command;
Amolog::Command->run( @ARGV );

=pod

=head1 NAME

amolog - grep any kind of logs

=head1 SYNOPSIS

    # select adapter

    amolog.pl -use xchat2
    amolog.pl -use pidgin
    amolog.pl -use firefox


    # time filter option

    amolog.pl -date now
    amolog.pl -date 1..30
    amolog.pl -date 1,4,8

    amolog.pl -day mon
    amolog.pl -day mon..tue


    # user filter option

    amolog.pl -user myname
    amolog.pl -user-regex /_away$/


    # user filter option

    amolog.pl -type notice -notice login


    # irc specific options

    amolog.pl -channel '#perl-kr'


    # operators

    amolog.pl -channel '#perl-kr             \
      -a \( -user 'am0c' -o -user 'jeen' \)  \
      -a -not -today

=head1 OPTION

=over

=item -use

C<-use> loads adapter plugin and imports command line options.
There is default options from base class L<::Default>.

=item -date

It takes one paramter, it can be range or time format.

=back

=end
