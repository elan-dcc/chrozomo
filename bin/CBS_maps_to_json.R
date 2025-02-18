setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

# The most current wijk- en buurtkaarten can be retrieved from here:
# https://www.cbs.nl/nl-nl/dossier/nederland-regionaal/geografische-data

library(sf) # deal with shapefiles
library(geojsonio) # convert shapefile to json
library(rmapshaper) #simplify json

shapefile <- "../data/gemeenten_2023_v1.shp"
dest_json <- "../data/elan.json"
loc_data <- "../data/elan_classification.csv"

# read in shapefile
gemeenten <- read_sf(shapefile)

# subset
gemeenten <- gemeenten[(gemeenten$H2O == "NEE") & (gemeenten$GM_CODE %in% elan$GM_CODE),]

# read in data elan and ensure the correct data is in there
# such as the names of the municipalities
elan <- read.csv(loc_data)
elan <- elan[c("name", "GM_CODE", "category")]
elan <- merge(elan, gemeenten, by.x = "GM_CODE", by.y = "GM_CODE")
# I decided to add the number of residents
# note that you cannot remove GM_CODE, as that is used as the key with the
# shapefile
elan <- elan[c("name", "GM_CODE", "AANT_INW", "category")]
write.csv(elan, loc_data, row.names = FALSE)

# select columns of interest and rename them
gemeenten <- gemeenten[c("GM_NAAM", "geometry")]
colnames(gemeenten) <- c("name", "geometry")

# simplify
gemeenten <- ms_simplify(gemeenten)

# save as json
write(geojson_json(gemeenten), dest_json)