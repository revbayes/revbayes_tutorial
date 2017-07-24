library(plotrix)
library(phytools)

character_file = "character.tree"

write_pdf = TRUE

if (write_pdf) {
    pdf("simmap.pdf")
}

sim2 = read.simmap(file=character_file, format="phylip")

colors = vector()
for (i in 1:length( sim2$maps ) ) { 
    colors = c(colors, names(sim2$maps[[i]]) )
}
colors = sort(as.numeric(unique(colors)))

cols = setNames( rainbow(length(colors), start=0.0, end=0.9), colors)

plotSimmap(sim2, cols, fsize=0.5, lwd=1, split.vertical=TRUE, ftype="i")

# add legend
x = 0
y = 15

leg = names(cols)
colors = cols
y = y - 0:(length(leg) - 1)
x = rep(x, length(y))
text(x + 0.0005, y, leg, pos=4, cex=0.75)

mapply(draw.circle, x=x, y=y, col=colors, MoreArgs = list(nv=200, radius=0.001, border="white"))

if (write_pdf) {
    dev.off()
}

