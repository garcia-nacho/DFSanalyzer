# Hello, world!
#
# This is an example function named 'hello'
# which prints 'Hello, world!'.
#
# You can learn more about package authoring with RStudio at:
#
#   http://r-pkgs.had.co.nz/
#
# Some useful keyboard shortcuts for package authoring:
#
#   Install Package:           'Ctrl + Shift + B'
#   Check Package:             'Ctrl + Shift + E'
#   Test Package:              'Ctrl + Shift + T'
imagejdir<-"/home/nacho/Fiji.app/"
dfsanalyzer <- function(BaseChannel="C2",Image,Cores=0,ImageFolder=NA,TrackCell, FilterSize, FilterShape) {
  #File selection
  if(is.na(ImageFolder)){
    image.vector<-Image
  }else{
    image.vector<-list.files(ImageFolder, full.names = TRUE, pattern = ".tif$|.tiff$")
  }

  #Sequential
  if(Cores==0 ){
  basedir<-getwd()
  setwd(imagejdir)

  for (i in 1:length(image.vector)) {
    command<-paste(image.vector[i],BaseChannel,sep=",")
    system(paste("./ImageJ-linux64 --no-splash -batch macros/segmenter.ijm",
                 command,">", paste(image.vector[i],"_DFSA.tsv",sep = ""), sep = " "))
  }

  setwd(basedir)

  }
  #Parallel


  #Read
  for(i in 1:length(image.vector)){
    dummy<-read.csv(paste(image.vector[i],"_DFSA.tsv",sep = ""), sep = "\t", header = FALSE)
    if(!exists("out")){
      out<-dummy
    }else{
      out<-rbind(out,dummy)
    }
    return(out)

  }
  file.remove(paste(image.vector,"_DFSA.tsv",sep = ""))

}

ouss<-dfsanalyzer(ImageFolder = "/home/nacho/DFSanalyzer/examples/")
