package MemHandle;

use strict;
use vars qw($VERSION @ISA @EXPORT @EXPORT_OK);
require IO::Handle;
require IO::Seekable;
use Symbol;
use MemHandle::Tie;

require Exporter;
use 5.000;

@ISA = qw(IO::Handle IO::Seekable Exporter);
# Items to export into callers namespace by default. Note: do not export
# names by default without a very good reason. Use EXPORT_OK instead.
# Do not simply export all your public functions/methods/constants.
@EXPORT = qw(
	
);
$VERSION = '0.03';


# Preloaded methods go here.
sub new {
    my $class = shift;
    $class = ref( $class ) || $class || 'MemHandle';
    my $fh = gensym;

    ${*$fh} = tie *$fh, 'MemHandle::Tie', $fh;

    bless $fh, $class;
}

sub seek {
    my $fh = shift;
    ${*$fh}->SEEK( @_ );
}

sub tell {
    my $fh = shift;
    ${*$fh}->TELL( @_ );
}

sub mem {
    my $fh = shift;
    ${*$fh}->{mem};
}

sub doclose {
    my $fh = shift;
    untie *$fh;
    undef ${*$fh};
}

# Autoload methods go after =cut, and are processed by the autosplit program.

1;
__END__
# Below is the stub of documentation for your module. You better edit it!

=head1 NAME

MemHandle - supply memory-based FILEHANDLE methods

=head1 SYNOPSIS

    use MemHandle;
    use IO::Seekable;

    my $mh = new MemHandle;
    print $mh "foo\n";
    $mh->print( "bar\n" );
    printf $mh "This is a number: %d\n", 10;
    $mh->printf( "a string: \"%s\"\n", "all strings come to those who wait" );

    my $len = $mh->tell();  # Use $mh->tell();
                            # tell( $mh ) will NOT work!
    $mh->seek(0, SEEK_SET); # Use $mh->seek($where, $whence)
                            # seek($mh, $where, $whence)
                            # will NOT work!

    Here's the real meat:

    my $mh = new MemHandle;
    my $old = select( $mh );
    .
    .
    .
    print "foo bar\n";
    print "baz\n";
    &MyPrintSub();
    select( $old );
    $mh->seek( 0, SEEK_SET );
    print "here it all is: ", <$mh>, "\n";

=head1 DESCRIPTION

Generates an IO::Handle for use with file routines, but which uses memory.

=head1 AUTHOR

"Sheridan C. Rawlins" <scr14@cornell.edu>

=head1 SEE ALSO

perl(1).
perlfunc(1).
perldoc IO::Handle.
perldoc IO::Seekable.

=cut
