options(repos = c("CRAN" = "http://cran.ma.imperial.ac.uk"))
options(BioC_mirror = c("Cambridge" = "http://mirrors.ebi.ac.uk/bioconductor/"))
source("http://www.bioconductor.org/biocLite.R")
biocLite(c("org.Hs.eg.db","BSgenome.Hsapiens.UCSC.hg19","gridExtra","ggplot2"))

