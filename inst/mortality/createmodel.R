#library(rattle)
building <- TRUE
scoring  <- ! building

# The colorspace package is used to generate the colours used in plots, if available.
#library(colorspace)
# A pre-defined value is used to reset the random seed so that results are repeatable.
crv$seed <- 42

# Load the data.
crs$dataset <- read.csv('~/RStudio/mortality/inst/mortality/readmission.csv', na.strings=c('.', 'NA', '', '?'), strip.white=TRUE, encoding='UTF-8')


# The following variable selections have been noted.
crs$input <- c('enum', 't.start', 't.stop', 'time','event', 'chemo', 'sex', 'dukes','charlson')
crs$numeric <- c('enum', 't.start', 't.stop', 'time','event')
crs$categoric <- c('chemo', 'sex', 'dukes', 'charlson')
crs$target  <- 'death'
crs$risk    <- NULL
crs$ident   <- c('record', 'id')
crs$ignore  <- NULL
crs$weights <- NULL

# Decision Tree Model
# The 'rpart' package provides the 'rpart' function.
require(rpart, quietly=TRUE)
# Reset the random number seed to obtain the same results each time.
set.seed(crv$seed)
# Read a dataset from file for testing the model.
crs$testset <- read.csv('~/RStudio/mortality/data/ExportFile.csv', na.strings=c('.', 'NA', '', '?'), header=TRUE, sep=',', encoding='UTF-8')
# Build the Decision Tree model.
##crs$rpart <- rpart(death ~ ., data=crs$dataset[, c(crs$input, crs$target)], method='class', parms=list(split='information'), control=rpart.control(usesurrogate=0, maxsurrogate=0))
mortality_model <- rpart(death ~ ., data=crs$dataset[, c(crs$input, crs$target)], method='class', parms=list(split='information'), control=rpart.control(usesurrogate=0, maxsurrogate=0))

# Visualize the Model.  Create plot file for the Decision Tree.
setwd('~/RStudio/mortality/plots')
png('R_Score_Plot_1.png')
plot(mortality_model)
text(mortality_model, use.n=TRUE)
title(main='Decision Tree', sub=format(Sys.time(), '%a %b %d %X %Y'), col.main='blue', col.sub='black', line='2', font.main=4, font.sub=3)
     
# Save the Model
#dir.create("data", showWarnings=FALSE)
setwd('~/RStudio/mortality')
save(mortality_model, file="data/mortality_model.rda")

# # Obtain probability scores for the Decision Tree model on ExportFile.csv.
# crs$pr <- predict(mortality_model, crs$testset[,c(crs$input)], type='class')
#      
# # Dump data frame from predict() to file from R.
# ##write.csv(data.frame(crs$pr), '~/RStudio/mortality/results/test3.csv', row.names=TRUE)
#     
# # Extract the relevant variables from the dataset.
# sdata <- subset(crs$testset[,], select=c('record', 'id'))
# sdata <- crs$testset[myvars]
# ##print(sdata <- crs$testset[myvars])
# sdata <- crs$testset[myvars]    
# 
#    
# # Output the combined data.
# write.csv(cbind(sdata, crs$pr), file='~/RStudio/mortality/results/ExportFile_score_idents.csv', row.names=FALSE)
# 
# ##quit()
