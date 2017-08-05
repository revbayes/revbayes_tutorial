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

tree_file = "output/anc_states_primates_ClaSSE_results.tree"

plot_ancestral_states(tree_file, summary_statistic="MAPRange",
                      tip_label_size=3,
                      tip_label_offset=1,
                      xlim_visible=c(0,100),
                      node_label_size=0,
                      shoulder_label_size=0,
                      include_start_states=TRUE,
                      show_posterior_legend=TRUE,
                      node_size_range=c(4, 7),
                      alpha=0.75)

output_file = "RevBayes_Anc_States_ClaSSE.pdf"
ggsave(output_file, width = 11, height = 9)

