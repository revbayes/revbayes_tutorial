# Install RevGadget if you haven't done so already
#library(devtools)
#install_github("revbayes/RevGadgets")

library(RevGadgets)

tree <- read.tree("data/primates_Springer.tre")

rev_out <- rev.process.div.rates(speciation_times_file = "output/primates_EBD_speciation_times.log",
                                 speciation_rates_file = "output/primates_EBD_speciation_rates.log",
                                 extinction_times_file = "output/primates_EBD_extinction_times.log",
                                 extinction_rates_file = "output/primates_EBD_extinction_rates.log",
                                 tree,
                                 burnin=0.25,numIntervals=1000)

pdf("EBD.pdf")
par(mfrow=c(2,2))
rev.plot.div.rates(rev_out)
dev.off()
