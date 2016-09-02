###
# Reversible Jump MCMC algorithm:
# applied to estimate the diversification rates over time.
#
# author: Sebastian Hoehna
#

library(TESS)

treefile <- "primates_Springer"
sampling_method <- "uniform_sampling"
analysis_name <- sprintf("CoMET_%s_%s",treefile, sampling_method)
CDT <- "survival"
EXPECTED_NUM_EVENTS <- 2
MCMC_ITERATIONS <- 1000000
ALLOW_MASS_EXTINCTION <- FALSE
if ( ALLOW_MASS_EXTINCTION == TRUE ) {
   analysis_name <- sprintf("CoMET_%s_%s_ME",treefile, sampling_method)
} else {
   analysis_name <- sprintf("CoMET_%s_%s",treefile, sampling_method)
}

tree <- read.tree(file=sprintf("data/%s.tre",treefile) ) 

total <- 377
sampledSpecies <- tree$Nnode + 1
rho <- (sampledSpecies)/total

#priorForms <- c("lognormal","normal","gamma")
priorForms <- c("lognormal")

tess.analysis(tree=tree, numExpectedRateChanges=EXPECTED_NUM_EVENTS, numExpectedMassExtinctions=EXPECTED_NUM_EVENTS, initialSpeciationRate=2.0, initialExtinctionRate=1.0, empiricalHyperPriorInflation = 10.0, empiricalHyperPriorForm = priorForms, samplingProbability=rho, estimateMassExtinctionTimes = ALLOW_MASS_EXTINCTION, estimateNumberMassExtinctions = ALLOW_MASS_EXTINCTION, MAX_ITERATIONS = MCMC_ITERATIONS, THINNING = 100,  MAX_TIME = Inf, MIN_ESS = 1000, CONDITION=CDT, dir = analysis_name)            

out <- tess.process.output(analysis_name, tree, numExpectedRateChanges=EXPECTED_NUM_EVENTS)


NUM_FIGS <- 6
FIG_TYPES <- c("speciation rates","speciation shift times","extinction rates","extinction shift times","mass extinction Bayes factors","mass extinction times")
if ( ALLOW_MASS_EXTINCTION == FALSE ) {
   NUM_FIGS <- 4
   FIG_TYPES <- c("speciation rates","speciation shift times","extinction rates","extinction shift times")
}
pdf(sprintf("%s.pdf",analysis_name))
layout.mat <- matrix(1:NUM_FIGS,nrow=2,ncol=NUM_FIGS / 2)
layout(layout.mat)
tess.plot.output(out,fig.types=FIG_TYPES,las=1)
dev.off()

