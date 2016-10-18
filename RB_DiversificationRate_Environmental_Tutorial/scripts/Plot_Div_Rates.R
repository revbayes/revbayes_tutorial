################################################################################
#
# @brief Plotting the output of a episodic diversification rate analysis with mass-extinction events.
#
# @date Last modified: 2016-09-05
# @author Michael R May and Sebastian Hoehna
# @version 1.0
# @since 2016-08-31, version 1.0.0
#
# @param    output            list          The processed output for plotting.
# @param    fig.types         character     Which aspects of the model to visualize. See details for a complete description.
# @param    xlab              character     The label of the x-axis. By default, millions of years.
# @param    col               character     Colors used for printing. Must be of same length as fig.types.
# @param    col.alpha         numeric       Alpha channel parameter for credible intervals.
# @param    xaxt              character     The type of x-axis to plot. By default, no x-axis is plotted (recommended).
# @param    yaxt              character     The type of y-axis to plot.
# @param    pch               integer       The type of points to draw (if points are drawn).
# @param    ...                             Parameters delegated to various plotting functions.
#
#
################################################################################

rev.plot.div.rates = function(output,fig.types=c("speciation rate", "extinction rate", "net-diversification rate","relative-extinction rate"),
                            xlab="million years ago",col=NULL,col.alpha=50,
                            xaxt="n",yaxt="s",pch=19,plot.tree=FALSE, use.geoscale=TRUE, use.smoothing=!TRUE,
                            predictor.ages=c(),predictor.var=c(),
                            ...){

    # Check that fig type is valid
    validFigTypes <- c("speciation rate","speciation shift times","speciation Bayes factors",
                       "extinction rate","extinction shift times","extinction Bayes factors",
                       "net-diversification rate","relative-extinction rate",
                       "mass extinction times","mass extinction Bayes factors")
    invalidFigTypes <- fig.types[!fig.types %in% validFigTypes]

    if ( length( invalidFigTypes ) > 0 ) {
        stop("\nThe following figure types are invalid: ",paste(invalidFigTypes,collapse=", "),".",
             "\nValid options are: ",paste(validFigTypes,collapse=", "),".")
    }

    # Make color vector
    if ( is.null(col) ) {
        col <- c("speciation rate"="#984EA3",
                 "speciation shift times"="#984EA3",
                 "speciation Bayes factors"="#984EA3",
                 "extinction rate"="#E41A1C",
                 "extinction shift times"="#E41A1C",
                 "extinction Bayes factors"="#E41A1C",
                 "net-diversification rate"="#377EB8",
                 "relative-extinction rate"="#FF7F00",
                 "mass extinction times"="#4DAF4A",
                 "mass extinction Bayes factors"="#4DAF4A")
    } else {
        names(col) <- fig.types
    }

    # Compute the axes
    tree_age <- max(branching.times(output$tree))
    numIntervals <- length(output$intervals)-1
    plotAt <- 0:numIntervals
    intervalSize <- tree_age/numIntervals
    labels <- pretty(c(0,tree_age))
    labelsAt <- numIntervals - (labels / intervalSize)
    ages <- seq(0,tree_age,length.out=numIntervals+1)

    for( type in fig.types ) {

        if ( grepl("times",type) ) {

            thisOutput <- output[[type]]
            meanThisOutput <- colMeans(thisOutput)
            criticalPP <- output[[grep(strsplit(type," ")[[1]][1],grep("CriticalPosteriorProbabilities",names(output),value=TRUE),value=TRUE)]]

            if(plot.tree){
                plot(output$tree,show.tip.label=FALSE,edge.col=rgb(0,0,0,0.10),x.lim=c(0,treeAge))
                par(new=TRUE)
            }

            barplot(meanThisOutput,space=0,xaxt=xaxt,col=col[type],border=col[type],main=type,ylab="posterior probability",xlab=xlab,ylim=c(0,1),...)
            abline(h=criticalPP,lty=2,...)
            axis(4,at=criticalPP,labels=2*log(output$criticalBayesFactors),las=1,tick=FALSE,line=-0.5)
            axis(1,at=labelsAt,labels=labels)
            box()

        } else if ( grepl("Bayes factors",type) ) {

            thisOutput <- output[[type]]
            ylim <- range(c(thisOutput,-10,10),finite=TRUE)

            if(plot.tree){
                plot(output$tree,show.tip.label=FALSE,edge.col=rgb(0,0,0,0.10),x.lim=c(0,tree_age))
                par(new=TRUE)
            }
            plot(x=plotAt[-1]-diff(plotAt[1:2])/2,y=thisOutput,type="p",xaxt=xaxt,col=col[type],ylab="Bayes factors",main=type,xlab=xlab,ylim=ylim,xlim=range(plotAt),pch=pch,...)
            abline(h=2 * log(output$criticalBayesFactors),lty=2,...)
            axis(4,at=2 * log(output$criticalBayesFactors),las=1,tick=FALSE,line=-0.5)
            axis(1,at=labelsAt,labels=labels)

        } else {

            thisOutput <- output[[type]]
            meanThisOutput <- colMeans(thisOutput)      
            quantilesThisOutput <- apply(thisOutput,2,quantile,prob=c(0.025,0.975))
            
            # find the limits of the y-axis
            # we always want the speciation and extinction rates to be on the same scale 
            if ( type %in% c("speciation rate","extinction rate")) {

                quantilesSpeciation <- apply(output[["speciation rate"]],2,quantile,prob=c(0.025,0.975))
                quantilesExtinction <- apply(output[["extinction rate"]],2,quantile,prob=c(0.025,0.975))
                ylim <- c(min(0,quantilesSpeciation,quantilesExtinction),max(quantilesSpeciation,quantilesExtinction))

            } else {
                ylim <- c(min(0,quantilesThisOutput),max(quantilesThisOutput))
            }

            if (plot.tree) {
                plot(output$tree,show.tip.label=FALSE,edge.col=rgb(0,0,0,0.10),x.lim=c(0,tree_age))
                par(new=TRUE)
            }

            if ( use.geoscale == TRUE ) {
                if ( use.smoothing == TRUE ) {
                    y_unsmoothed <- c(meanThisOutput[1],meanThisOutput)
                    y_smoothed <- (lowess(x=1:length(y_unsmoothed),y_unsmoothed, f=0.2))$y
                    
                    y_unsmoothed_1 <- c(quantilesThisOutput[1,1],quantilesThisOutput[1,])
                    y_unsmoothed_2 <- rev(c(quantilesThisOutput[2,1],quantilesThisOutput[2,]))
                    lo_1 <- lowess(x=1:length(y_unsmoothed_1),y_unsmoothed_1, f=0.2)
                    y_smoothed_1 <- lo_1$y
                    lo_2 <- lowess(x=1:length(y_unsmoothed_2),y_unsmoothed_2, f=0.2)
                    y_smoothed_2 <- lo_2$y
                    y_smoothed_ci <- c(y_smoothed_1,y_smoothed_2)
                } else {
                    y_smoothed <- c(meanThisOutput[1],meanThisOutput)
                    y_smoothed_ci <- c(c(quantilesThisOutput[1,1],quantilesThisOutput[1,]),rev(c(quantilesThisOutput[2,1],quantilesThisOutput[2,])))
                }
                
                geoscalePlot(rev(ages),y_smoothed,units=c("Period","Epoch"),type="l",label=type,tick.scale=10,age.lim=c(tree_age,0),data.lim=ylim,cex.ts=1.3,col=1,lwd=2,cex.age=1.75)
                polygon(x=c((ncol(quantilesThisOutput):0)/numIntervals*tree_age,(0:ncol(quantilesThisOutput))/numIntervals*tree_age),y=y_smoothed_ci,border=NA,col=paste(col[type],col.alpha,sep=""))
            
                if ( is.null(predictor.var) == FALSE && is.null(predictor.ages) == FALSE ) {
                    max_this_plot    <- max(ylim)
                    min_this_plot    <- min(ylim)
                    mid_this_plot    <- min_this_plot + (max_this_plot - min_this_plot)/2
                    spread_this_plot <- max_this_plot - min_this_plot

                    max_predictor_var <- max(predictor.var)
                    min_predictor_var <- min(predictor.var)
                    mid_predictor_var  <- min_predictor_var + (max_predictor_var - min_predictor_var)/2
                    spread_predictor_var <- max_predictor_var - min_predictor_var
                    predictor_var <- ( (predictor.var - mid_predictor_var) / spread_predictor_var ) * spread_this_plot * 0.8 + mid_this_plot

                    lines(predictor.ages,predictor_var,lwd=4,lty=3)
                }
            
            } else {
                plot(x=plotAt,y=c(meanThisOutput[1],meanThisOutput),type="l",ylim=ylim,xaxt=xaxt,col=col[type],ylab="rate",main=type,xlab=xlab,...)
                polygon(x=c(0:ncol(quantilesThisOutput),ncol(quantilesThisOutput):0),y=c(c(quantilesThisOutput[1,1],quantilesThisOutput[1,]),rev(c(quantilesThisOutput[2,1],quantilesThisOutput[2,]))),border=NA,col=paste(col[type],col.alpha,sep=""))
                axis(1,at=labelsAt,labels=labels)
            }
      
        }

    }

}



################################################################################
#
# @brief Processing the output of a episodic diversification rate analysis with mass-extinction events.
#
# @date Last modified: 2016-09-05
# @author Michael R May and Sebastian Hoehna
# @version 1.0
# @since 2016-08-31, version 1.0.0
#
# @param    dir                         character      The directory from which the CoMET output will be read.
# @param    tree                        phylo          The tree analyzed with CoMET in phylo format. By default, looks for a tree in the target directory.
# @param    numExpectedRateChanges      numeric        The number of expected diversification-rate changes.
# @param    numExpectedMassExtinctions  numeric        The number of expected mass-extinction events.
# @param    burnin                      numeric        The fraction of the posterior samples to be discarded as burnin.
# @param    numIntervals                numeric        The number of discrete intervals in which to break the tree.
# @param    criticalBayesFactors        numeric        The Bayes factor thresholds to use to assess significance of events.
#
#
################################################################################

rev.process.div.rates = function(speciation_times_file="",speciation_rates_file="",extinction_times_file="",extinction_rates_file="",tree,burnin=0.25,numIntervals=100){


  # Get the time of the tree and divide it into intervals
  time <- max( branching.times(tree) )
  intervals <- seq(0,time,length.out=numIntervals+1)

  processSpeciationRates <- rev.read.mcmc.output.rates.through.time(speciation_times_file, speciation_rates_file, intervals, burnin)
  processExtinctionRates <- rev.read.mcmc.output.rates.through.time(extinction_times_file, extinction_rates_file, intervals, burnin)


  # Process the net-diversification and relative-extinction rates
  processNetDiversificationRates <- as.mcmc(processSpeciationRates-processExtinctionRates)
  processRelativeExtinctionRates <- as.mcmc(processExtinctionRates/processSpeciationRates)



  res <- list("speciation rate" = processSpeciationRates,
              "extinction rate" = processExtinctionRates,
              "net-diversification rate" = processNetDiversificationRates,
              "relative-extinction rate" = processRelativeExtinctionRates,
              "tree" = tree,
              "intervals" = rev(intervals) )

  return(res)

}

