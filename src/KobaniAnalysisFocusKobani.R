
library(geodata)
library(tidyverse)
library(sf)
library(mapview)
library(RColorBrewer)
library(terra)

###########
# geodata #
###########
# Collect Data
##############
# gadm - https://gadm.org/index.html
# Download Country/Region Data
##############################
#gadm_syria_0 <- gadm(country="Syria", level=0, dir_data, version="latest", resolution=1)
#gadm_syria_1 <- gadm(country="Syria", level=1, dir_data, version="latest", resolution=1)
#gadm_syria_2 <- gadm(country="Syria", level=2, dir_data, version="latest", resolution=1)
# Download Population Data
##########################
osm_syria <- osm(country="Syria", "places", path=dir_data)
# Read Country/Region Data from local file (once downloaded)
############################################################
#gadm_syria_0 <- readRDS(paste0(dir_data,"/gadm/gadm41_SYR_0_pk.rds", sep=""))
#gadm_syria_1 <- readRDS(paste0(dir_data,"/gadm/gadm41_SYR_1_pk.rds", sep=""))
gadm_syria_2 <- readRDS(paste0(dir_data,"/gadm/gadm41_SYR_2_pk.rds", sep=""))

osm_syria <- st_read(paste0(dir_data,"/SYR_places.gpkg", sep=""))

# District - Level_2 = ['Ayn al-'Arab, A'zaz, Afrin, Al Bab, As-Safirah, Jabal Sam'an, Jarabulus, Manbij]
# District - Level_2 = 'Ayn al-'Arab
####################################
gadm_kobani_2 <- subset(gadm_syria_2, gadm_syria_2$NAME_2 == "'Ayn al-'Arab", c("COUNTRY", "NAME_1", "NAME_2", "TYPE_2", "ENGTYPE_2"))

# Joining points and polygons to keep intersecting elements
###########################################################
# Keep the polygons (district)
gadm_kobani_2_sf <- st_as_sf(gadm_kobani_2)
kobani_cities <- gadm_kobani_2_sf %>%
  sf::st_join(osm_syria)

# Merge the original osm-data (point of cities) with the new data (only cities inside kobani)
# https://stackoverflow.com/questions/49032217/inner-joining-two-sf-objects-by-non-sf-column
# Debugging
#str(kobani_cities)
#str(osm_syria)
kobani_cities_points <- merge(x = kobani_cities %>% as.data.frame(), y = osm_syria %>% as.data.frame(), by = "name")
kobani_cities_points <- kobani_cities_points %>% st_sf(sf_column_name = 'geom')

# Drop unnecessary variables
############################
kobani_cities_points$geometry <- NULL
kobani_cities_points$other_tags.y <- NULL
kobani_cities_points$place.y <- NULL
kobani_cities_points <- kobani_cities_points %>% 
  rename("place" = "place.x", "other_tags" = "other_tags.x")

# Plot Data collected via geodata-Package
plot_spat_vector <- function(spat_vector, plot_title, variable_01, variable_02){
  current_region <- aggregate(spat_vector, variable_01)
  plot(spat_vector, col="light blue", lty=2, border="red", lwd=2)
  title(main=plot_title)
  lines(current_region, lwd=5)
  lines(current_region, col="white", lwd=1)
  text(spat_vector, variable_02, cex=.5, halo=TRUE)
  return(current_region)
}

png(paste0(dir_out, "map-syria-kobani-ramans-study-all-villages.png", sep=""), pointsize=10, width=1200, height=1600, res=200)
#kobani_2_plot <- plot_spat_vector(gadm_kobani_2, "Kobani - Cities", "NAME_1", "NAME_2")
current_region <- aggregate(gadm_kobani_2, "NAME_1")
kobani_2_villages_plot <- plot(gadm_kobani_2, col="light blue", lty=2, border="red", lwd=2)
title(main="Kobani - Cities")
lines(current_region, lwd=5)
lines(current_region, col="white", lwd=1)
plot(st_geometry(st_centroid(kobani_cities_points)), pch = 21, col = "red", add = TRUE)
text(gadm_kobani_2, "NAME_2", cex=1.0, halo=TRUE)
dev.off()


# I just wanted a nice overview... Is that too much to ask for? Gotta go back to the csv-file I guess :(
# PlaceOfLiving | PlaceOfLiving_Kur | PlaceOfLiving_Ara | 
################################################################################
# Mazre         | Mezra             | قرة مزرعة |  |  |  | = # مزرعة صوفي vs. قرة مزرعة  # ??
# Chixor        | Çixor             |  |  |  |  |  = # جقور 
# Laheene       | Lihênê            |  |  |  |  |  = # لحينة                       # Lahinah ?
# Tashluk       | Taşloga jêrîn     |  |  |  |  |  = # طاشلي هيوك التحتاني       # Tashli Huyuk at Tahtani ?      
# Kharabeesan   | Xerabîsan         |  |  |  |  |  = #	خرابة                       # Kharabah ?
# Bir-rash      | Bîr-reş           |  |  |  |  | 
# ??            | Xerabî Zer        |  |  |  |  | 
# ??            | Boraz Oxlî        |  |  |  |  | 
# ??            | Zerik             |  |  |  |  | 
# ??            | Derbazin          |  |  |  |  | 
# ??            | Siftek            |  |  |  |  | 
# ??            | Çariqlê           |  |  |  |  | 
# ??            | Termik            |  |  |  |  | 
# ??            | Memit             |  |  |  |  | 
# ??            | Helinc            |  |  |  |  | 
# ??            | Eyn-Bet           |  |  |  |  | 

# Load Ramans data of study participants
kobani_dialect_metainfo = read.csv(paste0(dir_data, "/KobaniAnalysisMetaInformationCompleted.csv", sep=""), sep=",")
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

# Approach prior to the (above) shift to merging
# Add columns to the dataframe for multiple languages of city-names
#kobani_cities_points_audio_ara <- kobani_cities_points_audio_ara$PlaceOfLiving_Kur <- kobani_cities_audio_kur

##############################################################################################
# TODO: Concept of "data.frame" vs. "spatVector" and how to transform/process them correctly #
##############################################################################################
# As (spat)Vector for use in plot-function
# https://rdrr.io/cran/terra/man/as.data.frame.html#
#kobani_cities_points_audio_ara_vector <- vect(kobani_cities_points_audio_ara)
# => Error: [vect] the variable name(s) in argument `geom` are not in `x`
# First cast the geometry elements:
# https://www.rdocumentation.org/packages/sf/versions/1.0-12/topics/st_cast
#
# kobani_cities_points_audio_ara <- st_cast(kobani_cities_points_audio_ara$geom, "MULTIPOINT")
# 
# Then the transformation into a vector works:
# 
# kobani_cities_points_audio_ara_vector <- vect(kobani_cities_points_audio_ara)
#
# Alternative approach from way earlier (above in the plot of "Kobani - Cities")
kobani_cities_points_audio_ara <- kobani_cities_points_audio_ara %>% st_sf(sf_column_name = 'geom')

# Debugging:
#kobani_cities_points_audio_ara_vector_sf <- st_as_sf(kobani_cities_points_audio_ara_vector)
#kobani_cities_points_audio_ara_vector_df <- as.data.frame(kobani_cities_points_audio_ara_vector)

# At some point got the error
# Error: (list) object cannot be coerced to type 'double'
# https://www.statology.org/r-list-object-cannot-be-coerced-to-type-double/

# Extract x and y coordinates from the (city) points from the geometry variable
# https://gis.stackexchange.com/questions/393116/r-sf-transform-a-geometry-column-made-of-points-and-multipoints-into-xy-coordi
# Seems to also work with the "not-vector" version at this point- but breaks down when trying to plot :/
kobani_cities_points_audio_ara_vector_xy <- data.frame(st_coordinates(kobani_cities_points_audio_ara$geom))
#kobani_cities_points_audio_ara_vector_xy <- data.frame(st_coordinates(kobani_cities_points_audio_ara_vector$geom))
kobani_cities_x <- kobani_cities_points_audio_ara_vector_xy$X
kobani_cities_y <- kobani_cities_points_audio_ara_vector_xy$Y

################################################################################
# Plot Text (labels) in Plot:
# https://stat.ethz.ch/R-manual/R-devel/library/graphics/html/text.html
#
# Add non-overlapping text labels to plot
# https://rdrr.io/github/JosephCrispell/basicPlotteR/man/addTextLabels.html
################################################################################
# addTextLabels(
#   xCoords,
#   yCoords,
#   labels,
#   cex.label = 1,
#   col.label = "red",
#   col.line = "black",
#   col.background = NULL,
#   lty = 1,
#   lwd = 1,
#   border = NA,
#   avoidPoints = TRUE,
#   keepLabelsInside = TRUE,
#   cex.pt = 1
# )



# Plot of Study-Participants-Place-of-Living (Arabic) Village-Names
###################################################################
current_region <- aggregate(gadm_kobani_2, "NAME_1")
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






