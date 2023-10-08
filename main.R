#
# Preparation at start-up of project: Kobani Analysis
#
# Author: Christian "Doofnase" Schuler, Raman Ahmad
# Date: 2023 June
################################################################################

# Set initial working directories
dir_init <- getwd()
dir_src <- paste0(dir_init, "/src/", sep="")
## Raw data is not to be touched by anyone
dir_raw <- paste0(dir_init, "/data/raw/", sep="")
# Downloading uses "dir_raw" since the gadm-package automatically add a directory called "gadm"
# For reading and later use, this path: dir_raw_gadm
dir_raw_gadm <- paste0(dir_init, "/data/raw/gadm/", sep="")
dir_raw_osm <- paste0(dir_init, "/data/raw/osm/", sep="")
dir_raw_manual <- paste0(dir_init, "/data/manual/", sep="")
## Processed data as step to lessen the computational load
dir_processed <- paste0(dir_init, "/data/processed/", sep="")
## Output data holds all results and figures
dir_out <- paste0(dir_init, "/data/output/", sep="")

setwd(dir_init)
print(paste0("Working directory: ", dir_init))
print(paste0("Source directory: ", dir_src))
print(paste0("Data (raw) directory: ", dir_raw))
print(paste0("Output directory: ", dir_out))

# Setup
#######
## The script that takes care of the setup of this project
source(paste0(dir_src, "setup.R", sep=""))

# Process Data
##############
## The script that handles the data processing
source(paste0(dir_src, "processData.R", sep=""))

# TODO: Refactor code into a more modular approach, where everything happens in its own script/function
#       The creation of the subset around the Kobani-region on its own (and optionally)
#       The plotting of all locations in Kobani (with and without name-labels)
#       The plotting of all locations corresponding to the Study
#       And so on...

# Run Analysis
##############
## The script to run parts of the analysis
source(paste0(dir_src, "runAnalysis.R", sep=""))



