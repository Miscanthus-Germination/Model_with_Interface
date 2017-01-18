# Defult testing values
# 
# totalG <- 0.56
# ThermalMinMax <- c(30,480)
# peekG <- 90

#start Funcrion
MakeSeed.Datr <- function(totalG=0.56, ThermalMinMax=c(30,480), peekG=90){
    
    #Calculate the increment by which to devide Thermal Time(TT) in Degree D
    inter <- (ThermalMinMax[2] - ThermalMinMax[1])/12
    
    #Set Defults
    tgball <- c(1,2,3,4,5,6,7,8,9,10,11,12,13,99999)
    for(i in seq(1,13,1)){
        #incrementaly add starting at min to get a range of TT
        tgball[i] <- ThermalMinMax[1]+(inter*(i-1))
    }
    
    #Get True Fulses for whitch ones are under the peek
    underPeek <- (tgball < peekG)
    #A coppy of the total for use within the loop
    total <- totalG
    FrcAtTime <- c(0,2,3,4,5,6,7,8,9,10,11,12,13,1)
    for(x in seq(1,14,1)) {
        
        #for the main seq of values(exclued the first and last [based on defults])
        if(FrcAtTime[x] != 0 & FrcAtTime[x] != 1) {
            if(underPeek[x] == T) {
                if(x == 13){FrcAtTime[x] <- total}else{
                    #a algarithan to rufly aproxamate the data see the exal file in the modal folder fakeFun.xlsx
                    runningG <- total/(x/(x/6))
                    FrcAtTime[x] <- runningG
                    total <- total - runningG
                }
            }
            if(underPeek[x] == F) {
                if(x == 13){FrcAtTime[x] <- total}else{
                    runningG <- total/(x/(x/2.5))
                    FrcAtTime[x] <- runningG
                    total <- total - runningG
                }
            }
        }
        if(FrcAtTime[x] == 1) {
            FrcAtTime[x] <- 1 - totalG
        }
    }
    
    Frc <- cumsum(FrcAtTime)
    
    out <- cbind.data.frame(FrcAtTime, Frc, tgball)
    out <- round(out, digits = 2)
    
    return(out)
}


#start Funcrion
MakeSeed.DatrW <- function(MinMax=c(0.064,0.280), peekG=90){
    
    Water <- seq(MinMax[1], MinMax[2], length.out = 10)
    Water <- data.frame(Water)
    Water$Proportion <- Water$Water - MinMax[1]
    for (x in 2:10) {
        Water$Proportion[x] <- (Water$Proportion[x-1]^.9) + (Water$Proportion[x]^peekG)
    }
    Water$Proportion <- Water$Proportion / max(Water$Proportion)
    out <- rbind(c(0,0), Water)
    plot(out$Water, out$Proportion, xlim = c(0,1), ylim = c(0,1))
    return(out)
}



restNorm <- function(No, Mean=T, Min, Max, Dig=1) {
    SD <- ((Max - Min)/10) * 2
    if(Mean == T) {
        Mean <- mean(c(Min,Max))
    }
    #rHelp Mike Miller-13
    x <- round(qnorm(runif(No, pnorm(Min, mean=Mean, sd=SD), pnorm(Max, mean=Mean, sd=SD)), mean=Mean, sd=SD), digits = Dig)
    return(x)
}



MakeClod.Datr <- function(MinMax.Clod, numb.min.Clod, numb.max.Clod, Prob.Serf.Clod) {
    
    ############# output setup 
    output <- matrix(data = NA, nrow = 5, ncol = 5)
    colnames(output) <- c('No.of.Clods', 'Min.Size', 'P.on.serface', 'P.stuk.serface', 'P.stuk.soil')
    
    
    ############# size of clod 
    incro <- (MinMax.Clod[2] - MinMax.Clod[1])/4
    
    for(Row in seq(1, nrow(output), 1)) {
        output[Row, 2] <- round(x = MinMax.Clod[1] + (incro * (Row -1)), digits = 0)
        
    }
    
    
    ######### Number of clods 
    incro <- round(mean(c(numb.min.Clod, numb.max.Clod)), digits = 0)
    
    output[1, 1] <- numb.min.Clod
    output[2, 1] <- round(mean(c(numb.min.Clod, incro)), digits = 0)
    output[3, 1] <- incro
    output[4, 1] <- round(mean(c(incro, numb.max.Clod)), digits = 0)   
    output[5, 1] <- numb.max.Clod
    
    
    ########### P.on.serface 
    switch(
        EXPR = Prob.Serf.Clod,
        no = output[, 3] <- 0,
        LwithS = output[, 3] <- c(0.1,0.3,0.5,0.7,0.9),
        MwithS = output[, 3] <- c(0.9,0.7,0.5,0.3,0.1),
        all = output[, 3] <- 1,
    )
    
    ######### Finish 
    output[, 4] <- 0.5
    output[, 5] <- 0.5
    
    return(output)
}