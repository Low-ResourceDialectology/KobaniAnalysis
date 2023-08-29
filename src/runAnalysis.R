# Run Analysis
##############
# Helper function to plot many city labels without overlapping
source(paste0(dir_src, "runAnalysis/plotLabels.R", sep=""))

# Load processed data for analysis
source(paste0(dir_src, "runAnalysis/loadData.R", sep=""))
# → data: gadm_syria_0, gadm_syria_1, gadm_syria_2
# → data: osm_syria
# → data: kobani_dialect_metainfo

# TODO: This should eventually happen as part of "processData" and then be packed up for easy analysis + anonymized
## Load Ramans data of study participants from file: KobaniAnalysisMetaInformation.csv
kobani_dialect_metainfo = read.csv(paste0(dir_raw_manual, "/kobaniAnalysisMetaInformation.csv", sep=""), sep=",")
# TODO: Move duplicate-handling to dataProssing + anonymization
# Removal of publicates
# TODO: Fix
# kobani_dialect_metainfo <- removeDuplicates(kobani_dialect_metainfo, "Name")
kobani_dialect_metainfo = kobani_dialect_metainfo[!duplicated(kobani_dialect_metainfo$Name),]


# Demographic information of study participants
source(paste0(dir_src, "runAnalysis/demographic.R", sep=""))


# Geolocation information of the study participants
source(paste0(dir_src, "runAnalysis/geolocation.R", sep=""))
# → functions: plotGeoData, plotGeoDataKobani

# Geolocation information of the target region
source(paste0(dir_src, "runAnalysis/geolocationKobani.R", sep=""))
# → figures

# Searching geolocations corresponding to study locations in R (! TAKES A WHILE !)
#source(paste0(dir_src, "runAnalysis/searchingGeolocations.R", sep=""))
# → figure of all kobani towns with name-labels

# Phonology analysis
source(paste0(dir_src, "runAnalysis/phonology.R", sep=""))


# Morphology analysis
source(paste0(dir_src, "runAnalysis/morphology.R", sep=""))

# TODO: Move into another place
# Plot the GeoData
##################
# Level_0 - Country #TODO: Plotting function is not dynamic enough for this!
#plot_syria_level_0 <- plotGeoData(spat_vector=gadm_syria_1, plot_title="Syria - Administrative Level 0 (Country)", var_1="COUNTRY", var_2="NAME_1")

# Level_1 - Gouvernement
png(paste0(dir_out, "kobaniAnalysis-map-syria-administrative-1.png", sep=""), 
    pointsize=10, width=1200, height=1200, res=200)
plot_syria_level_1 <- plotGeoData(spat_vector=gadm_syria_1, 
                                  plot_title="Syria - Administrative Level 1 (Gouvernement)", 
                                  var_1="NAME_1", 
                                  var_2="NAME_1")
dev.off()

# Level_2 - District
png(paste0(dir_out, "kobaniAnalysis-map-syria-administrative-2.png", sep=""), 
    pointsize=10, width=1200, height=1200, res=200)
plot_syria_level_2 <- plotGeoData(spat_vector=gadm_syria_2, 
                                  plot_title="Syria - Administrative Level 2 (District)", 
                                  var_1="NAME_1", 
                                  var_2="NAME_2")
dev.off()

# Level_2 - Focus on Kobani
png(paste0(dir_out, "kobaniAnalysis-map-syria-administrative-2-kobani.png", sep=""),
    pointsize=10, width=1200, height=1200, res=200)
plot_syria_kobani <- plotGeoDataKobani(spat_vector=gadm_syria_2, 
                                       plot_title="Syria - Kobani ('Ayn al-'Arab)", 
                                       var_1="NAME_1", 
                                       var_2="NAME_2", 
                                       var_3="'Ayn al-'Arab")
dev.off()


# Now part of "searchingGeolocations.R"
#######################################
# # Kobani subset
# ###############
# gadm_kobani_2 <- subset(gadm_syria_2, gadm_syria_2$NAME_2 == "'Ayn al-'Arab", c("COUNTRY", "NAME_1", "NAME_2", "TYPE_2", "ENGTYPE_2"))
# 
# # Joining points and polygons to keep intersecting elements
# ###########################################################
# # Keep the polygons (district)
# gadm_kobani_2_sf <- st_as_sf(gadm_kobani_2)
# kobani_cities <- gadm_kobani_2_sf %>%
#   sf::st_join(osm_syria)
# 
# # Merge the original osm-data (point of cities) with the new data (only cities inside kobani)
# # https://stackoverflow.com/questions/49032217/inner-joining-two-sf-objects-by-non-sf-column
# kobani_cities_points <- merge(x = kobani_cities %>% as.data.frame(), y = osm_syria %>% as.data.frame(), by = "name")
# kobani_cities_points <- kobani_cities_points %>% st_sf(sf_column_name = 'geom')
# 
# # Drop unnecessary variables
# ############################
# kobani_cities_points$geometry <- NULL
# kobani_cities_points$other_tags.y <- NULL
# kobani_cities_points$place.y <- NULL
# kobani_cities_points <- kobani_cities_points %>% 
#   rename("place" = "place.x", "other_tags" = "other_tags.x")
# 
# png(paste0(dir_out, "kobaniAnalysis-map-syria-administrative-2-kobani-locations.png", sep=""), pointsize=10, width=1200, height=1200, res=200)
# plot_syria_kobani_2 <- plotGeoData(gadm_kobani_2, "Kobani - Cities", "NAME_1", "NAME_2")
# plot(st_geometry(st_centroid(kobani_cities_points)), pch = 21, col = "red", add = TRUE)
# dev.off()


