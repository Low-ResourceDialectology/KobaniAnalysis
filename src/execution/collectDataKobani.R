# Script to collect required data
#
# Author: Christian "Doofnase" Schuler
# Date: 2023 Jul
################################################################################

# Data download via geodata::gadm
#################################
gadm_syria_0 <- downloadGadm(country="Syria", level=0, path=dir_raw, version="latest", resolution=1)
# File: gadm41_SYR_0_pk.rds
gadm_syria_1 <- downloadGadm(country="Syria", level=1, path=dir_raw, version="latest", resolution=1)
# File: gadm41_SYR_1_pk.rds
gadm_syria_2 <- downloadGadm(country="Syria", level=2, path=dir_raw, version="latest", resolution=1)
# File: gadm41_SYR_2_pk.rds

# Data download via geodata::osm
################################
osm_syria <- downloadOsmData(country="Syria", var="places", path=dir_raw_osm)
# File: SYR_places.gpkg

# Ramans Study
##############
# Load Ramans data of study participants from file: KobaniAnalysisMetaInformation.csv
kobani_dialect_metainfo = read.csv(paste0(dir_raw_manual, "/KobaniAnalysisMetaInformation.csv", sep=""), sep=",")


# TODO: Where does this data come from?
# File: osm-2020-02-10-v3.11_asia_syria.mbtiles