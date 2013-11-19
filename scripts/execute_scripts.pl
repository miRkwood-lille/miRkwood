#!/usr/bin/perl -w

use warnings;
use strict;

use FindBin;

BEGIN {
    use lib File::Spec->catdir( $FindBin::Bin, '..', 'lib' );
    use PipelineMiRNA;
    use PipelineMiRNA::MainPipeline;
}


## Code ##
my ( $ifilterCDS, $imfei, $irandfold,  $ialign, $idirJob, $iplant ) = @ARGV;

PipelineMiRNA::MainPipeline::main_entry( $ifilterCDS, $imfei, $irandfold, $ialign, $idirJob, $iplant );
