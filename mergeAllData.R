dataPath <- "data/"
outputfilename <- "allFeatures.csv"
studentsfilename <- "students.csv"
testsfilename <- "student_tests.csv"
morefeaturesfilename <- "moreFeatures.csv"

students <- read.csv(paste(dataPath, studentsfilename, sep=""))
tests <- read.csv(paste(dataPath, testsfilename, sep=""))
morefeatures <- read.csv(paste(dataPath, morefeaturesfilename, sep=""))

students$X <- NULL
morefeatures$X <- NULL
morefeatures$X.1 <- NULL

combined <- merge(tests, students)
combined <- merge(combined, morefeatures)

write.csv(combined, paste(dataPath, outputfilename, sep=""))