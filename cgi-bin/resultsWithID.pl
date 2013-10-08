#!/usr/bin/perl -w
use strict;
use warnings;

use Class::Struct;
use CGI;
my $cgi = CGI->new;
use CGI::Carp qw(fatalsToBrowser);
use Cwd qw( abs_path );
use File::Basename qw(dirname);
use File::Spec;
use Data::Dumper;
use FindBin;                     # locate this script
use lib "$FindBin::Bin/../lib";  # use the parent directory
use PipelineMiRNA::WebFunctions;
use PipelineMiRNA::WebTemplate;

my $bioinfo_menu = PipelineMiRNA::WebTemplate::get_bioinfo_menu();
my $header_menu  = PipelineMiRNA::WebTemplate::get_header_menu();
my $footer       = PipelineMiRNA::WebTemplate::get_footer();

my $id_job = $cgi->param('run_id'); # récupération id job
my $name_job = $cgi->param('nameJob'); # récupération id job

my $HTML_header = <<'END_TXT';
Content-type: application/xhtml+xml

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">

    <head>
        <link rel="stylesheet" type="text/css" href="/arn/style/script.css" />
        <script type="text/javascript" language="Javascript" src="/arn/js/results.js"> </script>
        <script type="text/javascript" src="/arn/js/graphics.js"></script>
        <script type="text/javascript" src="/arn/js/miARN.js"></script>
    	
    	  <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.3.1/jquery.min.js" type="text/javascript"></script>
  		 <script src="/arn/js/imgpreview.full.jquery.js" type="text/javascript"></script>
   	 	
    </head>
END_TXT

my $HTML_additional = "";
if ($name_job ne "")
{
    $HTML_additional .= "<div class='titleJob' ><li>Title Job : ".$name_job."</li></div>";
}

my $valid = PipelineMiRNA::WebFunctions->is_valid_jobID($id_job);

if($valid){
    my %myResults = PipelineMiRNA::WebFunctions->get_structure_for_jobID($id_job);
    my $HTML_results = PipelineMiRNA::WebFunctions->resultstruct2pseudoXML( \%myResults);

    print <<"HTML";
$HTML_header    <body onload="main('all');">

<div class="bloc_droit">

$header_menu

<div class="main main-full">
$HTML_additional
<div id="select" > 
		<p style='font-size:17px;font-family: "Times New Roman", Serif' >Export selected entries \( <a onclick='selectAll()' class='myButton'>Select all<\/a> /  <a  onclick='deSelectAll()'  class='myButton'>Deselect all</a> \) :</p> 
		<form id= 'exportForm'>
		<input type="radio" name="export" checked='checked' value="csv"  />tab-delimited format (csv)<br/>
		<input type="radio" name="export" value="fas"/>fasta format (plain sequence)<br/>
		<input type="radio" name="export" value="dot"/>dot-bracket format (plain sequence + secondary structure)<br/>
		<input type="radio" name="export" value="odf"/>full report in document format (odf)<br/>
		<input type="radio" name="export" value="gff"/>gff format<br/><br/>
		<input type="button" name="bout" value="Export" onclick='exportTo("$id_job")'/>
		</form>
	
		<p style='font-size:16px;font-family: "Times New Roman", Serif' >Click on a line to see the full html report. Click on the checkbox to select an entry.<br/>	<br/>
		Sort by \( <a onclick ="sortingTable(\'all\')"  class='myButton'>Position<\/a> /  <a  onclick ="sortingTable(\'all2\')"   class='myButton'>Quality</a> \)
		</p>
</div>
    
        <div id="table" ></div>
        <div id="singleCell"> </div>
$HTML_results
       
        <div id="id_job" >$id_job</div>
    </div><!-- main -->

    $footer
    </div><!-- bloc droit-->
    	
    </body>
</html>
HTML

}else{
    print <<"HTML";
$HTML_header
<body>
    <div class="theme-border"></div>
    <div class="logo"></div>
    $bioinfo_menu
    <div class="bloc_droit">
        $header_menu
        <div class="main">
        $HTML_additional
            <p>No results available for the given job identifier $id_job: $valid </p>
        </div><!-- main -->
    $footer
    </div><!-- bloc droit-->
    </body>
</html>
HTML
}
