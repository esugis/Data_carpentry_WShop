# plotting package
library(ggplot2)
# piping / chaining
library(magrittr)
# modern dataframe manipulations
library(dplyr)

surveys_raw <- read.csv("http://files.figshare.com/1919744/surveys.csv")

surveys_complete <- surveys_raw %>%
  filter(species_id != "") %>%        # remove missing species_id
  filter(!is.na(weight)) %>%          # remove missing weight
  filter(!is.na(hindfoot_length))     # remove missing hindfoot_length

# count records per species
species_counts <- surveys_complete %>%
  group_by(species_id) %>%
  tally

head(species_counts)

# get names of those frequent species
frequent_species <- species_counts %>%
  filter(n >= 10) %>%
  select(species_id)

surveys_complete <- surveys_complete %>%
  filter(species_id %in% frequent_species$species_id)

########### I added extra options to the following part of the existing tutorial#######
########### Plotting with ggplot2###############
yearly_counts <- surveys_complete %>%
  group_by(year, species_id) %>%
  tally

#Faceting
#ggplot has a special technique called faceting that allows to split one plot into multiple plots based on some factor. We will use it to plot one time series for each species separately.

#Change plot background to white. Useful for the publications.

ggplot(data = yearly_counts, aes(x = year, y = n, color = species_id)) +
  geom_line() + facet_wrap(~species_id) +
  theme_bw()

#Add title to the plot
ggplot(data = yearly_counts, aes(x = year, y = n, color = species_id)) +
  geom_line() + facet_wrap(~species_id) +
  theme_bw() +
  ggtitle("Yearly counts")

#Change font size/color of the axis 
ggplot(data = yearly_counts, aes(x = year, y = n, color = species_id)) +
  geom_line() + facet_wrap(~species_id) +
  theme_bw() +
  ggtitle("Yearly counts") +
  theme(axis.text.x = element_text(colour="grey20",size=15,angle=90,hjust=.5,vjust=.5,face="plain"),
      axis.text.y = element_text(colour="grey20",size=12,angle=0,hjust=1,vjust=0,face="plain"),  
      axis.title.x = element_text(colour="grey20",size=20,angle=0,hjust=.5,vjust=0,face="plain"),
      axis.title.y = element_text(colour="grey20",size=20,angle=90,hjust=.5,vjust=.5,face="plain"))

#save plot to file
ggsave("yearly_counts.png", width=15, height=10)