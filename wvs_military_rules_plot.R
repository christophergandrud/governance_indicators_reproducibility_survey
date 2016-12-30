# ------------------------------------------------------------------------------
# Create World Values Survey military rule plot
# Christopher Gandrud
# MIT License
# ------------------------------------------------------------------------------

# Load required packages
library(ggplot2)
library(wesanderson)
theme_set(theme_bw())

# Enter data from Kurzman 2014 
# (https://www.washingtonpost.com/news/monkey-cage/wp/2014/09/02/world-values-lost-in-translation/)
# as a data frame

main <- data.frame(
    country = c('Vietnam', 'Vietnam', 
                'Indonesia', 'Indonesia',
                'Iran', 'Iran',
                'Albania', 'Albania'),
    year = rep(c('1999-2004', '2006-2009'), 4),
    support = c(99, 33,
                96, 95,
                83, 33,
                83, 13)
)

# Plot ------
# Create colour palette
pal <- wes_palette("Cavalcanti")[c(1:2, 4:5)]

# Produce plot
ggplot(main, aes(as.factor(year), support, group = country, colour = country)) +
    geom_line() +
    scale_colour_manual(values = pal, name = '') +
    scale_y_continuous(limits = c(0, 100)) +
    xlab('\nWVS Survey Wave') + 
    ylab('Affirmative Response to Military Question\n(% of respondents)\n')
