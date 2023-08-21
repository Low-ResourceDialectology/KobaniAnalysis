
# Saving names for places to file for Raman to sort out what is where-
## kobani_cities
kobani_cities_names_to_file <- kobani_cities %>% st_drop_geometry()
write.csv(kobani_cities_names_to_file, file=paste0(dir_processed, "Names_kobani_cities.csv", sep=""))

## kobani_cities_points
kobani_cities_points_names_to_file <- kobani_cities_points %>% st_drop_geometry()
write.csv(kobani_cities_points_names_to_file, file=paste0(dir_processed, "Names_kobani_cities_points.csv", sep=""))

## osm_syria
osm_syria_names_to_file <- osm_syria # %>% st_drop_geometry()
write.csv(osm_syria_names_to_file, file=paste0(dir_processed, "Names_osm_syria.csv", sep=""))
