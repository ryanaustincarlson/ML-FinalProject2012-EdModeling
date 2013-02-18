library(reshape2)

#source("clusteringFunctions.R")
options(scipen=10)

#lca1 <- LCA(students, 4, TRUE)
#lca2 <- LCA(students, 4, TRUE)

reformatProbs <- function(lca)
{
  df <- data.frame()
  for (feature in names(lca$probs))
  {
    melted <- melt(lca$probs[[feature]])
    melted$datasource <- feature
    df <- rbind(df, melted)
  }
  df 
}

mapBetweenDistributions <- function(newLCA, baselineLCA)
{
  new_df <- reformatProbs(newLCA)
  baseline_df <- reformatProbs(baselineLCA)
  
  classes <- levels(new_df$Var1)
  
  map <- NULL
  minDiffs <- NULL
  for (class1 in classes)
  {
    new_classval <- subset(new_df, Var1 == class1)$value
    
    diffs <- NULL
    # FIXME this is wildly inefficient...
    for (class2 in classes)
    {
      baseline_classval <- subset(baseline_df, Var1 == class2)$value
      diff <- mean(abs(new_classval-baseline_classval)) # TODO could use a better metric
      diffs <- c(diffs, diff)
    }  
    map <- c(map, which.min(diffs))
    minDiffs <- c(minDiffs, min(diffs))
  }
  list(map, mean(minDiffs))
}

#mapBetweenDistributions(lca2, lca1)



