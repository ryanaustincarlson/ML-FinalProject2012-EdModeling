dataPath <- "data/"
filename <- "allFeatures.csv"
students <- read.csv(paste(dataPath, filename, sep=""))

featurenames <- names(students)[5:length(names(students))]

for (featurename in featurenames)
{
  featurevals <- students[[featurename]]
  splits <- unique(quantile(featurevals, seq(0,1,len=6), na.rm=TRUE))
  categories <- cut(featurevals, splits, labels=FALSE, include.lowest=TRUE)
  students[[featurename]] <- categories
}

for (featurename in featurenames)
{
  featurevals <- students[[featurename]]
  print(unique(featurevals))
}

write.csv(students, paste(dataPath, "students-nominalized.csv", sep=""))