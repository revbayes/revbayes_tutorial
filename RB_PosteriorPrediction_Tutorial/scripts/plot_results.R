
#
# Script to plot posterior predictive data results.
#
# authors: Sebastian Hoehna, Will Freyman
#


model_name <- "JC"

dir = paste0("results_",model_name,"/")
dataset_name = "pps_example"

posterior_predictive_data <- read.table(paste0(dir,"simulated_data_",dataset_name,".tsv"),header=TRUE,sep=",",check.names=FALSE)
posterior_original_data   <- read.table(paste0(dir,"empirical_data_",dataset_name,".tsv"),header=TRUE,sep=",",check.names=FALSE)

names <- colnames( posterior_original_data )

posterior_predictive_data_num <- matrix(data = NA, nrow = dim(posterior_predictive_data)[1], ncol = dim(posterior_predictive_data)[2])

for (i in 1:dim(posterior_predictive_data)[2]) {
    posterior_predictive_data_num[,i] <- c(as.numeric(posterior_predictive_data[[i]]))
}

min_value <- c()
max_value <- c()
spread_value <- c()

for ( i in 1:length(names)) {

    pdf( paste0(dir,"posterior_predictive_",model_name,"_",dataset_name,"_",names[i],"_results.pdf") )
    min_value[i] <- min(posterior_predictive_data_num[,i],posterior_original_data[[i]])
    max_value[i] <- max(posterior_predictive_data_num[,i],posterior_original_data[[i]])
    spread_value[i] <- max_value[i] - min_value[i]
    d <- density(posterior_predictive_data_num[,i])
    q01  <- quantile(posterior_predictive_data_num[,i],prob=0.01)
    q025 <- quantile(posterior_predictive_data_num[,i],prob=0.025)
    q975 <- quantile(posterior_predictive_data_num[,i],prob=0.975)
    q99  <- quantile(posterior_predictive_data_num[,i],prob=0.99)
    x.min <- which.min( d$x )
    x01  <- min(which(d$x >= q01))  
    x025 <- max(which(d$x <  q025))
    x975 <- min(which(d$x >  q975))
    x99  <- max(which(d$x <  q99))
    x.max <- which.max( d$x )
    plot(d,
         main="",
         xlab=names[i],
         xlim=c(min_value[i]-0.25*spread_value[i],max_value[i]+0.25*spread_value[i]) )

    with(d, polygon(x=c(x[c(x.min,x.min:x01,x01)]), y= c(0, y[x.min:x01], 0), col="darkgray", border="black") )
    with(d, polygon(x=c(x[c(x01,x01:x025,x025)]), y= c(0, y[x01:x025], 0), col="lightgray", border="black") )
    with(d, polygon(x=c(x[c(x975,x975:x99,x99)]), y= c(0, y[x975:x99], 0), col="lightgray", border="black") )
    with(d, polygon(x=c(x[c(x99,x99:x.max,x.max)]), y= c(0, y[x99:x.max], 0), col="darkgray", border="black") )
    abline(v=posterior_original_data[[i]], col="black", lty=3, lwd=3)
    
    dev.off()

}
