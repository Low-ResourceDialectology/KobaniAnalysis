
#' Gadm GeoData
#'
#' Removing duplicates from data 
#'
#' @param data 
#' @param variable
#' 
#' @return Data with unique values
#'
#' @section Warning:
#' 
#' Warning necessary?
#' 
#' @section Info:
#' 
#' TODO
#' 
#' @examples
#' Remove duplicates based on "Name"
#' kobani_dialect_metainfo = kobani_dialect_metainfo[!duplicated(kobani_dialect_metainfo$Name),]
#'  
#' @export
removeDuplicates <- function(data, varialbe) {
  data_unique <-data[!duplicated(data$variable),]
    
  return(data_unique)
}


