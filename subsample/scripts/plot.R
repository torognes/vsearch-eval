#!/usr/local/bin/Rscript

library(methods)
library(ggplot2)
library(grid)
library(gridExtra)

args <- commandArgs(trailingOnly = TRUE)

inp <- args[1]
w <- as.numeric(args[2])
out <- paste0(inp, ".pdf")

xtitle <- "Top amplicon abundance"

z = read.table(inp, header = TRUE)

fractions = unique(z$fraction)

plist <- list()

i<- 1
for(f in fractions)
{
  d <- subset(z, fraction == f)
  m <- aggregate(abundance ~ program, d, mean)
  m$colour = c("red", "blue")

  p <- ggplot(d, aes(x=abundance)) +
    geom_histogram(colour = "black", fill = "white", binwidth = w) +
    labs(x = xtitle, y = "Occurences") +
    geom_vline(data = m, aes(xintercept = abundance, colour = colour)) + 
    facet_grid(program ~ fraction)

  plist[[i]] <- p
  i <- i + 1
}

pdf(out, 8.0, 11.0)

do.call(grid.arrange, c(plist, list(ncol=1)))

quit(save = "no")
