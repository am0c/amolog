package Amolog::Command;
use 5.014;
use warnings;
use strict;
use List::Gather;

use Data::Dump qw(dump);

no strict 'subs';

sub run {
    my $class = shift;
    my @args = @_;
    my @tokens = lex( @args );
    dump parse( @tokens );
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

*parse = Amolog::Command::parser::parse;


package Amolog::Command::parser;

our @token;

sub parse {
    @token = @_;
    cond_or();
}

sub cond_or {
    my @res = cond_and();
    while (look('Or')) {
        push @res, match('Or');
        push @res, cond_and();
    }
    return @res > 1 ? \@res : $res[0];
}

sub cond_and {
    my @res = cond_list();
    while (look('And')) {
        push @res, match('And');
        push @res, cond_list();
    }
    return @res > 1 ? \@res : $res[0];
}

sub cond_list {
    my @res;
    while (my @r = cond_factor()) {
        push @res, @r;
    }
    return @res > 1 ? \@res : $res[0];
}

sub cond_factor {
    my @res;
    if (look('ParenOpen')) {
        match('ParenOpen');
        @res = cond_or();
        match('ParenClose');
    }
    elsif (look('Not')) {
        push @res, match('Not');
        push @res, cond_factor();
    }
    elsif (look('Cond')) {
        @res = cond();
    }
    else {
        return;
    }
    return @res > 1 ? \@res : $res[0];
}

sub cond {
    match('Cond');
}

sub match {
    my $expect = shift;
    my $top = $token[0];
    if ($top =~ /^$expect/) {
        return shift @token;
    }
    else {
        die "$expect expected. but got $top";
    }
}

sub look {
    my @expect = @_;
    no warnings 'uninitialized';
    for (0 .. $#expect) {
        return unless $token[$_] =~ /^$expect[$_]/;
    }
    return 1;
}

1;
