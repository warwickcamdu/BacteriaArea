# BacteriaArea

Approximates area of bateria per cell by measuring area of bacteria (channel 2) and dividing by the number of nuclei (channel 1). Saves ROIs and results to OMERO. Analysis is conducted on the in focus plane of each channel (found by finding the plane with the highest standard deviation.

## Requirements

- Details for connecting to an OMERO server.
- OMERO dataset ID containting image stacks with at least 2 channels.

## Setup

- Install [Fiji](https://fiji.sc/)
- Install [OMERO for ImageJ Plugin](https://www.openmicroscopy.org/omero/downloads/)
- Install [simple-omero-clients](https://github.com/GReD-Clermont/simple-omero-client)
- Install [omero_macro-extensions](https://github.com/GReD-Clermont/omero_macro-extensions)

Instructions of installing all Plugins are available here: [https://omero-guides.readthedocs.io/projects/fiji/en/latest/installation.html](https://omero-guides.readthedocs.io/projects/fiji/en/latest/installation.html)

## Output
Saves ROIs for nuclei and bacteria to OMERO images and saves Bacteria Area per Cell.csv to OMERO dataset. Bacteria Area per Cell.csv contains two columns: 1) the image ids and 2) the bacterial area per cell for each image.

## References

Pouchin P, Zoghlami R, Valarcher R et al. Easing batch image processing from OMERO: a new toolbox for ImageJ \[version 2; peer review: 2 approved\]. F1000Research 2022, 11:392 (https://doi.org/10.12688/f1000research.110385.2) 
