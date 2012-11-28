package Amolog::Command;
use 5.014;
use warnings;
use strict;

use Data::Dump qw(dump);

sub run {
    my $class = shift;
    my @args = @_;
    my @tokens = lex( @args );
    return parse( @tokens );
}

sub lex {
    my @args = @_;
    my @tokens;
    while (my $line = shift @args) {
        for ($line) {
            when ([qw/ -day -date -month -year /]) {
                my $range = shift @args;
                push @tokens, "CondDate";
            }
            when ([qw/ -text /]) {
                my $text = shift @args;
                push @tokens, "CondText";
            }
            when ([qw/ -user -who /]) {
                my $user = shift @args;
                push @tokens, "CondUser";
            }
            push @tokens, "Not"        when /^-(!|n|not)$/;
            push @tokens, "And"        when /^-(a|and)$/;
            push @tokens, "Or"         when /^-(o|or)$/;
            push @tokens, "ParenOpen"  when "(";
            push @tokens, "ParenClose" when ")";
            default {
                die "Unexpected option: $_";
            }
        }
    }
    @tokens;
}

sub parse {
    dump @_;
    ()
}

1;
