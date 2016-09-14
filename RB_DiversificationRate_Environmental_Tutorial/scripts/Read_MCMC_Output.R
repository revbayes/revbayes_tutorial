################################################################################
#
# @brief Plotting the output of a episodic diversification rate analysis with mass-extinction events.
#
# @date Last modified: 2016-09-08
# @author Sebastian Hoehna
# @version 1.0
# @since 2016-09-08, version 1.0.0
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

rev.read.mcmc.output.rates.through.time = function(times_file_name, rates_file_name, intervals, burnin=0.25) {

  # Process the rates
  lines_to_skip <- 0
  s <- readLines(times_file_name)[lines_to_skip+1]
  while ( substring(s, 1, 1) == "#" ) {
    lines_to_skip <- lines_to_skip + 1
    s <- readLines(times_file_name)[lines_to_skip+1]
  }
  
  cols <- strsplit(readLines(times_file_name)[lines_to_skip+1],"\t")[[1]]
  col_headers <- c("Iteration","Posterior","Likelihood","Prior")
  cols_to_skip <- sum(col_headers %in% cols)
  
  rate_change_times   <- strsplit(readLines(times_file_name)[-(1:(lines_to_skip+1))],"\t")
  rates               <- strsplit(readLines(rates_file_name)[-(1:(lines_to_skip+1))],"\t")
  n_burnt_sampled     <- round(length(rates) * burnin)

  process_rates <- as.mcmc(do.call(rbind,lapply(n_burnt_sampled:length(rate_change_times),function(sample) {
    times <- as.numeric(rate_change_times[[sample]][-(1:cols_to_skip)])
    rates <- as.numeric(rates[[sample]][-(1:cols_to_skip)])
    order <- order(times)
    times <- times[order]
    rates <- c(rates[1],rates[-1][order])
#    rates <- rates[order]
    res   <- rates[findInterval(intervals[-1],times)+1]
#    res   <- rates[findInterval(intervals,times)+1]
#a <- sum(is.finite(res)==FALSE); if (a > 0) cat(a," - ",length(times),length(intervals),intervals," --- \n")
    res   <- rev(res)
    return (res)
  } )))

  return(process_rates)

}

