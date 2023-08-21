# Script to collect required data
#
# Author: Christian "Doofnase" Schuler
# Date: 2023 Jul
################################################################################

# TODO: Load data from "data/processed/" instead and do all processing in "processData/geoData.R"
# Instead of doing the processing all over

# IF moved to "collectDataKobani.R", Error in st_join.sf(., osm_syria): second argument shouls be of class sf: maybe revert the first two arguments?
#osm_syria <- osm(country="Syria", "places", path=dir_raw)
osm_syria <- st_read(paste0(dir_raw_osm,"SYR_places.gpkg", sep=""))

gadm_syria_2 <- readRDS(paste0(dir_raw_gadm,"gadm41_SYR_2_pk.rds", sep=""))


