# Setup
#######

## Installation of required packages
source(paste0(dir_src, "setup/installPackages.R", sep=""))

library(geodata) # For downloadGadm
library(terra) # For downloadOsmData
library(geodata)
library(tidyverse)
library(sf)
library(ggplot2)
library(ggalluvial)
library(stringr)
library(dplyr)
library(tidyr)
library(DescTools)
# From old "plotGeoData.R" → still needed? ################
#library(tidyverse)
#library(sf)
#library(mapview)
#library(RColorBrewer)
#library(ggplot2)
#library(terra)
# From old "plotKobani.R" ##########################
#library(geodata)
#library(tidyverse)
#library(sf)
library(mapview)
library(RColorBrewer)
#library(terra)
# From "demographic.R" #############
#library(geodata)
#library(tidyverse)
#library(sf)
#library(ggplot2)
#library(ggalluvial)
#library(stringr)
#library(dplyr)
#library(tidyr)
#library(DescTools)

## Download of geolocation data
source(paste0(dir_src, "setup/downloadData.R", sep=""))
# → functions: downloadOsmData, downloadGadm

# Data download via geodata::gadm
#################################
gadm_syria_0 <- downloadGadm(country="Syria", level=0, path=dir_raw, version="latest", resolution=1)
# → file: gadm41_SYR_0_pk.rds
gadm_syria_1 <- downloadGadm(country="Syria", level=1, path=dir_raw, version="latest", resolution=1)
# → file: gadm41_SYR_1_pk.rds
gadm_syria_2 <- downloadGadm(country="Syria", level=2, path=dir_raw, version="latest", resolution=1)
# → file: gadm41_SYR_2_pk.rds

# Data download via geodata::osm
################################
osm_syria <- downloadOsmData(country="Syria", var="places", path=dir_raw_osm)
# → file: SYR_places.gpkg
