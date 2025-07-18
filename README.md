# ChroZoMo - Chronische Zorg Monitor

Link to the current dashboard:
https://elandcc.shinyapps.io/chrozomo/

The **Chronische Zorg Monitor** (ChroZoMo) is a shiny dashboard developed by [ELAN](https://elan.healthcampusdenhaag.nl) to provide insights into chronic care data.

## Getting started
Clone the repository and run app.R. Do make sure you have installed all the required packages. These packages can be found at the top of app.R

## Directory structure
The **ChroZoMo** project is organized into the following directories:
```
Chrozomo
├───bin #code to convert CBS maps to json
├───data
│   └───hartfalen
├───helpers #utility functions and helper scripts
├───includes #commonly included html-files
├───modules
│   ├───hartfalen
│   └───showcase
└───www #web-related assets
    ├───css
    ├───fonts
    └───images
    └───scripts
 ```
Each directory serves a specific function, ensuring modularity and maintainability within the project.

## Updating the json of the region
To update the json of the region:

1. Download the most recent maps from [CBS](https://www.cbs.nl/nl-nl/dossier/nederland-regionaal/geografische-data).
1. Use the script located at `bin/CBS_maps_to shapefile.R` to convert the relevant shapefile to json.
