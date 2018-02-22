---
bibliography:
- '\\GlobalResourcePath refs.bib'
---

= 20pt

**Phylogenetic Inference using <span>`RevBayes`</span>**\

***<span>Total-Evidence Analysis of Fossil and Extant Taxa under the
Fossilized Birth-Death Process</span>***\

Overview {#sect:Overview}
========

This tutorial demonstrates how to specify the models used in a Bayesian
“total-evidence” phylogenetic analysis of extant and fossil species,
combining morphological and molecular data as well as stratigraphic
range data from the fossil record [<span><span>*e.g.,*</span></span>
@Ronquist2012a; @Zhang2016; @Gavryushkina2016]. We begin with a concise
introduction to the models used in this analysis in section
\[sect:Introduction\], followed by a detailed example analysis in
section \[sect:Exercise\] demonstrating how to apply these models in
<span>`RevBayes`</span>[@Hoehna2017a] and use Markov chain Monte Carlo
(MCMC) to estimate the posterior distribution of dated phylogenies for
data collected from living and fossil bears (family Ursidae).

Requirements {#subsect:Overview-Requirements}
------------

### Required Software {#subsub:Req-Software}

This tutorial requires that you download and install the latest release
of <span>`RevBayes`</span>[@Hoehna2017a], which is available for Mac OS
X, Windows, and Linux operating systems. Directions for downloading and
installing the software are available on the program webpage:
[http://revbayes.com](http://revbayes.com/). The exercise provided also
requires additional programs for editing text files and visualizing
output. The following are very useful tools for working with
<span>`RevBayes`</span>:

-   A good text editor – if you do not already have one that you like,
    we recommend one that has features for syntax coloring, easy
    navigation between different files, line numbers, etc. Good options
    include [Sublime Text](http://www.sublimetext.com/) or
    [Atom](https://atom.io/), which are available for Mac OSX, Windows,
    and Linux.

-   [Tracer](http://tree.bio.ed.ac.uk/software/tracer/) – for
    visualizing and assessing numerical parameter samples from
    <span>`RevBayes`</span>

-   [IcyTree](http://tgvaughan.github.io/icytree/) – a web-hosted
    phylogenetic tree visualization tool that is supported for
    [Firefox](https://www.mozilla.org/en-US/firefox/products/) or
    [Google Chrome](https://www.google.com/chrome/) browsers

-   [FigTree](http://tree.bio.ed.ac.uk/software/figtree/) – a tree
    visualization program

### Prerequisite Tutorials

In addition to installing the software, this tutorial assumes that you
have read and completed the following tutorials:

-   [<span>***Basic Introduction to <span>`Rev`</span>and
    MCMC***</span>](https://github.com/revbayes/revbayes_tutorial/blob/master/tutorial_TeX/RB_Basics_Tutorial/RB_Basics_Tutorial.pdf)

-   [<span>***Introduction to MCMC
    Simulation***</span>](https://github.com/revbayes/revbayes_tutorial/blob/master/tutorial_TeX/RB_MCMC_Intro_Tutorial/RB_MCMC_Intro_Tutorial.pdf)

-   [<span>***Substitution
    Models***</span>](https://github.com/revbayes/revbayes_tutorial/blob/master/tutorial_TeX/RB_CTMC_Tutorial/RB_CTMC_Tutorial.pdf)

-   [<span>***Partitioned Data
    Analysis***</span>](https://github.com/revbayes/revbayes_tutorial/blob/master/tutorial_TeX/RB_Partition_Tutorial/RB_Partition_Tutorial.pdf)

Introduction {#sect:Introduction}
============

The “total-evidence” analysis described in this tutorial uses a
probabilistic graphical model [@Hoehna2014b] integrating three separate
likelihood components or data partitions (Fig. \[fig:module-gm\]): one
for molecular data (section \[subsect:Intro-GTR\]), one for
morphological data (section \[subsect:Intro-Morpho\]), and one for
fossil stratigraphic range data (section \[subsect:Intro-TipSampling\]).
In addition, all likelihood components are conditioned on a tree
topology with divergence times, which is modeled according to a separate
prior component (section \[subsect:Intro-FBD\]).

\[fig:module-gm\]

In figure \[fig:example-tree\] we provide an example of the type of tree
estimated from a total-evidence analysis. This example shows the
complete tree (Fig. \[fig:example-tree\]A) and the sampled or
reconstructed tree (Fig. \[fig:example-tree\]B). Importantly, we are
interested in estimating the topology, divergence times, and fossil
sample times of the *reconstructed tree* (Fig. \[fig:example-tree\]B).
We will describe the distinction between these two trees in section
\[subsect:Intro-FBD\].

\[fig:example-tree\]

Lineage Diversification and Sampling {#subsect:Intro-FBD}
------------------------------------

The joint prior distribution on tree topologies and divergence times of
living and extinct species used in this tutorial is described by the
*fossilized birth-death* (FBD) process [@Stadler2010; @Heath2014]. This
model simply treats the fossil observations as part of the process
governing the tree topology and branch times (the node in
Fig. \[fig:module-gm\]). The fossilized birth-death process provides a
model for the distribution of speciation times, tree topology, and
lineage samples before the present
(<span><span>*e.g.,*</span></span>non-contemporaneous samples like
fossils or viruses). This type of tree is shown in figure
\[fig:example-tree\]. Importantly, this model can be used *with or
without* character data for the historical samples. Thus, it provides a
reasonable prior distribution for analyses combining morphological or
DNA data for both extant and fossil
taxa—<span><span>*i.e.,*</span></span>the so-called “total-evidence”
approaches described by @Ronquist2012a and extended by @Zhang2016 and
@Gavryushkina2016. When matrices of discrete morphological characters
for both living and fossil species are unavailable, the fossilized
birth-death model imposes a time structure on the tree by
[*marginalizing*](https://en.wikipedia.org/wiki/Marginal_distribution)
over all possible attachment points for the fossils on the extant tree
[@Heath2014], therefore, some prior knowledge of phylogenetic
relationships is important.

The FBD model (Fig. \[fig:fbd\_gm\]) describes the probability of the
tree and fossils conditional on the birth-death parameters:
$f[\mathcal{T} \mid \lambda, \mu, \rho, \psi, \phi]$, where
$\mathcal{T}$ denotes the tree topology, divergence times, fossil
occurrence times, and the times at which the fossils attach to the tree.
The birth-death parameters $\lambda$ and $\mu$ denote the speciation and
extinction rates, respectively. The “fossilization rate” or “fossil
recovery rate” is denoted $\psi$ and describes the rate at which fossils
are sampled along lineages of the complete tree. The sampling
probability parameter $\rho$ represents the *probability* that an extant
species is sampled, and $\phi$ represents the time at which the process
originated.

\[fig:fbd\_gm\]

In the example FBD tree shown in figure \[fig:example-tree\], the
diversification process originates at time $\phi$, giving rise to $n=20$
species in the present, with both sampled fossils (red circles) and
extant species (black circles). All of the lineages represented in
figure \[fig:example-tree\]A (both solid and dotted lines) show the
*complete tree*. This is the tree of all extant *and* extinct lineages
generated by the process. The complete tree is distinct from the
*reconstructed tree* (Fig. \[fig:example-tree\]B) which is the tree
representing only the lineages sampled as extant taxa or fossils. Fossil
observations (red circles in figure \[fig:example-tree\]) are recovered
over the lifetime of the process along the lineages of the complete
tree. If a lineage does not have any descendants sampled in the present,
it is lost and cannot be observed, these are the dotted lines in figure
\[fig:example-tree\]A. The probability must be conditioned on the origin
time of the process $\phi$. The origin ($\phi$) of a birth-death process
is the starting time of the *stem* lineage, thus this conditions on a
single lineage giving rise to the tree.

An important characteristic of the FBD model is that it accounts for the
probability of sampled ancestor-descendant pairs [@foote1996]. Given
that fossils are sampled from lineages in the diversification process,
the probability of sampling fossils that are ancestors to taxa sampled
at a later date is correlated with the turnover rate ($r=\mu/\lambda$)
and the fossil recovery rate ($\psi$). This feature is important,
particularly for datasets with many sampled fossils. In the example
(Fig. \[fig:example-tree\]), several of the fossils have sampled
descendants. These fossils have solid black lines leading to the
present.

Incorporating Fossil Occurrence Time Uncertainty {#subsect:Intro-TipSampling}
------------------------------------------------

In order to account for uncertainty in the ages of our fossil species,
we can incorporate intervals on the ages of our represented fossil
species. These intervals can be stratigraphic ranges or measurement
standard error. We do this by assuming each fossil can occur with
uniform probability anywhere within its observed interval. This is
somewhat different from the typical approach to node calibration. Here,
instead of treating the calibration density as an additional prior
distribution on the tree, we treat it as the *likelihood* of our fossil
data given the tree parameter. Specifically, we assume the likelihood of
a particular fossil observation $\mathcal{F}_i$ is equal to one if the
fossil’s inferred age on the tree $t_i$ falls within its observed time
interval $(a_i,b_i)$, and zero otherwise:
$$f[\mathcal{F}_i \mid a_i, b_i, t_i] = \begin{cases}
1 & \text{if } a_i < t_i < b_i\\
0 & \text{otherwise}
\end{cases}$$ In other words, we assume the likelihood is equal to one
if the inferred age is consistent with the data observed. We can
represent this likelihood in <span>`RevBayes`</span>using a distribution
that is proportional to the likelihood,
<span><span>*i.e.,*</span></span>non-zero when the likelihood is equal
to one (Fig. \[fig:tipsampling\_gm\]). This model component represents
the observed in the modular graphical model shown in figure
\[fig:module-gm\].

\[fig:tipsampling\_gm\]

It is worth noting that this is not technically the appropriate way to
model fossil data that are actually observed as stratigraphic ranges. In
paleontology, a stratigraphic range represents the interval of time
between the first and last appearences of a fossilized species. Thus,
this range typically represents multiple fossil specimens observed at
different times along a single lineage. An extension of the fossilized
birth-death process that is a distribution on stratigraphic ranges has
been described by @Stadler2017. This model is not yet fully implemented
in <span>`RevBayes`</span>.

Nucleotide Sequence Evolution {#subsect:Intro-GTR}
-----------------------------

The model component for the molecular data uses a general
time-reversible model of nucleotide evolution and gamma-distributed rate
heterogeneity across sites (the and in Fig. \[fig:module-gm\]). This
model of sequence evolution is covered thoroughly in the
[<span>***Substitution
Models***</span>](https://github.com/revbayes/revbayes_tutorial/raw/master/tutorial_TeX/RB_CTMC_Tutorial/RB_CTMC_Tutorial.pdf)
tutorial.

### Lineage-Specific Rates of Sequence Evolution {#subsub:Intro-GTR-UExp}

Rates of nucleotide sequence evolution can vary widely among lineages,
and so models that account for this variation by relaxing the assumption
of a strict molecular clock [@Zuckerkandl1962] can allow for more
accurate estimates of substitution rates and divergence times
[@Drummond2006]. The simplest type of relaxed clock model assumes that
lineage-specific substitution rates are independent or “uncorrelated”.
One example of such an uncorrelated relaxed model is the uncorrelated
*exponential* relaxed clock, in which the substitution rate for each
lineage is assumed to be independent and identically distributed
according to an exponential density (Fig. \[fig:uexp\_gm\]). This is the
for the (<span><span>*i.e.,*</span></span>Fig. \[fig:module-gm\]) that
we will use in this tutorial. Another possible uncorrelated relaxed
clock model is the uncorrelated lognormal model, described in the
[<span>***Relaxed
Clocks***</span>](https://github.com/revbayes/revbayes_tutorial/raw/master/tutorial_TeX/RB_Dating_Tutorial/RB_Dating_Tutorial.pdf)
tutorial [also see @Thorne2002; @Heath2013].

\[fig:uexp\_gm\]

Morphological Character Evolution {#subsect:Intro-Morpho}
---------------------------------

For the vast majority of extinct species, fossil morphology is the
primary source of phylogenetically informative characters. Therefore, an
appropriate model of morphological character evolution is needed to
reliably infer the positions of these species in a phylogenetic
analysis. The Mk model [@Lewis2001] uses a generalized Jukes-Cantor
matrix to allow for the incorporation of morphology into likelihood and
Bayesian analyses. In its simplest form, this model assumes that
characters change states symmetrically—that a given character is as
likely to transition from a one state to another as it is to reverse. In
this tutorial we will consider only binary morphological characters,
<span><span>*i.e.,*</span></span>characters that are observed in one of
two states, 0 or 1. For example, the assumption of the single-rate Mk
model applied to our binary character would mean that a change from a 0
state to a 1 state is as likely as a change from a 1 state to a 0 state.
This assumption is equivalent to assuming that the stationary
probability of being in a 1 state is equal to $1/2$.

In this tutorial, we will apply a single-rate Mk model as a prior on
binary morphological character change. If you are interested extensions
of the Mk model that relax the assumptions of symmetric state change,
please see [Discrete Morphology
tutorial](https://github.com/revbayes/revbayes_tutorial/raw/master/tutorial_TeX/RB_Discrete_Morphology_Tutorial/RB_Discrete_Morphology.pdf).

Because of the way morphological data are collected, we need to exercise
caution in how we model the data. Traditionally, phylogenetic trees were
built from morphological data using parsimony. Therefore, only parsimony
informative characters were collected—that is, characters that are
useful for discriminating between phylogenetic hypotheses under the
maximum parsimony criterion. This means that many morphological datasets
do not contain invariant characters or
[autapomorphies](https://en.wikipedia.org/wiki/Autapomorphy), as these
are not parsimony informative. However, by excluding these slow-evolving
characters, estimates of the branch lengths can be inflated
[@Felsenstein1992; @Lewis2001]. Therefore, it is important to use models
that can condition on this data-acquisition bias.
<span>`RevBayes`</span>has two ways of doing this: one is used for
datasets in which only parsimony informative characters are observed;
the other is for datasets in which parsimony informative characters and
parsimony uninformative variable characters (such as autapomorphies) are
observed.

### The Morphological Clock {#subsub:Intro-MorphClock}

Just like with the molecular data (section \[subsub:Intro-GTR-UExp\]),
our observations of discrete morphological characters are conditional on
the rate of change along each branch in the tree. This model component
defines the of the in the generalized graphical model shown in figure
\[fig:module-gm\]. The relaxed clock model we described for the
molecular data in section \[subsub:Intro-GTR-UExp\] it allows the
substitution rate to vary through time and among lineages. For the
morphological data, we will instead use a “strict clock” model
[@Zuckerkandl1962], in which the rate of discrete character change is
assumed to be constant throughout the tree. The strict clock is the
simplest morphological branch rate model we can construct (graphical
model shown in Fig. \[fig:morph\_clock\_gm\]).

\[fig:morph\_clock\_gm\]

Example: Estimating the Phylogeny and Divergence Times of Fossil and Extant Bears {#sect:Exercise}
=================================================================================

In this exercise, we will combine different types of data from 22
species of extant and extinct bears to estimate a posterior distribution
of calibrated time trees for this group. We have molecular sequence data
for ten species, which represent all of the eight living bears and two
extinct species sequenced from sub-fossil specimens (*Arctodus simus,
Ursus spelaeus*). The sequence alignment provided is a 1,000 bp fragment
of the cytochrome-b mitochondrial gene [@krause2008]. The morphological
character matrix unites 18 taxa (both fossil and extant) with 62 binary
(states <span><span>`0`</span></span> or <span><span>`1`</span></span>)
characters [@abella12]. For the fossil species, occurrence times are
obtained from the literature or fossil databases like the [Fossilworks
PaleoDB](http://fossilworks.org/) or the [Fossil Calibration
Database](http://fossilcalibrations.org/), or from your own
paleontological expertise. The 14 fossil species used in this analysis
are listed in Table \[bearFossilTable\] along with the age range for the
species and relevant citation. Finally, there are two fossil species
(*Parictis montanus, Ursus abstrusus*) for which we do not have
morphological character data (or molecular data) and we must use prior
information about their phylogenetic relationships to incorporate these
taxa in our analysis. This information will be applied using clade
constraints.

<span>@l c c c r</span> & & & &\

*Parictis montanus* & & 33.9–37.2 & & [@clark1972; @krause2008]\

*Zaragocyon daamsi* & & 20–22.8 & & [@ginsburg1995; @abella12]\

*Ballusia elmensis* & & 13.7–16 & & [@ginsburg1998; @abella12]\

*Ursavus primaevus* & & 13.65–15.97 & & [@andrews1977; @abella12]\

*Ursavus brevihinus* & & 15.97–16.9 & & [@heizmann1980; @abella12]\

*Indarctos vireti* & & 7.75–8.7 & & [@montoya2001; @abella12]\

*Indarctos arctoides* & & 8.7–9.7 & & [@geraads2005; @abella12]\

*Indarctos punjabiensis* & & 4.9–9.7 & & [@baryshnikov2002; @abella12]\

*Ailurarctos lufengensis* & & 5.8–8.2 & & [@jin2007; @abella12]\

*Agriarctos spp.* & & 4.9–7.75 && [@abella2011; @abella12]\

*Kretzoiarctos beatrix* & & 11.2–11.8 & & [@abella2011; @abella12]\

*Arctodus simus* & & 0.012–2.588 & & [@churcher1993; @krause2008]\

*Ursus abstrusus* & & 1.8–5.3 & & [@bjork1970; @krause2008]\

*Ursus spelaeus* & & 0.027–0.25 & & [@loreille2001; @krause2008]\

Tutorial Format {#subsect:Exercise-Format}
---------------

This tutorial follows a specific format for issuing instructions and
information.

The boxed instructions guide you to complete tasks that are not part of
the <span>`RevBayes`</span>syntax, but rather direct you to create
directories or files or similar.

Information describing the commands and instructions will be written in
paragraph-form before or after they are issued.

All command-line text, including all <span>`Rev`</span>syntax, are given
in <span><span>`monotype font`</span></span>. Furthermore, blocks of
<span>`Rev`</span>code that are needed to build the model, specify the
analysis, or execute the run are given in separate shaded boxes. For
example, we will instruct you to create a constant node called
<span><span>`rho`</span></span> that is equal to
<span><span>`1.0`</span></span> using the <span><span>`<-`</span></span>
operator like this:

    rho <- 1.0

It is important to be aware that some PDF viewers may render some
characters given as differently. Thus, if you copy and paste text from
this PDF, you may introduce some incorrect characters. Because of this,
we recommend that you type the instructions in this tutorial or copy
them from the scripts provided.

Data and Files {#subsect:Exercise-DataFiles}
--------------

On your own computer or your remote machine, create a directory called
(or any name you like).

In this directory download and unzip the archive containing the data
files:
[<span><span>`data.zip`</span></span>](https://github.com/revbayes/revbayes_tutorial/raw/master/RB_TotalEvidenceDating_FBD_Tutorial/data.zip).

This will create a folder called <span><span>`data`</span></span> that
contains the files necessary to complete this exercise.

In the <span><span>`data`</span></span> folder, you will find the
following files:

-   <span><span>`bears_taxa.tsv`</span></span>: a tab-separated table
    listing every bear species (both fossil and extant) and their
    occurrence dates. For extant taxa, the occurrence date is
    <span><span>`0.0`</span></span>
    (<span><span>*i.e.,*</span></span>the present) and for fossil
    species, the occurrence date is equal to the mean of the age range
    (the ranges are defined in a separate file).

-   <span><span>`bears_cytb.nex`</span></span>: an alignment in NEXUS
    format of 1,000 bp of cytochrome b sequences for 10 bear species.
    This alignment includes 8 living bears and 2 extinct
    sub-fossil bears.

-   <span><span>`bears_morphology.nex`</span></span>: a matrix of 62
    discrete, binary (coded <span><span>`0`</span></span> or
    <span><span>`1`</span></span>) morphological characters for 18
    species of fossil and extant bears.

-   <span><span>`bears_fossil_intervals.tsv`</span></span>: a
    tab-separated table containing the age ranges (minimum and maximum
    in millions of years) for 14 fossil bears.

Getting Started {#subsect:Exercise-GetStart}
---------------

Create a new directory (in
<span><span>`RB_TotalEvidenceDating_FBD_Tutorial`</span></span>) called
. (If you do not have this folder, please refer to the directions in
section \[subsect:Exercise-DataFiles\].)

When you execute <span>`RevBayes`</span>in this exercise, you will do so
within the main directory you created,
<span><span>`RB_TotalEvidenceDating_FBD_Tutorial`</span></span>, thus,
if you are using a Unix-based operating system, we recommend that you
add the <span>`RevBayes`</span>binary to your path.

Creating <span>`Rev`</span>Files {#subsect:Exercise-CreatingFiles}
--------------------------------

For complex models and analyses, it is best to create
<span>`Rev`</span>script files that will contain all of the model
parameters, moves, and functions. In this exercise, you will work
primarily in your text editor[^1] and create a set of modular files that
will be easily managed and interchanged. You will write the following
files from scratch and save them in the
<span><span>`scripts`</span></span> directory:

-   <span><span>`mcmc_TEFBD.Rev`</span></span>: the master
    <span>`Rev`</span>file that loads the data, the separate model
    files, and specifies the monitors and MCMC sampler.

-   <span><span>`model_FBDP_TEFBD.Rev`</span></span>: specifies the
    model parameters and moves required for the fossilized birth-death
    prior on the tree topology, divergence times, fossil occurrence
    times, and diversification dynamics.

-   <span><span>`model_UExp_TEFBD.Rev`</span></span>: specifies the
    components of the uncorrelated exponential model of lineage-specific
    substitution rate variation.

-   <span><span>`model_GTRG_TEFBD.Rev`</span></span>: specifies the
    parameters and moves for the general time-reversible model of
    sequence evolution with gamma-distributed rates across sites
    (GTR+$\Gamma$).

-   <span><span>`model_Morph_TEFBD.Rev`</span></span>: specifies the
    model describing discrete morphological character change
    (binary characters) under a strict morphological clock.

All of the files that you will create are also provided in the
<span>`RevBayes`</span>tutorial repository[^2]. Please refer to these
files to verify or troubleshoot your own scripts.

Start the Master <span>`Rev`</span>File and Import Data {#subsect:Exercise-StartMasterRev}
-------------------------------------------------------

Open your text editor and create the master <span>`Rev`</span>file
called in the <span><span>`scripts`</span></span> directory.

Enter the <span>`Rev`</span>code provided in this section in the new
model file.

The file you will begin in this section will be the one you load into
<span>`RevBayes`</span>when you’ve completed all of the components of
the analysis. In this section you will begin the file and write the
<span>`Rev`</span>commands for loading in the taxon list and managing
the data matrices. Then, starting in section
\[subsect:Exercise-ModelFBD\], you will move on to writing module files
for each of the model components. Once the model files are complete, you
will return to editing <span><span>`mcmc_TEFBD.Rev`</span></span> and
complete the <span>`Rev`</span>script with the instructions given in
section \[subsect:Exercise-CompleteMCMC\].

### Load Taxon List {#subsub:Exercise-TaxList}

Begin the <span>`Rev`</span>script by loading in the list of taxon names
from the <span><span>`bears_taxa.tsv`</span></span> file using the
<span><span>`readTaxonData()`</span></span> function.

    taxa <- readTaxonData("data/bears_taxa.tsv")

This function reads a tab-delimited file and creates a variable called
<span><span>`taxa`</span></span> that is a list of all of the taxon
names relevant to this analysis. This list includes all of the fossil
and extant bear species names in the first columns and a single age
value in the second column. The ages provided are either
<span><span>`0.0`</span></span> for extant species or the average of the
age range for fossil species (see Table \[bearFossilTable\]).

### Load Data Matrices {#subsub:Exercise-LoadData}

<span>`RevBayes`</span>uses the function
<span><span>`readDiscreteCharacterData()`</span></span> to load a data
matrix to the workspace from a formatted file. This function can be used
for both molecular sequences and discrete morphological characters.

Load the cytochrome-b sequences from file and assign the data matrix to
a variable called <span><span>`cytb`</span></span>.

    cytb <- readDiscreteCharacterData("data/bears_cytb.nex") 

Next, import the morphological character matrix and assign it to the
variable <span><span>`morpho`</span></span>.

    morpho <- readDiscreteCharacterData("data/bears_morphology.nex")

### Add Missing Taxa {#subsub:Exercise-AddMissing}

In the descriptions of the files in section
\[subsect:Exercise-DataFiles\], we mentioned that the two data matrices
have different numbers of taxa. Thus, we must add any taxa that are not
found in the molecular (<span><span>`cytb`</span></span>) partition
(<span><span>*i.e.,*</span></span>are only found in the fossil data) to
that data matrix as missing data (with <span><span>`?`</span></span> in
place of all characters), and do the same with the morphological data
partition (<span><span>`morpho`</span></span>). In order for all the
taxa to appear on the same tree, they all need to be part of the same
dataset, as opposed to present in separate datasets. This ensures that
there is a unified taxon set that contains all of our tips.

    cytb.addMissingTaxa( taxa )
    morpho.addMissingTaxa( taxa )

### Create Helper Variables {#subsub:Exercise-mviVar}

Before we begin writing the <span>`Rev`</span>scripts for each of the
model components, we need to instantiate a couple “helper variables”
that will be used by downstream parts of our model specification files.
These variables will be used in more than one of the module files so
it’s best to initialize them in the master file.

Create a new constant node called <span><span>`n_taxa`</span></span>
that is equal to the number of species in our analysis (22).

    n_taxa <- taxa.size() 

Next, create a workspace variable called
<span><span>`mvi`</span></span>. This variable is an iterator that will
build a vector containing all of the MCMC moves used to propose new
states for every stochastic node in the model graph. Each time a new
move is added to the vector, <span><span>`mvi`</span></span> will be
incremented by a value of <span><span>`1`</span></span>.

    mvi = 1

One important distinction here is that <span><span>`mvi`</span></span>
is part of the <span>`RevBayes`</span>workspace and not the hierarchical
model. Thus, we use the workspace assignment operator
<span><span>`=`</span></span> instead of the constant node assignment
<span><span>`<-`</span></span>.

Save your current working version of
<span><span>`mcmc_TEFBD.Rev`</span></span> in the
<span><span>`scripts`</span></span> directory.

We will now move on to the next <span>`Rev`</span>file and will complete
<span><span>`mcmc_TEFBD.Rev`</span></span> in section
\[subsect:Exercise-CompleteMCMC\].

The Fossilized Birth-Death Process {#subsect:Exercise-ModelFBD}
----------------------------------

Open your text editor and create the fossilized birth-death model file
called in the <span><span>`scripts`</span></span> directory.

Enter the <span>`Rev`</span>code provided in this section in the new
model file.

This file will define the models described in sections
\[subsect:Intro-FBD\] and \[subsect:Intro-TipSampling\] above. If
necessary, please review the graphical models depicted for the
fossilized birth-death process (Fig. \[fig:fbd\_gm\]) and the likelihood
of the tip sampling process (Fig. \[fig:tipsampling\_gm\]).

### Speciation and Extinction Rates {#subsub:Exercise-FBD-SpeciationExtinction}

Two key parameters of the FBD process are the speciation rate (the rate
at which lineages are added to the tree, denoted by $\lambda$ in
Fig. \[fig:fbd\_gm\]) and the extinction rate (the rate at which
lineages are removed from the tree, $\mu$ in Fig. \[fig:fbd\_gm\]).
We’ll place exponential priors on both of these values. Each parameter
is assumed to be drawn independently from a different exponential
distribution with rates $\delta_{\lambda}$ and $\delta_{\mu}$
respectively (see Fig. \[fig:fbd\_gm\]). Here, we will assume that
$\delta_{\lambda} = \delta_{\mu} = 10$. Note that an exponential
distribution with $\delta = 10$ has an expected value (mean) of $1/10$.

Create the exponentially distributed stochastic nodes for the
<span><span>`speciation_rate`</span></span> and
<span><span>`extinction_rate`</span></span> using the
<span><span>`~`</span></span> operator.

    speciation_rate ~ dnExponential(10)
    extinction_rate ~ dnExponential(10)

For every stochastic node we declare, we must also specify proposal
algorithms (called *moves*) to sample the value of the parameter in
proportion to its posterior probability. If a move is not specified for
a stochastic node, then it will not be estimated, but fixed to its
initial value.

The rate parameters for extinction and speciation are both positive,
real numbers (<span><span>*i.e.,*</span></span>non-negative floating
point variables). For both of these nodes, we will use a scaling move
(<span><span>`mvScale()`</span></span>), which proposes multiplicative
changes to a parameter. Many moves also require us to set a *tuning
value*, called <span><span>`lambda`</span></span> for
<span><span>`mvScale()`</span></span>, which determine the size of the
proposed change. Here, we will use three scale moves for each parameter
with different values of lambda. By using multiple moves for a single
parameter, we will improve the mixing of the Markov chain.

    moves[mvi++] = mvScale(speciation_rate, lambda=0.01, weight=1)
    moves[mvi++] = mvScale(speciation_rate, lambda=0.1,  weight=1)
    moves[mvi++] = mvScale(speciation_rate, lambda=1.0,  weight=1)

    moves[mvi++] = mvScale(extinction_rate, lambda=0.01, weight=1)
    moves[mvi++] = mvScale(extinction_rate, lambda=0.1,  weight=1)
    moves[mvi++] = mvScale(extinction_rate, lambda=1,    weight=1)

You will also notice that each move has a specified
<span><span>`weight`</span></span>. This option allows you to indicate
how many times you would like a given move to be performed at each MCMC
cycle. The way that we will run our MCMC for this tutorial will be to
execute a *schedule* of moves at each step in our chain instead of just
one move per step, as is done in <span>MrBayes</span> [@Ronquist2003] or
<span>BEAST</span> [@Drummond2012; @Bouckaert2014]. Here, if we were to
run our MCMC with our current vector of 6 moves, then our move schedule
would perform 6 moves at each cycle. Within a cycle, an individual move
is chosen from the move list in proportion to its weight. Therefore,
with all six moves assigned <span><span>`weight=1`</span></span>, each
has an equal probability of being executed and will be performed on
average one time per MCMC cycle. For more information on moves and how
they are performed in <span>`RevBayes`</span>, please refer to the
[<span>***Introduction to
MCMC***</span>](https://github.com/revbayes/revbayes_tutorial/blob/master/tutorial_TeX/RB_MCMC_Intro_Tutorial/RB_MCMC_Intro_Tutorial.pdf)
and [<span>***Substitution
Models***</span>](https://github.com/ssb2017/revbayes_intro/blob/master/tutorials/RB_CTMC_Tutorial.pdf)
tutorials.

In addition to the speciation ($\lambda$) and extinction ($\mu$) rates,
we may also be interested in inferring diversification ($\lambda - \mu$)
and turnover ($\mu/\lambda$). Since these parameters can be expressed as
a deterministic transformation of the speciation and extinction rates,
we can monitor (that is, track the values of these parameters, and print
them to a file) their values by creating two deterministic nodes using
the <span><span>`:=`</span></span> operator.

    diversification := speciation_rate - extinction_rate
    turnover := extinction_rate/speciation_rate

### Probability of Sampling Extant Taxa {#subsub:Exercise-FBD-Rho}

All extant bears are represented in this dataset. Therefore, we will fix
the probability of sampling an extant lineage ($\rho$ in
Fig. \[fig:fbd\_gm\]) to 1. The parameter
<span><span>`rho`</span></span> will be specified as a constant node
using the <span><span>`<-`</span></span> operator.

    rho <- 1.0

Because $\rho$ is a constant node, we do not have to assign a move to
this parameter.

### The Fossil Sampling Rate {#subsub:Exercise-FBD-Psi}

Since our data set includes serially sampled lineages, we must also
account for the rate of sampling back in time. This is the fossil
sampling (or recovery) rate ($\psi$ in Fig. \[fig:fbd\_gm\]), which we
will instantiate as a stochastic node (named
<span><span>`psi`</span></span>). As with the speciation and extinction
rates (Sect. \[subsub:Exercise-FBD-SpeciationExtinction\]), we will use
an exponential prior on this parameter and use scale moves to sample
values from the posterior distribution.

    psi ~ dnExponential(10) 
    moves[mvi++] = mvScale(psi, lambda=0.01, weight=1)
    moves[mvi++] = mvScale(psi, lambda=0.1,  weight=1)
    moves[mvi++] = mvScale(psi, lambda=1,    weight=1)

### The Origin Time {#subsub:Exercise-FBD-Origin}

We will condition the FBD process on the origin time ($\phi$ in
Fig. \[fig:fbd\_gm\]) of bears, and we will specify a uniform
distribution on the origin age. For this parameter, we will use a
sliding window move (<span><span>`mvSlide`</span></span>). A sliding
window samples a parameter uniformly within an interval (defined by the
half-width <span><span>`delta`</span></span>). Sliding window moves can
be tricky for small values, as the window may overlap zero. However, for
parameters such as the origin age, there is little risk of this being an
issue.

    origin_time ~ dnUnif(37.0, 55.0)
    moves[mvi++] = mvSlide(origin_time, delta=0.01, weight=5.0)
    moves[mvi++] = mvSlide(origin_time, delta=0.1,  weight=5.0)
    moves[mvi++] = mvSlide(origin_time, delta=1,    weight=5.0)

Note that we specified a higher move <span><span>`weight`</span></span>
for each of the proposals operating on
<span><span>`origin_time`</span></span> than we did for the three
previous stochastic nodes. This means that our move schedule will
propose five times as many updates to
<span><span>`origin_time`</span></span> than it will to
<span><span>`speciation_rate`</span></span>,
<span><span>`extinction_rate`</span></span>, or
<span><span>`psi`</span></span>.

### The FBD Distribution Object {#subsub:Exercise-FBD-dnFBD}

All the parameters of the FBD process have now been specified. The next
step is to use these parameters to define the FBD tree prior
distribution, which we will call <span><span>`fbd_dist`</span></span>.

    fbd_dist = dnFBDP(origin=origin_time, lambda=speciation_rate, mu=extinction_rate, psi=psi, rho=rho, taxa=taxa)

### Clade Constraints {#subsub:Exercise-FBD-Constraints}

Note that we created the distribution as a workspace variable using the
workspace assignment operator <span><span>`=`</span></span>. This is
because we still need to include a topology constraint in our final
specification of the tree prior. Specifically, we do not have any
morphological or molecular data for the fossil species *Ursus
abstrusus*. Therefore, in order to use the age of this fossil as an
observation, we need to specify to which clade it belongs. In this case,
*Ursus abstrusus* belongs to the subfamily Ursinae, so we define a clade
for the total group Ursinae including *Ursus abstrusus*.

    clade_ursinae = clade("Melursus_ursinus", "Ursus_arctos", "Ursus_maritimus", 
                          "Helarctos_malayanus", "Ursus_americanus", "Ursus_thibetanus", 
                          "Ursus_abstrusus", "Ursus_spelaeus")

Then we can specify the final constrained tree prior distribution by
creating a vector of constraints, and providing it along with the
workspace FBD distribution to the constrained topology distribution.
Here we use the stochastic assignment operator `~` to create a
stochastic node for our constrained, FBD-tree variable (called
<span><span>`fbd_tree`</span></span>).

    constraints = v(clade_ursinae)
    fbd_tree ~ dnConstrainedTopology(fbd_dist, constraints=constraints)

It is important to recognize that we do not know if *Ursus abstrusus* is
a *crown* or *stem* Ursinae. Because of this, we defined this clade
constraint so that it constrained the *total group* Ursinae and this
uncertainty is taken into account. As a result, our MCMC will
marginalize over both stem and crown positions of *U. abstrusus* and
sample the phylogeny in proportion to its posterior probability,
conditional on our model and data.

Additionally, we do not have morphological data for the fossil species
*Parictis montanus*. However, we will not create a clade constraint for
this taxon because it is a very old, stem-fossil bear. Thus, the MCMC
may propose to place this taxon anywhere in the tree (except within the
clade constraint we made above). This allows us to account for the
maximum amount of uncertainty in the placement of *P. montanus*.

### Moves on the Tree Topology and Node Ages {#subsub:Exercise-FBD-TreeMoves}

Next, in order to sample from the posterior distribution of trees, we
need to specify moves that propose changes to the topology
(<span><span>`mvFNPR`</span></span>) and node times
(<span><span>`mvNodeTimeSlideUniform`</span></span>). Included with
these moves is a proposal that will collapse or expand a fossil branch
(<span><span>`mvCollapseExpandFossilBranch`</span></span>). This will
change a fossil that is a sampled ancestor (see
Fig. \[fig:example-tree\] and Sect. \[subsect:Intro-FBD\]) so that it is
on its own branch and vice versa. In addition, when conditioning on the
origin time, we also need to explicitly sample the root age
(<span><span>`mvRootTimeSlideUniform`</span></span>).

    moves[mvi++] = mvFNPR(fbd_tree, weight=15.0)
    moves[mvi++] = mvCollapseExpandFossilBranch(fbd_tree, origin_time, weight=6.0)
    moves[mvi++] = mvNodeTimeSlideUniform(fbd_tree, weight=40.0)
    moves[mvi++] = mvRootTimeSlideUniform(fbd_tree, origin_time, weight=5.0)

### Sampling Fossil Occurrence Ages {#subsub:Exercise-FBD-TipSampling}

Next, we need to account for uncertainty in the age estimates of our
fossils using the observed minimum and maximum stratigraphic ages
provided in the file
<span><span>`bears_fossil_intervals.tsv`</span></span>. First, we read
this file into a matrix called <span><span>`intervals`</span></span>.

    intervals = readDataDelimitedFile(file="data/bears_fossil_intervals.tsv", header=true)

Next, we loop over this matrix. For each fossil observation, we create a
uniform random variable representing the likelihood. Remember, we can
represent the fossil likelihood using any uniform distribution that is
non-zero when the likelihood is equal to one
(Sect. \[subsect:Intro-TipSampling\]).

For example, if $t_i$ is the inferred fossil age and $(a_i,b_i)$ is the
observed stratigraphic interval, we know the likelihood is equal to one
when $a_i < t_i < b_i$, or equivalently $t_i - b_i < 0 < t_i - a_i$. So
let’s represent the likelihood using a uniform random variable uniformly
distributed in $(t_i - b_i, t_i - a_i)$ and clamped at zero.

    for(i in 1:intervals.size())
    {
        taxon  = intervals[i][1]
        a_i = intervals[i][2]
        b_i = intervals[i][3]
        
        t[i] := tmrca(fbd_tree, clade(taxon))
            
        fossil[i] ~ dnUniform(t[i] - b_i, t[i] - a_i)
        fossil[i].clamp( 0 )
    }

Finally, we add a move that samples the ages of the fossil nodes on the
tree.

    moves[mvi++] = mvFossilTimeSlideUniform(fbd_tree, origin_time, weight=5.0)

### Monitoring Parameters of Interest using Deterministic Nodes {#subsub:Exercise-FBD-DetNodes}

There are additional parameters that may be of particular interest to us
that are not directly inferred as part of this graphical model. As with
the diversification and turnover nodes specified in section
\[subsub:Exercise-FBD-SpeciationExtinction\], we can create
deterministic nodes to sample the posterior distributions of these
parameters. Create a deterministic node called
<span><span>`num_samp_anc`</span></span> that will compute the number of
sampled ancestors in our <span><span>`fbd_tree`</span></span>.

    num_samp_anc := fbd_tree.numSampledAncestors()

We are also interested in the age of the most-recent-common ancestor
(MRCA) of all living bears. To monitor the age of this node in our MCMC
sample, we must use the <span><span>`clade()`</span></span> function to
identify the node. Importantly, since we did not include this clade in
our constraints that defined <span><span>`fbd_tree`</span></span>, this
clade will not be constrained to be monophyletic. Once this clade is
defined, we can instantiate a deterministic node called
<span><span>`age_extant`</span></span> with the
<span><span>`tmrca()`</span></span> function that will record the age of
the MRCA of all living bears.

    clade_extant = clade("Ailuropoda_melanoleuca","Tremarctos_ornatus","Melursus_ursinus",
                        "Ursus_arctos","Ursus_maritimus","Helarctos_malayanus",
                        "Ursus_americanus","Ursus_thibetanus")
    age_extant := tmrca(fbd_tree, clade_extant)

In the same way we monitored the MRCA of the extant bears, we can also
create a deterministic node to monitor the age of a fossil taxon that we
are particularly interested in recording. We will monitor the marginal
distribution of the age of *Kretzoiarctos beatrix*, which is between
11.2–11.8 My.

    age_Kretzoiarctos_beatrix   := tmrca(fbd_tree, clade("Kretzoiarctos_beatrix"))

You have completed the FBD model file. Save
<span><span>`model_FBD_TEFBD.Rev`</span></span> in the
<span><span>`scripts`</span></span> directory.

We will now move on to the next model file.

The Uncorrelated Exponential Relaxed-Clock Model {#subsect:Exercise-ModelUExp}
------------------------------------------------

Open your text editor and create the lineage-specific branch-rate model
file called in the <span><span>`scripts`</span></span> directory.

Enter the <span>`Rev`</span>code provided in this section in the new
model file.

For our hierarchical, uncorrelated exponential relaxed clock model
(described in section \[subsub:Intro-GTR-UExp\] and shown in
Fig. \[fig:uexp\_gm\]), we first define the mean branch rate as an
exponential random variable. Then, we specify scale proposal moves on
the mean rate parameter.

    branch_rates_mean ~ dnExponential(10.0)
    moves[mvi++] = mvScale(branch_rates_mean, lambda=0.01, weight=1.0)
    moves[mvi++] = mvScale(branch_rates_mean, lambda=0.1,  weight=1.0)
    moves[mvi++] = mvScale(branch_rates_mean, lambda=1.0,  weight=1.0)

Before creating a rate parameter for each branch, we need to get the
number of branches in the tree. For rooted trees with $n$ taxa, the
number of branches is $2n-2$.

    n_branches <- 2 * n_taxa - 2

Then, use a for loop to define a rate for each branch. The branch rates
are independent and identically exponentially distributed with mean
equal to the mean branch rate parameter we specified above. For each
rate parameter we also create scale proposal moves.

    for(i in 1:n_branches){
        branch_rates[i] ~ dnExp(1/branch_rates_mean)
        moves[mvi++] = mvScale(branch_rates[i], lambda=1.0,  weight=1.0)
        moves[mvi++] = mvScale(branch_rates[i], lambda=0.1,  weight=1.0)
        moves[mvi++] = mvScale(branch_rates[i], lambda=0.01, weight=1.0)
    }

Lastly, we use a vector scale move to propose changes to all branch
rates simultaneously. This way we can sample the total branch rate
independently of each individual rate, which can improve mixing.

    moves[mvi++] = mvVectorScale(branch_rates, lambda=0.01, weight=4.0) 
    moves[mvi++] = mvVectorScale(branch_rates, lambda=0.1,  weight=4.0) 
    moves[mvi++] = mvVectorScale(branch_rates, lambda=1.0,  weight=4.0)

You have completed the FBD model file. Save
<span><span>`model_UExp_TEFBD.Rev`</span></span> in the
<span><span>`scripts`</span></span> directory.

We will now move on to the next model file.

The General Time-Reversible + Gamma Model of Nucleotide Sequence Evolution {#subsect:Exercise-ModelGTRG}
--------------------------------------------------------------------------

Open your text editor and create the molecular substitution model file
called in the <span><span>`scripts`</span></span> directory.

Enter the <span>`Rev`</span>code provided in this section in the new
model file.

For our nucleotide sequence evolution model, we need to define a general
time-reversible (GTR) instantaneous-rate matrix
(<span><span>*i.e.,*</span></span>$Q$-matrix). A nucleotide GTR matrix
is defined by a set of 4 stationary frequencies, and 6 exchangeability
rates. We create stochastic nodes for these variables, each drawn from a
uniform Dirichlet prior distribution.

    sf_hp <- v(1,1,1,1)
    sf ~ dnDirichlet(sf_hp)

    er_hp <- v(1,1,1,1,1,1)
    er ~ dnDirichlet(er_hp)

We need special moves to propose changes to a Dirichlet random variable,
also known as a simplex (a vector constrained sum to one). Here, we use
a <span><span>`mvSimplexElementScale`</span></span> move, which scales a
single element of a simplex and then renormalizes the vector to sum to
one. The tuning parameter <span><span>`alpha`</span></span> specifies
how conservative the proposal should be, with larger values of
<span><span>`alpha`</span></span> leading to proposals closer to the
current value.

    moves[mvi++] = mvSimplexElementScale(er, alpha=10.0, weight=5.0)
    moves[mvi++] = mvSimplexElementScale(sf, alpha=10.0, weight=5.0)

Then we can define a deterministic node for our GTR $Q$-matrix using the
special GTR matrix function (<span><span>`fnGTR`</span></span>).

    Q_cytb := fnGTR(er,sf)

Next, in order to model gamma-distributed rates across, we create an
exponential parameter $\alpha$ for the shape of the gamma distribution,
along with scale proposals.

    alpha_cytb ~ dnExponential( 1.0 )
    moves[mvi++] = mvScale(alpha_cytb, lambda=0.01, weight=1.0)
    moves[mvi++] = mvScale(alpha_cytb, lambda=0.1,  weight=1.0)
    moves[mvi++] = mvScale(alpha_cytb, lambda=1,    weight=1.0)

Then we create a Gamma$(\alpha,\alpha)$ distribution, discretized into 4
rate categories using the <span><span>`fnDiscretizeGamma`</span></span>
function. Here, <span><span>`rates_cytb`</span></span> is a
deterministic vector of rates computed as the mean of each category.

    rates_cytb := fnDiscretizeGamma( alpha_cytb, alpha_cytb, 4 )

Finally, we can create the phylogenetic continuous time Markov chain
(PhyloCTMC) distribution for our sequence data, including the
gamma-distributed site rate categories, as well as the branch rates
defined as part of our exponential relaxed clock. We set the value of
this distribution equal to our observed data and identify it as a static
part of the likelihood using the <span><span>`clamp`</span></span>
method.

    phySeq ~ dnPhyloCTMC(tree=fbd_tree, Q=Q_cytb, siteRates=rates_cytb, branchRates=branch_rates, type="DNA")
    phySeq.clamp(cytb)

You have completed the FBD model file. Save
<span><span>`model_GTRG_TEFBD.Rev`</span></span> in the
<span><span>`scripts`</span></span> directory.

We will now move on to the next model file.

Modeling the Evolution of Binary Morphological Characters {#subsect:Exercise-ModelMorph}
---------------------------------------------------------

Open your text editor and create the morphological character model file
called in the <span><span>`scripts`</span></span> directory.

Enter the <span>`Rev`</span>code provided in this section in the new
model file.

As stated in the introduction (section \[subsect:Intro-Morpho\]) we will
use Mk to model our data. Because the Mk model is a generalization of
the Mk model, we will initialize our Q matrix from a Jukes-Cantor
matrix.

    Q_morpho := fnJC(2)

As in the molecular data partition, we will allow gamma-distributed rate
heterogeneity among sites.

    alpha_morpho ~ dnExponential( 1.0 )
    rates_morpho := fnDiscretizeGamma( alpha_morpho, alpha_morpho, 4 )

    moves[mvi++] = mvScale(alpha_morpho, lambda=0.01, weight=1.0)
    moves[mvi++] = mvScale(alpha_morpho, lambda=0.1,  weight=1.0)
    moves[mvi++] = mvScale(alpha_morpho, lambda=1,    weight=1.0)

The phylogenetic model also assumes that each branch has a rate of
morphological character change. For simplicity, we will assume a strict
exponential clock—meaning that every branch has the same rate drawn from
an exponential distribution (section \[subsub:Intro-MorphClock\]).

    clock_morpho ~ dnExponential(1.0)
    moves[mvi++] = mvScale(clock_morpho, lambda=0.01, weight=4.0)
    moves[mvi++] = mvScale(clock_morpho, lambda=0.1,  weight=4.0)
    moves[mvi++] = mvScale(clock_morpho, lambda=1,    weight=4.0)

As in our molecular data partition, we now combine our data and our
model in the phylogenetic CTMC distribution. There are some unique
aspects to doing this for morphology.

You will notice that we have an option called
<span><span>`coding`</span></span>. This option allows us to condition
on biases in the way the morphological data were collected
(ascertainment bias). The option
<span><span>`coding=variable`</span></span> specifies that we should
correct for coding only variable characters (discussed in
\[subsect:Intro-Morpho\]).

    phyMorpho ~ dnPhyloCTMC(tree=fbd_tree, siteRates=rates_morpho, branchRates=clock_morpho, Q=Q_morpho, type="Standard", coding="variable")
    phyMorpho.clamp(morpho)

You have completed the FBD model file. Save
<span><span>`model_Morph_TEFBD.Rev`</span></span> in the
<span><span>`scripts`</span></span> directory.

We will now move on to the next model file.

Complete Master <span>`Rev`</span>File {#subsect:Exercise-CompleteMCMC}
--------------------------------------

Return to the master <span>`Rev`</span>file you created in section
\[subsect:Exercise-StartMasterRev\] called in the
<span><span>`scripts`</span></span> directory.

Enter the <span>`Rev`</span>code provided in this section in this file.

### Source Model Scripts {#subsub:Exercise-SourceMods}

<span>`RevBayes`</span>uses the <span><span>`source()`</span></span>
function to load commands from <span>`Rev`</span>files into the
workspace. Use this function to load in the model scripts we have
written in the text editor and saved in the
<span><span>`scripts`</span></span> directory.

    source("scripts/model_FBDP_TEFBD.Rev")

    source("scripts/model_UExp_TEFBD.Rev")

    source("scripts/model_GTRG_TEFBD.Rev")

    source("scripts/model_Morph_TEFBD.Rev")

### Create Model Object {#subsub:Exercise-ModObj}

We can now create our workspace model variable with our fully specified
model DAG. We will do this with the <span><span>`model()`</span></span>
function and provide a single node in the graph
(<span><span>`sf`</span></span>).

    mymodel = model(sf)

The object <span><span>`mymodel`</span></span> is a wrapper around the
entire model graph and allows us to pass the model to various functions
that are specific to our MCMC analysis.

### Specify Monitors and Output Filenames {#subsub:Exercise-Monitors}

The next important step for our master <span>`Rev`</span>file is to
specify the monitors and output file names. For this, we create a vector
called <span><span>`monitors`</span></span> that will each sample and
record or output our MCMC.

First, we will specify a workspace variable to iterate over the
<span><span>`monitors`</span></span> vector.

    mni = 1

The first monitor we will create will monitor every named random
variable in our model graph. This will include every stochastic and
deterministic node using the <span><span>`mnModel`</span></span>
monitor. The only parameter that is not included in the
<span><span>`mnModel`</span></span> is the tree topology. Therefore, the
parameters in the file written by this monitor are all numerical
parameters written to a tab-separated text file that can be opened by
accessory programs for evaluating such parameters. We will also name the
output file for this monitor and indicate that we wish to sample our
MCMC every 10 cycles.

    monitors[mni++] = mnModel(filename="output/bears.log", printgen=10)

The <span><span>`mnFile`</span></span> monitor writes any parameter we
specify to file. Thus, if we only cared about the speciation rate and
nothing else (this is not a typical or recommended attitude for an
analysis this complex) we wouldn’t use the
<span><span>`mnModel`</span></span> monitor above and just use the
<span><span>`mnFile`</span></span> monitor to write a smaller and
simpler output file. Since the tree topology is not included in the
<span><span>`mnModel`</span></span> monitor (because it is not
numerical), we will use <span><span>`mnFile`</span></span> to write the
tree to file by specifying our <span><span>`fbd_tree`</span></span>
variable in the arguments.

    monitors[mni++] = mnFile(filename="output/bears.trees", printgen=10, fbd_tree)

The last monitor we will add to our analysis will print information to
the screen. Like with <span><span>`mnFile`</span></span> we must tell
<span><span>`mnScreen`</span></span> which parameters we’d like to see
updated on the screen. We will choose the age of the MCRCA of living
bears (<span><span>`age_extant`</span></span>), the number of sampled
ancestors (<span><span>`num_samp_anc`</span></span>), and the origin
time (<span><span>`origin_time`</span></span>).

    monitors[mni++] = mnScreen(printgen=10, age_extant, num_samp_anc, origin_time)

### Set-Up the MCMC

Once we have set up our model, moves, and monitors, we can now create
the workspace variable that defines our MCMC run. We do this using the
<span><span>`mcmc()`</span></span> function that simply takes the three
main analysis components as arguments.

    mymcmc = mcmc(mymodel, monitors, moves)

The MCMC object that we named <span><span>`mymcmc`</span></span> has a
member method called <span><span>`.run()`</span></span>. This will
execute our analysis and we will set the chain length to
<span><span>`10000`</span></span> cycles using the
<span><span>`generations`</span></span> option.

    mymcmc.run(generations=10000,tuningInterval=0)

Once our Markov chain has terminated, we will want
<span>`RevBayes`</span>to close. Tell the program to quit using the
<span><span>`q()`</span></span> function.

    q()

You made it! Save all of your files.

Execute the MCMC Analysis {#subsect:Exercise-RunMCMC}
-------------------------

With all the parameters specified and all analysis components in place,
you are now ready to run your analysis. The <span>`Rev`</span>scripts
you just created will all be used by <span>`RevBayes`</span>and loaded
in the appropriate order.

Begin by running the <span>`RevBayes`</span>executable. In Unix systems,
type the following in your terminal (if the
<span>`RevBayes`</span>binary is in your path):

Provided that you started <span>`RevBayes`</span>from the correct
directory
(<span><span>`RB_TotalEvidenceDating_FBD_Tutorial`</span></span>), you
can then use the <span><span>`source()`</span></span> function to feed
<span>`RevBayes`</span>your master script file
(<span><span>`mcmc_TEFBD.Rev`</span></span>).

    source("scripts/mcmc_TEFBD.Rev")

This will execute the analysis and you should see the following output
(though not the exact same values):

When the analysis is complete, <span>`RevBayes`</span>will quit and you
will have a new directory called <span><span>`output`</span></span> that
will contain all of the files you specified with the monitors
(Sect. \[subsub:Exercise-Monitors\]).

Evaluate and Summarize Your Results {#subsect:Exercise-SummarizeResults}
-----------------------------------

### Evaluate MCMC {#subsub:Exercise-EvalMCMC}

In this section, we will evaluate the *mixing* and *convergence* of our
MCMC simulation using the program <span>Tracer</span>. We can also
summarize the marginal distributions for particular parameters we’re
interested in. [Tracer](http://tree.bio.ed.ac.uk/software/tracer/)
[@Rambaut2011] is a tool for visualizing parameters sampled by MCMC.
This program is limited to numerical parameters, however, and cannot be
used to summarize or analyze MCMC samples of the tree topology (this
will be discussed further in section \[subsub:Exercise-SummarizeTree\]).

\[fig:tracer\]

Open <span>Tracer</span> and import the
<span><span>`bears.log`</span></span> file in the <span>***FileImport
New Trace File***</span>. Or click the button on the left-hand side of
the screen to add your log file (see Fig. \[fig:tracer\]).

\[fig:tracer-post-ests\]

Immediately upon loading your file (see Fig. \[fig:tracer-post-ests\]),
you will see the list of <span>***Trace Files***</span> on the left-hand
side (you can load multiple files). The bottom left section, called
<span>***Traces***</span>, provides a list of every parameter in the log
file, along with the mean and the effective sample size (ESS) for the
posterior sample of that parameter. The ESS statistic provides a measure
of the number of independent draws in our sample for a given parameter.
This quantity will typically be much smaller than the number of
generations of the chain. In <span>Tracer</span>, poor to fair values
for the ESS will be colored red and yellow. You will likely see a lot of
red and yellow numbers because the MCMC runs in this exercise are too
short to effectively sample the posterior distributions of most
parameters. A much longer analysis is provided in the
<span><span>`output`</span></span> directory.

The inspection window for your selected parameter is the
<span>***Estimates***</span> window, which shows a histogram and summary
statistics of the values sampled by the Markov chain. Figure
\[fig:tracer-post-ests\] shows the marginal distribution of the
<span>***Posterior***</span> statistic for the
<span><span>`bears.log`</span></span> file in the
<span><span>`output`</span></span> directory.

Look through the various parameters and statistics in the list of
<span>***Traces***</span>.

<span><span><span> </span></span></span>Are there any parameters that
have really low ESS? Why do you think that might be?

Next, we can click over to the <span>***Trace***</span> window. This
window shows us the samples for a given parameter at each iteration of
the MCMC. The left side of the chain has a shaded portion that has been
excluded as “burn-in”. Samples taken near the beginning of chain are
often discarded or “burned” because the MCMC may not immediately begin
sampling from the target posterior distribution, particularly if the
starting condition of the chain is far from the region of highest
posterior density. Figure \[fig:tracer-extinction-trace\] shows the
trace for the extinction rate.

\[fig:tracer-extinction-trace\]

The <span>***Trace***</span> window allows us to evaluate how well our
chain is sampling the target distribution. For a fairly short analysis,
the output in figure \[fig:tracer-extinction-trace\] shows reasonable
*mixing*—there is no consistent pattern or trend in the samples, nor are
there long intervals where the statistic does not change. The presence
of a trend or large leaps in a parameter value might indicate that your
MCMC is not mixing well. You can read more about MCMC tuning and
improving mixing in the tutorials [<span>***Intro to
MCMC***</span>](https://github.com/revbayes/revbayes_tutorial/raw/master/tutorial_TeX/RB_MCMC_Intro_Tutorial/RB_MCMC_Intro_Tutorial.pdf)
and [<span>***MCMC
Algorithms***</span>](https://github.com/revbayes/revbayes_tutorial/raw/master/tutorial_TeX/RB_MCMC_Tutorial/RB_MCMC_Tutorial.pdf).

Look through the traces for your parameters.

<span><span><span> </span></span></span>Are there any parameters in your
log files that show trends or large leaps? What steps might you take to
solve these issues?

In <span>Tracer</span> you can view the marginal probability
distributions of your parameters in the <span>***Marginal Prob
Distribution***</span> window. Using this tool, you can compare the
distributions of several different parameters (by selecting them both).

Go to the <span><span>`diversification`</span></span> parameter in the
<span>***Marginal Prob Distribution***</span> window.

<span><span><span> </span></span></span>What is the mean value estimated
for the net diversification rate ($d$)? What does the marginal
distribution tell you about the net diversification? (Hint:
$d = \lambda - \mu$)

While specifying the model, remember that we created several
deterministic nodes that represent parameters that we would like to
estimate, including the net diversification rate. <span>Tracer</span>
allows us to view the summaries of these parameters since they appear in
our log files.

Go to the <span><span>`age_extant`</span></span> parameter in the
<span>***Estimates***</span> window.

<span><span><span> </span></span></span>What is the mean and 95% highest
posterior density of the age of the MRCA for all living bears?

Since you have evaluated several of the parameters by viewing the trace
files and the ESS values, you may be aware that the MCMC analysis you
conducted for this tutorial did not sufficiently sample the joint
posterior distribution of phylogenetic parameters. More explicitly,
*your run has not converged*. It is not advisable to base your
conclusions on such a run and it will be critical to perform multiple,
independent runs for many more MCMC cycles. For further discussion of
recommended MCMC practices in <span>`RevBayes`</span>, please see the
[<span>***Intro to
MCMC***</span>](https://github.com/revbayes/revbayes_tutorial/raw/master/tutorial_TeX/RB_MCMC_Intro_Tutorial/RB_MCMC_Intro_Tutorial.pdf)
and [<span>***MCMC
Algorithms***</span>](https://github.com/revbayes/revbayes_tutorial/raw/master/tutorial_TeX/RB_MCMC_Tutorial/RB_MCMC_Tutorial.pdf)
tutorials.

### Summarize Tree {#subsub:Exercise-SummarizeTree}

In addition to evaluating the performance and sampling of an MCMC run
using numerical parameters, it is also important to inspect the sampled
topology and tree parameters. This is a difficult endeavor, however. One
tool for evaluating convergence and mixing of the tree samples is
[RWTY](https://github.com/danlwarren/RWTY) [@Warren2016]. In this
tutorial, we will only summarize the sampled trees, but we encourage you
to consider approaches for assessing the performance of the MCMC with
respect to the tree topology.

Ultimately, we are interested in summarizing the sampled trees and
branch times, given that our MCMC has sampled all of the important
parameters in proportion to their posterior probabilities.
<span>`RevBayes`</span>includes some functions for summarizing the tree
topology and other tree parameters.

We will complete this part of the tutorial using
<span>`RevBayes`</span>interactively. Begin by running the
<span>`RevBayes`</span>executable. You should do this from within the
<span><span>`RB_TotalEvidenceDating_FBD_Tutorial`</span></span>
directory.

In Unix systems, type the following in your terminal (if the
<span>`RevBayes`</span>binary is in your path):

Read in the MCMC sample of trees from file.

    trace = readTreeTrace("output/bears.trees")

The first thing we need to do is remove taxa for which we did not have
any molecular or morphological data. The phylogenetic placement of these
taxa is based only on their occurrence times and any clade constraints
we applied (section \[subsub:Exercise-FBD-Constraints\]). Because no
data are available to resolve their relationships to other lineages, we
will treat their placement as [*nuisance
parameters*](https://en.wikipedia.org/wiki/Nuisance_parameter) and
remove them from the summary tree.

We must read our complete taxon list into <span>`RevBayes`</span>so that
we can easily access the taxon names of the lineages we’d like to prune.

    taxa <- readTaxonData("data/bears_taxa.tsv")

We will remove two fossil taxa, *Parictis montanus* and *Ursus
abstrusus*, from every tree in the trace file before summarizing the
samples. These two species have the indices
<span><span>`17`</span></span> and <span><span>`20`</span></span> in our
list of taxa. You can view the list by typing its variable name
<span><span>`taxa`</span></span>:

    taxa 
    |*  [ Ailuropoda_melanoleuca, Helarctos_malayanus, Melursus_ursinus, Tremarctos_ornatus,
    |*  Ursus_americanus, Ursus_arctos, Ursus_maritimus, Ursus_thibetanus, Agriarctos_spp,
    |*  Ailurarctos_lufengensis, Arctodus_simus, Ballusia_elmensis, Indarctos_arctoides,
    |*  Indarctos_punjabiensis, Indarctos_vireti, Kretzoiarctos_beatrix, Parictis_montanus,
    |*  Ursavus_brevirhinus, Ursavus_primaevus, Ursus_abstrusus, Ursus_spelaeus, Zaragocyon_daamsi]

Use the <span><span>`fnPruneTree()`</span></span> function to prune
taxon <span><span>`17`</span></span> and taxon
<span><span>`20`</span></span> from each tree using a
<span><span>`for`</span></span> loop. We’ll store each new tree in the
vector called <span><span>`trees`</span></span>.

    for(i in 1:trace.size())
    {
        trees[i] = fnPruneTree(trace.getTree(i), pruneTaxa=v(taxa[17],taxa[20]))
    }

Then we create a second tree trace containing the pruned trees using the
<span><span>`treeTrace`</span></span> function.

    trace_pruned = treeTrace(trees)

If you use the size function of the
<span><span>`trace_pruned`</span></span> variable by typing the command
, you will see that our MCMC sampled 1001 trees. By default, a burn-in
of 25% is used when creating the tree trace (250 trees in our case). You
can specify a different burn-in fraction, say 50%, by typing the command
.

Now we will use the <span><span>`mccTree()`</span></span> function to
return a maximum clade credibility (MCC) tree. The MCC tree is the tree
with the maximum product of the posterior clade probabilities. When
considering trees with sampled ancestors, we refer to the maximum
sampled ancestor clade credibility (MSACC) tree [@Gavryushkina2016]. We
also use the option <span><span>`conditionalAges=false`</span></span> to
indicate that the node ages of the output tree should not be summarized
conditional on the MCC topology.

    mccTree(trace_pruned, file="output/bears.mcc.tre", conditionalAges=false )

When there are sampled ancestors present in the tree, visualizing the
tree can be fairly difficult in traditional tree viewers. We will make
use of a browser-based tree viewer called
[IcyTree](http://tgvaughan.github.io/icytree/), created by [Tim
Vaughan](https://github.com/tgvaughan). <span>IcyTree</span> has many
unique options for visualizing phylogenetic trees and can produce
publication-quality vector image files
(<span><span>*i.e.,*</span></span>SVG). Additionally, it correctly
represents sampled ancestors on the tree as nodes, each with only one
descendant (Fig. \[fig:IcyTreeSumm\]).

\[fig:IcyTreeSumm\]

Navigate to <http://tgvaughan.github.io/icytree> and open the file
<span><span>`output/bears.mcc.tre`</span></span> in
<span>IcyTree</span>.

<span><span><span> </span></span></span>Try to replicate the tree in
Fig. \[fig:IcyTreeSumm\]. (Hint: <span>***StyleMark
Singletons***</span>) Why might a node with a sampled ancestor be
referred to as a singleton?

<span><span><span> </span></span></span>How can you see the names of the
fossils that are putative sampled ancestors?

<span><span><span> </span></span></span>Try mousing over different
branches (see Fig. \[fig:IcyTreeScreenshort\]). What are the fields
telling you? <span><span><span> </span></span></span>What is the
posterior probability that *Zaragocyon daamsi* is a sampled ancestor?

Another newly available web-based tree viewer is
[Phylogeny.IO](http://phylogeny.io/) [@Jovanovic2016]. Try this site for
a different way to view the tree.

\[fig:IcyTreeScreenshort\]

Version dated:

[^1]: In section \[subsub:Req-Software\] we offer a recommendation for a
    text editor.

[^2]: <https://github.com/revbayes/revbayes_tutorial/tree/master/RB_TotalEvidenceDating_FBD_Tutorial/scripts>
