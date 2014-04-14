#!/usr/bin/perl -w

# PODNAME: mirkwood.pl
# ABSTRACT: miRkwood - A micro-RNA analysis pipeline

use warnings;
use strict;

use Pod::Usage;
use Getopt::Long;
use File::Copy;
use File::Spec;

my $man  = 0;
my $help = 0;

# Pipeline options
my $both_strands = 0;
my $randfold     = 0;
my $mfei         = 0;
my $align        = 0;
my $species_mask = '';
my $no_varna     = 0;

my $mask          = 0;
my $output_folder = 'results_directory';

## Parse options
GetOptions(
    randfold         => \$randfold,
    mfei             => \$mfei,
    align            => \$align,
    'both-strands'   => \$both_strands,
    'no-varna'       => \$no_varna,
    'species-mask=s' => \$species_mask,
    'output=s'       => \$output_folder,
    'help|?'         => \$help,
    man              => \$man
) || pod2usage( -verbose => 0 );
pod2usage( -verbose => 1 ) if ($help);
pod2usage( -verbose => 2 ) if ($man);

pod2usage("$0: No FASTA files given.") if ( @ARGV == 0 );

if ($species_mask) {
    $mask = 1;
}

my $varna = 1;
if ($no_varna) {
    $varna = 0;
}

my $fasta_file = $ARGV[0];
( -e $fasta_file ) or die("$fasta_file is not a file");

my $abs_output_folder = File::Spec->rel2abs($output_folder);
if ( !-e $abs_output_folder ) {
    print "Creating $abs_output_folder\n";
    mkdir $output_folder or die("Error when creating $abs_output_folder");
}
my $tmp_pieces_folder = File::Spec->catdir( $abs_output_folder, 'pieces' );
if ( !-e $tmp_pieces_folder ) {
    mkdir $tmp_pieces_folder or die("Error when creating $tmp_pieces_folder");
}

# Importing stuff after directory creation
use PipelineMiRNA;
use PipelineMiRNA::CLI;
use PipelineMiRNA::MainPipeline;
use PipelineMiRNA::Paths;

my $seq_name = 'Sequences.fas';
my $seq_path = File::Spec->catfile( $abs_output_folder, $seq_name );

File::Copy::copy( $fasta_file, $seq_path );

my $run_options_file =
  PipelineMiRNA::Paths->get_job_config_path($abs_output_folder);
PipelineMiRNA->CONFIG_FILE($run_options_file);
PipelineMiRNA::write_config( $run_options_file, $both_strands, $mfei, $randfold,
    $align, "", $species_mask, $varna );

PipelineMiRNA::MainPipeline::main_entry($abs_output_folder);
PipelineMiRNA::CLI::process_results_dir_for_offline($abs_output_folder);

__END__

=head1 SYNOPSIS

mirkwood [options] [FASTA files]

=head1 OPTIONS

=over 8

=item B<--both-strands>

Process both strands

=item B<--species-mask>

Mask coding regions against the given organism

=item B<--randfold>

Compute thermodynamic stability

=item B<--mfei>

Compute MFE/MFEI/AMFE (minimal folding energy)

=item B<--align>

Align against mature microRNAs miRBase

=item B<--no-varna>

Disable the structure genration using Varna

=item B<-help>

Print a brief help message and exits.

=item B<-man>

Prints the manual page and exits.

=back

=head1 DESCRIPTION

B<miRkwood> is a micro-RNA analysis pipeline.

=cut
