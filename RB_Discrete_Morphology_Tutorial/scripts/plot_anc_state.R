#!/usr/bin/env Rscript
stable = !T
if (stable) {
    library(RevGadgets)
} else {
    source("/Users/mlandis/projects/RevGadgets/R/plot_ancestral_states.R")
}
library(ggtree)
library(tools)

# file argument
args = commandArgs(trailingOnly=TRUE)
n_args = length(args)
tree_fn = "output/mk_simple.char_1.ase.tre"
if (n_args == 1) {
    tree_fn = args[1]    
} else if (n_args > 1) {
    error("Must supply 0 or 1 argument for the tree filename.")
}
fix_fn = paste(file_path_sans_ext(tree_fn), ".fix.", file_ext(tree_fn), sep="")
pdf_fn = paste(file_path_sans_ext(tree_fn), ".pdf", sep="")

# clean up the ASE file to work with ggtree
lines = readLines(tree_fn)
n_trees = length(lines)
lines = sapply(lines, function(x) { gsub("\\[(.brlen.*?)\\]", "", x)  } )
lines = sapply(lines, function(x) { gsub("posterior=1.000000,", "", x) } )
file_conn = file(fix_fn)
writeLines(lines, file_conn)
close(file_conn)

# plot states
plot_scale = 0.1
summary_statistic = "MAP"
p = plot_ancestral_states(tree_file=fix_fn,
                          include_start_states=F,
                          summary_statistic=summary_statistic,
                          node_label_size=0,
                          node_size_range=c(2,4),
                          node_label_nudge_x=0.1*plot_scale,
                          tip_node_size=4,
                          tip_label_size=2,
                          tip_label_offset=0.5*plot_scale,
                          xlim_visible=c(0,17*plot_scale),
                          show_posterior_legend=T,
                          show_tree_scale=T)

# save plot
ggsave(filename=pdf_fn)
