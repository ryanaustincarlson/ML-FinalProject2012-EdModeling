source("clusteringFunctions.R")

dataPath <- "data/"

#load, sort data
students <- read.csv(paste(dataPath, "students-nominalized.csv", sep=""))

#allstats <- LCAstats(students, 1:10)
#allstats
#plotStats(allstats)

nBestClass <- 4
lc <- LCA(students, nBestClass, graphs=TRUE)
students$latent <- as.vector(by(students, 1:nrow(students), chooseBestLatentClass, lc, nBestClass))

write.csv(students, paste(dataPath, "students-latent.csv", sep=""))

