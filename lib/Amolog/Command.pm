package Amolog::Command;
use warnings;
use strict;

use Data::Dump qw(dump);

sub run {
    my @args = @_;
    my @tokens = lex( @args );
    return parse( @tokens );
}

sub lex {
    my @args = @_;
    my @tokens;
    while ($_ = shift @args) {
        if (/^-(day|date|month|year)$/) {
            my $range = shift @args;
            push @tokens, "CondDate";
        }
        elsif (/^-text$/) {
            my $text = shift @args;
            push @tokens, "CondText";
        }
        elsif (/^-(user|who)$/) {
            push @tokens, "CondUser";
        }
        elsif (/^-(!|n|not)$/) {
            push @tokens, "Not";
        }
        elsif (/^-(a|and)$/) {
            push @tokens, "And";
        }
        elsif (/^-(o|or)$/) {
            push @tokens, "Or";
        }
        elsif ($_ eq "(") {
            push @tokens, "ParenOpen";
        }
        elsif ($_ eq ")") {
            push @tokens, "ParenClose";
        }
        else {
            die "Unexpected option: $_";
        }
    }
    @tokens;
}

sub parse {
    dump @_;
    ()
}

1;
