library(RevGadgets)
tree <- read.nexus("data/primates.tre")


#source("scripts/Plot_EBD_RevBayes.R")
"uniform"

files <- c("output/primates_uniform_speciation_times.log", "output/primates_uniform_speciation_rates.log", "output/primates_uniform_extinction_times.log", "output/primates_uniform_extinction_rates.log")

rev_out <- rev.process.output(files,tree,burnin=0.25,numIntervals=100)

pdf("uniform.pdf")
par(mfrow=c(2,2))
rev.plot.output(rev_out)
dev.off()


#plot.EBD("output/primates_uniform","uniform")
"diversified"

files <- c("output/primates_diversified_speciation_times.log", "output/primates_diversified_speciation_rates.log", "output/primates_diversified_extinction_times.log", "output/primates_diversified_extinction_rates.log")

rev_out <- rev.process.output(files,tree,burnin=0.25,numIntervals=100)

pdf("diversified.pdf")
par(mfrow=c(2,2))
rev.plot.output(rev_out)
dev.off()

#plot.EBD("output/primates_diversified","diversified")


"empirical"

files <- c("output/primates_empirical_speciation_times.log", "output/primates_empirical_speciation_rates.log", "output/primates_empirical_extinction_times.log", "output/primates_empirical_extinction_rates.log")

rev_out <- rev.process.output(files,tree,burnin=0.25,numIntervals=100)

pdf("empirical.pdf")
par(mfrow=c(2,2))
rev.plot.output(rev_out)
dev.off()
#plot.EBD("output/primates_empirical","empirical")
