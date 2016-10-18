library("phytools")

tree <- read.nexus("data/primates.tree")
> data <- fastBM(tree,a=1,alpha=1,sig2=0.25,theta=1,nsim=1000)
> write.table(data,"test.txt",quote=FALSE,sep="\t")

