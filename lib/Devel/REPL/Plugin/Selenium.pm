package Devel::REPL::Plugin::Selenium;
 
use Devel::REPL::Plugin;
use Data::Dumper;
use namespace::clean -except => [ 'meta' ];
 
has 'selenium' => (isa     => 'Object', is => 'rw');

sub selenium_lex_env {
    my $self = shift;

    my $class = ref($self->selenium);
    my $code = "my \$sel;\n" . Data::Dumper->Dump([$self->selenium], ['sel']);
    $code .= "delete \$sel->{_ua};\n";
    $code .= "use $class; bless \$sel, '$class';";
    return $code;
}

around 'read' => sub {
    my $orig = shift;
    my ($self, @args) = @_;
    my $line = $self->$orig(@args);
    return $line unless $line =~ m/\S/;

    if ($line =~ m/^js:\s*(.+)/) {
        $line = "get_eval(q|$1|)";
    }
    $line =~ s/^(jQuery|\$)\((.+)/get_eval(q|window.jQuery($1)|)/;
    $line = "\$sel->$line";
    warn $line;
    return $line;
};

1;
