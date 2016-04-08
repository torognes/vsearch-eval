#!/usr/local/bin/Rscript

library(methods)
library(ggplot2)
library(grid)
library(gridExtra)

args <- commandArgs(trailingOnly = TRUE)

inp <- args[1]
pfile <- args[2]
w <- as.numeric(args[3])
out <- paste0(inp, ".pdf")

xtitle <- "Top amplicon abundance"

z = read.table(inp, header = TRUE)

k = read.table(pfile, header = TRUE)

fractions = unique(z$fraction)

plist <- list()

i<- 1
for(f in fractions)
{
  d <- subset(z, fraction == f)
  m <- aggregate(abundance ~ program, d, mean)
  m$colour = c("red", "blue")

  kk <- subset(k, fraction == f)
  perfect <- kk$mean

  p <- ggplot(d, aes(x=abundance)) +
    geom_histogram(colour = "black", fill = "white", binwidth = w) +
    labs(x = xtitle, y = "Occurences") +
    geom_vline(data = m, aes(xintercept = abundance, colour = colour)) + 
    geom_vline(xintercept = perfect, colour = "green") + 
    facet_grid(program ~ fraction)

  plist[[i]] <- p
  i <- i + 1
}

pdf(out, 8.0, 11.0)

do.call(grid.arrange, c(plist, list(ncol=1)))

quit(save = "no")
