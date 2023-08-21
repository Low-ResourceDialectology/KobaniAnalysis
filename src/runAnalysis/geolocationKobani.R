
library(geodata)
library(tidyverse)
library(sf)
library(mapview)
library(RColorBrewer)
library(terra)

# IF moved to "collectDataKobani.R", Error in st_join.sf(., osm_syria): second argument shouls be of class sf: maybe revert the first two arguments?
#osm_syria <- osm(country="Syria", "places", path=dir_raw)
osm_syria <- st_read(paste0(dir_raw_osm,"SYR_places.gpkg", sep=""))

gadm_syria_2 <- readRDS(paste0(dir_raw_gadm,"gadm41_SYR_2_pk.rds", sep=""))

gadm_kobani_2 <- subset(gadm_syria_2, gadm_syria_2$NAME_2 == "'Ayn al-'Arab", c("COUNTRY", "NAME_1", "NAME_2", "TYPE_2", "ENGTYPE_2"))

gadm_kobani_2_sf <- st_as_sf(gadm_kobani_2)
kobani_cities <- gadm_kobani_2_sf %>%
  sf::st_join(osm_syria)


kobani_cities_points <- merge(x = kobani_cities %>% as.data.frame(), y = osm_syria %>% as.data.frame(), by = "name")
kobani_cities_points <- kobani_cities_points %>% st_sf(sf_column_name = 'geom')

# Drop unnecessary variables
############################
kobani_cities_points$geometry <- NULL
kobani_cities_points$other_tags.y <- NULL
kobani_cities_points$place.y <- NULL
kobani_cities_points <- kobani_cities_points %>% 
  rename("place" = "place.x", "other_tags" = "other_tags.x")


# Load Ramans data of study participants
# Moved to "collectDataKobani.R"
#kobani_dialect_metainfo = read.csv(paste0(dir_raw, "/KobaniAnalysisMetaInformationCompleted.csv", sep=""), sep=",")
# Remove duplicates based on "Name"
kobani_dialect_metainfo = kobani_dialect_metainfo[!duplicated(kobani_dialect_metainfo$Name),]

# Lists of City-Names for labeling the plots
kobani_cities_audio_ara <- kobani_dialect_metainfo$PlaceOfLiving_Ara_R
kobani_cities_audio_kur <- kobani_dialect_metainfo$PlaceOfLiving_Kur

# Only keep the cities that are in the provided list
####################################################
# Prio approach that works for single language:
#kobani_cities_points_audio_ara_missing <- kobani_cities_points[kobani_cities_points$name %in% kobani_cities_audio_ara, ]
#
# New approach via merge to also include the city-names from other languages
# Keep all information from "kobani_dialect_metainfo" 
kobani_cities_points_audio_ara_with_duplicates <- merge(x = kobani_dialect_metainfo, y = kobani_cities_points, by.x = "PlaceOfLiving_Ara_R", by.y = "name", all.x = TRUE)

# Remove duplicates to prevent plot from being overloaded
kobani_cities_points_audio_ara_missing = kobani_cities_points_audio_ara_with_duplicates[!duplicated(kobani_cities_points_audio_ara_with_duplicates$PlaceOfLiving_Ara_R),]

# HOTFIX: Dropping the rows of cities without geometry points for coordinate extraction:
# Cities: Xerabîsan, Siftek, Lihênê
# Delete rows by PlaceOfLiving_Kur 
# https://sparkbyexamples.com/r-programming/drop-dataframe-rows-in-r/
#kobani_cities_points_audio_ara_missing <- kobani_cities_points_audio_ara_missing[!(row.PlaceOfLiving_Kur(kobani_cities_points_audio_ara_missing) %in% c("Xerabîsan", "Siftek", "Lihênê")),]
kobani_cities_points_audio_ara <- kobani_cities_points_audio_ara_missing[!(row.names(kobani_cities_points_audio_ara_missing) %in% c("1", "7", "10", "29", "45")),]

# Alternative approach from way earlier (above in the plot of "Kobani - Cities")
kobani_cities_points_audio_ara <- kobani_cities_points_audio_ara %>% st_sf(sf_column_name = 'geom')

# Extract x and y coordinates from the (city) points from the geometry variable
# https://gis.stackexchange.com/questions/393116/r-sf-transform-a-geometry-column-made-of-points-and-multipoints-into-xy-coordi
# Seems to also work with the "not-vector" version at this point- but breaks down when trying to plot :/
kobani_cities_points_audio_ara_vector_xy <- data.frame(st_coordinates(kobani_cities_points_audio_ara$geom))
#kobani_cities_points_audio_ara_vector_xy <- data.frame(st_coordinates(kobani_cities_points_audio_ara_vector$geom))
kobani_cities_x <- kobani_cities_points_audio_ara_vector_xy$X
kobani_cities_y <- kobani_cities_points_audio_ara_vector_xy$Y

# Plot of Study-Participants-Place-of-Living (Arabic) Village-Names
###################################################################
current_region <- aggregate(gadm_kobani_2, "NAME_1")
# Save plot as figure
png(paste0(dir_out, "map-syria-kobani-ramans-study-ara.png", sep=""), pointsize=10, width=1200, height=1600, res=200)
kobani_2_audio_ara_plot <- plot(gadm_kobani_2, col="light blue", lty=2, border="red", lwd=2)
title("Kobani - Cities where Data was collected")
lines(current_region, lwd=5)
lines(current_region, col="white", lwd=1)
text(gadm_kobani_2, "NAME_2", cex=1.0, halo=TRUE)
plot(st_geometry(st_centroid(kobani_cities_points_audio_ara)), pch = 23, cex = 2, alpha = 0.5, col = "red", bg = "blue", lwd = 2, add = TRUE)
# When using: st_geometry(st_centroid(kobani_cities_points_audio_ara)
# Error in h(simpleError(msg, call)) : 
#   error in evaluating the argument 'x' in selecting a method for function 'plot': no applicable method for 'st_centroid' applied to an object of class "data.frame"
#text(kobani_cities_points_audio_ara_vector, "PlaceOfLiving_Ara_R", adj = c(0.5, 1.5), offset = 1, cex=.8, halo=TRUE) # Works, but overlapping labels
addTextLabels(kobani_cities_x, kobani_cities_y, kobani_cities_points_audio_ara$PlaceOfLiving_Ara_R, cex.label=1, col.background=rgb(0,0,0, 0.75), col.label="white")
dev.off()

# Plot of Study-Participants-Place-of-Living (Kurdish) Village-Names
####################################################################

# Use par(mai =  c(bottom, left, top, right)) before the plot. It will create extra space around the plot area.
#par(mar=c(5.1, 4.1, 4.1, 200), xpd=TRUE)

current_region <- aggregate(gadm_kobani_2, "NAME_1")
# Save plot as figure
png(paste0(dir_out, "map-syria-kobani-ramans-study-kur.png", sep=""), pointsize=10, width=1200, height=1600, res=200)
kobani_2_audio_kur_plot <- plot(gadm_kobani_2, col="light blue", lty=2, border="red", lwd=2)
title("Kobani - Cities where Data was collected")
lines(current_region, lwd=5)
lines(current_region, col="white", lwd=1)
text(gadm_kobani_2, "NAME_2", cex=1.0, halo=TRUE)
plot(st_geometry(st_centroid(kobani_cities_points_audio_ara)), pch = 23, cex = 2, alpha = 0.5, col = "red", bg = "blue", lwd = 2, add = TRUE)
addTextLabels(kobani_cities_x, kobani_cities_y, kobani_cities_points_audio_ara$PlaceOfLiving_Kur, cex.label=1, col.background=rgb(0,0,0, 0.75), col.label="white")
# Add legend to top right, outside plot region
# https://stackoverflow.com/questions/3932038/plot-a-legend-outside-of-the-plotting-area-in-base-graphics
# Add extra space to right of plot area; change clipping to figure
list_of_cities_kur <- kobani_cities_points_audio_ara$PlaceOfLiving_Kur
#legend("topright", inset=c(-0.2, 0), legend=list_of_cities_kur, pch=c(1,3), title="Villages")
#legend("topright", inset=c(-0.2, 0), legend=c("Bla", "BLubb"), pch=c(1,3), title="Villages")
dev.off()






