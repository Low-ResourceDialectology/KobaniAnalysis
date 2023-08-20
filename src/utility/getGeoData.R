
#' geodata library from \url{https://github.com/rspatial/geodata}
#' manual \url{https://cran.r-project.org/web/packages/geodata/geodata.pdf}
#' 
#' Functions of interest for this project:
#' gadm() for downloading country data
#' osm() for downloading OpenStreetMap data
library(geodata) # For downloadGadm

library(terra) # For downloadOsmData

#' Gadm GeoData
#'
#' Download the GeoData from gadm (\url{https://gadm.org/index.html}) for the 
#' specified country and level.
#' Checks if data has already been downloaded prior to starting the download.
#'
#' @param country 
#' @param level
#' @param path
#' @param version
#' @param resolution
#' 
#' @return Country data (once downloaded)
#'
#' @section Warning:
#' 
#' Target directory (path) is in the scope of a .gitignore- 
#' therefore download is required after cloning the project.
#'
#' @section Info:
#' 
#' While downloading the country-specific data happens via
#' gadm_syria_0 <- gadm(country="Syria", level=0, directory=dir_raw, version="latest", resolution=1)
#' already downloaded data can easily be read via
#' gadm_syria_0 <- readRDS(paste0(dir_raw,"/gadm/gadm41_SYR_0_pk.rds", sep=""))
#' where the filename has to be specified accordingly.
#' 
#' @examples
#' gadmn_data <- downloadGadm(country="Syria", level=0, directory=dir_dat, version="latest", resolution=1)  
#'  
#' @export
downloadGadm <- function(country, level, path, version, resolution) {
  if(missing(resolution)) {resolution = 1}
  if(missing(version)) {version = "latest"}
  
  gadm_data <- geodata::gadm(country=country, level=level, path=path, version=version, resolution=resolution)
  
  return(gadm_data)
}




#' Osm Data
#'
#' Download osm data from ?? (\url{}) for the 
#' specified country.
#' ??? Checks if data has already been downloaded prior to starting the download.
#'
#' @param country 
#' @param var
#' @param path
#' 
#' @return OSM data (once downloaded)
#'
#' @section Warning:
#' 
#' Target directory is in the scope of a .gitignore- 
#' therefore download is required after cloning the project.
#'
#' @section Info:
#' 
#' While downloading the country-specific osm data happens via
#' osm_data <- osm(country="Syria", var="places", path=dir_raw)
#' already downloaded data can easily be read via
#' osm_data <- st_read(paste0(dir_raw,"/SYR_places.gpkg", sep=""))
#' where the filename has to be specified accordingly.
#' 
#' @examples
#' osm_syria <- downloadOsmData(country="Syria", var="places", path=dir_raw)
#'  
#' @export
downloadOsmData <- function(country, var, path) {
  
  osm_data <- osm(country=country, var=var, path=path)
  
  return(osm_data)
}



