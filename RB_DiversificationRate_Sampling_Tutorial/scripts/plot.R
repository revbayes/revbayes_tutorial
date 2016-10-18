# Install RevGadget if you haven't done so already
#library(devtools)
#install_github("revbayes/RevGadgets")

library(RevGadgets)


tree <- read.nexus("data/primates.tre")


"uniform"
rev_out <- rev.process.div.rates(speciation_times_file = "output/primates_uniform_speciation_times.log",
                                 speciation_rates_file = "output/primates_uniform_speciation_rates.log",
                                 extinction_times_file = "output/primates_uniform_extinction_times.log",
                                 extinction_rates_file = "output/primates_uniform_extinction_rates.log",
                                 tree,
                                 burnin=0.25,numIntervals=100)

pdf("uniform.pdf")
par(mfrow=c(2,2))
rev.plot.div.rates(rev_out)
dev.off()


"diversified"
rev_out <- rev.process.div.rates(speciation_times_file = "output/primates_diversified_speciation_times.log",
                                 speciation_rates_file = "output/primates_diversified_speciation_rates.log",
                                 extinction_times_file = "output/primates_diversified_extinction_times.log",
                                 extinction_rates_file = "output/primates_diversified_extinction_rates.log",
                                 tree,
                                 burnin=0.25,numIntervals=100)

pdf("diversified.pdf")
par(mfrow=c(2,2))
rev.plot.div.rates(rev_out)
dev.off()


"empirical"
rev_out <- rev.process.div.rates(speciation_times_file = "output/primates_empirical_speciation_times.log",
                                 speciation_rates_file = "output/primates_empirical_speciation_rates.log",
                                 extinction_times_file = "output/primates_empirical_extinction_times.log",
                                 extinction_rates_file = "output/primates_empirical_extinction_rates.log",
                                 tree,
                                 burnin=0.25,numIntervals=100)

pdf("empirical.pdf")
par(mfrow=c(2,2))
rev.plot.div.rates(rev_out)
dev.off()
