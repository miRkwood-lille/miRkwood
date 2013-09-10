package PipelineMiRNA::Parsers;

use strict;
use warnings;


=method parse_pvalue

Parse the contents of the given pvalue file

=cut

sub parse_pvalue {
    my @args   = @_;
    my $pvalue = shift @args;
    my $result;
    open( my $FH, '<', $pvalue ) or die "Error when opening file $pvalue: $!";
    while ( my $line = <$FH> ) {

        if ( $line =~ m{
           ^                #Begin of line
           (.*?)            #A non-greedy sequence of characters, captured
           \t               #One tabulation
           (.*?)            #A non-greedy sequence of characters, captured
           \t               #One tabulation
           (.*?)            #A non-greedy sequence of characters, captured
           $                #End of line
           }smx ) {
           $result = $3;
       }

    }
    close $FH or die("Error when closing: $!");
    return $result;
}

=method parse_mfei

Parse the contents of the given MFEI file

=cut

sub parse_mfei {
    my @args     = @_;
    my $mfei_out = shift @args;
    my @res;
    open( my $FH, '<', $mfei_out )
      or die "Error when opening file: $!";
    while ( my $line = <$FH> ) {
        if ( $line =~ /(.*)\t(.*)\t(.*)\t(.*)/xms ) {
            push @res, $2;
            push @res, $3;
            push @res, $4;
        }
    }
    close $FH or die("Error when closing: $!");
    return @res;
}

=method parse_selfcontain

Parse the contents of the given SelfContain file

=cut

sub parse_selfcontain {
    my @args            = @_;
    my $selfcontain_out = shift @args;
    my $result;
    open( my $FH, '<', $selfcontain_out )
      or die "Error when opening file: $!";
    while ( my $line = <$FH> ) {
        if ( $line =~ /(.*) (.*)/xms ) {
            $result = $2;
        }
    }
    close $FH or die("Error when closing: $!");
    return $result;
}

=method parse_vienna

Parse the contents of the given Vienna file

=cut

sub parse_vienna {
    my @args       = @_;
    my $vienna_out = shift @args;
    my @res;
    open( my $FH, '<', $vienna_out )
      or die "Error when opening file: $!";
    while ( my $line = <$FH> ){
        if ( $line =~ m{
           ^\s+?            # Begin of line and some whitespace
           ([aAcCgGtTuU]*)  # A sequence of nucleotides, captured
           \s+?             # Some whitespace
           ([\(\.\)]+)      # A sequence of either '.', '(' or ')'
           \s+?             # Some whitespace
           (.*?)$           # Whatever, non-greedy, captured
           \s*$             # Some whitespace until the end
           }smx ) {
            $res[0] = $1;    # récupération sequence
            $res[1] = $2;    # récupération Vienna
       }
    }
    close $FH or die("Error when closing: $!");
    return @res;
}

=method parse_alignment

Parse the contents of the given Alignment file

=cut

sub parse_alignment {
    my @args            = @_;
    my $alignement_file = shift @args;
    open( my $FH, '<', $alignement_file )
      or die "Error when opening file: $!";
    my $align = 'none';
    while ( my $line = <$FH> ) {
        if ( $line =~ /^C4/xms ) {
            $align = $alignement_file;
            last;
        }
    }
    close $FH or die("Error when closing: $!");
    return $align;
}

=method parse_Vienna_line

Parse the given Vienna format line, return a couple (structure, energy)

=cut

sub parse_Vienna_line {
    my @args = @_;
    my $line = shift @args;
    my ( $structure, $energy ) =
                $line =~ m{
                       ^                #Begin of line
                       ([\.()]+?)       #A sequence of ( ) .
                       \s+?             #Some whitespace
                       \(\s*?           #Opening parenthesis and maybe whistespace
                           ([-.\d]*?)   #
                       \s*?\)           #Closing parenthesis and maybe whistespace
                       \s*$             #Whitespace until the end
                   }smx;
    return ( $structure, $energy );
}

1;
