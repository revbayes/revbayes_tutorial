BUILD_ALL="false"


BUILD_GETTING_STARTED="false"
BUILD_BASICS="false"

BUILD_MCMC_INTRO="false"

BUILD_BAYES_FACTOR="false"
BUILD_PPS="false"

BUILD_CTMC="false"
BUILD_PARTITION="false"

BUILD_DIVERSIFICATION_RATE="false"
BUILD_DIVERSIFICATION_RATE_EPISODIC="false"
BUILD_DIVERSIFICATION_RATE_ENVIRONMENTAL="false"
BUILD_DIVERSIFICATION_RATE_SAMPLING="false"

BUILD_DISCRETE_MORPHOLOGY="true"



###################
#                 #
#   Basic Stuff   #
#                 #
###################

# Getting started
if [[ ${BUILD_GETTING_STARTED} == "true" || ${BUILD_ALL} == "true" ]]
then
cd RB_Getting_Started
pdflatex RB_Getting_Started.tex
bibtex RB_Getting_Started
pdflatex RB_Getting_Started.tex
pdflatex RB_Getting_Started.tex

rm RB_Getting_Started.aux
rm RB_Getting_Started.bbl
rm RB_Getting_Started.blg
rm RB_Getting_Started.log
rm RB_Getting_Started.out

cd ..
fi


# Basics
if [[ ${BUILD_BASICS} == "true" || ${BUILD_ALL} == "true" ]]
then
cd RB_Intro_Tutorial
pdflatex RB_Intro_Tutorial.tex
bibtex RB_Intro_Tutorial
pdflatex RB_Intro_Tutorial.tex
pdflatex RB_Intro_Tutorial.tex

rm RB_Intro_Tutorial.aux
rm RB_Intro_Tutorial.bbl
rm RB_Intro_Tutorial.blg
rm RB_Intro_Tutorial.log
rm RB_Intro_Tutorial.out

cd ..
fi


# Rev
if [[ ${BUILD_BASICS} == "true" || ${BUILD_ALL} == "true" ]]
then
cd RB_Rev_Tutorial
pdflatex RB_Rev_Tutorial.tex
bibtex RB_Rev_Tutorial
pdflatex RB_Rev_Tutorial.tex
pdflatex RB_Rev_Tutorial.tex

rm RB_Rev_Tutorial.aux
rm RB_Rev_Tutorial.bbl
rm RB_Rev_Tutorial.blg
rm RB_Rev_Tutorial.log
rm RB_Rev_Tutorial.out

cd ..
fi



############
#          #
#   MCMC   #
#          #
############

# simple MCMC
if [[ ${BUILD_MCMC_INTRO} == "true" || ${BUILD_ALL} == "true" ]]
then
cd RB_MCMC_Binomial_Tutorial
pdflatex RB_MCMC_Binomial_Tutorial.tex
bibtex RB_MCMC_Binomial_Tutorial
pdflatex RB_MCMC_Binomial_Tutorial.tex
pdflatex RB_MCMC_Binomial_Tutorial.tex

rm RB_MCMC_Binomial_Tutorial.aux
rm RB_MCMC_Binomial_Tutorial.bbl
rm RB_MCMC_Binomial_Tutorial.blg
rm RB_MCMC_Binomial_Tutorial.log
rm RB_MCMC_Binomial_Tutorial.out

cd ..
fi

# simple MCMC
if [[ ${BUILD_MCMC_INTRO} == "true" || ${BUILD_ALL} == "true" ]]
then
cd RB_MCMC_Archery_Tutorial
pdflatex RB_MCMC_Archery_Tutorial.tex
bibtex RB_MCMC_Archery_Tutorial
pdflatex RB_MCMC_Archery_Tutorial.tex
pdflatex RB_MCMC_Archery_Tutorial.tex

rm RB_MCMC_Archery_Tutorial.aux
rm RB_MCMC_Archery_Tutorial.bbl
rm RB_MCMC_Archery_Tutorial.blg
rm RB_MCMC_Archery_Tutorial.log
rm RB_MCMC_Archery_Tutorial.out

cd ..
fi

#####################
#                   #
#   Model testing   #
#                   #
#####################

# Bayes factors
if [[ ${BUILD_BAYES_FACTOR} == "true" || ${BUILD_ALL} == "true" ]]
then
    cd RB_BayesFactor_Tutorial
    pdflatex RB_BayesFactor_Tutorial.tex
    bibtex RB_BayesFactor_Tutorial
    pdflatex RB_BayesFactor_Tutorial.tex
    pdflatex RB_BayesFactor_Tutorial.tex

    rm RB_BayesFactor_Tutorial.aux
    rm RB_BayesFactor_Tutorial.bbl
    rm RB_BayesFactor_Tutorial.blg
    rm RB_BayesFactor_Tutorial.log
    rm RB_BayesFactor_Tutorial.out

    cd ..
fi

# Posterior Predictive Simulation
if [[ ${BUILD_PPS} == "true" || ${BUILD_ALL} == "true" ]]
then
    cd RB_PosteriorPrediction_Tutorial
    pdflatex RB_PosteriorPrediction_Tutorial.tex
    bibtex RB_PosteriorPrediction_Tutorial
    pdflatex RB_PosteriorPrediction_Tutorial.tex
    pdflatex RB_PosteriorPrediction_Tutorial.tex

    rm RB_PosteriorPrediction_Tutorial.aux
    rm RB_PosteriorPrediction_Tutorial.bbl
    rm RB_PosteriorPrediction_Tutorial.blg
    rm RB_PosteriorPrediction_Tutorial.log
    rm RB_PosteriorPrediction_Tutorial.out

    cd ..
fi


############################
#                          #
#   Phylogeny Estimation   #
#                          #
############################

# Substitution model
if [[ ${BUILD_CTMC} == "true" || ${BUILD_ALL} == "true" ]]
then
cd RB_CTMC_Tutorial
pdflatex RB_CTMC_Tutorial.tex
bibtex RB_CTMC_Tutorial
pdflatex RB_CTMC_Tutorial.tex
pdflatex RB_CTMC_Tutorial.tex

rm RB_CTMC_Tutorial.aux
rm RB_CTMC_Tutorial.bbl
rm RB_CTMC_Tutorial.blg
rm RB_CTMC_Tutorial.log
rm RB_CTMC_Tutorial.out

cd ..
fi


# Partitioned data analysis
if [[ ${BUILD_PARTITION} == "true" || ${BUILD_ALL} == "true" ]]
then
cd RB_Partition_Tutorial
pdflatex RB_Partition_Tutorial.tex
bibtex RB_Partition_Tutorial
pdflatex RB_Partition_Tutorial.tex
pdflatex RB_Partition_Tutorial.tex

rm RB_Partition_Tutorial.aux
rm RB_Partition_Tutorial.bbl
rm RB_Partition_Tutorial.blg
rm RB_Partition_Tutorial.log
rm RB_Partition_Tutorial.out

cd ..
fi



#######################################
#                                     #
#   Diversification Rate Estimation   #
#                                     #
#######################################

# diversification rate estimation
if [[ ${BUILD_DIVERSIFICATION_RATE} == "true" || ${BUILD_ALL} == "true" ]]
then
cd RB_DiversificationRate_Tutorial
pdflatex RB_DiversificationRate_Tutorial.tex
bibtex RB_DiversificationRate_Tutorial
pdflatex RB_DiversificationRate_Tutorial.tex
pdflatex RB_DiversificationRate_Tutorial.tex

rm RB_DiversificationRate_Tutorial.aux
rm RB_DiversificationRate_Tutorial.bbl
rm RB_DiversificationRate_Tutorial.blg
rm RB_DiversificationRate_Tutorial.log
rm RB_DiversificationRate_Tutorial.out

cd ..
fi


# diversification rates through time
if [[ ${BUILD_DIVERSIFICATION_RATE_EPISODIC} == "true" || ${BUILD_ALL} == "true" ]]
then
cd RB_DiversificationRate_Episodic_Tutorial
pdflatex RB_DiversificationRate_Episodic_Tutorial.tex
bibtex RB_DiversificationRate_Episodic_Tutorial
pdflatex RB_DiversificationRate_Episodic_Tutorial.tex
pdflatex RB_DiversificationRate_Episodic_Tutorial.tex

rm RB_DiversificationRate_Episodic_Tutorial.aux
rm RB_DiversificationRate_Episodic_Tutorial.bbl
rm RB_DiversificationRate_Episodic_Tutorial.blg
rm RB_DiversificationRate_Episodic_Tutorial.log
rm RB_DiversificationRate_Episodic_Tutorial.out

cd ..
fi


# environmental correlated diversification rates through time
if [[ ${BUILD_DIVERSIFICATION_RATE_ENVIRONMENTAL} == "true" || ${BUILD_ALL} == "true" ]]
then
cd RB_DiversificationRate_Environmental_Tutorial
pdflatex RB_DiversificationRate_Environmental_Tutorial.tex
bibtex RB_DiversificationRate_Environmental_Tutorial
pdflatex RB_DiversificationRate_Environmental_Tutorial.tex
pdflatex RB_DiversificationRate_Environmental_Tutorial.tex

rm RB_DiversificationRate_Environmental_Tutorial.aux
rm RB_DiversificationRate_Environmental_Tutorial.bbl
rm RB_DiversificationRate_Environmental_Tutorial.blg
rm RB_DiversificationRate_Environmental_Tutorial.log
rm RB_DiversificationRate_Environmental_Tutorial.out

cd ..
fi


# incomplete taxon sampling
if [[ ${BUILD_DIVERSIFICATION_RATE_SAMPLING} == "true" || ${BUILD_ALL} == "true" ]]
then
cd RB_DiversificationRate_Sampling_Tutorial
pdflatex RB_DiversificationRate_Sampling_Tutorial.tex
bibtex RB_DiversificationRate_Sampling_Tutorial
pdflatex RB_DiversificationRate_Sampling_Tutorial.tex
pdflatex RB_DiversificationRate_Sampling_Tutorial.tex

rm RB_DiversificationRate_Sampling_Tutorial.aux
rm RB_DiversificationRate_Sampling_Tutorial.bbl
rm RB_DiversificationRate_Sampling_Tutorial.blg
rm RB_DiversificationRate_Sampling_Tutorial.log
rm RB_DiversificationRate_Sampling_Tutorial.out

cd ..
fi


###########################
#                         #
#   Discrete Morphology   #
#                         #
###########################

# Discrete Morphology
if [[ ${BUILD_DISCRETE_MORPHOLOGY} == "true" || ${BUILD_ALL} == "true" ]]
then
    cd RB_DiscreteMorphology_Tutorial
    pdflatex RB_DiscreteMorphology_Tutorial.tex
    bibtex RB_DiscreteMorphology_Tutorial
    pdflatex RB_DiscreteMorphology_Tutorial.tex
    pdflatex RB_DiscreteMorphology_Tutorial.tex

    rm RB_DiscreteMorphology_Tutorial.aux
    rm RB_DiscreteMorphology_Tutorial.bbl
    rm RB_DiscreteMorphology_Tutorial.blg
    rm RB_DiscreteMorphology_Tutorial.log
    rm RB_DiscreteMorphology_Tutorial.out

    cd ..
fi


###############################
#                             #
#   Historical Biogeography   #
#                             #
###############################

# DEC
if [[ ${BUILD_DEC} == "true" || ${BUILD_ALL} == "true" ]]
then
    cd RB_Biogeography_DEC_Tutorial
    pdflatex RB_Biogeography_DEC_Tutorial.tex
    bibtex RB_Biogeography_DEC_Tutorial
    pdflatex RB_Biogeography_DEC_Tutorial.tex
    pdflatex RB_Biogeography_DEC_Tutorial.tex

    rm RB_Biogeography_DEC_Tutorial.aux
    rm RB_Biogeography_DEC_Tutorial.bbl
    rm RB_Biogeography_DEC_Tutorial.blg
    rm RB_Biogeography_DEC_Tutorial.log
    rm RB_Biogeography_DEC_Tutorial.out

    cd ..
fi

# bayarea
if [[ ${BUILD_BAYAREA} == "true" || ${BUILD_ALL} == "true" ]]
then
    cd RB_Biogeography_many_area_Tutorial
    pdflatex RB_Biogeography_many_area_Tutorial.tex
    bibtex RB_Biogeography_many_area_Tutorial
    pdflatex RB_Biogeography_many_area_Tutorial.tex
    pdflatex RB_Biogeography_many_area_Tutorial.tex

    rm RB_Biogeography_many_area_Tutorial.aux
    rm RB_Biogeography_many_area_Tutorial.bbl
    rm RB_Biogeography_many_area_Tutorial.blg
    rm RB_Biogeography_many_area_Tutorial.log
    rm RB_Biogeography_many_area_Tutorial.out

    cd ..
fi
