package Stronghold::Makerand;

require 5.005_62;
use strict;
use warnings;
use Carp;

require Exporter;
require DynaLoader;
use AutoLoader;

our @ISA = qw(Exporter DynaLoader);

# Items to export into callers namespace by default. Note: do not export
# names by default without a very good reason. Use EXPORT_OK instead.
# Do not simply export all your public functions/methods/constants.

# This allows declaration	use Stronghold::Makerand ':all';
# If you do not need this, moving things directly into @EXPORT or @EXPORT_OK
# will save memory.
our %EXPORT_TAGS = ( 'all' => [ qw(
	trand32
) ] );

our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );

our @EXPORT = qw(
	
);
our $VERSION = '0.01';

sub AUTOLOAD {
    # This AUTOLOAD is used to 'autoload' constants from the constant()
    # XS function.  If a constant is not found then control is passed
    # to the AUTOLOAD in AutoLoader.

    my $constname;
    our $AUTOLOAD;
    ($constname = $AUTOLOAD) =~ s/.*:://;
    croak "& not defined" if $constname eq 'constant';
    my $val = constant($constname, @_ ? $_[0] : 0);
    if ($! != 0) {
	if ($! =~ /Invalid/ || $!{EINVAL}) {
	    $AutoLoader::AUTOLOAD = $AUTOLOAD;
	    goto &AutoLoader::AUTOLOAD;
	}
	else {
	    croak "Your vendor has not defined Stronghold::Makerand macro $constname";
	}
    }
    {
	no strict 'refs';
	# Fixed between 5.005_53 and 5.005_61
	if ($] >= 5.00561) {
	    *$AUTOLOAD = sub () { $val };
	}
	else {
	    *$AUTOLOAD = sub { $val };
	}
    }
    goto &$AUTOLOAD;
}

bootstrap Stronghold::Makerand $VERSION;

# Preloaded methods go here.

# Autoload methods go after =cut, and are processed by the autosplit program.

1;
__END__
# Below is stub documentation for your module. You better edit it!

=head1 NAME

Stronghold::Makerand - Perl extension for the truerand library

=head1 SYNOPSIS

  use Stronghold::Makerand;
  $rand = Stronghold::Makerand::trand32();

=head1 DESCRIPTION

Uses the truerand library to generate a random 32 bit number.

The basic idea here is that between clock "skew" and various
hard-to-predict OS event arrivals, counting a tight loop will yield
a little (maybe a third of a bit or so) of "good" randomness per
interval clock tick.  This seems to work well even on unloaded
machines.  If there is a human operator at the machine, you should
augment truerand with other measure, like keyboard event timing.

On server machines (e.g., when you need to generate a
Diffie-Hellman secret) truerand alone may be good enough.

=head2 Exportable functions

  unsigned long trand32(void)

=head1 AUTHOR

The truerand library was developed by Matt Blaze, Jim Reeds, and Jack
Lacy. Copyright (c) 1992, 1994 AT&T.  This Perl extension was created
by Mark Cox, mjc@redhat.com, March 2001.

=head1 SEE ALSO

perl(1).

=cut
