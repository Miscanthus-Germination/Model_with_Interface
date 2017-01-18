Options <- function (FileName) {
     
     Componets <- read.csv(FileName);
     Componets <- Componets[c(1,3,5,6,7)] 
     Componets[Componets==""]  <- NA 
     m <- as.matrix(Componets)
     row <- nrow(Componets)
     
     for(a in seq(1, row, by=1)) {
          print(paste("row", a))
          if(is.na(m[a,2])) {
               
               m[a,2] <- as.character(m[a,5])
               
               
          } else {
               if(as.numeric(as.character(m[a,2])) > as.numeric(as.character(m[a,4])) | as.numeric(as.character(m[a,2])) < as.numeric(as.character(m[a,3]))) {
                    stop(paste("Limet ERROR\nYou Have set the value of -", as.character(m[a,1]), "- outside the limets\nCorrect this in the csv file", FileName))
               }
          }
     }
     options <- as.data.frame(m)
     rownames(options) <- options[,1]
     options <- options[2] 
     
     
     return(options) 
}







