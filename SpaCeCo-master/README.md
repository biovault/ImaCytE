[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.3885814.svg)](https://doi.org/10.5281/zenodo.3885814)

# SpaCeCo
SpaCeCo is an interactive tool for the data-driven comparison of spatially resolved single-cell data  as presented in the paper " Visual cohort comparison for spatial single-cell omics-data".

## Cite 

If you use our interactive tool or any of the created visual interfaces within the scope of a scientific article you must cite the original publication:

Somarakis A., Ijsselsteijn, M.E., Luk, S.J., Kenkhuis, B., de Miranda, N.F., Lelieveldt B., and Höllt T., __Visual cohort comparison for spatial single-cell omics-data__, _IEEE Transactions on Visualization and Computer Graphics_, _pp. 1-1_, 2020. [DOI: 10.1109/TVCG.2020.3030336](https://dx.doi.org/10.1109/TVCG.2020.3030336)

## Getting started

You can download and install the executable from the [release page](https://github.com/biovault/SpaCeCo/releases) .

### Loading data for analysis 

* Select the _Option_ menu

* Click on _Load Data_

* Here, provide a **folder**. 
In this folder should be **two subfolders, one for each cohort** you want to load.
In each subfolder you must contain for each sample of the cohort a **"<name>.csv"** file with each row representing the cell type of each cell and a **"*<name>.tiff"** file which is used as the cell mask. 

An example of the folder structure and the form of the Input data can be seen from the Example data in the [release page](https://github.com/biovault/SpaCeCo/releases).
