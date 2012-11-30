dataPath <- "data/"
students <- read.csv(paste(dataPath, "students.csv", sep=""))

featurenames <- names(students)[4:length(names(students))]

for (featurename in featurenames)
{
  print(paste("feature name:", featurename))
  featurevals <- students[[featurename]]
  splits <- quantile(featurevals, seq(0,1,len=6))
  print(splits)
}
