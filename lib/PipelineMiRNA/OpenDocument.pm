package PipelineMiRNA::OpenDocument;

# ABSTRACT: Exporting pipeline results as OpenDocument

use strict;
use warnings;

use PipelineMiRNA::Paths;
use File::Spec;
use PipelineMiRNA::WebFunctions;
use ODF::lpOD;

=method prepare_document

Return a prepared ODF document object
with styles already set.

=cut

sub prepare_document {
    my ( $self, @args ) = @_;
    my $doc = odf_document->create('text')
      or die 'Error when initialising ODF document';

    my $elt;

    # Default paragraph style creation
    $elt = $doc->insert_style(
        odf_create_style(
            'paragraph',
            margin_top    => '2mm',
            margin_bottom => '2mm',
            orphans       => 2,
            widows        => 2
        ),
        default => TRUE
    );
    $elt->set_properties(
        area     => 'text',
        language => 'none',
        country  => 'none'
    );

    # Basic paragraph style creation
    $elt = $doc->insert_style(
        odf_create_style(
            'paragraph',
            name        => 'Basic',
            margin_top  => '0mm',
            margin_left => '0mm'
        )
    );

    # Level 2 Heading style creation
    my $heading_style = $doc->insert_style(
        odf_create_style(
            'paragraph',
            name           => 'Level 2 Heading',
            keep_with_next => 'always',
            margin_top     => '1cm',
            margin_bottom  => '4mm'
        )
    );
    $heading_style->set_properties(
        area   => 'text',
        size   => '16pt',
        weight => 'bold',
        style  => 'italic',
        color  => 'navy blue'
    );

    # top title style
    $doc->insert_style(
        odf_create_style(
            'paragraph',
            name          => 'Top title',
            align         => 'center',
            margin_top    => '0cm',
            margin_bottom => '1cm'
        )
      )->set_properties(
        area   => 'text',
        size   => '200%',
        weight => 'bold',
        color  => 'navy blue'
      );
    return $doc;
}

=method generate_report

Generate an ODF document for the given jobID

Write it on disk and return the server path to it.

=cut

sub generate_report {
    my ( $self, @args ) = @_;
    my $jobId = shift @args;

    my $jobPath = PipelineMiRNA::WebFunctions->jobId_to_jobPath($jobId);

    my $ODP_filename = "Prediction_report_$jobId.odt";
    my $ODP_abspath =
      File::Spec->catfile( PipelineMiRNA::Paths->get_absolute_path($jobPath),
        $ODP_filename );
    my $ODP_serverpath =
      File::Spec->catfile( PipelineMiRNA::Paths->get_server_path($jobPath),
        $ODP_filename );

    my %results = PipelineMiRNA::WebFunctions->get_structure_for_jobID($jobId);

    my $doc = $self->prepare_document();

    # Main context access
    my $context = $doc->body;

    # Metadata access
    my $meta = $doc->meta;

    $meta->set_generator('PipelineMiRNA');
    $meta->set_title('PipelineMiRNA results');

    # make sure that the document body is empty
    $context->clear;

    # put the main title
    $context->append_element(
        odf_create_heading(
            level => 1,
            text  => 'PipelineMiRNA results',
            style => 'Top title'
        )
    );
    my @headers = qw( position mfei mfe amfe p_value self_contain );
    my @keys    = sort keys %results;

    foreach my $key (@keys) {
        my $value = $results{$key};
        my ( $start, $end ) = split( m/[-]/xms, ${$value}{'position'} );
        $context->append_element(
            odf_create_heading(
                level => 2,
                text  => $key,
            )
        );
        my $result;
        for my $header (@headers) {
            $result .= "$header: ${$value}{$header}\n";
        }
        my $vienna_seq =
          PipelineMiRNA::WebFunctions->make_Vienna_viz( ${$value}{'Vienna'},
            ${$value}{'DNASequence'} );

        $result .= "Vienna:\n$vienna_seq";
        my $para =
          $context->append_element( odf_create_paragraph( text => $result ) );

        my $img_path      = ${$value}{'image'};
        my $img_full_path = PipelineMiRNA::Paths->get_absolute_path($img_path);

        my ( $lien_image, $taille_image ) =
          $doc->add_image_file($img_full_path);
        $para->append_element(
            odf_frame->create(
                image => $lien_image,
                name  => "Structure_${$value}{'name'}_${$value}{'position'}",
                title => 'Structure',
                description => 'Structure',
                name        => 'Fleur',
                size        => $taille_image,
            )
        );
    }    #  while each %results

    # save the generated document and quit
    $doc->save( target => $ODP_abspath, pretty => TRUE );

    return $ODP_serverpath;
}

1;
