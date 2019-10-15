# ImaCytE

[![DOI](https://zenodo.org/badge/197559881.svg)](https://zenodo.org/badge/latestdoi/197559881)

ImaCytE is a tool developed for the interactive and data-driven exploration of Imaging Mass Cytometry data as presented in the paper "ImaCytE: Visual Exploration of Cellular Micro-environments for Imaging Mass Cytometry Data". 
It is focused on the identification of the cell phenotypes that exist in the samples and the interactive exploration of their microenvironment. 

### Cite
If you use ImaCytE within the scope of a scientific article you must cite the original publication:

Somarakis A., van Unen V., Koning F., Lelieveldt B., and Höllt T., __ImaCytE: Visual Exploration of Cellular Microenvironments for Imaging Mass Cytometry Data__, _IEEE Transactions on Visualization and Computer Graphics_, accepted for publication, 2019

## Getting started

In case you have a Matlab 2016b or newer you can run ImaCytE from source code. 

If you have an older version or you don't have a Matlab installed in your PC you can download and install the executable from the [release page](https://github.com/biovault/ImaCytE/releases) .

### Using ImaCytE from source code

* Please download the full repisotory and add it to your current direcotry. 

* Run ImaCytE.m to start histoCAT from source

### Loading data for analysis 

* Select the _Option_ menu

* Click on _Load Data_

* Here, provide a **folder**. 
In this folder should be **one subfolder for each sample** you want to load. 
In each subfolder you must contain a mutli-**".tiff"** file with all markers as exported from MCD viewer and a **"*_mask.tiff"** file which is used as the cell mask

### Contact

Antonios Somarakis a.somarakis@lumc.nl
