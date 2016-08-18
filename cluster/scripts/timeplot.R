library(methods)
library(ggplot2)
library(reshape)

# sky blue, orange, dark grey
cbbPalette <- c("#56B4E9", "#E69F00", "#444444")

d <- read.table("results/timing.txt", dec=".")

colnames(d) <- c("dataset", "algorithm", "program", "id", "time")

d$algorithm <- factor(d$algorithm, labels = c("length sorted (cluster_fast)", "abundance sorted (cluster_smallmem)"))

d2 <- melt(cast(d, dataset~algorithm~program~id, median))

colnames(d2) <- c("dataset", "algorithm", "program", "id", "time")

ggplot(d2, aes(factor(id), y = time, fill = program)) + 
 geom_bar(stat="identity", width=0.7, position = position_dodge(width = 0.8)) +
 facet_grid( dataset ~ algorithm, scale = "free") +
 labs(x = "identity (%)", y = "median wall time (s)") +
 theme(legend.position = c(0.07, 0.93), legend.title=element_blank()) +
 scale_y_continuous(breaks = seq(0, 40, 5)) +
 scale_fill_manual(values=cbbPalette, 
 labels=c("usearch 7", "usearch 8", "vsearch"))

ggsave(file = "results/clustering_timing.pdf", width=8, height=8)

quit(save = "no")
