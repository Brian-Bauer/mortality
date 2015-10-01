sink('~/RStudio/mortality/data/output.txt', append=TRUE)

library(rattle)
building <- TRUE
scoring  <- ! building

# The colorspace package is used to generate the colours used in plots, if available.
library(colorspace)
# A pre-defined value is used to reset the random seed so that results are repeatable.
crv$seed <- 42

# Load the data.
crs$dataset <- read.csv('~/RStudio/mortality/data/readmission.csv', na.strings=c('.', 'NA', '', '?'), strip.white=TRUE, encoding='UTF-8')


# The following variable selections have been noted.
crs$input <- c('enum', 't.start', 't.stop', 'time','event', 'chemo', 'sex', 'dukes','charlson')
crs$numeric <- c('enum', 't.start', 't.stop', 'time','event')
crs$categoric <- c('chemo', 'sex', 'dukes', 'charlson')
crs$target  <- 'death'
crs$risk    <- NULL
crs$ident   <- c('record', 'id')
crs$ignore  <- NULL
crs$weights <- NULL

# Decision Tree 
# The 'rpart' package provides the 'rpart' function.
require(rpart, quietly=TRUE)
# Reset the random number seed to obtain the same results each time.
set.seed(crv$seed)
# Build the Decision Tree model.
crs$rpart <- rpart(death ~ ., data=crs$dataset[, c(crs$input, crs$target)], method='class', parms=list(split='information'), control=rpart.control(usesurrogate=0, maxsurrogate=0))
# Score a dataset. 
# Read a dataset from file for testing the model.
crs$testset <- read.csv('~/RStudio/mortality/data/ExportFile.csv', na.strings=c('.', 'NA', '', '?'), header=TRUE, sep=',', encoding='UTF-8')
     
     
# Dump rpart object to standard output - sink() - and write out test data set from R.
printcp(crs$rpart)
write.csv(crs$testset, file='~/RStudio/mortality/results/test2.csv', row.names=TRUE)

# Obtain probability scores for the Decision Tree model on ExportFile.csv.
crs$pr <- predict(crs$rpart, crs$testset[,c(crs$input)], type='class')
     
# Dump data frame from predict() to file from R.
write.csv(data.frame(crs$pr), '~/RStudio/mortality/results/test3.csv', row.names=TRUE)
    
# Extract the relevant variables from the dataset.
sdata <- subset(crs$testset[,], select=c('record', 'id'))
# TRYING ANOTHER APPROACH
     myvars <- c('record', 'id')
     print(myvars)
     write.csv(myvars, file='~/RStudio/mortality/results/myvars.csv')
     
     
        
# DEBUGGING R
#traceback()

sdata <- crs$testset[myvars]
   
print(sdata <- crs$testset[myvars])
sdata <- crs$testset[myvars]    
#write.csv(crs$testset[myvars], file='~/RStudio/mortality/results/test4.csv', row.names=TRUE)
#write.csv(crs$testset[myvars], file='~/RStudio/mortality/test4.csv')
#write.csv(sdata, file='~/RStudio/mortality/results/test4.csv')
#write.csv(crs$testset, file='~/RStudio/mortality/results/test4.csv')
#if(class(sdata) == 'try-error' { cat('Error!!!...\n') }
   
# Output the combined data.
write.csv(cbind(sdata, crs$pr), file='~/RStudio/mortality/results/ExportFile_score_idents.csv', row.names=FALSE)
# Create plot file for the Decision Tree.
setwd('~/RStudio/mortality/plots')
png('R_Score_Plot_1.png')
plot(crs$rpart)
text(crs$rpart, use.n=TRUE)
title(main='Decision Tree', sub=format(Sys.time(), '%a %b %d %X %Y'), col.main='blue', col.sub='black', line='2', font.main=4, font.sub=3)
quit()
