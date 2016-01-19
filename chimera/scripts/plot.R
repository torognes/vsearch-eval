#!/usr/local/bin/Rscript

library(methods)
library(ggplot2)
library(grid)
library(gridExtra)

args <- commandArgs(trailingOnly = TRUE)
ds <- args[1]

z <- NULL

for(pre in c("derep", "clust"))
{
  for (program in c("usearch", "vsearch"))
  {
    for(algo in c("dn", "ref"))
    {
      fn <- paste0("results/", pre, "/", ds, "_", 
        pre, "_", program, "_", algo, ".roc")
      x <- read.table(fn)
      x$pre <- pre
      x$program <- program
      x$algo <- algo
      z = rbind(z, x)
    }
  }
}

colnames(z) <- c("fpr", "tpr", "pre", "program", "algo")

y = ggplot(z, aes(x=fpr, y=tpr, color = program)) +
  geom_line() +
  labs(x = "False Positive Rate", y = "True Positive Rate") +
  xlim(0, 0.01) +
  ylim(0, 1.00) +
  facet_grid(algo ~ pre)

ggsave(file = paste0("results/", ds, ".pdf"), width=10, height=8, y)

quit(save = "no")
