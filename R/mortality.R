#' Score the Mortality model
#' 
#' @export
mortality <- function(input){
  #input can either be csv file or data	
  newdata <- if(is.character(input) && file.exists(input)){
    read.csv(input)
  } else {
    as.data.frame(input)
  }
  ##stopifnot("age" %in% names(newdata))
  ##stopifnot("marital" %in% names(newdata))
  
  ##newdata$age <- as.numeric(newdata$age)

  #mortality_model is included with the package
  ##newdata$tv <- as.vector(predict.gam(tv_model, newdata = newdata))
  ##crs$pr <- predict(mortality_model, crs$testset[,c(crs$input)], type='class')
  # Read a dataset from file for testing the model.
  testset <- read.csv('~/RStudio/mortality/data/ExportFile.csv', na.strings=c('.', 'NA', '', '?'), header=TRUE, sep=',', encoding='UTF-8')
  crs$pr <- predict(mortality_model, testset[,c(newdata)], type='class')  
  return(newdata)
}
