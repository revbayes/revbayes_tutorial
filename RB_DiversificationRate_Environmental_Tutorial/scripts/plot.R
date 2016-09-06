# Install RevGadget if you haven't done so already
#library(devtools)
#install_github("revbayes/RevGadgets")

#library(RevGadgets)
library(ape)
library(coda)
source("scripts/Plot_Div_Rates.R")

tree <- read.tree("data/primates_Springer.tre")

cat("processing\n")
rev_out <- rev.process.div.rates(speciation_times_file = "output/primates_co2_speciation_times.log",
                                 speciation_rates_file = "output/primates_co2_speciation_rates.log",
                                 extinction_times_file = "output/primates_co2_extinction_times.log",
                                 extinction_rates_file = "output/primates_co2_extinction_rates.log",
                                 tree,
                                 burnin=0.25,numIntervals=100)
cat("plotting\n")
pdf("CO2.pdf")
par(mfrow=c(2,2))
rev.plot.div.rates(rev_out)
dev.off()
