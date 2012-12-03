dataPath <- "data/"
filename <- "allFeatures.csv"
students <- read.csv(paste(dataPath, filename, sep=""))


nominalize <- function(students, featurenames, nCategories=5)
{
  for (featurename in featurenames)
  {
    featurevals <- students[[featurename]]
    splits <- unique(quantile(featurevals, seq(0,1,len=nCategories+1), na.rm=TRUE))
    categories <- cut(featurevals, splits, labels=FALSE, include.lowest=TRUE)
    students[[featurename]] <- categories
  }  
  students
}

featurenames <- names(students)
test_names <- c(
  "pre_test",
  "immediate_post_test",
  "immediate_post_test_adjusted",
  "delayed_post_test",
  "delayed_post_test_adjusted"
  )

featurenames <- featurenames[featurenames != "X"]
featurenames <- featurenames[featurenames != "Anon.Student.Id"]
featurenames <- featurenames[featurenames != "Condition"]

for (test_name in test_names)
{
  featurenames <- featurenames[featurenames != test_name]
}

students <- nominalize(students, featurenames)
students <- nominalize(students, test_names, 3)

for (name in c(featurenames, test_names))
{
  print(name)
  print(sort(unique(students[[name]])))
}

write.csv(students, paste(dataPath, "students-nominalized.csv", sep=""))