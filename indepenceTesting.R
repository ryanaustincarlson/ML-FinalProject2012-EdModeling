dataPath <- "data/"

#load, sort data
students <- read.csv(paste(dataPath, "students-latent.csv", sep=""))

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

