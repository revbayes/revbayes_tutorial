################################################################################
#
# Plot ancestral placental types inferred using MuSSE/HiSSE models.
#
#
# authors: Sebastian Hoehna, Will Freyman
#
################################################################################

#library(devtools)
#install_github("revbayes/RevGadgets")

library(RevGadgets)

tree_file = "output/anc_states_primates_BiSSE_activity_period_results.tree"

plot_ancestral_states(tree_file, summary_statistic="MAP",
                      tip_label_size=0,
                      xlim_visible=NULL,
                      node_label_size=0,
                      show_posterior_legend=TRUE,
                      node_size_range=c(2, 6),
                      alpha=0.75)

output_file = "RevBayes_Anc_States_BiSSE.pdf"
ggsave(output_file, width = 11, height = 9)

