library(methods)
library(ggplot2)
library(grid)
library(gridExtra)

# sky blue, orange, dark grey
cbbPalette <- c("#56B4E9", "#E69F00", "#444444")

z <- NULL

for (program in c("usearch", "usearch8", "vsearch"))
  {
    fn <- paste0("results/curve.", program, ".txt")
    x <- read.table(fn)
    x$program <- program
    z = rbind(z, x)   
  }

colnames(z) <- c("fdr", "tpr", "program")

y = ggplot(z, aes(x=fdr, y=tpr, color = program)) +
 geom_line() +
 labs(x = "False Discovery Rate", y = "True Positive Rate") +
 scale_y_continuous(limits = c(0.0, 1.0), breaks = seq(0.0, 1.0, by=0.2)) +
 xlim(0, 0.02) +
 theme(legend.position = c(0.85, 0.2), legend.title=element_blank()) +
 scale_colour_manual(values=cbbPalette, 
 labels=c("usearch 7", "usearch 8", "vsearch"))

ggsave(file = paste0("results/curve.pdf"), width=4, height=3, y)

quit(save = "no")
