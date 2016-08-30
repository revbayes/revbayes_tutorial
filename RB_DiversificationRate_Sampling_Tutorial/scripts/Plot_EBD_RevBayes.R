

plot.EBD <- function(source_name, output_name) {

    speciation <- read.csv(sprintf("%s_speciation.log",source_name),skip = 2,sep="\t")
    offset <- 0
    offset <- offset + sum(colnames(speciation) == "Iteration")
    offset <- offset + sum(colnames(speciation) == "Posterior")
    offset <- offset + sum(colnames(speciation) == "Likelihood")
    offset <- offset + sum(colnames(speciation) == "Prior")

    mean_rate_speciation <- c()
    for (i in 1:(length(speciation[1,])-offset)) mean_rate_speciation[i] <- mean(speciation[,i+offset])

    lower_rate_speciation <- c()
    for (i in 1:(length(speciation[1,])-offset)) lower_rate_speciation[i] <- quantile(speciation[,i+offset], probs=c(0.025))

    upper_rate_speciation <- c()
    for (i in 1:(length(speciation[1,])-offset)) upper_rate_speciation[i] <- quantile(speciation[,i+offset], probs=c(0.975))

    max_rate_speciation <- max(upper_rate_speciation) * 1.1
    min_rate_speciation <- min(lower_rate_speciation) * 0.9



    extinction <- read.csv(sprintf("%s_extinction.log",source_name),skip = 2,sep="\t")
    offset <- 0
    offset <- offset + sum(colnames(extinction) == "Iteration")
    offset <- offset + sum(colnames(extinction) == "Posterior")
    offset <- offset + sum(colnames(extinction) == "Likelihood")
    offset <- offset + sum(colnames(extinction) == "Prior")

    mean_rate_extinction <- c()
    for (i in 1:(length(extinction[1,])-offset)) mean_rate_extinction[i] <- mean(extinction[,i+offset])

    lower_rate_extinction <- c()
    for (i in 1:(length(extinction[1,])-offset)) lower_rate_extinction[i] <- quantile(extinction[,i+offset], probs=c(0.025))

    upper_rate_extinction <- c()
    for (i in 1:(length(extinction[1,])-offset)) upper_rate_extinction[i] <- quantile(extinction[,i+offset], probs=c(0.975))

    max_rate_extinction <- max(upper_rate_extinction) * 1.1
    min_rate_extinction <- min(lower_rate_extinction) * 0.9

    
    
    
    mean_rate_net_diversification <- c()
    for (i in 1:(length(extinction[1,])-offset)) mean_rate_net_diversification[i] <- mean(speciation[,i+offset] - extinction[,i+offset])

    lower_rate_net_diversification <- c()
    for (i in 1:(length(extinction[1,])-offset)) lower_rate_net_diversification[i] <- quantile(speciation[,i+offset] - extinction[,i+offset], probs=c(0.025))

    upper_rate_net_diversification <- c()
    for (i in 1:(length(extinction[1,])-offset)) upper_rate_net_diversification[i] <- quantile(speciation[,i+offset] - extinction[,i+offset], probs=c(0.975))

    max_rate_net_diversification <- max(upper_rate_net_diversification) * 1.1
    min_rate_net_diversification <- min(lower_rate_net_diversification) * 0.9
    
    
    mean_rate_rel_extinction <- c()
    for (i in 1:(length(extinction[1,])-offset)) mean_rate_rel_extinction[i] <- mean(extinction[,i+offset] / speciation[,i+offset])

    lower_rate_rel_extinction <- c()
    for (i in 1:(length(extinction[1,])-offset)) lower_rate_rel_extinction[i] <- quantile(extinction[,i+offset] / speciation[,i+offset], probs=c(0.025))

    upper_rate_rel_extinction <- c()
    for (i in 1:(length(extinction[1,])-offset)) upper_rate_rel_extinction[i] <- quantile(extinction[,i+offset] / speciation[,i+offset], probs=c(0.975))

    max_rate_rel_extinction <- max(upper_rate_rel_extinction) * 1.1
    min_rate_rel_extinction <- min(lower_rate_rel_extinction) * 0.9


    pdf( sprintf("%s.pdf",output_name) )
    par(mfrow=c(2,2))
    plot( rev(mean_rate_speciation), type="S", ylim=c(min_rate_speciation,max_rate_speciation), ylab="speciation rate" )
    lines( rev(lower_rate_speciation), type="S", lty=2 )
    lines( rev(upper_rate_speciation), type="S", lty=2 )
    plot( rev(mean_rate_extinction), type="S", ylim=c(min_rate_extinction,max_rate_extinction), ylab="extinction rate" )
    lines( rev(lower_rate_extinction), type="S", lty=2 )
    lines( rev(upper_rate_extinction), type="S", lty=2 )
    
    plot( rev(mean_rate_net_diversification), type="S", ylim=c(min_rate_net_diversification,max_rate_net_diversification), ylab="net-diversification rate" )
    lines( rev(lower_rate_net_diversification), type="S", lty=2 )
    lines( rev(upper_rate_net_diversification), type="S", lty=2 )
    plot( rev(mean_rate_rel_extinction), type="S", ylim=c(min_rate_rel_extinction,max_rate_rel_extinction), ylab="relative extinction rate" )
    lines( rev(lower_rate_rel_extinction), type="S", lty=2 )
    lines( rev(upper_rate_rel_extinction), type="S", lty=2 )
    dev.off()

}
