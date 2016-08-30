library(ggplot2)
library(scales)
library(tidyr)
library(dplyr)

## Generic data for different subsampling percentages
runs <- list(list("source" = "1", "percentage" = "0.1", "divider" = 1),
             list("source" = "5", "percentage" = "0.5", "divider" = 5),
             list("source" = "15", "percentage" = "1.5", "divider" = 15),
             list("source" = "25", "percentage" = "2.5", "divider" = 25),
             list("source" = "50", "percentage" = "5", "divider" = 50))

subsampling_plots <- function(arg) {
    ## Load data
    setwd("../results/")
    
    input <- paste("TARA_V9_264_samples.subsample_", run$source, "_head.log", sep = "")

    ## Import and format data
    d <- read.table(input, sep = "\t", header = TRUE, dec = ".")
    methods <- c("vsearch", "usearch")
    divider <- run$divider / 100
    target_values <- c(d$nominal_size[1] * divider, d$nominal_size[1] * divider)
    targets <- data.frame(methods, target_values)
    d <- d[-c(1:3)]
    colnames(d) <- methods
    d <- gather(d, "method", "size", 1:2)
    d <- within(d, d$method <- factor(d$method, levels = c("usearch", "vsearch")))
    
    means <- group_by(d, method) %>%
        summarise(mean = mean(size), sd = sd(size))
    print(means)
    
    binwidth <- round((max(d$size) - min(d$size)) / 100)
    
    ## Plot
    cbbPalette <- c("#000000", "#E69F00", "#56B4E9", "#009E73", "#F0E442", "#0072B2", "#D55E00", "#CC79A7")
    ggplot(d, aes(x = size)) +
        geom_histogram(binwidth = binwidth, colour = "black", fill = "white") + 
        facet_grid(method ~ .) +
        scale_colour_manual(values = cbbPalette) + 
        scale_x_continuous(labels = comma) +
        ylab("observations (out of 10,000 subsamplings)") +
            xlab("frequency of the top amplicon") +
        geom_vline(data = means, aes(xintercept = mean, colour = method), size = 1) +
        geom_vline(data = targets, aes(xintercept = target_values),
                   linetype = "dashed", size = 1, colour = "#56B4E9") +
        ggtitle(paste("Subsampling TARA V9 (9.5 M) to ", run$percentage, "%", sep ="")) +
        theme(legend.position="none")
    
    ## Output to PDF
    output <- gsub(".log", "_head.pdf", input, fixed = TRUE)
    ggsave(file = output, width = 8 , height = 5)
}

for (run in runs) {
    subsampling_plots(run)
    warnings()
}

quit(save = "no")
