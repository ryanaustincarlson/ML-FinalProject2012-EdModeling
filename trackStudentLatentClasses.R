library(gdata) # startsWith()

source("clusteringFunctions.R")
source("clusteringClassValuesAnalysis.R")

dataPath <- "data/"
allstudents <- read.csv(paste(dataPath, "students-nominalized.csv", sep=""))

nBestClass <- 4
baselineLCA <- LCA(allstudents, nBestClass, graphs=TRUE)
baselineLatent <- as.vector(by(allstudents, 1:nrow(allstudents), chooseBestLatentClass, baselineLCA, nBestClass))

classInferences <- NULL
classInferences$students <- allstudents$Anon.Student.Id
classInferences <- as.data.frame(classInferences)
classInferences$finalLatentClass <- baselineLatent
fits <- NULL

studentIndex <- 1
for (studentfile in list.files("data/studentSubsets"))
{
  students <- read.csv(paste("data/studentSubsets/",studentfile,sep="")
  newLCA <- LCA(students, nBestClass, graphs=TRUE)
  
  X <- mapBetweenDistributions(newLCA, baselineLCA)
  map <- melt(X[1])$value # weird workaround, otherwise length=1, which is dumb. I hate R data types.. :(
  fit <- as.numeric(X[2])  
  
  latent <- as.vector(by(students, 1:nrow(students), chooseBestLatentClass, newLCA, nBestClass))
  remapped <- latent
  for (index in 1:length(map))
  {
    remapped[latent == index] <- map[index]
  }
  remapped <- remapped == classInferences$finalLatentClass
  remapped[remapped == TRUE] <- 1
  remapped[remapped == FALSE] <- 0
  classInferences[[paste("inferred", sprintf("%02d", studentIndex), sep="")]] <- remapped
  fits <- c(fits, fit)
  studentIndex <- studentIndex + 1
}

inferencePercents <- NULL
for (name in sort(names(classInferences)))
{
  if (startsWith(name, "inferred"))
  {
    percent <- sum(classInferences[[name]]) / length(classInferences[[name]])
    inferencePercents <- c(inferencePercents, percent)
  }
}

plot(inferencePercents)
plot(fits)
