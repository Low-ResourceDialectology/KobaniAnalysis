# setup

## Check installed packages
## → https://stackoverflow.com/questions/4090169/elegant-way-to-check-for-missing-packages-and-install-them
## Seems to be out of date (?)
list.of.packages <- c("ggplot2", "Rcpp")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)
## Another idiot not adding the effing publication date- what is wrong with these bellends?!
## → https://statisticsglobe.com/r-install-missing-packages-automatically
# Specify your packages
required_packages <- c("A3", "aaSEA", "abbyyR", "abc")                                        
# Extract not installed packages
not_installed <- required_packages[!(required_packages %in% installed.packages()[ , "Package"])]    
if(length(not_installed)) install.packages(not_installed)
# Print information to console
# "4 packages had to be installed."
print(paste(length(not_installed), "packages had to be installed.")) 



# processData



# runAnalysis



################################################################################
# Information about Kobani
##########################
# Wikipedia: 
# Kobanê (kurdisch کۆبانێ Kobanê bzw. کۆبانی Kobanî) oder Ain al-Arab (
# arabisch عين العرب, DMG ʿAyn al-ʿArab) ist die Hauptstadt des Distrikts 
# Ain al-Arab im Gouvernement Aleppo in Syrien. Die Stadt wird mit 54.681 Menschen 
# (geschätzter Stand 2007) überwiegend von Kurden bewohnt. 
# COUNTRY     Gouvernement    District        (Municipal-)City
# Syria       Aleppo          Ain al-Arab     Kobanê (Ayn al-Arab)(Eng?) (Ain al-Arab)(Ger?)

# Cities, towns and villages of Ayn al-Arab Subdistrict
# https://en.wikipedia.org/wiki/Ayn_al-Arab_Subdistrict
#######################################################

# Cities, towns and villages of Shuyukh Tahtiani Subdistrict
# https://en.wikipedia.org/wiki/Shuyukh_Tahtani_Subdistrict
###########################################################





#' geodata library from \url{https://github.com/rspatial/geodata}
#' manual \url{https://cran.r-project.org/web/packages/geodata/geodata.pdf}
#' 
#' Functions of interest for this project:
#' gadm() for downloading country data
#' osm() for downloading OpenStreetMap data