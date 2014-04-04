<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
  <head>
        <link type='text/css' rel='stylesheet' href='./Style/bioinfo.css' />
		<link type='text/css' rel='stylesheet' href='./style/help.css' />
		<link type='text/css' rel='stylesheet' href='./style/rna.css' />
        <script type='text/javascript' src='/js/miARN.js'></script>
        <title>MicroRNA identification</title>
    </head>
 <body>
        <div class="theme-border"></div>
        <div class="logo"></div>
         <? include("./static/bioinfo_menu.txt") ?>
        <div class="bloc_droit">
        <? include("./static/header_menu.txt") ?>
<div class="main">
<p>This page is a user manual for <a href='/cgi-bin/mirkwood/web_scripts/interface.pl'>miRkwood website</a>.
The method implemented in miRkwood is described in full detail in this other page.</p>

<div class="table-of-contents">
<ol>
	<li><a href="#input_form">Input form</a></li>
	<li><a href="#results_page">Result page</a></li>
	<li><a href="#export">Export</a></li>
	<li><a href="#html_report">HTML report</a></li>
</ol>
</div>

<h2 id='input_form'>Input form</h2>


<p>The input form of miRkwood has three main sections:</p>
<ol>
	<li>Enter query sequence,</li>
	<li>Parameters: select additional annotation criteria for the miRNA precursors,</li>
	<li>Submit the job.</li>
</ol>
<p>Results are displayed on a new page.<p>

<h3>Enter query sequence</h3>

<p>miRkwood input is (Multi) FASTA  format.  Lower-case and upper-case letters are both accepted, as well as T/U.  Other characters, such as N, R, Y,&#8230; are prohibited.</p>

<p>You can either paste or upload a file. The maximum size for a submission is 100 000 nt.</p>

<p><strong>Scan both strands:</strong> miRkwood normally analyses data in forward direction only. Checking this option will cause the program to search both the forward and reverse complement strands.</p>

<p><strong>Mask coding regions:</strong> This option allows selecting non-coding sequences in the input data by masking putative coding regions. It consists in a BlastX search against the protein sequences from the chosen species (E-value=1E-5).  Currently available species are: <i>Arabidopsis thaliana</i>, <i>Medicago truncatula</i> (<a href='http://www.jcvi.org/medicago/'>Medicago truncatula genome project</a>, Mt4.0) and <i>Oriza sativa</i> (<a href='http://rice.plantbiology.msu.edu/'>Rice genome annotation project</a>, V7.0).</p>

<h3>Parameters</h3>

<p>miRkwood folds the input sequence to identify miRNA precursor secondary structures (see miRkwood method for more explanation on this step). This gives a set of candidate pre-miRNAs. For each candidate pre-miRNA, it is possible to calculate additional criteria that help to bring further evidence to the quality of the prediction and to distinguish accurate miRNA precursors from pseudo-hairpins.</p>

<p id='mfei_definition'><strong>Select only sequences with MFEI < -0.6:</strong> MFEI is the minimal folding free energy index. It is calculated by the following equation:</p>

<p class='equation'>MFEI = [MFE / sequence length x 100] / (G+C%).</p>

<p>where MFE (minimal free energy) denotes the negative folding free energies of a secondary structure, and is calculated using the Matthews-Turner nearest neighbor model implemented in <a href='http://www.tbi.univie.ac.at/~ronny/RNA/RNAeval.html'>RNAeval</a>. When checked, this option removes all candidate pre-miRNAs with an MFEI greater than or equal to -0.6. Indeed, more than 96% of miRBase precursors have an MFEI smaller than -0.6, whereas pseudo-hairpins show significantly larger values of MFEI (for more details, see <a href='./mirkwood/method.php'>miRkwood method</a>).</p>

<p><strong>Compute thermodynamic stability:</strong> The significance of the stability of the sequence can also be measured by comparison with other equivalent sequences. <em><a href='http://www.ncbi.nlm.nih.gov/pubmed/15217813'>Bonnet et al</a></em> have established that the majority of the pre-miRNA sequences exhibit a MFE that is lower than that for shuffled sequences.  We compute the probability that, for a given sequence, the MFE of the secondary structure is different from a distribution of MFE computed with 300 random sequences with the same length and the same dinucleotide frequency. </p>

<p><strong>Flag conserved mature miRNAs:</strong> Some families of mature miRNAs are highly conserved through evolution. In this case, it is possible to localize  the mature miRNA within the pre-miRNA  by similarity. For that,  we compare each sequence with  the mature miRNAs of plant (<i>Viridiplantae</i>) deposited in <a href='http://www.mirbase.org/ftp.shtml'>miRBase</a> (Release 20). Alignments are performed with <a href='https://www.ebi.ac.uk/~guy/exonerate/'>Exonerate</a>, which implements an exact model for pairwise alignment. We select alignments with at most three errors (mismatch, deletion or insertion) against the full-length mature miRNA and that occur in one of the two arms of the stem-loop.  The putative location obtained is then validated with <a href='http://www.cs.mcgill.ca/~blanchem/mirdup/'>miRdup</a>, that assesses the stability of the miRNA-miRNA* duplex. Here, it was trained on miRbase Viridiplantae v20.

<h3>Submission</h3>

<p>Each job is automatically assigned an ID.</p>

<p><strong>Job title: </strong>It is possible to identify the tool result by giving it a name.</p>

<p><strong>Email address: </strong> You can enter your email address to be notified when the job is finished. The email contains a link to access the results for 2 weeks.</p>

<h2 id='results_page'>Result page</h2>

<p>Results are summarized in a two-way table. Each row corresponds to a pre-miRNA, and each column to a feature. By default, results are sorted by sequence and then by position. It is possible to have them sorted by quality (<a href='#definition_quality'>see definition</a>) You can view all information related to a given prediction by clicking on the row (<a href='#html_report'>see section HTML Report</a>).</p>

<p><strong>Name:</strong> Name of the original sequence, as specified in the heading of the FASTA format.</p>

<p><strong>Position:</strong> Start and end positions of the putative pre-miRNA in the original sequence.</p>

<p><strong>+/- (option):</strong> Strand, forward or reverse complement. </p>

<p id='definition_quality'><strong>Quality:</strong> The quality is a distinctive feature of miRkwood. It is a combination of all other criteria described afterwards, and allows to rank the predictions according to the significance, from zero- to three- stars. It is calculated as follows: 
<ul>
<li><em>MFEI &lt; -0.8:</em> add one star. This MFEI threshold covers 83% of miRBase pre-miRNAs, whereas it is observed in less than 13% of pseudo hairpins (see XXX)</li>

<li><em>Existence of a conserved miRNA in miRBase (alignment):</em> add one star. We allow up to three errors in the alignment with mature miRBase, which corresponds to an estimated P-value of  3E-2 for each pre-miRNA. Alignments with 2 errors or less have an estimated P-value of 4E-3.

<li><em>The location of the mature miRNA obtained by alignment is validated by miRdup:</em> add one star</p>
</ul>

<p><strong>MFE:</strong> value of the minimal free energy (computed with <a href='http://www.tbi.univie.ac.at/~ronny/RNA/RNAeval.html'>RNAeval</a>).</p>

<p><strong>MFEI:</strong> value of the MFEI (<a href='#mfei_definition'>see definition</a>).</p>

<p><strong>Shuffles (option):</strong> proportion of shuffled sequences whose MFE is lower than the MFE of the candidate miRNA precursor (see <em>Compute thermodynamic stability</em>).  This value ranges between 0 and 1. The smaller it is, the more significant is the MFE.  We report pre-miRNA stem-loops for which the value is smaller than 0.01, which covers more than 89% of miRBase sequences. Otherwise, if the P-value is greater than 0.01, we say that it is non significant, and do not report any value.</p>

<p><strong>miRBase alignment (option):</strong> This cell is checked when an alignment between the candidate sequence and miRBase is found (see <em>Flag conserved mature miRNAs</em>). It is doubled checked when the location of the candidate mature miRNA is validated by miRdup. The alignments are visible in the HTML or ODF report.</p>

<p><strong>2D structure:</strong> You can drag the mouse over the zoom icon to visualize the stem-loop structure of the pre-miRNA. The image is generated with <a href='http://varna.lri.fr/'>Varna</a>.</p>

<h2>Export</h2>

<p>Results, or a selection thereof, can also be exported to a variety of formats, and saved to a local folder for further analyses.</p>

<p><strong>GFF:</strong> General annotation format, that displays the list of positions of pre-miRNA found (see more explanation on <a href='http://www.ensembl.org/info/website/upload/gff.html'>Ensembl documentation</a>)/</p>

<p><strong>FASTA:</strong> This is the compilation of all pre-miRNA sequences found 

<p><strong>Dot-bracket notation:</strong> This is the compilation of all pre-miRNA sequences found, together with the predicted secondary structure. The secondary structure is given as a set of matching parentheses (see more explanation on <a href='http://www.tbi.univie.ac.at/RNA/bracket.html'>Vienna website</a>).</p>

<p><strong>CSV (comma separated value):</strong> It contains the same information as the result table, plus the FASTA sequences and the dot-bracket secondary structures. This tabular format is supported by spreadsheets like Excel.</p>

<p><strong>ODF:</strong> This is an equivalent of the <a href='#html_report'>HTML report</a>, and contains the full report of the predictions. This document format is compatible with Word or OpenOffice.</p>

<h2 id='html_report'>HTML Report</h2>

<p>The HTML report contains all information related to a given predicted pre-miRNA.</p>

<p>It begins with the following information.</p>

<ul>
<li><strong>Name:</strong> Name of the initial sequence, as specified in the heading of the FASTA format</li>

<li><strong>Position:</strong> Start and end positions of the putative pre-miRNA in the original sequence. The length is indicated in parentheses</li>

<li><strong>Strand:</strong> + (forward) or - (reverse complement)</li>

<li><strong>GC content:</strong> Percentage of bases that are either guanine or cytosine</li>

<li><strong>Sequence (FASTA format):</strong> Link to download the sequence</li>

<li><strong>Stem-loop structure:</strong> Link to download the secondary structure in dot-bracket format.  The first line contains a FASTA-like header. The second line contains the nucleic acid sequence. The last line contains the set of associated pairings encoded by brackets and dots. A base pair between bases <em>i</em> and <em>j</em> is represented by a "(" at position <em>i</em> and a ")" at position <em>j</em>. Unpaired bases are represented by dots. </li>

<pre>
> Sample_1001-1085, stemloop structure
cugagauacugccauagacgacuagccaucccucuggcucuuagauagccggauacagugauuuugaaagguuugugggguacag
(((...((((.((((((((........(((.((((((((.......)))))))....).)))........)))))))))))))))
</pre>

<li><strong>Optimal MFE secondary structure:</strong> If the stem-loop structure is not the MFE structure, we also provide a link to download the MFE structure.</li>

<li><strong>Alternative candidates (dot-bracket format):</strong> This is the set of stem-loop sequences that overlap the current prediction. The choice between several alternative overlapping candidate pre-miRNAs is made according to the best MFEI.</li>
</ul>
<p>The stem-loop structure of the miRNA precursor is also displayed with Varna.</p>

<h3>Thermodynamics stability</h3>
<ul>
<li><strong>MFE:</strong> Value of the Minimum Free Energy (computed by <a href='http://www.tbi.univie.ac.at/~ronny/RNA/RNAeval.html'>RNAeval</a>)</li>

<li><strong>AMFE:</strong> Value of the adjusted MFE : MFE &divide; (sequence length) &times; 100</li>

<li><strong>MFEI:</strong> Value of the minimum folding energy index (<a href='#mfei_definition'>see definition</a>).</li>

<li><strong>Shuffles:</strong> Proportion of shuffled sequences whose MFE is lower than the MFE of the candidate miRNA precursor (see Compute thermodynamic stability).  This value ranges between 0 and 1. The smaller it is, the more significant is the MFE.  We report pre-miRNA stem-loops for which the value is smaller than 0.01, which covers more than 89% of miRBase sequences. Otherwise, if the P-value is greater than 0.01, we say that it is non significant, and do not report any value.</li>
</ul>

<h3>Conservation of the mature miRNA</h3>

<p>All alignments with miRBase are reported and gathered according to their positions.</p>
<div class='example'>
<pre class='alignment'>
query            19 ucgcuuggugcaggucggga- 38
                    ||||||||||||| ||||||  
miRBase           1 ucgcuuggugcagaucgggac 21
</pre>
<span class="others">miRBase sequences: <a href='http://mirbase.org/cgi-bin/mirna_entry.pl?acc=MIMAT0001045'>osa-miR168a-5p</a>, <a href='http://mirbase.org/cgi-bin/mirna_entry.pl?acc=MIMAT0001452'>sbi-miR168</a>, <a href='http://mirbase.org/cgi-bin/mirna_entry.pl?acc=MIMAT0001665'>sof-miR168a</a>, <a href='http://mirbase.org/cgi-bin/mirna_entry.pl?acc=MIMAT0001726'>zma-miR168a-5p</a>, <a href='http://mirbase.org/cgi-bin/mirna_entry.pl?acc=MIMAT0001727'>zma-miR168b-5p</a>, <a href='http://mirbase.org/cgi-bin/mirna_entry.pl?acc=MIMAT0018215'>hvu-miR168-5p</a></span>
</div>

<p>query is the user sequence, and miRBase designates the mature miRNA found in miRBase. It is possible to access the corresponding mirBAse entry by clicking on the link under the alignment. The report also indicates whether the location is validated with <a href='http://www.cs.mcgill.ca/~blanchem/mirdup/'>miRdup</a>. Finally, we provide an ASCII representation of the putative miRNA within the stem-loop  precursor.</p>
    


 </div>
        </div><!-- bloc droit-->
       <? include("./static/footer.txt") ?>
    </body>
    
</html>