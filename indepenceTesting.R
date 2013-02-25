dataPath <- "data/"

#load, sort data
students <- read.csv(paste(dataPath, "students-latent.csv", sep=""))
tests <- read.csv(paste(dataPath, "student_tests.csv", sep=""))

#testnames <- c("pre_test", "immediate_post_test", "immediate_post_test_adjusted", 
#           "delayed_post_test", "delayed_post_test_adjusted")
testnames <- c("immediate_post_test_adjusted","delayed_post_test_adjusted")

print.chisq <- function(data1, data2, title)
{
  x <- chisq.test(table(data1, data2))
  if (x$p.value < 0.06)
  {
    print("!!!")
  }
  print(paste(title, " ChiSq.. X^2: ", signif(x$statistic, 5), 
              ", df: ", signif(x$parameter, 5),
              ", p-value: ", signif(x$p.value, 5), sep="")) 
}

all.chisq <- function(students)
{
  
  print(chisq.test(table(students$Condition, students$latent)))
  
  for (t in testnames)
  {
    print(paste("Test Type:", t))
    testscores <- students[t][[1]]
    print.chisq(students$Condition, testscores, "Condition")
    print.chisq(students$latent, testscores, "Latent")
    print("")
  }
}

all.chisq(students)

chisq.by.latent <- function(students)
{
  latents <- sort(unique(students$latent))
  for (latentname in latents)
  {
    print(paste("Latent Class:", latentname))
    
    s <- students[students$latent==latentname,]
    
    for (t in testnames)
    {
      print(paste("Test Type:", t))
      testscores <- s[t][[1]]
      #print(table(s$Condition, testscores))
      print.chisq(s$Condition, testscores, "Condition")
      #print.chisq(s$latent, testscores, "Latent")
      print("")
    }
    print("")
  }
}

chisq.by.latent(students)

# condition and cluster membership
x <- matrix(c(13,15,10,25,21,16,10,15,17,18,7,10,18,10,12,13,15,14,11,20), 
            ncol=4, 
            byrow=TRUE)
chisq.test(x)
x.collapsed <- 
  matrix(c(sum(x[1:4,1]),sum(x[1:4,2]),sum(x[1:4,3]),sum(x[1:4,4]),x[5,]),
         ncol=4,
         byrow=TRUE)
chisq.test(x.collapsed)

chisq.test(table(students$latent,students$pre_test))

students.tests <- merge(
  students, 
  tests,
  by="Anon.Student.Id")

#######################
# MAKE SURE stubborn group is CLASS = 2
#######################
medium.classnum <- 1
stubborn.classnum <- 2
clever.classnum <- 3
interactive.classnum <- 4

medium <- students.tests[students.tests$latent == medium.classnum,]$pre_test.y
stubborn <- students.tests[students.tests$latent == stubborn.classnum,]$pre_test.y
clever <- students.tests[students.tests$latent == clever.classnum,]$pre_test.y
interactive <- students.tests[students.tests$latent == interactive.classnum,]$pre_test.y


stubborn.single <- students.tests[students.tests$Condition == "single" 
                                  & students.tests$latent == stubborn.classnum,]$pre_test.y

stubborn.multiple <- students.tests[students.tests$Condition != "single" 
                                    & students.tests$latent == stubborn.classnum,]$pre_test.y
t.test(stubborn.single, stubborn.multiple)

notstubborn <- students.tests[students.tests$latent != stubborn.classnum,]$pre_test.y
t.test(stubborn, notstubborn)

t.test(stubborn, medium)
t.test(stubborn, clever)
t.test(stubborn, interactive)

t.test(medium, clever)
t.test(medium, interactive)

t.test(clever, interactive)


