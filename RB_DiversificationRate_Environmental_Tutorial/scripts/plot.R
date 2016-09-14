# Install RevGadget if you haven't done so already
#library(devtools)
#install_github("revbayes/RevGadgets")

#library(RevGadgets)
library(ape)
library(coda)
library(geoscale)

source("scripts/Plot_Div_Rates.R")
source("scripts/Read_MCMC_Output.R")

tree <- read.tree("data/primates_Springer.tre")

numIntervals <- 100
time <- max( branching.times(tree) )
intervals <- seq(0,time,length.out=numIntervals+1)


co2 <- c(297.6, 301.36, 304.84, 307.86, 310.36, 312.53, 314.48, 316.31, 317.42, 317.63, 317.74, 318.51, 318.29, 316.5, 315.49, 317.64, 318.61, 316.6, 317.77, 328.27, 351.12, 381.87, 415.47, 446.86, 478.31, 513.77, 550.74, 586.68, 631.48, 684.13, 725.83, 757.81, 789.39, 813.79, 824.25, 812.6, 784.79, 755.25, 738.41, 727.53, 710.48, 693.55, 683.04, 683.99, 690.93, 694.44, 701.62, 718.05, 731.95, 731.56, 717.76)
#temperature <- c(3.893, 3.708, 3.532, 3.368, 3.214, 3.070, 2.935, 2.811, 2.700, 2.594, 2.488, 2.385, 2.297, 2.224, 2.159, 2.104, 2.063, 2.045, 2.048, 2.053, 2.060, 2.078, 2.102, 2.132, 2.168, 2.202, 2.262, 2.351, 2.429, 2.458, 2.439, 2.398, 2.335, 2.216, 2.051, 1.902, 1.761, 1.602, 1.461, 1.357, 1.266, 1.162, 1.046, 0.929, 0.803, 0.670, 0.533, 0.389, 0.235, 0.074, -0.094)

MAX_VAR_AGE = 50
NUM_INTERVALS = length(co2)
co2_age <- MAX_VAR_AGE * (1:(NUM_INTERVALS)) / (NUM_INTERVALS)
predictor.ages <- co2_age
predictor.var <- co2


#cat("CO2 plots\n")
#rev_out <- rev.process.div.rates(speciation_times_file = "output/primates_co2_speciation_times.log",
#                                 speciation_rates_file = "output/primates_co2_speciation_rates.log",
#                                 extinction_times_file = "output/primates_co2_extinction_times.log",
#                                 extinction_rates_file = "output/primates_co2_extinction_rates.log",
#                                 tree,
#                                 burnin=0.25,numIntervals=100)
#pdf("CO2.pdf")
#par(mfrow=c(2,2))
#rev.plot.div.rates(rev_out, predictor.ages=co2_age, predictor.var=co2)
#dev.off()



#cat("RJ plots\n")
#rev_out <- rev.process.div.rates(speciation_times_file = "output/primates_co2_rj_speciation_times.log",
#                                 speciation_rates_file = "output/primates_co2_rj_speciation_rates.log",
#                                 extinction_times_file = "output/primates_co2_rj_extinction_times.log",
#                                 extinction_rates_file = "output/primates_co2_rj_extinction_rates.log",
#                                 tree,
#                                 burnin=0.25,numIntervals=100)
#pdf("CO2_RJ.pdf")
#par(mfrow=c(2,2))
#rev.plot.div.rates(rev_out, predictor.ages=co2_age, predictor.var=co2)
#dev.off()


#cat("test plots\n")
#rev_out <- rev.process.div.rates(speciation_times_file = "output/primates_co2_test_speciation_times.log",
#                                 speciation_rates_file = "output/primates_co2_test_speciation_rates.log",
#                                 extinction_times_file = "output/primates_co2_test_extinction_times.log",
#                                 extinction_rates_file = "output/primates_co2_test_extinction_rates.log",
#                                 tree,
#                                 burnin=0.25,numIntervals=100)
#pdf("test.pdf")
#par(mfrow=c(2,2))
#rev.plot.div.rates(rev_out, predictor.ages=co2_age, predictor.var=co2)
#dev.off()



#cat("EBD plots\n")
#rev_out <- rev.process.div.rates(speciation_times_file = "output/primates_EBD_speciation_times.log",
#                                 speciation_rates_file = "output/primates_EBD_speciation_rates.log",
#                                 extinction_times_file = "output/primates_EBD_extinction_times.log",
#                                 extinction_rates_file = "output/primates_EBD_extinction_rates.log",
#                                 tree,
#                                 burnin=0.25,numIntervals=100)
#pdf("EBD.pdf")
#par(mfrow=c(2,2))
#rev.plot.div.rates(rev_out, predictor.ages=co2_age, predictor.var=co2, use.geoscale=!FALSE)
#dev.off()



cat("EBD Corr plots\n")
rev_out <- rev.process.div.rates(speciation_times_file = "output/primates_EBD_Corr_speciation_times.log",
                                 speciation_rates_file = "output/primates_EBD_Corr_speciation_rates.log",
                                 extinction_times_file = "output/primates_EBD_Corr_extinction_times.log",
                                 extinction_rates_file = "output/primates_EBD_Corr_extinction_rates.log",
                                 tree,
                                 burnin=0.25,numIntervals=100)
pdf("EBD_Corr.pdf")
par(mfrow=c(2,2))
rev.plot.div.rates(rev_out, predictor.ages=co2_age, predictor.var=co2, use.geoscale=!FALSE)
dev.off()


cat("EBD Corr-RJ plots\n")
rev_out <- rev.process.div.rates(speciation_times_file = "output/primates_EBD_Corr_RJ_speciation_times.log",
                                 speciation_rates_file = "output/primates_EBD_Corr_RJ_speciation_rates.log",
                                 extinction_times_file = "output/primates_EBD_Corr_RJ_extinction_times.log",
                                 extinction_rates_file = "output/primates_EBD_Corr_RJ_extinction_rates.log",
                                 tree,
                                 burnin=0.25,numIntervals=100)
pdf("EBD_Corr_RJ.pdf")
par(mfrow=c(2,2))
rev.plot.div.rates(rev_out, predictor.ages=co2_age, predictor.var=co2, use.geoscale=!FALSE)
dev.off()
