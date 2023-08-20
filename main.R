#
# Preparation at start-up of project
#
# Author: Christian "Doofnase" Schuler
# Date: 2023 June
################################################################################

# Set initial working directories
dir_init <- getwd()
dir_src <- paste0(dir_init, "/src/", sep="")
dir_raw <- paste0(dir_init, "/data/raw/", sep="")
# Downloading uses "dir_raw" since the gadm-package automatically add a directory called "gadm"
# For reading and later use, this path: dir_raw_gadm
dir_raw_gadm <- paste0(dir_init, "/data/raw/gadm/", sep="")
dir_raw_osm <- paste0(dir_init, "/data/raw/osm/", sep="")
dir_raw_manual <- paste0(dir_init, "/data/raw/manual/", sep="")
dir_raw_aggregated <- paste0(dir_init, "/data/raw/aggregated/", sep="")
dir_out <- paste0(dir_init, "/output/", sep="")

setwd(dir_init)
print(paste0("Working directory: ", dir_init))
print(paste0("Source directory: ", dir_src))
print(paste0("Data (raw) directory: ", dir_raw))
print(paste0("Output directory: ", dir_out))

# Initial Setup (Comment line after first execution)
## Installation of required packages via installPackages.R
# TODO: Automatic package installation still iffy... → geodata had to be installed via RStudio prompting...
#source(paste0(dir_src, "utility/installPackages.R", sep=""))

# Utility (Load Functions from Scripts)
#######################################
## Functions to download geodata from various sources
source(paste0(dir_src, "utility/getGeoData.R", sep=""))

## Function to plot geodata with non-overlapping labels
source(paste0(dir_src, "utility/plotNonOverlappingLabels.R", sep=""))

## Functions to plot geodata
source(paste0(dir_src, "utility/plotGeoData.R", sep=""))

## Functions to (pre)process the data
source(paste0(dir_src, "utility/processData.R", sep=""))

# Execution (Load Functions from Scripts)
#########################################
## Collection of data for Kobani
source(paste0(dir_src, "execution/collectDataKobani.R", sep=""))
# → gadm_syria_0, gadm_syria_1, gadm_syria_2
# → osm_syria
# → kobani_dialect_metainfo

## TODO:
## Analysis of data for Kobani
source(paste0(dir_src, "execution/analyseDataKobani.R", sep=""))

## TODO:
## Plot the results for Kobani
#source(paste0(dir_src, "execution/plotDataKobani.R", sep=""))

## TODO: turn into Functions, to plot Kobani specifically and be called by "analyseDataKobani.R" and "plotResultsKobani.R"
source(paste0(dir_src, "plotKobani.R", sep=""))

## TODO: turn into Functions, to plot demographic information and be called by "analyseDataKobani.R" and "plotResultsKobani.R"
source(paste0(dir_src, "demographicInformation.R", sep=""))



# Plot the GeoData
##################
# Level_0 - Country #TODO: Plotting function is not dynamic enough for this!
#plot_syria_level_0 <- plotGeoData(spat_vector=gadm_syria_1, plot_title="Syria - Administrative Level 0 (Country)", var_1="COUNTRY", var_2="NAME_1")

# Level_1 - Gouvernement
png(paste0(dir_out, "map-syria-administrative-1.png", sep=""), pointsize=10, width=1200, height=1200, res=200)
plot_syria_level_1 <- plotGeoData(spat_vector=gadm_syria_1, plot_title="Syria - Administrative Level 1 (Gouvernement)", var_1="NAME_1", var_2="NAME_1")
dev.off()

# Level_2 - District
png(paste0(dir_out, "map-syria-administrative-2.png", sep=""), pointsize=10, width=1200, height=1200, res=200)
plot_syria_level_2 <- plotGeoData(spat_vector=gadm_syria_2, plot_title="Syria - Administrative Level 2 (District)", var_1="NAME_1", var_2="NAME_2")
dev.off()

# Level_2 - Focus on Kobani
png(paste0(dir_out, "map-syria-administrative-2-kobani.png", sep=""), pointsize=10, width=1200, height=1200, res=200)
plot_syria_kobani <- plotGeoDataKobani(spat_vector=gadm_syria_2, plot_title="Syria - Kobani ('Ayn al-'Arab)", var_1="NAME_1", var_2="NAME_2", var_3="'Ayn al-'Arab")
dev.off()

#png(paste0(dir_out, "map-syria-administrative-1.png", sep=""), pointsize=10, width=1200, height=1200, res=200)
#plot_syria_level_1
#dev.off()

#png(paste0(dir_out, "map-syria-administrative-2.png", sep=""), pointsize=10, width=1200, height=1200, res=200)
#plot_syria_level_2
#dev.off()

#png(paste0(dir_out, "map-syria-kobani.png", sep=""), pointsize=10, width=1200, height=1200, res=200)
#plot_syria_kobani
#dev.off()




# Transformations and Subsetting prior to plotting
##################################################
# Kobani Study Data
###################
# Happens in plotKobani.R
#kobani_dialect_metainfo = kobani_dialect_metainfo[!duplicated(kobani_dialect_metainfo$Name),]

# Kobani subset
###############
gadm_kobani_2 <- subset(gadm_syria_2, gadm_syria_2$NAME_2 == "'Ayn al-'Arab", c("COUNTRY", "NAME_1", "NAME_2", "TYPE_2", "ENGTYPE_2"))

# Joining points and polygons to keep intersecting elements
###########################################################
# Keep the polygons (district)
gadm_kobani_2_sf <- st_as_sf(gadm_kobani_2)
kobani_cities <- gadm_kobani_2_sf %>%
  sf::st_join(osm_syria)

# Merge the original osm-data (point of cities) with the new data (only cities inside kobani)
# https://stackoverflow.com/questions/49032217/inner-joining-two-sf-objects-by-non-sf-column
kobani_cities_points <- merge(x = kobani_cities %>% as.data.frame(), y = osm_syria %>% as.data.frame(), by = "name")
kobani_cities_points <- kobani_cities_points %>% st_sf(sf_column_name = 'geom')

# Drop unnecessary variables
############################
kobani_cities_points$geometry <- NULL
kobani_cities_points$other_tags.y <- NULL
kobani_cities_points$place.y <- NULL
kobani_cities_points <- kobani_cities_points %>% 
  rename("place" = "place.x", "other_tags" = "other_tags.x")

png(paste0(dir_out, "map-syria-administrative-2-kobani-unknown.png", sep=""), pointsize=10, width=1200, height=1200, res=200)
plot_syria_kobani_2 <- plotGeoData(gadm_kobani_2, "Kobani - Cities", "NAME_1", "NAME_2")
plot(st_geometry(st_centroid(kobani_cities_points)), pch = 21, col = "red", add = TRUE)
dev.off()


# Saving names for places to file for Raman to sort out what is where-
## kobani_cities
kobani_cities_names_to_file <- kobani_cities %>% st_drop_geometry()
write.csv(kobani_cities_names_to_file, file=paste0(dir_raw_aggregated, "Names_kobani_cities.csv", sep=""))

## kobani_cities_points
kobani_cities_points_names_to_file <- kobani_cities_points %>% st_drop_geometry()
write.csv(kobani_cities_points_names_to_file, file=paste0(dir_raw_aggregated, "Names_kobani_cities_points.csv", sep=""))

## osm_syria
osm_syria_names_to_file <- osm_syria # %>% st_drop_geometry()
write.csv(osm_syria_names_to_file, file=paste0(dir_raw_aggregated, "Names_osm_syria.csv", sep=""))




