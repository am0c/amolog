package Amolog::Command;

sub run {
    my @args = @_;
    my @tokens = lex @args;
    return parse @tokens;
}

1;
