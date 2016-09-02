library(RevGadgets)

tree <- read.tree("data/primates_Springer.tre")
files <- c("output/primates_EBD_speciation_times.log", "output/primates_EBD_speciation_rates.log", "output/primates_EBD_extinction_times.log", "output/primates_EBD_extinction_rates.log")

rev_out <- rev.process.output(files,tree,burnin=0.25,numIntervals=100)

pdf("EBD.pdf")
par(mfrow=c(2,2))
rev.plot.output(rev_out)
dev.off()
