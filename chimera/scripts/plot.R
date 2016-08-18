#!/usr/local/bin/Rscript

library(methods)
library(ggplot2)
library(grid)
library(gridExtra)

# sky blue, orange, dark grey
cbbPalette <- c("#56B4E9", "#E69F00", "#444444")

args <- commandArgs(trailingOnly = TRUE)
ds <- args[1]

z <- NULL

for(pre in c("derep", "clust"))
{
  for (program in c("usearch", "usearch8", "vsearch"))
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

pre_names <- c('derep'="dereplicated", 'clust'="clustered at 97%")
algo_names <- c('dn'="de novo", 'ref'="reference-based")

y = ggplot(z, aes(x=fpr, y=tpr, color = program)) +
 geom_line() +
 labs(x = "False Positive Rate", y = "True Positive Rate") +
 xlim(0, 0.01) +
 ylim(0, 1.00) +
 facet_grid(algo ~ pre, labeller=labeller(pre=pre_names, algo=algo_names)) +
 theme(legend.position = c(0.93, 0.93), legend.title=element_blank()) +
 scale_colour_manual(values=cbbPalette, 
  labels=c("usearch 7", "usearch 8", "vsearch"))

ggsave(file = paste0("results/", ds, ".pdf"), width=8, height=8, y)

quit(save = "no")
