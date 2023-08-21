# Process Data
##############
# Process the geolocation data of the study participants
source(paste0(dir_src, "processData/geoData.R", sep=""))


# Process the collected study data
source(paste0(dir_src, "processData/studyData.R", sep=""))

# Ramans Study
##############
## Load Ramans data of study participants from file: KobaniAnalysisMetaInformation.csv
kobani_dialect_metainfo = read.csv(paste0(dir_raw_manual, "/KobaniAnalysisMetaInformation.csv", sep=""), sep=",")

# TODO: Anonymize data of study participants

# TODO: Where does this data come from?
# File: osm-2020-02-10-v3.11_asia_syria.mbtiles

# Semi-manual approach to identify location names
source(paste0(dir_src, "processData/locationNames.R", sep=""))
# → csv-files: Names_kobani_cities.csv, Names_kobani_cities_points.csv, Names_osm_syria.csv
