
#library(tidyverse)
#library(sf)
#library(mapview)
#library(RColorBrewer)
#library(ggplot2)
#library(terra)

#library(tidyterra) # for: geom_spatvector

# Closes all open devices
graphics.off()  

#' Plot GeoData
#'
#' @param spat_vector 
#' @param plot_title
#' @param var_1
#' @param var_2
#' 
#' @return Plot of GeoData
#'
#' @section Info:
#' 
#' The data in spat_vector is regional data e.g. from Syria.
#' By aggregating this data with var_1, a new current_region is defined.
#' Now the plot can contain elements from the levels of var_1 and var_2.
#' 
#' @examples
#' plot_geodata <- plotGeoData(spat_vector=mySpatvector, plot_title="myTitle", var_1=myVar1, var_2=myVar2)
#'  
#' @export
plotGeoData <- function(spat_vector, plot_title, var_1, var_2) {
  current_region <- aggregate(spat_vector, var_1)
  
  plot_of_geodata <- plot(spat_vector, col="light blue", lty=2, border="red", lwd=2)
  title(main=plot_title)
  lines(current_region, lwd=5)
  lines(current_region, col="white", lwd=1)
  text(spat_vector, var_2, cex=.5, halo=TRUE)
  
  return(plot_of_geodata)
}


# TODO: Proper structure
plotGeoDataKobani <- function(spat_vector, plot_title, var_1, var_2, var_3) {
  current_region <- aggregate(spat_vector, var_1)
  
  plot_of_geodata <- plot(spat_vector, col="light blue", lty=2, border="red", lwd=2)
  title(main=plot_title)
  lines(current_region, lwd=5)
  lines(current_region, col="white", lwd=1)
  text(spat_vector, var_2, cex=.5, halo=TRUE)
  
  # Subset Kobani out of Syria 
  # TODO: Variable expansions
  #gadm_syria_kobani_selection <- spat_vector$var_2 == var_3
  gadm_syria_kobani_selection <- spat_vector$NAME_2 == "'Ayn al-'Arab"
  plot(spat_vector[ gadm_syria_kobani_selection, ], col="green", add = TRUE)
  text(spat_vector, var_2, cex=.5, halo=TRUE)
  
  return(plot_of_geodata)
}

