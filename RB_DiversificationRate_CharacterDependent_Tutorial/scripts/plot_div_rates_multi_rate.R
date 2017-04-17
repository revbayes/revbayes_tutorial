################################################################################
#
# Summarizing RevBayes output
# 
#
# authors: Sebastian Hoehna
#
################################################################################

library(coda)
library(ggplot2)
source("scripts/multiplot.R")

i <- 2
data <- read.table(paste0("output/primates_multi_rate_BD_",i,".log"),header=TRUE)

dat_ext  <- data.frame(dens = c(data$extinction.1, data$extinction.2), Type = rep(c("1", "2"), each = length(data$extinction.1)))
dat_spec <- data.frame(dens = c(data$speciation.1, data$speciation.2), Type = rep(c("1", "2"), each = length(data$extinction.1)))
dat_div  <- data.frame(dens = c(data$speciation.1-data$extinction.1, data$speciation.2-data$extinction.2), Type = rep(c("1", "2"), each = length(data$extinction.1)))
dat_rel  <- data.frame(dens = c(data$extinction.1/data$speciation.1, data$extinction.2/data$speciation.2), Type = rep(c("1", "2"), each = length(data$extinction.1)))

pdf(paste0("RevBayes_primates_multi_rate_BD_",i,"_Results.pdf"))

p1 <- ggplot(dat_spec, aes(x = dens, fill = Type)) + labs(title = "Speciation", x="Rate", y="Posterior Density") + geom_density(alpha = 0.5)
p2 <- ggplot(dat_ext, aes(x = dens, fill = Type)) + labs(title = "Extinction", x="Rate", y="Posterior Density") + geom_density(alpha = 0.5)
p3 <- ggplot(dat_div, aes(x = dens, fill = Type)) + labs(title = "Net-Diversification", x="Rate", y="Posterior Density") + geom_density(alpha = 0.5)
p4 <- ggplot(dat_rel, aes(x = dens, fill = Type)) + labs(title = "Relative Extinction", x="Rate", y="Posterior Density") + geom_density(alpha = 0.5)

multiplot(p1, p2, p3, p4)
dev.off()


