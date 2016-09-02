library(ape)
library(coda)
source("scripts/Plot_Div_Rates_RevBayes.R")

tree <- read.nexus("data/primates.tre")

files <- c("output/primates_diversified_speciation_times.log", "output/primates_diversified_speciation_rates.log", "output/primates_diversified_extinction_times.log", "output/primates_diversified_extinction_rates.log")

rev_out <- rev.process.output(files,tree,burnin=0.25,numIntervals=100)

pdf("test.pdf")
par(mfrow=c(2,2))
rev.plot.output(rev_out)
dev.off()
