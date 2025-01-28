# ChroZoMo - Chronische Zorg Monitor

The **Chronische Zorg Monitor** (ChroZoMo) is a shiny dashboard developed by [ELAN](https://elan.healthcampusdenhaag.nl) to provide insights into chronic care data.

## Getting started
Clone the repository and run app.R. Do make sure you have installed all the required packages. These packages can be found at the top of app.R

## Updating the json of the region
To update the json of the region:

1. Download the most recent maps from [CBS](https://www.cbs.nl/nl-nl/dossier/nederland-regionaal/geografische-data).
1. Use the script located at `bin/CBS_maps_to shapefile.R` to convert the relevant shapefile to json.