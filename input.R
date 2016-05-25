###########################
# input.R
###########################
#
# Description
#
# read input
#
###########################



#####################################
# set parameters
#####################################

######## read config file
daConfig <- read.table(configFile,as.is=TRUE,header=TRUE)

######## generate R-commands
commands1 <- paste(daConfig$Variable," <- ",daConfig$Value,sep="")
commands2 <- paste(daConfig$Variable," <- ","\"",daConfig$Value,"\"",sep="")

######## execute commands
for (ii in 1:length(commands1)) {
  if (inherits(try(eval(parse(text=commands1[ii])),silent=TRUE),"try-error")) {
    eval(parse(text=commands2[ii]))
  }
}

######## make sure fileNameUtils and fileNameFuncs were treated as characters
indxUtils <- grep("fileNameUtils",daConfig$Variable)
indxFuncs <- grep("fileNameFuncs",daConfig$Variable)

eval(parse(text=paste("fileNameUtils"," <- ","\"",daConfig$Value[indxUtils],"\"",sep="")))
eval(parse(text=paste("fileNameFuncs"," <- ","\"",daConfig$Value[indxFuncs],"\"",sep="")))


#########################
# load libraries
#########################
if (exists("libRequests")) {
  libs <- unlist(strsplit(libRequests,","))
  if (length(libs)>0) {
    for (ii in 1:length(libs)) {
      eval(parse(text=paste("require(",libs[ii],")",sep="")))
    }
  }
}
  

#########################
# load utilities
#########################

if (exists("dirNameUtils")) {
  if (length(unlist(strsplit(fileNameUtils,",")))>0) {
    fileUtils <- paste(dirNameUtils,unlist(strsplit(fileNameUtils,",")),".R",sep="")
    for (ii in 1:length(fileUtils)) {
      source(paste(fileUtils[ii]))
    }
  }
}

#########################
# load functions
#########################

if (exists("dirNameFuncs")) {
  if (length(unlist(strsplit(fileNameFuncs,",")))>0) {
    fileFuncs <- paste(dirNameFuncs,unlist(strsplit(fileNameFuncs,",")),".R",sep="")
    for (ii in 1:length(fileFuncs)) {
      source(paste(fileFuncs[ii]))
    }
  }
}

#########################
# load dynamic link libraries
#########################

if (exists("dirNameDyns")) {
  if (length(unlist(strsplit(fileNameDyns,",")))>0) {
    fileDyns.R  <- paste(dirNameDyns,unlist(strsplit(fileNameDyns,",")),".R",sep="")
    fileDyns.so <- paste(dirNameDyns,unlist(strsplit(fileNameDyns,",")),".so",sep="")
    for (ii in 1:length(fileDyns.so)) {
      dyn.load(fileDyns.so[ii])
      source(paste(fileDyns.R[ii]))
    }
  }
}

