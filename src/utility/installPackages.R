# Script to install required packages
#
# Author: Christian "Doofnase" Schuler
# Date: 2023 May
################################################################################

# Prerequisites ################################################################
#print("Installing packages:")
# GeoData and Spatial Data Analysis with R https://edzer.github.io/hertie-school/
install.packages("gapminder")
install.packages("gstat")
install.packages("maps")
install.packages("mapview")
install.packages("rnaturalearth")
install.packages("sf")
install.packages("spatstat")
install.packages("stars")
install.packages("stringr")
install.packages("tidyverse")
install.packages("units")
install.packages("spdep")
install.packages("plm")
install.packages("splm")
install.packages("geodata")
install.packages("DescTools")
install.packages("terra")


#install.packages(c("gapminder", "gstat", "maps", "mapview",
#                   "rnaturalearth", "sf", "spatstat", "stars", 
#                   "stringr", "tidyverse", "units", "spdep", 
#                   "plm", "splm"))

# ----


#install.packages("tidyverse", dependencies = TRUE, repos = "https://cran.rstudio.com")
#install.packages("vroom", dependencies = TRUE, repos = "https://cran.rstudio.com")
#install.packages("dplyr")
#install.packages("ggplot2")
#install.packages("sp") # Solving: Error in as.double(x) : cannot coerce type 'S4' to vector of type 'double'
#library(sp)

#print("Loading packages:")
#library(tidyverse) # Many useful functions
#library(vroom)     # Fast data loading
#library(dplyr)    # Many useful functions
#library(ggplot2) # Fancy plotting-functions
#library(ggpubr)
#library(rstatix)
#library(gridExtra) # Printing dataframe to pdf
#library(data.table)

# Database functions
#library(DBI)

# File formats
#install.packages("XML")
#library(XML)
#install.packages("rjson")
#library(jsonlite)
#library(rjson)
#library(fs)

# Exploration https://www.r-bloggers.com/2018/11/explore-your-dataset-in-r/
#library(DataExplorer) # Amazing data exploration
#library(rmarkdown)    # To work with html_document
#library(prettydoc)    # For fancy html-themes

# Survey https://towardsdatascience.com/5-ways-to-effectively-visualize-survey-data-using-r-89928bf08cb2
#library(likert)
#library(plyr)
#library(corrplot)
#library(ggcorrplot)
#library(naniar)
#library(reshape2)
#library(ggalluvial)


# Geodata https://github.com/rspatial/geodata
#install.packages("geodata", dependencies = TRUE, repos = "https://cran.rstudio.com")
#library(geodata)
#library(terra)
#library(raster)
#library(sp)

# Statistical Analysis
#library(psych) # Using describeBy()

# Visualisations
# install.packages("png") # https://statisticsglobe.com/add-image-to-plot-in-r
#library("png")         # Add Image to Plot
#install.packages("patchwork") # https://stackoverflow.com/questions/1249548/side-by-side-plots-with-ggplot2
#library("patchwork")   # Patching plots together

# Formatting axis-labels:
# https://ggplot2.tidyverse.org/articles/faq-axes.html
#library(scales)

# To check for conflicting functions from different packages:
#library(conflicted)
#rename






