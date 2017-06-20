# ------------------------------------------------------------------------------
# Create heatmap of governance indicator reproducibility survey
# Christopher Gandrud
# MIT License
# ------------------------------------------------------------------------------

# Set working directory. Change as needed
setwd('/git_repositories/governance_indicators_reproducibility_survey')

# Load required packages
library(rio)
library(dplyr)
library(tidyr)
library(ggplot2)

# Load data (originally entered into a Google sheet)
results <- import('indicators_survey - Sheet1.csv') %>%
                arrange(indicator_name)

# Record order of indicators
i_names <- unique(results$indicator_name)

# Variables to keep for the heatmap
keepers <- results[, c(1, 9:ncol(results))]
notes <- names(keepers)[grepl(pattern = '_note$', x = names(keepers))]
no_notes <- names(keepers)[!(names(keepers) %in% notes)]
keepers <- keepers[, no_notes]

# Clean up survey quantiy labels
clean_labels <- function(x) {
    x <- gsub("(^|[[:space:]])([[:alpha:]])", "\\1\\U\\2", x, perl = TRUE)
    x <- gsub('_', ' ', x)
    return(x)
}

no_notes <- clean_labels(no_notes)

# Reshape data to make it compatible with plotting function
keepers_gathered <- gather(keepers, variable, value, 2:ncol(keepers))
keepers_gathered$variable <- clean_labels(keepers_gathered$variable)

# Convert survey result to factor
keepers_gathered$value[keepers_gathered$value == ''] <- 'N/A'
keepers_gathered$value <- factor(keepers_gathered$value,
                                 levels = c('yes', 'no', 'N/A'))
keepers_gathered$variable <- factor(keepers_gathered$variable,
                                    levels = no_notes[-1])
keepers_gathered$indicator_name <- factor(keepers_gathered$indicator_name,
                                    levels = i_names)

# Plot heatmap
ggplot(keepers_gathered, aes(variable, indicator_name)) +
    geom_tile(aes(fill = value), colour = 'white') +
    scale_x_discrete(position = 'top') +
    scale_y_discrete(limits = rev(levels(keepers_gathered$indicator_name))) +
    scale_fill_manual(values = c('#636363', '#bdbdbd', 'white'),
                      name = "Present?") +
    xlab('') + ylab('') +
    theme(
       # legend.position = 'none',
        panel.grid.major.x = element_blank(),
        panel.grid.major.y = element_blank(),
        axis.ticks = element_blank(),
        panel.border = element_blank(),
        axis.text.x = element_text(angle = 315, vjust = 0, hjust = 1)
        )

# Saved as a PNG image in RStudio with dimensions 800 x 600
ggsave(filename = 'figures/figure_2.eps', width = 15, height = 10)
