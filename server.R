source("Model/FakeDataFun.R")
source("Model/ElipsWeb.R")
source("Model/OtherFun.R")


shinyServer(function(input, output) {
    
    Enviro.table <- function() {
        if(input$Data.Eno) {
            Evo.Dat.tab <- read.csv(input$InputFile.Enviro$datapath)
        }else {
            Evo.Dat.tab <- read.csv(paste("Default_data/EnviroLims/", input$Enviro.Default, ".csv", sep = ""))
        }
        if(input$useETslider) {
            if(input$Data.Temp.dist == 'norm'){
                Evo.Dat.tab$AvTemp = restNorm(No=nrow(Evo.Dat.tab), Min = input$MinMax.Temp[1], Max = input$MinMax.Temp[2], Dig=1)
            }else {
                Evo.Dat.tab$AvTemp = round(runif(n=nrow(Evo.Dat.tab), input$MinMax.Temp[1], input$MinMax.Temp[2]), 1)
            }
        }
        
        if(input$useEMslider) {
            if(input$Data.Moist.dist == 'norm'){
                Evo.Dat.tab$AvWat = restNorm(No=nrow(Evo.Dat.tab), Min = input$MinMax.Most[1], Max = input$MinMax.Most[2], Dig=3)
            }else {
                Evo.Dat.tab$AvWat = round(runif(n=nrow(Evo.Dat.tab), input$MinMax.Most[1], input$MinMax.Most[2]), 3)
            }
        }
        
        if(input$useERslider) {
            if(input$Data.Rain.dist == 'norm'){
                Evo.Dat.tab$Rainfall = restNorm(No=nrow(Evo.Dat.tab), Min = input$MinMax.Rain[1], Max = input$MinMax.Rain[2], Dig=2)
            }else {
                Evo.Dat.tab$Rainfall = round(runif(n=nrow(Evo.Dat.tab), input$MinMax.Rain[1], input$MinMax.Rain[2]), 2)
            }
        }
        Evo.Dat.tab
    }
    
    output$Enviro.table = renderDataTable({
        Enviro.table()
    }, options = list(lengthMenu = c(3, 30, 50, 100), pageLength = 8, searching = FALSE))
    
    
    
    
    Seed.table = function() {
        if(input$Data.Seed) {
            Seed.Dat.tab <- read.csv(input$InputFile.Seed$datapath)
        }else {
            Seed.Dat.tab <- read.csv(paste("Default_data/TGBSeeds/",input$SeedSet.Default,"_Temp_", input$SeedTemp.Default, ".csv", sep = ""))
        }
        if(input$useSeedSlider) {
            Seed.Dat.tab <- MakeSeed.Datr(input$Germ.TP, input$Germ.Range, input$Germ.Peek)
        }
        Seed.Dat.tab
    }
    
    output$Seed.table <- renderDataTable({
        Seed.table()
    }, options = list(lengthMenu = c(5, 15, 20), pageLength = 15, searching = FALSE))
    
    output$Seed.plot = renderPlot({
        seedPlot <- Seed.table()
        plot(seedPlot$tgball, seedPlot$Frc, type= 'o', col="red", ylim = c(0,1) , xlim = c(0,1200), xlab = 'Thermal Time (DegD)', ylab = 'Fraction of seed germ')
    }) 
    
    
    
    Seed.Wtable = function() {
        if(input$Data.WSeed) {
            Seed.Dat.tab <- read.csv(input$InputFile.WSeed$datapath)
        }else {
            Seed.Dat.tab <- read.csv(paste("Default_data/WaterLims/",input$WaterSet.Default, ".csv", sep = ""))
        }
        if(input$useWatSlider) {
            Seed.Dat.tab <- MakeSeed.DatrW(input$Germ.WRange, input$Germ.Wexp)
        }
        Seed.Dat.tab
    }
    
    output$Seed.Wtable <- renderDataTable({
        Seed.Wtable()
    }, options = list(lengthMenu = c(5, 15, 20), pageLength = 15, searching = FALSE))
    
    output$Seed.Wplot = renderPlot({
        seedPlot <- Seed.Wtable()
        plot(seedPlot$Water, seedPlot$Proportion, type= 'o', col="red", ylim = c(0,1) , xlim = c(0,.5), xlab = 'Soil Water (W/V)', ylab = 'Fraction of Total Seeds Germ')
    }) 
    
    
    
    Clod.table = function() {
        if(input$Data.SoilFil) {
            Clod.Dat.tab <- read.csv(input$InputFile.Clod$datapath)
        }else {
            Clod.Dat.tab <- read.csv(paste("Default_data/ClodLims/", input$Soil.Default, ".csv", sep = ""))
        }
        if(input$useSoilSlider) {
            Clod.Dat.tab <- MakeClod.Datr(input$MinMax.Clod, input$numb.min.Clod, input$numb.max.Clod, input$Prob.Serf.Clod)
        }
        as.data.frame(Clod.Dat.tab)
    }
    
    output$Clod.table = renderDataTable({
        Clod.table()
    }, options = list(lengthMenu = c(7, 10), pageLength = 7, searching = FALSE))
    
    
    
    Get.Components.spp <- function() {
        Components.spp <- read.csv(paste("Default_data/SPPLims/", input$Spp.Default, ".csv", sep = ""))
        
        if(input$Data.speshSpp) {
            Components.spp$Tb.germ <- input$Tb.germ
            Components.spp$Tb.elomg <- input$Tb.elomg
            Components.spp$Yb.germ <- input$Yb.germ
            Components.spp$DryProb <- input$DryProb
            Components.spp$Hit.Size <- input$Hit.Size
            Components.spp$a <- input$a
            Components.spp$b <- input$b
            Components.spp$c <- input$c
        }
        
        #print(Components.spp)
        Components.spp
    }
    
    output$text.spp <- renderUI({
        Components.spp <- Get.Components.spp()
        HTML(paste("<h4> Your seed lots requirements for growth are: </h4>",
                   "A minimum of <b>", Components.spp$Tb.germ, " °C</b> for germination. <br/>",
                   "A minimum of <b>", Components.spp$Tb.elomg, " °C</b> for growth (elongation). <br/>",
                   "A minimum <b>water potential of ", Components.spp$Yb.germ, "</b> for germination. <br/>",
                   "<br/><h4> Your seed types chances of emerging the soil are effected by: </h4>",
                   "The probability the seedling will get through a dry crust is <b>", Components.spp$DryProb*100, " %</b>. <br/>",
                   "A stone of <b>", Components.spp$Hit.Size, " mm</b> in diameter can affect the emergence of the seedling. <br/>",
                   "<br/><h4> Your seeds hypocotyl Weibull parameters efect its growth: </h4>",
                   "Grouwth stage one is to <b>", Components.spp$a, " mm</b> elongation of the hypocotal. <br/>",
                   "Poly parameter <i>a</i> <b>", Components.spp$b, ".</b> <br/>",
                   "Poly parameter  <i>b</i> <b>", Components.spp$c, ".</b> <br/>",
                   sep=""))
        
    })
    
    
    
    Get.Components.sow <- function() {
        Components.sow <- read.csv(paste("Default_data/SowLims/", input$Sow.Default, ".csv", sep = ""))
        
        if(input$Data.speshSow) {
            Components.sow$Seeds <- input$Seeds
            Components.sow$x <- input$x
            Components.sow$y <- input$y
            Components.sow$z <- input$z
            Components.sow$SD <- input$SD
            Components.sow$yStyle <- as.numeric(input$yStyle1) + as.numeric(input$yStyle2)
            Components.sow$Run <- input$Run
            Components.sow$Startday <- as.numeric(strftime(input$Startday, format = "%j"))
            Components.sow$CRc <- input$CRc
            Components.sow$DRc1 <- input$DRc1
            Components.sow$DRc2 <- input$DRc2
            if(input$yStyle2 > 1) {
                Components.sow$Sowing.lineS <- input$Sowing.line[1]
                Components.sow$Sowing.lineE <- input$Sowing.line[2]
                if(input$yStyle2 > 11) {
                    Components.sow$Sowing.line2S <- input$Sowing.line2[1]
                    Components.sow$Sowing.line2E <- input$Sowing.line2[2]
                }
            }
        }
        
        #print(Components.sow)
        Components.sow
    }
    
    output$text.sow <- renderUI({
        Components.sow <- Get.Components.sow()
        HTML(paste("<h4> Your are sowing ", Components.sow$Seeds, " seeds, in the folowing plot: </h4>",
                   "Plot <i>Width</i> is <b>", Components.sow$x/1000, " meters </b> <br/>",
                   "Plot <i>Length</i> is <b>", Components.sow$y/1000, " meters </b> <br/>",
                   "Plot <i>Depth</i> is <b>", Components.sow$z/10, " cm </b>(the depth of soil modelled) <br/>",
                   "The <i>Sowing Depth</i> of the seed is <b>", Components.sow$SD/10, " cm </b> <br/>",
                   "The seed is sown <b>", if((Components.sow$yStyle %% 10) == 0) {"Randomly"} else{"Evenly"}, " ", if(Components.sow$yStyle < 5) {"all over the plot"} else {paste("in ", if(Components.sow$yStyle > 15) {"two rows"} else {"a row"})}, "</b>. <br/>",
                   "<br/><h4> The time of sowing: </h4>",
                   "The seeds are modelled for <b>", Components.sow$Run, " Days </b> <br/>",
                   "Seeds are sown on <b>",format(strptime(Components.sow$Startday, "%j"), format="%B %d"),"</b> or <i><b>", Components.sow$Startday, "</i> day of the year</b>. <br/>",
                   "<br/><h4> Soil Crusting: </h4>",
                   "The total accumulated rainfall for the soil to crust is <b>", Components.sow$CRc, " mm </b> <br/>",
                   "However if it rains <b>", Components.sow$DRc1, " mm</b> in one day it will crust. <br/>",
                   "Yet if it rains <b>", Components.sow$DRc2, " mm</b> the day the seedling reaches the surface it will find it moist. <br/>",
                   sep=""))
        
    })
    
    
    Run.Model <- function() {
        if(input$RUN == 0)
            return()
        
        progress <- shiny::Progress$new(min = 0, max = 100)##
        on.exit(progress$close())##
        progress$set(message = "Seting up Model", value = 0)##
        
        if(input$el) {el <- 1; progress$inc(1, detail = paste("Elipses used"))} else {el <- 0; progress$inc(1, detail = paste("Elipses Not used"))}
        
        EnviroData <- Enviro.table()
        write.csv(EnviroData, "Model/Temp.Data/EnviroData.csv", row.names=FALSE)
        SeedLims <- Seed.table()
        write.csv(SeedLims, "Model/Temp.Data/SeedLims.csv", row.names=FALSE)
        WaterLims <- Seed.Wtable()
        write.csv(WaterLims, "Model/Temp.Data/WaterLims.csv", row.names=FALSE)
        ClodLims <- Clod.table()
        write.csv(ClodLims, "Model/Temp.Data/ClodLims.csv", row.names=FALSE)
        
        progress$inc(3, detail = paste("Loaded Data"))##
        
        options <- Get.Components.spp()
        Tb.germ <- as.numeric(options$Tb.germ)
        Tb.elomg <- as.numeric(options$Tb.elomg)
        Yb.germ <- as.numeric(options$Yb.germ)
        a <- as.numeric(options$a)
        b <- as.numeric(options$b)
        c <- as.numeric(options$c)
        DryProb <- as.numeric(options$DryProb)
        Hit.Size <- as.numeric(options$Hit.Size)
        write.csv(options, "Model/Temp.Data/Components.spp.csv", row.names=FALSE)
        
        progress$inc(5, detail = paste("Set up Species Variables"))##
        
        options <- Get.Components.sow()
        Sowing.lineS <- as.numeric(options$Sowing.lineS)
        Sowing.lineE <- as.numeric(options$Sowing.lineE)
        Sowing.line2S <- as.numeric(options$Sowing.line2S)
        Sowing.line2E <- as.numeric(options$Sowing.line2E)
        x <- as.numeric(options$x)
        y <- as.numeric(options$y)
        z <- as.numeric(options$z)
        seeds <- as.numeric(options$Seeds)
        SD <- as.numeric(options$SD)
        Run <- as.numeric(options$Run)
        Startday <- as.numeric(options$Startday)
        yStyle <- as.numeric(options$yStyle)
        CRc <- as.numeric(options$CRc)
        DRc1 <- as.numeric(options$DRc1)
        DRc2 <- as.numeric(options$DRc2)
        write.csv(options, "Model/Temp.Data/Components.sow.csv", row.names=FALSE)
        #start modaling
        
        progress$inc(7, detail = paste("Set up Sowing Variables"))##
        
        ERROR_ms <- shell('Py -2 Model/Main.py') ##################################### <- this is the bit that calls python
        
        output.sum <- read.csv("Model/Temp.Data/summ.csv")
        
        progress$inc(100, detail = paste("Summary Calculated"))##
        output.sum$ERROR_ms <- ERROR_ms
        return(output.sum)
        
    }
    
    output$model.summ <- renderUI({
        input$RUN
        isolate({    
            summ <- Run.Model()
        })
        Germ <- round((summ$No.Germed/summ$seeds)*100, digits = 1)
        Emerged <- round((summ$No.Emerge/summ$No.Germed)*100, digits = 1)
        StopedClod <- round((summ$No.StopedClod/summ$No.NEmerge)*100, digits = 1)
        StopedCrust <- round((summ$No.StopedCrust/summ$No.NEmerge)*100, digits = 1)
        ERROR_ms <- summ$ERROR_ms
        if (is.null(ERROR_ms)) {
            ERROR_ms <- "Not Run Yet"
        }
        if (ERROR_ms == 0) {
            ERROR_ms <- "Model Run Successfull"
        }
        if (is.numeric(ERROR_ms) && ERROR_ms > 0) {
            ERROR_ms <- "Error Model Not Run!<br/>see Log file for Details"
        }
        HTML(paste("<center><h4>", Germ, "% of seeds germinated</h4>",
                   "<i> of those </i> <br/>",
                   "<h4>", Emerged, "% Emerged </h4>",
                   "<i> of those that didn't </i> <br/>",
                   "<h4>", StopedClod, "% were stopped by clods </h4>",                  
                   "<i> and </i> <br/>",
                   "<h4>", StopedCrust, "% were stopped by the crust </h4>",
                   "<br/><i><font color=#ff0000>", ERROR_ms , "</i> <br/></center>",
                   
                   sep=""))
    })
    
    
    Main.Graph <- function() {
        if(input$mainPlt == 0)
            return(box3d())
        
        progress <- shiny::Progress$new(min = 0, max = 100)##
        on.exit(progress$close())##
        progress$set(message = "Reading Files", value = 0)##
        
        if(input$use.old.zip){
            seedinfo <- read.csv(unz(filename = "Model/Temp.Data/Seed_info.csv", as.character(input$InputFile.Evrything$datapath)))
            seedbed <- read.csv(unz(filename = "Model/Temp.Data/Clod_info.csv", as.character(input$InputFile.Evrything$datapath)))
            seedloci <- read.csv(unz(filename = "Model/Temp.Data/Seed_cloide.csv", as.character(input$InputFile.Evrything$datapath)))
            options <- read.csv(unz(filename = "Model/Temp.Data/Components.sow.csv", as.character(input$InputFile.Evrything$datapath)))
        }else {
            seedinfo <- read.csv("Model/Temp.Data/Seed_info.csv")
            seedbed <- read.csv("Model/Temp.Data/Clod_info.csv")
            seedloci <- read.csv("Model/Temp.Data/Seed_cloide.csv")
            options <- read.csv("Model/Temp.Data/Components.sow.csv")
        }
        
        progress$inc(1, detail = paste("Files input"))##
        
        progress$set(message = "Setting up variables", value = 2)##
        
        if(input$el) {el <- 1; progress$inc(3, detail = paste("Elipses used"))} else {el <- 0; progress$inc(3, detail = paste("Elipses Not used"))}
        
        x <- as.numeric(options$x)
        y <- as.numeric(options$y)
        z <- as.numeric(options$z)
        seeds <- as.numeric(options$Seeds)
        SD <- as.numeric(options$SD)
        
        progress$inc(4, detail = paste("Variables up"))##
        progress$set(message = "Making Seedbed", value = 5)##
        
        clodmatrix <- as.matrix(seedbed[,c(4,5,6)])
        with(seedbed, plot3d(clodmatrix, type="n", size=0, col="red", cex=2, box=FALSE, aspect="iso", xlab = "", ylab = "", zlab = "", axes=FALSE))
        points3d(c(x,0,0), c(0,y,0), c(0,0,(z+50)), size=0, alpha =0)
        if(input$qube){box3d()}
        planes3d(a=c(0,x), b=c(0,y), c=-1, d=z, col=input$CSoil, alpha=0.8)
        progress$inc(6, detail = paste("Seedbed finished"))##
        Nobr <- nrow(seedbed)
        
        progress$set(message = "Adding Seedlings", value = 7)##
        progress$inc(8, detail = paste("Calculating", Nobr, "Clod Positions"))##
        prog <- (32/Nobr)##
        if(el == 1) {
            N <- nrow(seedbed)
            set.seed(123)
            positions <- as.matrix(seedbed[,c(4,5,6)])
            sizes <- as.matrix(seedbed[,c(1,2,3)])
            angles <- as.matrix(seedbed[,c(7,8,8)])
            
            rgl.ellipsoids2(positions, sizes, angles, col=input$CClod)
            
        }else {
            for(a in seq(1, Nobr, by=1)) {
                Rdus <- Size(Lenth=seedbed[a,1], Hight=seedbed[a,2], Depth=seedbed[a,3])
                with(seedbed[a,], spheres3d(center.1., center.2., center.3., radius=Rdus, col=input$CClod, alpha=1)) #Map seedbead
                progress$inc((a*prog)+8, detail = paste("Done Clod", a))##
            }
        }
        progress$inc(40, detail = paste("Placing", seeds, "into Seedbed"))##
        prog <- (60/seeds)
        a=1
        stuckT <- c(0,1,2,3,4,5,6)
        for(a in 1:seeds) {
            col <- input$CSeed #black
            
            if(seedloci[a,7] == 'N-Clod') {
                col <- input$CSeed.hit #Stuck Under Clod # vilot
            }
            if(seedloci[a,7] %in% stuckT) {
                if(as.numeric(seedloci[a,7]) > 0 ) {
                    col <- input$CSeed.fail #Failed to Emerge # red
                }
            }
            if(seedloci[a,7] == 'N-around') {
                col <- input$CSeed.cfail #Tryed to Navigate Clod but Failed # blue
            }
            if(seedloci[a,7] == 'Y-around') {
                col <- input$CSeed.sup #Tryed to Navigate Clod and Emerged # aquer
            }
            if(seedloci[a,7] != 'N-Clod' & seedloci[a,7] != 'N-around' & seedloci[a,5] == 1 & seedloci[a,7] == 'y') {
                col <- input$CSeed.best #Emerged without Insedent # green
            }
            
            with(seedloci[a,], points3d(x, y, z, col=input$CSeed)) #Map seedbead # black
            with(seedloci[a,], lines3d(x:x, y:y, z:Hight, col=col)) #Map seedbead
            progress$inc((a*prog)+40, detail = paste("Placing seedling", a, "into Seedbed"))##
        }

    }
    
    
    
    output$Main.plot <- renderWebGL({
        input$mainPlt
        isolate({
            Main.Graph()
            withProgress(message = 'Now rendering the graph',
                         detail = 'Ignore the JavaScript warning', value = 0, {
                             for(pro in seq(0, 1, 0.01)){
                                 incProgress(pro)
                             }
                         })
        })
    }, width = 1200, height = 900)
    
    
    output$RowsUI <- renderUI({
        if(input$yStyle2 < 1){
            return()
        } else {
            out <- sliderInput("Sowing.line", "Start & End of sowing line (mm)", min = 0, max = input$x, value = c(0,1), step = 1)           
        }  
        return(out)
    })
    
    output$RowsUI2 <- renderUI({
        if(input$yStyle2 < 11){
            return()
        } else {
            out <- sliderInput("Sowing.line2", "Start & end of 2nd sowing line (mm)", min = 0, max = input$x, value = c(0,1), step = 1)           
        }  
        return(out)
    })
        
    output$Key <- renderUI({
        HTML(paste("<h3>Legend</h3>",
                   "<h4><u>Main Fetuers</u></h4>",
                   "<font color=", input$CClod, "><b> Clods in the Soil </b> </font color=", input$CClod, "><br/>",
                   "<font color=", input$CSeed, "><b> Seeds in the Soil </b> </font color=", input$CSeed, "><br/>",
                   "<font color=", input$CSoil, "><b> The Soil surface </b> </font color=", input$CSoil, "><br/>",
                   "<h4><u>The Status of the Seedlings</u></h4>",
                   "<font color=", input$CSeed.fail, "><b> Seeds that have failed to emerge </b> </font color=", input$CSeed.fail, "><br/>",
                   "<font color=", input$CSeed.hit, "><b> is stuck under a clod </b> </font color=", input$CSeed.hit, "><br/>",
                   "<font color=", input$CSeed.cfail, "><b> tried to go around a clod and failed </b> </font color=", input$CSeed.cfail, "><br/>",
                   "<font color=", input$CSeed.sup, "><b> tried to go around a clod and emerged </b> </font color=", input$CSeed.sup, "><br/>",
                   "<font color=", input$CSeed.best, "><b> emerged without incident </b> </font color=", input$CSeed.best, "><br/><br/>",
                   sep=""))
    })
    
    
    
    observe({
        if (input$zip.all == 0)
            return()
        
        isolate({
            zip(zipfile = paste(TheDir(), "/", input$zip.name, ".zip", sep = ""), files = "Model/Temp.Data/")
        })
    })
    
    Tree.Data <- function() {
        if(input$use.old.zip){
            summ <- read.csv(unz(filename = "Model/Temp.Data/summ.csv", as.character(input$InputFile.All$datapath)))
        }else {
            summ <- read.csv("Model/Temp.Data/summ.csv")
        }
        
        Data <- matrix(data = NA, nrow = 0, ncol = 4)
        colnames(Data) <- c("Name", "Parent", "Val", "Col")
        
        Data <- rbind(Data, c("All Seed", NA, summ$seeds, 0))
        Data <- rbind(Data, c("Germinated", "All Seed", summ$No.Germed, .1))
        Data <- rbind(Data, c("Not Germinated", "All Seed", summ$No.NGermed, .15))
        Data <- rbind(Data, c("Dead", "Not Germinated", summ$No.Dead, .2))
        Data <- rbind(Data, c("Not Enough TT to Germ", "Not Germinated", summ$No.NuTT.G, .25))
        Data <- rbind(Data, c("Did Not Emerge", "Germinated", summ$No.NEmerge, .3))
        Data <- rbind(Data, c("Emerge", "Germinated", summ$No.Emerge + summ$No.Round, .35))
        Data <- rbind(Data, c("Emerge Without Problem", "Emerge", summ$No.Emerge, .4))
        Data <- rbind(Data, c("Around Clod", "Emerge", summ$No.Round, .45))
        Data <- rbind(Data, c("Hit Crust", "Did Not Emerge", summ$No.StopedCrust, .5))
        Data <- rbind(Data, c("Hit Clod", "Did Not Emerge", summ$No.StopedClod, .55))
        Data <- rbind(Data, c("Not Enough TT to Emerge", "Did Not Emerge", summ$No.NuTT.E, .6))
        Data <- rbind(Data, c("Hit and Stopped", "Hit Clod", summ$No.hitClod, .65))
        Data <- rbind(Data, c("Failed to go Round", "Hit Clod", summ$No.NRound, .7))
        return(Data)
    }
    
    Line.Data <- function() {
        if(input$use.old.zip){
            seedinfo <- read.csv(unz(filename = "Model/Temp.Data/Seed_info.csv", as.character(input$InputFile.All$datapath)))
        }else {
            seedinfo <- read.csv("Model/Temp.Data/Seed_info.csv")
        }
        seedinfo <- seedinfo[,c(1,2,4,5,10)]
        Data <- unique(seedinfo$d)
        NoSeed <- length(unique(seedinfo$i))
        
        Data <- as.data.frame(Data)
        days <- max(Data)
        Data$Emerge <- NA
        Data$Germenated <- NA
        Data$TT <- NA
        
        for(Day in seq(0, days, 1)){
            From <- as.numeric(Day*NoSeed) + 1
            Too <- as.numeric((Day + 1)*NoSeed)
            dat <- seedinfo[c(From:Too),]
            
            Data$TT[Day+1] <- (dat$STTid[1])
            Data$Germinated[Day+1] <- length(dat$Gi[dat$Gi == 1])
            Data$Emerge[Day+1] <- length(dat$Emerge[dat$Emerge == 'y' | dat$Emerge == 'Y-around'])
        }
        Data$Emerge <- Data$Emerge/NoSeed
        Data$Germinated <- Data$Germinated/NoSeed
        
        return(Data)
    }
    
    output$TreeG <- renderGvis({
        if(input$All.Plt == 0)
            return()
        input$All.Plt
        isolate({
            Data <- Tree.Data()
            if(input$flatTree) {
                Data <- as.data.frame(Data[c(1,4,5,8,9,10,12,13,14),], stringsAsFactors = F)
                Data$Parent <- 'All Seed'
                Data$Parent[1] <- NA
            } else {
                Data <- as.data.frame(Data, stringsAsFactors = F)
            }
            tree <- gvisTreeMap(Data, "Name", "Parent", "Val", "Col", options=list(fontSize=16, height=450,width=600))      
        })
    })

    
    output$LineG <- renderGvis({
        if(input$All.Plt == 0)
            return()
        input$All.Plt
        isolate({
            Data <- Line.Data()
            if(input$useTT){
                Area <- gvisAreaChart(Data, xvar = "TT", yvar = c("Emerge", "Germinated"),
                                      options = list(fontSize=12, height=450,width=600,
                                                     hAxis="{title: 'Thermal Time (degDays)'}", vAxis="{title: 'Fraction of Seed'}"))
            } else {
                Area <- gvisAreaChart(Data, xvar = "Data", yvar = c("Emerge", "Germinated"),
                                      options = list(fontSize=12, height=450,width=600, 
                                                     hAxis="{title: 'Time (Days)'}", vAxis="{title: 'Fraction of Seed'}"))
            }
        })
    })
    
    
    observe({
        if (input$TreeD == 0)
            return()
        
        isolate({
            write.csv(Tree.Data(), paste(TheDir(), "/", input$csv.Tree, ".csv", sep = ""), row.names = F)
        })
    })
    
    observe({
        if (input$LineD == 0)
            return()
        
        isolate({
            write.csv(Line.Data(), paste(TheDir(), "/", input$csv.Line, ".csv", sep = ""), row.names = F)
        })
    })
    
    
    observe({
        if (input$DirGet == 0)
            return()
        
        isolate({
            Dir <- choose.dir(getwd(), "Input Destination Folder")
            if(is.na(Dir)) {
                write(getwd(), "Default_data/Dir")
            }else {
                write(Dir, "Default_data/Dir")
            }
            
        })
        
    })
    

    TheDir <- reactive({
        input$DirGet
        Dir <- read.table("Default_data/Dir", sep = "&")
        Dir <- as.character(Dir[1,1])
        Dir
    })
    
    output$DIR <- renderText({
        Dir <- paste(TheDir(), "\\", sep = "")
        Dir
    })
     output$DIR1 <- renderText({
         Dir <- paste(TheDir(), "\\", sep = "")
         Dir
    })
    output$DIR2 <- renderText({
        Dir <- paste(TheDir(), "\\", sep = "")
        Dir
    })
    output$DIR3 <- renderText({
        Dir <- paste(TheDir(), "\\", sep = "")
        Dir
    })
     
    
}) # end shyny server
