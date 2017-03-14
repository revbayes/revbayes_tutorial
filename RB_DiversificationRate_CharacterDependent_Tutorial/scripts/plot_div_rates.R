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

names <- c("solitariness","activity_period","terrestrially","habitat","missing")

for ( n in names ) {
data <- read.table(paste0("output/primates_BiSSE_",n,".log"),header=TRUE)

dat_ext  <- data.frame(dens = c(data$extinction.1, data$extinction.2), Type = rep(c("1", "2"), each = length(data$extinction.1)))
dat_spec <- data.frame(dens = c(data$speciation.1, data$speciation.2), Type = rep(c("1", "2"), each = length(data$extinction.1)))
dat_div  <- data.frame(dens = c(data$speciation.1-data$extinction.1, data$speciation.2-data$extinction.2), Type = rep(c("1", "2"), each = length(data$extinction.1)))
dat_rel  <- data.frame(dens = c(data$extinction.1/data$speciation.1, data$extinction.2/data$speciation.2), Type = rep(c("1", "2"), each = length(data$extinction.1)))

pdf(paste0("RevBayes_BiSSE_Results_",n,".pdf"))

p1 <- ggplot(dat_spec, aes(x = dens, fill = Type)) + labs(title = "Speciation", x="Rate", y="Posterior Density") + geom_density(alpha = 0.5)
p2 <- ggplot(dat_ext, aes(x = dens, fill = Type)) + labs(title = "Extinction", x="Rate", y="Posterior Density") + geom_density(alpha = 0.5)
p3 <- ggplot(dat_div, aes(x = dens, fill = Type)) + labs(title = "Net-Diversification", x="Rate", y="Posterior Density") + geom_density(alpha = 0.5)
p4 <- ggplot(dat_rel, aes(x = dens, fill = Type)) + labs(title = "Relative Extinction", x="Rate", y="Posterior Density") + geom_density(alpha = 0.5)

multiplot(p1, p2, p3, p4)
dev.off()

}



data <- read.table("output/primates_HiSSE.log",header=TRUE)

start <- round(0.5*length(data$extinction.1))
end   <- length(data$extinction.1)

HiSSE_types <- rep(c("1A", "2A", "1B", "2B"), each = length(data$extinction.1[start:end]))
dat_ext  <- data.frame(dens = c(data$extinction.1[start:end], data$extinction.2[start:end], data$extinction.3[start:end], data$extinction.4[start:end]), Type = HiSSE_types)
dat_spec <- data.frame(dens = c(data$speciation.1[start:end], data$speciation.2[start:end], data$speciation.3[start:end], data$speciation.4[start:end]), Type = HiSSE_types)
dat_div  <- data.frame(dens = c(data$speciation.1[start:end]-data$extinction.1[start:end], data$speciation.2[start:end]-data$extinction.2[start:end], data$speciation.3[start:end]-data$extinction.3[start:end], data$speciation.4[start:end]-data$extinction.4[start:end]), Type = HiSSE_types)
dat_rel  <- data.frame(dens = c(data$extinction.1[start:end]/data$speciation.1[start:end], data$extinction.2[start:end]/data$speciation.2[start:end], data$extinction.3[start:end]/data$speciation.3[start:end], data$extinction.4[start:end]/data$speciation.4[start:end]), Type = HiSSE_types)


pdf("RevBayes_HiSSE_Results.pdf")

p1 <- ggplot(dat_spec, aes(x = dens, fill = Type)) + labs(title = "Speciation", x="Rate", y="Posterior Density") + geom_density(alpha = 0.5) + guides(fill=guide_legend(ncol=2,byrow=TRUE))
p2 <- ggplot(dat_ext, aes(x = dens, fill = Type)) + labs(title = "Extinction", x="Rate", y="Posterior Density") + geom_density(alpha = 0.5) + guides(fill=guide_legend(ncol=2,byrow=TRUE))
p3 <- ggplot(dat_div, aes(x = dens, fill = Type)) + labs(title = "Net-Diversification", x="Rate", y="Posterior Density") + geom_density(alpha = 0.5) + guides(fill=guide_legend(ncol=2,byrow=TRUE))
p4 <- ggplot(dat_rel, aes(x = dens, fill = Type)) + labs(title = "Relative Extinction", x="Rate", y="Posterior Density") + geom_density(alpha = 0.5) + guides(fill=guide_legend(ncol=2,byrow=TRUE))

multiplot(p1, p2, p3, p4)
dev.off()

