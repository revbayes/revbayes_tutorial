stable = T
if (stable) {
    library(RevGadgets)
} else {
    source("/Users/mlandis/projects/RevGadgets/R/plot_ancestral_states.R")
}
library(ggtree)


out_str = "output/simple_phy"
tree_fn = paste(out_str, ".ase.tre", sep="")

st_lbl = c("R","K","O","M","H","Z","RK","RO","KO","RM","KM","OM","RH","KH","OH","MH","RZ","KZ","OZ","MZ","HZ")

summary_statistic = "MAPRange"
plot_ancestral_states(tree_file=tree_fn,
                      include_start_states=T,
                      shoulder_label_size=1.5,
                      summary_statistic=summary_statistic,
                      state_labels=st_lbl,
                      node_label_size=2,
                      node_size_range=c(2,6),
                      tip_label_size=2,
                      tip_label_offset=0.5,
                      xlim_visible=c(0,7))
