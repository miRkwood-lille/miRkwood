package miRkwood::ResultsExporter::CSVExporterGenomic;

# ABSTRACT: Class for exporting results in CSV

use strict;
use warnings;

use parent 'miRkwood::ResultsExporter::CSVExporter';


sub get_csv_headers {
    my ( $self, @args ) = @_;
    my @optional_fields = miRkwood::Candidate->get_optional_candidate_fields();
    my @csv_headers     = (
        'name', 'start_position', 'end_position', 'quality', '%GC',
        'mfe', 'mfei', 'amfe', @optional_fields, 'structure_stemloop', 'sequence'
    );
    return @csv_headers;
}

1;
