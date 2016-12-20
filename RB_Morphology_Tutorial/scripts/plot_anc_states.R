library(devtools)
install_github("revbayes/RevGadgets")


#library(RevGadgets)
library(ggtree)
source("scripts/plot_ancestral_states.R")

# read in tree
tree_file = "output/ancestral_states_results.tree"
t = read.beast(tree_file)
tree = attributes(t)$phylo
    
#plot_ancestral_states("output/ancestral_states_results.tree", summary_statistic="mean")
plot_ancestral_states(tree, summary_statistic="MAP",
                      tip_label_size=2,
                      xlim_visible=NULL,
                      node_label_size=0,
                      node_size_range=c(2, 8))


# 

#plot_ancestral_states("output/ancestral_states_results_site1.tree", summary_statistic="mean")
#plot_ancestral_states("output/ancestral_states_results_site2.tree", summary_statistic="mean")
#plot_ancestral_states("output/ancestral_states_results_site3.tree", summary_statistic="mean")
