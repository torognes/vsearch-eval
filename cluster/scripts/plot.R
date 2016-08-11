library(methods)
library(ggplot2)
library(reshape)

d <- read.table("clustering.metrics", dec = ".", sep =",")
colnames(d) <- c("program", "order", "shuffling", "id", "metric", "value")

# Compute median values
d4 <- melt(cast(d, metric~id~order~program, median))
colnames(d4) <- c("metric", "id", "order", "program", "value")
#d4$id <- as.character(d4$id)

levels(d4$metric)[1] <- "adjusted Rand index"

# plot recall, precision & adj rand index

d5 <- subset.data.frame(d4, d4$metric != "NMI" & d4$metric != "rand" & d4$metric != "clusters")

levels(d5$order)[1] <- "length sorted (cluster_fast)"
levels(d5$order)[2] <- "abundance sorted (cluster_smallmem)"

d5$metric <- factor(d5$metric,
          levels = c("adjusted Rand index",
                     "recall",
                     "precision"))

d5$order <- factor(d5$order,
         levels = c("abundance sorted (cluster_smallmem)",
                    "length sorted (cluster_fast)"))

# Faceted plot using median values
ggplot(d5, aes(x = id, y = value, col = program )) +
        geom_point(size = 1.5) +
        labs(x = "identity (%)", y = "metric value") +
        facet_grid(metric ~ order, scales = "free_y", space = "fixed") +
        scale_x_continuous(breaks = seq(81, 99, by = 2)) +
#        scale_colour_hue(l=60, c=150, h.start = 270) +
        theme(legend.position = c(0.9, 0.1), legend.title=element_blank())

ggsave(file = "clustering_metrics_medians.pdf", width=10, height=8)

# plot cluster counts

d6 <- subset.data.frame(d4, d4$metric == "clusters")

levels(d6$order)[1] <- "length sorted (cluster_fast)"
levels(d6$order)[2] <- "abundance sorted (cluster_smallmem)"

d6$order <- factor(d6$order,
         levels = c("abundance sorted (cluster_smallmem)",
                    "length sorted (cluster_fast)"))

# Faceted plot using median values
ggplot(d6, aes(x = id, y = value, col = program )) +
        geom_point(size = 1.5) +
        labs(x = "identity (%)", y = "clusters") +
        facet_grid(. ~ order, scales = "free_y", space = "fixed") +
        scale_x_continuous(breaks = seq(81, 99, by = 2)) +
        scale_y_continuous(trans = "log10") +
#        scale_colour_hue(l=60, c=150, h.start = 270) +
        theme(legend.position = c(0.9, 0.1), legend.title=element_blank())

ggsave(file = "clustering_clustercount_medians.pdf", width=10, height=5)

quit(save = "no")
