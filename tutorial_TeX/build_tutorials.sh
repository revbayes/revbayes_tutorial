BUILD_ALL="false"


BUILD_GETTING_STARTED="false"

BUILD_MCMC_INTRO="true"

BUILD_DIVERSIFICATION_RATE="false"
BUILD_DIVERSIFICATION_RATE_EPISODIC="false"
BUILD_DIVERSIFICATION_RATE_ENVIRONMENTAL="false"
BUILD_DIVERSIFICATION_RATE_SAMPLING="false"





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



############
#          #
#   MCMC   #
#          #
############

# simple MCMC
if [[ ${BUILD_MCMC_INTRO} == "true" || ${BUILD_ALL} == "true" ]]
then
cd RB_MCMC_Intro_Tutorial
pdflatex RB_MCMC_Intro_Tutorial.tex
bibtex RB_MCMC_Intro_Tutorial
pdflatex RB_MCMC_Intro_Tutorial.tex
pdflatex RB_MCMC_Intro_Tutorial.tex

rm RB_MCMC_Intro_Tutorial.aux
rm RB_MCMC_Intro_Tutorial.bbl
rm RB_MCMC_Intro_Tutorial.blg
rm RB_MCMC_Intro_Tutorial.log
rm RB_MCMC_Intro_Tutorial.out

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
