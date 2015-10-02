#' Score the Mortality model
#' 
#' @export
mortality <- function(input){
  #input can either be csv file or data	
  newdata <- if(is.character(input) && file.exists(input)){
    read.csv(input, na.strings=c('.', 'NA', '', '?'), header=TRUE, sep=',', encoding='UTF-8')
  } else {
    as.data.frame(input)
  }
  
  ##stopifnot("age" %in% names(newdata))
  ##stopifnot("marital" %in% names(newdata))
  ##newdata$age <- as.numeric(newdata$age)

  #mortality_model is included with the package
  input <- c('enum', 't.start', 't.stop', 'time','event', 'chemo', 'sex', 'dukes','charlson')
  ##write.csv(newdata, file='~/RStudio/mortality/results/test2.csv', row.names=TRUE)
  #join the predicted mortality - "pr" - to the original data being scored
  newdata$pr <- as.vector(predict(mortality_model, newdata[,c(input)], type='class'))
  ##write.csv(newdata, file='~/RStudio/mortality/results/test3.csv', row.names=TRUE)
  png('R_Score_Plot_1.png')
  plot(mortality_model)
  text(mortality_model, use.n=TRUE)
  title(main='Decision Tree', sub=format(Sys.time(), '%a %b %d %X %Y'), col.main='blue', col.sub='black', line='2', font.main=4, font.sub=3)
  return(newdata)
}