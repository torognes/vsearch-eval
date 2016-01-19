#!/usr/local/bin/Rscript

library(methods)
library(ggplot2)
library(grid)
library(gridExtra)

z <- NULL

#for (program in c("blast", "megablast", "usearch", "vsearch"))
for (program in c("usearch", "vsearch"))
  {
    p <- substr(program, 1, 1)
    fn <- paste0("results/curve.", p, ".txt")
    x <- read.table(fn)
    x$program <- program
    z = rbind(z, x)   
  }

colnames(z) <- c("fdr", "tpr", "program")

y = ggplot(z, aes(x=fdr, y=tpr, color = program)) +
  geom_line() +
  labs(x = "False Discovery Rate", y = "True Positive Rate") +
  scale_y_continuous(limits = c(0.0, 1.0), breaks = seq(0.0, 1.0, by=0.1)) +
  xlim(0, 0.02)

ggsave(file = paste0("results/curve.pdf"), width=10, height=8, y)

quit(save = "no")
