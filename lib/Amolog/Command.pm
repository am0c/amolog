package Amolog::Command;
use 5.014;
use warnings;
use strict;
use List::Gather;

use Data::Dump qw(dump);

sub run {
    my $class = shift;
    my @args = @_;
    my @tokens = lex( @args );
    return parse( @tokens );
}

sub lex {
    my @args = @_;
    gather {
        while (my $line = shift @args) {
            for ($line) {
                when ([qw/ -day -date -month -year /]) {
                    my $range = shift @args;
                    take "CondDate";
                }
                when ([qw/ -text /]) {
                    my $text = shift @args;
                    take "CondText";
                }
                when ([qw/ -user -who /]) {
                    my $user = shift @args;
                    take "CondUser";
                }
                take "Not"        when /^-(!|n|not)$/;
                take "And"        when /^-(a|and)$/;
                take "Or"         when /^-(o|or)$/;
                take "ParenOpen"  when "(";
                take "ParenClose" when ")";
                default {
                    die "Unexpected option: $_";
                }
            }
        }
    }
}

sub parse {
    dump @_;
    ()
}

1;
