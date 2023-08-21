

# TODO from "runAnalysis/loadData.R" related to this script:
# TODO: Load data from "data/processed/" instead and do all processing in "processData/geoData.R"
# Instead of doing the processing all over

# Temporary fix for "locationNames.R" to run
# → osm_syria
osm_syria <- st_read(paste0(dir_raw_osm,"SYR_places.gpkg", sep=""))
# Kobani subset
# Currently directly taken from download- later processing step inbetween to load if locally available
## From downloadData.R we get: gadm_syria_2 <- downloadGadm(country="Syria", level=2, path=dir_raw, version="latest", resolution=1)
# → File: gadm41_SYR_2_pk.rds
# → kobani_cities
gadm_kobani_2 <- subset(gadm_syria_2, gadm_syria_2$NAME_2 == "'Ayn al-'Arab", c("COUNTRY", "NAME_1", "NAME_2", "TYPE_2", "ENGTYPE_2"))
# Joining points and polygons to keep intersecting elements
# Keep the polygons (district)
gadm_kobani_2_sf <- st_as_sf(gadm_kobani_2)
kobani_cities <- gadm_kobani_2_sf %>%
  sf::st_join(osm_syria)
# → kobani_cities_points
kobani_cities_points <- merge(x = kobani_cities %>% as.data.frame(), y = osm_syria %>% as.data.frame(), by = "name")
kobani_cities_points <- kobani_cities_points %>% st_sf(sf_column_name = 'geom')
# Drop unnecessary variables
kobani_cities_points$geometry <- NULL
kobani_cities_points$other_tags.y <- NULL
kobani_cities_points$place.y <- NULL
kobani_cities_points <- kobani_cities_points %>% 
  rename("place" = "place.x", "other_tags" = "other_tags.x")