################################################################################
#
# @brief Plotting the output of a episodic diversification rate analysis with mass-extinction events.
#
# @date Last modified: 2014-10-05
# @author Michael R May and Sebastian Hoehna
# @version 1.0
# @since 2014-10-04, version 1.0.0
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

rev.plot.output = function(output,fig.types=c("speciation rates", "extinction rates", "net-diversification rates","relative-extinction rates"),
                            xlab="million years ago",col=NULL,col.alpha=50,
                            xaxt="n",yaxt="s",pch=19,plot.tree=FALSE,
                            ...){

  # Check that fig type is valid
  validFigTypes <- c("speciation rates","speciation shift times","speciation Bayes factors",
                     "extinction rates","extinction shift times","extinction Bayes factors",
                     "net-diversification rates","relative-extinction rates",
                     "mass extinction times","mass extinction Bayes factors")
  invalidFigTypes <- fig.types[!fig.types %in% validFigTypes]

  if ( length( invalidFigTypes ) > 0 ) {
    stop("\nThe following figure types are invalid: ",paste(invalidFigTypes,collapse=", "),".",
         "\nValid options are: ",paste(validFigTypes,collapse=", "),".")
  }

  # Make color vector
  if ( is.null(col) ) {
    col <- c("speciation rates"="#984EA3",
             "speciation shift times"="#984EA3",
             "speciation Bayes factors"="#984EA3",
             "extinction rates"="#E41A1C",
             "extinction shift times"="#E41A1C",
             "extinction Bayes factors"="#E41A1C",
             "net-diversification rates"="#377EB8",
             "relative-extinction rates"="#FF7F00",
             "mass extinction times"="#4DAF4A",
             "mass extinction Bayes factors"="#4DAF4A")
  } else {
    names(col) <- fig.types
  }

  # Compute the axes
  treeAge <- max(branching.times(output$tree))
  numIntervals <- length(output$intervals)-1
  plotAt <- 0:numIntervals
  intervalSize <- treeAge/numIntervals
  labels <- pretty(c(0,treeAge))
  labelsAt <- numIntervals - (labels / intervalSize)

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
        plot(output$tree,show.tip.label=FALSE,edge.col=rgb(0,0,0,0.10),x.lim=c(0,treeAge))
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
      if( type %in% c("speciation rates","extinction rates")){
        quantilesSpeciation <- apply(output[["speciation rates"]],2,quantile,prob=c(0.025,0.975))
        quantilesExtinction <- apply(output[["extinction rates"]],2,quantile,prob=c(0.025,0.975))
        ylim <- c(0,max(quantilesSpeciation,quantilesExtinction))
      } else {
        ylim <- c(0,max(quantilesThisOutput))
      }

      if(plot.tree){
        plot(output$tree,show.tip.label=FALSE,edge.col=rgb(0,0,0,0.10),x.lim=c(0,treeAge))
        par(new=TRUE)
      }
      plot(x=plotAt,y=c(meanThisOutput[1],meanThisOutput),type="l",ylim=ylim,xaxt=xaxt,col=col[type],ylab="rate",main=type,xlab=xlab,...)
      polygon(x=c(0:ncol(quantilesThisOutput),ncol(quantilesThisOutput):0),y=c(c(quantilesThisOutput[1,1],quantilesThisOutput[1,]),rev(c(quantilesThisOutput[2,1],quantilesThisOutput[2,]))),border=NA,col=paste(col[type],col.alpha,sep=""))
      axis(1,at=labelsAt,labels=labels)

    }

  }

}



################################################################################
#
# @brief Processing the output of a episodic diversification rate analysis with mass-extinction events.
#
# @date Last modified: 2014-10-05
# @author Michael R May and Sebastian Hoehna
# @version 2.0
# @since 2014-10-04, version 2.0.0
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

rev.process.output = function(file_names,tree,burnin=0.25,numIntervals=100){

#  files <- list.files(dir,full.names=TRUE)

  # Get the time of the tree and divide it into intervals
  time <- max( branching.times(tree) )
  intervals <- seq(0,time,length.out=numIntervals+1)

  # Process the speciation rates
  lines_to_skip <- 0
  s <- readLines(file_names[1])[lines_to_skip+1]
  while ( substring(s, 1, 1) == "#" ) {
    lines_to_skip <- lines_to_skip + 1
    s <- readLines(file_names[1])[lines_to_skip+1]
  }
  
  cols <- strsplit(readLines(file_names[1])[lines_to_skip+1],"\t")[[1]]
  col_headers <- c("Iteration","Posterior","Likelihood","Prior")
  cols_to_skip <- sum(col_headers %in% cols)
  
  speciationRateChangeTimes   <- strsplit(readLines(file_names[1])[-(1:(lines_to_skip+1))],"\t")
  speciationRates             <- strsplit(readLines(file_names[2])[-(1:(lines_to_skip+1))],"\t")
  speciationBurnin            <- length(speciationRates) * burnin

  processSpeciationRates <- as.mcmc(do.call(rbind,lapply(speciationBurnin:length(speciationRateChangeTimes),function(sample) {
    times <- as.numeric(speciationRateChangeTimes[[sample]][-(1:cols_to_skip)])
    rates <- as.numeric(speciationRates[[sample]][-(1:cols_to_skip)])
    order <- order(times)
    times <- times[order]
    rates <- c(rates[1],rates[-1][order])
    res   <- rates[findInterval(intervals[-1],times)+1]
    res   <- rev(res)
    return (res)
  } )))
  
  

  # Process the extinction rates
  extinctionRateChangeTimes   <- strsplit(readLines(file_names[3])[-(1:(lines_to_skip+1))],"\t")
  extinctionRates             <- strsplit(readLines(file_names[4])[-(1:(lines_to_skip+1))],"\t")
  extinctionBurnin            <- length(extinctionRates) * burnin

  processExtinctionRates <- as.mcmc(do.call(rbind,lapply(extinctionBurnin:length(extinctionRateChangeTimes),function(sample) {
    times <- as.numeric(extinctionRateChangeTimes[[sample]][-(1:cols_to_skip)])
    rates <- as.numeric(extinctionRates[[sample]][-(1:cols_to_skip)])
    order <- order(times)
    times <- times[order]
    rates <- c(rates[1],rates[-1][order])
    res   <- rates[findInterval(intervals[-1],times)+1]
    res   <- rev(res)
    return (res)
  } )))


  # Process the net-diversification and relative-extinction rates
  processNetDiversificationRates <- as.mcmc(processSpeciationRates-processExtinctionRates)
  processRelativeExtinctionRates <- as.mcmc(processExtinctionRates/processSpeciationRates)



  res <- list("speciation rates" = processSpeciationRates,
              "extinction rates" = processExtinctionRates,
              "net-diversification rates" = processNetDiversificationRates,
              "relative-extinction rates" = processRelativeExtinctionRates,
              "tree" = tree,
              "intervals" = rev(intervals) )

  return(res)

}

