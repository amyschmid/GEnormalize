**Gene expression preprocessing**

Gene expression processing pipeline used in: Sharma et al., 2012, BMC Genomics 13:351; Tonner et al., 2015, PLOS Genetics, 11(1):e1004912.

- This repository contains the code necessary to normalize 2-color Agilent gene expression microarray data.
- Example data files from Sharma et al., 2012, are included for demonstration purposes.

**Dependencies**

- R (version 2.15.2):
- limma - [http://www.bioconductor.org/packages/release/bioc/html/limma.html](http://www.bioconductor.org/packages/release/bioc/html/limma.html)
- maDB - [http://www.bioconductor.org/packages//2.7/bioc/html/maDB.html](http://www.bioconductor.org/packages//2.7/bioc/html/maDB.html)
- RColorBrewer
- yaml
- LaTex
- Sweave 

**Steps to run pipeline:**

- To run the demo, use raw Aglient feature extraction files in the repository folder, 'raw/'
- To run on your own data, download raw data from GEO, create a folder called 'raw/' and unpack into that directory
- To run the demo, use metadata file 'metadata.txt'. To run on your own data, generate a metadata file modeled on the repository metadata example file.
- Run the command 'R CMD Sweave preprocessing.Rnw'