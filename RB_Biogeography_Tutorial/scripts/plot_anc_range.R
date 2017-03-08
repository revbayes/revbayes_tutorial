stable = T
if (stable) {
    library(RevGadgets)
} else {
    source("/Users/mlandis/projects/RevGadgets/R/plot_ancestral_states.R")
}
library(ggtree)

# files
tree_fn = paste(out_str, ".ase.tre", sep="")
label_fn = paste(out_str, ".state_labels.txt", sep="")
color_fn = "scripts/range_colors.txt"

# get state labels
state_descriptions = read.csv(label_fn, header=T, sep=",", colClasses="character")

# map presence-absence ranges to area names
range_labels = sapply(state_descriptions$range[2:nrow(state_descriptions)],
    function(x) {
        present = as.vector(gregexpr(pattern="1", x)[[1]])
        paste( area_names[present], collapse="")
    })

# generate colors for ranges
range_color_list = read.csv(color_fn, header=T, sep=",", colClasses="character")
range_colors = range_color_list$color[ match(range_labels, range_color_list$range) ]
 
# plot ranges
summary_statistic = "MAPRange"
plot_ancestral_states(tree_file=tree_fn,
                      include_start_states=T,
                      shoulder_label_size=1.5,
                      shoulder_label_nudge_x=-0.1*plot_scale,
                      summary_statistic=summary_statistic,
                      state_labels=range_labels,
                      state_colors=range_colors,
                      node_label_size=2,
                      node_size_range=c(2,2),
                      node_label_nudge_x=0.1*plot_scale,
                      tip_label_size=2,
                      tip_label_offset=0.5*plot_scale,
                      xlim_visible=c(0,17*plot_scale),
                      show_posterior_legend=F,
                      show_tree_scale=T)
