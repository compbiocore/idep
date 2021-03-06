# dplyr complains this required libraries: libudunits2-dev, libmariadb-client-lgpl-dev
# install.packages("plotly", repos="http://cran.rstudio.com/", dependencies=TRUE)
# sometimes need to remove all installed packages: https://www.r-bloggers.com/how-to-remove-all-user-installed-packages-in-r/ 
list.of.packages <- c(
  "shiny", "shinyAce", "shinyBS", "plotly",
  "RSQLite", "gplots", 
  "ggplot2", "dplyr", #"tidyverse",
  "plotly",
  "e1071", "reshape2", "DT",
  "data.table", "Rcpp","WGCNA","flashClust","statmod","biclust","igraph","Rtsne"
)

list.of.bio.packages  <- c(
  "limma", "DESeq2", "edgeR", "gage", "PGSEA", "fgsea", "ReactomePA", "pathview", "PREDA",
  "impute", "runibic","QUBIC","rhdf5", "STRINGdb",
  "PREDAsampledata", "sfsmisc", "lokern", "multtest", "hgu133plus2.db", 
   "org.Ag.eg.db","org.At.tair.db","org.Bt.eg.db","org.Ce.eg.db","org.Cf.eg.db",
   "org.Dm.eg.db","org.EcK12.eg.db","org.EcSakai.eg.db","org.Gg.eg.db",
   "org.Hs.eg.db","org.Mm.eg.db","org.Mmu.eg.db","org.Pf.plasmo.db",
   "org.Pt.eg.db","org.Rn.eg.db","org.Sc.sgd.db","org.Ss.eg.db","org.Xl.eg.db"
)
# "org.Hs.ipi.db" removed because it is deprecated

 if(1) { # remove all old packages, to solve problem caused by Bioconductor upgrade
	# create a list of all installed packages
	 ip <- as.data.frame(installed.packages())
	# head(ip)
	# if you use MRO, make sure that no packages in this library will be removed
	 ip <- subset(ip, !grepl("MRO", ip$LibPath))
	# we don't want to remove base or recommended packages either\
	 ip <- ip[!(ip[,"Priority"] %in% c("base", "recommended")),]
	# determine the library where the packages are installed
	 path.lib <- unique(ip$LibPath)
	# create a vector with all the names of the packages you want to remove
	 pkgs.to.remove <- ip[,1]
	# head(pkgs.to.remove)
	# remove the packages
	 sapply(pkgs.to.remove, remove.packages, lib = path.lib)
}

new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
new.bio.packages <- list.of.bio.packages[!(list.of.bio.packages %in% installed.packages()[,"Package"])]
notInstalledPackageCount = length(new.packages) + length(new.bio.packages)

if (!requireNamespace("BiocManager", quietly = TRUE))
    install.packages("BiocManager")
    # install minet manually since it was recently moved from CRAN to bioconductor and breaks old packages that look for it in CRAN
    BiocManager::install("minet", version = "3.8")

#Install Require packages
while(notInstalledPackageCount != 0){

        if(length(new.bio.packages)){
          #source("https://bioconductor.org/biocLite.R")
          #biocLite(new.bio.packages, suppressUpdates = T, quiet=TRUE)
          BiocManager::install(new.bio.packages)
        }
        if(length(new.packages)) install.packages(new.packages, repos="http://cran.rstudio.com/", dependencies=TRUE, quiet=TRUE)


	new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
	new.bio.packages <- list.of.bio.packages[!(list.of.bio.packages %in% installed.packages()[,"Package"])]
	if( notInstalledPackageCount == length(new.packages) + length(new.bio.packages) )
	{
		#no new package installed.
		break
	}
	else {
	   notInstalledPackageCount = length(new.packages) + length(new.bio.packages)
	}
}

#Load Packages
suc = unlist ( lapply(list.of.packages, require, character.only = TRUE) )
if(sum(suc) < length(list.of.packages) )
	cat ("\n\nWarnning!!!!!! These R packages cannot be loaded:", list.of.packages[!suc] )

suc = unlist ( lapply(list.of.bio.packages, require, character.only = TRUE) )
if(sum(suc) < length(list.of.bio.packages) )
	cat ("\n\nWarnning!!!!!! These Bioconductor packages cannot be loaded:", list.of.bio.packages[!suc] )




