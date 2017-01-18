source("Model/NameFunction.R")
Enviro.presets <- Def_Name(list.files("default_data/EnviroLims/"))
Seed.presets.lot <- list('All', 'SYN55 Primed', 'SYN55', 'SYN56', 'SYN16', 'SYN58', 'SYN17', 'GNT 2', 'GNT 22', 'GNT 3', 'GNT 4', 'GNT 5', 'GNT 36', 'GNT 1', 'MX300')
Seed.presets.temp <- list('All', '05', '07', '09', '11', '13', '15', '17', '19', '21', '23', '25', '27', '29', '31')
Soil.presets <- Def_Name(list.files("default_data/ClodLims/"))
Spp.presets <- Def_Name(list.files("default_data/SPPLims/"))
Sow.presets <- Def_Name(list.files("default_data/SowLims/"))
Water.presets <- Def_Name(list.files("default_data/WaterLims/"))
Kchoices <- c('Red' = '#FF0000', 'Pink' = '#FFC0CB', 'Orange' = '#FF8C00', 'Tan' = '#FFA54F', 'Red Brown' = '#A52A2A', 'Chocolate' = '#8B4513', 'Green' = '#00FF00', 'Light Green' = '#7CFC00', 'Blue Violet' = '#8A2BE2', 'Violet' = '#663399', 'Blue' = '#0000FF', 'Aqua' = '#458B74', 'Black' = '#000000', 'Gray' = '#555555')

shinyUI(navbarPage("SimPlE Model", id = "NAV", inverse = T,     #mane page
                   tabPanel("Enviro Inputs",        #tab Enviro Inputs
                            shinyUI(fluidPage(       #shyny UI Enviro Inputs
                                fluidRow(            #help section Enviro Inputs
                                    column(12, offset = 0,   #help section panal
                                           h3("Daily Met Data", align = "center"),
                                           tabsetPanel(
                                               tabPanel("Main",
                                                        
                                                        fluidRow(            #shyny row 2
                                                            column(6, wellPanel(tabsetPanel(
                                                                tabPanel("Defaults",
                                                                         h3("Generate Hypothetical Data"),
                                                                         br(),
                                                                         selectInput(inputId = 'Enviro.Default', 'Defaults', Enviro.presets, Enviro.presets[1]),
                                                                         helpText("Note: At the moment only Default is correct others will work in the future."),
                                                                         hr(),
                                                                         br(),
                                                                         hr()
                                                                ),
                                                                tabPanel("Advanced",
                                                                         h3("Generate Hypothetical Data"),
                                                                         br(),
                                                                         h4("Temp"),
                                                                         checkboxInput(inputId = 'useETslider', label = 'Use slider', value = F),
                                                                         sliderInput("MinMax.Temp", "Temp Range", min = -30, max = 50, value = c(3, 15), step = 0.1),
                                                                         radioButtons("Data.Temp.dist", h6('Select The distribution of values for Temp:'),
                                                                                      c("Random" = "rand", "Normal" = "norm"), inline = T),
                                                                         br(),
                                                                         h4("Moisture"),
                                                                         checkboxInput(inputId = 'useEMslider', label = 'Use slider', value = F),
                                                                         sliderInput("MinMax.Most", "Moisture Range", min = 0, max = 1, value = c(0.01, 0.1), step = 0.0001),
                                                                         radioButtons("Data.Moist.dist", h6('Select The distribution of values for Moisture:'),
                                                                                      c("Random" = "rand", "Normal" = "norm"), inline = T),
                                                                         br(),
                                                                         h4("Rainfall"),
                                                                         checkboxInput(inputId = 'useERslider', label = 'Use slider', value = F),
                                                                         sliderInput("MinMax.Rain", "Rainfall Range", min = 0, max = 10, value = c(0.054, 0.16), step = 0.001),
                                                                         radioButtons("Data.Rain.dist", h6('Select The distribution of values for Rainfall:'),
                                                                                      c("Random" = "rand", "Normal" = "norm"), inline = T)
                                                                )
                                                            ))),
                                                            column(6, wellPanel(
                                                                h3("Import Data"),
                                                                br(),
                                                                'File must be a .csv file formatted as below',
                                                                fileInput('InputFile.Enviro', h6('Select File'), multiple = FALSE, accept = '.csv'),
                                                                checkboxInput(inputId = 'Data.Eno', label = 'Use file for data', value = F),
                                                                hr(),
                                                                br(),
                                                                hr(),
                                                                br()
                                                            ))
                                                        ),
                                                        
                                                        fluidRow(
                                                            column(10, offset = 1, wellPanel(
                                                                h3("Data"),
                                                                h4("Example of the data"),
                                                                dataTableOutput('Enviro.table')
                                                            ))
                                                        )  
                                               ),
                                               tabPanel("Help",
                                                        includeMarkdown("help_text/Enviro.Rmd")
                                               )
                                           )
                                    ) #/help section panal
                                )  #/help section Enviro Inputs , for next flued row
                                
                                
                            ))),
                   
                   
                   
                   tabPanel("Seed Inputs",
                            shinyUI(fluidPage(
                                
                                fluidRow(
                                    column(12, offset = 0, 
                                           h3("Seed Germination Data", align = "center"),
                                           tabsetPanel(
                                               tabPanel("Thermal Time",
                                                        fluidRow(
                                                            column(6, wellPanel(tabsetPanel(
                                                                tabPanel("Defaults",
                                                                         h3("Generate Data from TGB Reseults"),
                                                                         br(),
                                                                         selectInput(inputId = 'SeedSet.Default', 'TGB Seeds', Seed.presets.lot, Seed.presets.lot[1]),
                                                                         selectInput(inputId = 'SeedTemp.Default', 'TGB Temp', Seed.presets.temp, Seed.presets.temp[1]),
                                                                         #helpText("Note: At the moment only Default is working others will work in the future."),
                                                                         hr(),
                                                                         br(),
                                                                         hr()
                                                                ),
                                                                tabPanel("Advanced",
                                                                         h3("Generate hypothetical Data"),
                                                                         br(),
                                                                         checkboxInput(inputId = 'useSeedSlider', label = 'Use sliders', value = F),
                                                                         h4("Total proportion of seeds germ"),
                                                                         sliderInput("Germ.TP", "Maximum proportion", min = 0.1, max = 1, value = 0.56, step = 0.01),
                                                                         br(),
                                                                         h4("Thermal Time range"),
                                                                         sliderInput("Germ.Range", "Range of degD", min = 1, max = 1000, value = c(30, 480), step = 1),
                                                                         br(),
                                                                         h4("Thermal Time for Max Germination"),
                                                                         sliderInput("Germ.Peek", "Peek Germ (degD)", min = 1, max = 1000, value = 90, step = 1)
                                                                )
                                                            )
                                                            )),
                                                            column(6, wellPanel(
                                                                h3("Import Data"),
                                                                br(),
                                                                'File must be a .csv file formatted as below',
                                                                fileInput('InputFile.Seed', h6('Select File'), multiple = FALSE, accept = '.csv'),
                                                                checkboxInput(inputId = 'Data.Seed', label = 'Use file for data', value = F),
                                                                hr(),
                                                                br(),
                                                                hr(),
                                                                br()
                                                            ))
                                                        ),
                                                        
                                                        fluidRow(
                                                            column(10, offset = 1, wellPanel(tabsetPanel(
                                                                tabPanel("Data",
                                                                         h4("Example of the data"),
                                                                         dataTableOutput('Seed.table')
                                                                ),
                                                                tabPanel("Graph",
                                                                         h4("Plot of the data"),
                                                                         plotOutput("Seed.plot")
                                                                )
                                                            )
                                                            ))
                                                        )
                                               ),
                                               tabPanel("Water W/V",
                                                        fluidRow(
                                                            column(6, wellPanel(tabsetPanel(
                                                                tabPanel("Defaults",
                                                                         h3("Generate Data from 2015 Test"),
                                                                         br(),
                                                                         selectInput(inputId = 'WaterSet.Default', 'W/V Soil Water', Water.presets, Water.presets[1]),
                                                                         helpText("Note: At the moment only Default is working others will work in the future."),
                                                                         hr(),
                                                                         br(),
                                                                         hr()
                                                                ),
                                                                tabPanel("Advanced",
                                                                         h3("Generate hypothetical Data"),
                                                                         br(),
                                                                         checkboxInput(inputId = 'useWatSlider', label = 'Use sliders', value = F),
                                                                         h4("Total proportion of maximam seeds germ"),
                                                                         sliderInput("Germ.WRange", "Range of W/V Water", min = 0, max = 0.5, value = c(0.04, 0.28), step = .001),
                                                                         br(),
                                                                         h4("Min Water for Germination"),
                                                                         sliderInput("Germ.Wexp", "Exponant", min = 0, max = 20, value = 6, step = .1)
                                                                )
                                                            )
                                                            )),
                                                            column(6, wellPanel(
                                                                h3("Import Data"),
                                                                br(),
                                                                'File must be a .csv file formatted as below',
                                                                fileInput('InputFile.WSeed', h6('Select File'), multiple = FALSE, accept = '.csv'),
                                                                checkboxInput(inputId = 'Data.WSeed', label = 'Use file for data', value = F),
                                                                hr(),
                                                                br(),
                                                                hr(),
                                                                br()
                                                            ))
                                                        ),
                                                        
                                                        fluidRow(
                                                            column(10, offset = 1, wellPanel(tabsetPanel(
                                                                tabPanel("Data",
                                                                         h4("Example of the data"),
                                                                         dataTableOutput('Seed.Wtable')
                                                                ),
                                                                tabPanel("Graph",
                                                                         h4("Plot of the data"),
                                                                         plotOutput("Seed.Wplot")
                                                                )
                                                            )
                                                            ))
                                                        )
                                               ),
                                               tabPanel("Help",
                                                        includeMarkdown("help_text/Seed.Rmd")
                                               )
                                           )
                                    )
                                )
                            ))),
                   
                   
                   
                   tabPanel("Soil Inputs",
                            shinyUI(fluidPage(
                                fluidRow(
                                    column(12, offset = 0, 
                                           h3("Soil/Clod Data", align = "center"),
                                           tabsetPanel(
                                               tabPanel("Main",
                                                        fluidRow(
                                                            column(6, wellPanel(tabsetPanel(
                                                                tabPanel("Main",
                                                                         h3("Generate hypothetical Data"),
                                                                         br(),
                                                                         selectInput(inputId = 'Soil.Default', 'Defaults', Soil.presets, Soil.presets[1]),
                                                                         #helpText("Note: At the moment only Default is working others will work in the future."),
                                                                         hr(),
                                                                         br(),
                                                                         hr()
                                                                ),
                                                                tabPanel("Advanced",
                                                                         h3("Generate hypothetical Data"),
                                                                         checkboxInput(inputId = 'useSoilSlider', label = 'Use sliders', value = F),
                                                                         br(),
                                                                         h4("Clod Range"),
                                                                         sliderInput("MinMax.Clod", "Clod Range (mm)", min = 1, max = 300, value = c(2, 40), step = 1),
                                                                         sliderInput("numb.min.Clod", "Number of smallest clods", min = 1, max = 500, value = 10, step = 1),
                                                                         sliderInput("numb.max.Clod", "Number of largest clods", min = 1, max = 500, value = 10, step = 1),
                                                                         radioButtons("Prob.Serf.Clod", h6('Probabilty clods will be on the surface:'),
                                                                                      c("None" = "no", "less with size" = "LwithS", "More with size" = "MwithS", "All" = "all"), inline = T),
                                                                         br(),
                                                                         h5("Numbers of clods\nare in m2"),
                                                                         
                                                                         br()
                                                                )
                                                            )
                                                            )),
                                                            
                                                            column(6, wellPanel(
                                                                h3("Import Data"),
                                                                br(),
                                                                'File must be a .csv file formatted as below',
                                                                fileInput('InputFile.Clod', h6('Select File'), multiple = FALSE, accept = '.csv'),
                                                                checkboxInput(inputId = 'Data.SoilFil', label = 'Use file for data', value = F),
                                                                hr(),
                                                                br(),
                                                                hr(),
                                                                br()
                                                                
                                                            ))
                                                        ),
                                                        
                                                        fluidRow(
                                                            column(10, offset = 1, wellPanel(
                                                                h3("Data"),
                                                                h4("Example of the data"),
                                                                dataTableOutput('Clod.table')
                                                            ))
                                                        )         
                                                        
                                               ),
                                               tabPanel("Help",
                                                        includeMarkdown("help_text/Soil.Rmd")
                                               )
                                           ))
                                )
                                
                                
                            ))),
                   
                   
                   
                   tabPanel("Sowing Inputs",
                            shinyUI(fluidPage(
                                fluidRow(
                                    column(12, offset = 0,
                                           h3("Sowing Infomation", align = "center"),
                                           tabsetPanel(
                                               tabPanel("Main",
                                                        fluidRow(
                                                            column(6, wellPanel(
                                                                h4("Seed Specifications"),
                                                                tabsetPanel(
                                                                    tabPanel("Defaults",
                                                                             selectInput(inputId = 'Spp.Default', 'Defaults', Spp.presets, Spp.presets[1]),
                                                                             helpText("Note: More can be added in the future."),
                                                                             hr(),
                                                                             br(),
                                                                             hr()
                                                                    ),
                                                                    tabPanel("Seed Advanced",
                                                                             h4("Advanced"),
                                                                             checkboxInput(inputId = 'Data.speshSpp', label = 'Use Advanced settings', value = F),                                                     
                                                                             br(),
                                                                             h5("Growing"),
                                                                             numericInput('Tb.germ', "Base temperature for germination of the seed (C)", 0, min = -10, max = 40, step = .1),
                                                                             numericInput('Tb.elomg', "Base temperature for elongation of the hupercotyl (C)", 0, min = -10, max = 40, step = .1),
                                                                             numericInput('Yb.germ', "Base Water for germination (W/V)", 0.079, min = -1, max = 0, step = .01),
                                                                             br(),
                                                                             h5("Emergence"),
                                                                             numericInput('DryProb', "The probabilty the seedling can get thrugh a dry crust (%)", 0.9, min = 0, max = 1, step = .1),
                                                                             numericInput('Hit.Size', "The minimum size of clod needed to slow or stop the seed (mm)", 5, min = 0.1, max = 100, step = .1),
                                                                             br(),
                                                                             h5("Extra Advanced"),
                                                                             numericInput('a', "Maximam elongation before grouth stage 2 (mm)", 50, min = 1, max = 1000, step = 1),
                                                                             numericInput('b', "First component of a 2nd order polynomial to describe early growth", -0.00008, min = -20, max = 20, step = 0.00001),
                                                                             numericInput('c', "First component of a 2nd order polynomial to describe early growth", 0.1314, min = -20, max = 20, step = 0.00001)
                                                                    )
                                                                )
                                                            )),
                                                            
                                                            column(6, wellPanel(
                                                                h4("Sowing Specifications"),
                                                                tabsetPanel(
                                                                    tabPanel("Sowing Defaults",
                                                                             selectInput(inputId = 'Sow.Default', 'Defaults', Sow.presets, Sow.presets[1]),
                                                                             helpText("Note: More can be added in the future."),
                                                                             hr(),
                                                                             br(),
                                                                             hr()
                                                                             
                                                                    ),
                                                                    tabPanel("Sowing Advanced",
                                                                             h4("Advanced"),
                                                                             checkboxInput(inputId = 'Data.speshSow', label = 'Use Advanced settings', value = F),
                                                                             br(),
                                                                             numericInput("Seeds", "Number of seeds to sow:", min = 1, max = 100000, value = 400, step = 1),
                                                                             h5("Plot Dimensions"),
                                                                             numericInput("x", "Width of Plot (mm)", min = 10, max = 50000, value = 400, step = 1),
                                                                             numericInput("y", "Length of Sowing (mm)", min = 10, max = 50000, value = 1000, step = 1),
                                                                             numericInput("z", "Depth of the hole plot (mm)", min = 1, max = 1000, value = 80, step = 1),
                                                                             numericInput("SD", "Sowing Depth (mm)", min = 1, max = 500, value = 40, step = 1),
                                                                             br(),
                                                                             h5("Sowing Style"),
                                                                             radioButtons(inputId = 'yStyle1', 'Way of sowing seed', c("Random" = 0, "Evan" = 1), inline = T),
                                                                             radioButtons(inputId = 'yStyle2', 'Number of rows to sow', c("No Rows" = 0, "One" = 10, "Two" = 20), inline = T),
                                                                             uiOutput("RowsUI"),
                                                                             uiOutput("RowsUI2"),
                                                                             br(),
                                                                             h5("Day Info"),
                                                                             numericInput("Run", "Number of days to run the model for:", min = 2, max = 364, value = 10, step = 1),
                                                                             dateInput('Startday', 'Day on which to start (dd-mm-yy)', value = '6-30-13', min = '1-1-85', max = '28/12/35', format = "dd-mm-yy"),
                                                                             br(),
                                                                             h5("Crusting"),
                                                                             numericInput('CRc', "Total Rainfall for soil to crust (mm)", 12, min = .1, max = 200, step = .1),
                                                                             numericInput('DRc1', "Daily Rainfall for soil to crust (mm)", 5, min = .1, max = 100, step = .1),
                                                                             numericInput('DRc2', "Daily Rainfall for crust to be moist (mm)", 3.5, min = .1, max = 100, step = .1)
                                                                    )
                                                                )
                                                            ))
                                                            
                                                        ),
                                                        
                                                        
                                                        fluidRow(
                                                            column(6, wellPanel(
                                                                h3("Seed specifications"),
                                                                htmlOutput("text.spp")
                                                                
                                                                
                                                            )),
                                                            column(6, wellPanel(
                                                                h3("Sowing specifications"),
                                                                htmlOutput("text.sow")
                                                                
                                                            ))
                                                        ),
                                                        fluidRow(
                                                            column(7, offset = 0, wellPanel(
                                                                h5("Ready?"),
                                                                helpText("Note: There is normally no need to change these, just press Run"),
                                                                checkboxInput(inputId = 'el', label = 'Use Experimental elipses', value = F),
                                                                br(),
                                                                h5("Run"),
                                                                actionButton('RUN', '', icon("play", "fa-3x") )
                                                            )),
                                                            column(5, offset = 0, wellPanel(
                                                                h5("Done?"),
                                                                htmlOutput("model.summ")
                                                            ))
                                                        )
                                               ),
                                               
                                               tabPanel("Help",
                                                        includeMarkdown("help_text/Sowing.Rmd")
                                               )
                                               
                                           )
                                    )
                                )
                            ))),
                   
                   
                   
                   tabPanel("Seedbed Output",
                            shinyUI(fluidPage(
                                fluidRow(
                                    column(12, offset = 0,
                                           h3("Seed simulation Graph", align = "center"),
                                           tabsetPanel(
                                               tabPanel("Graph",
                                                        fluidRow(
                                                            column(6, offset = 0, wellPanel(
                                                                actionButton('mainPlt', 'Re-Plot'),
                                                                helpText("This will plot a seedbed using the latest data generated by the model"),
                                                                hr(),
                                                                helpText("If you have JavaScript enabled please ignore the warning and wait for the plot")
                                                            )),
                                                            column(6, offset = 0, wellPanel(
                                                                h5("Pick a Zip file with all the data to re-plot a previously saved seedbed"),
                                                                fileInput('InputFile.Evrything', h6('Select File'), multiple = FALSE, accept = c('.zip')),
                                                                checkboxInput(inputId = 'use.old.zip', label = 'use this file for the graph', value = F),
                                                                helpText("You must run this plot using the plot button on the left")                                                            
                                                            ))
                                                        ),         
                                                        fluidRow(
                                                            column(12, offset = 0,
                                                                   webGLOutput("Main.plot", width = 1200, height = 900),
                                                                   htmlOutput("Key"),
                                                                   hr()
                                                            )
                                                        )
                                               ),#/end of tabpanal
                                               tabPanel("Customize Seedbed \n Colors",
                                                        h4('Select if the plot has a border or not'),
                                                        checkboxInput(inputId = 'qube', label = 'Enable Cube', value = T),
                                                        br(),
                                                        h4('Below you can customize the chart colors'),
                                                        selectInput(inputId = 'CClod', label = h5('Clods'), Kchoices, selected = '#A52A2A'),
                                                        hr(),
                                                        selectInput(inputId = 'CSeed', label = h5('Seeds'), Kchoices, selected = '#000000'),
                                                        hr(),
                                                        selectInput(inputId = 'CSoil', label = h5('Soil Surface'), Kchoices, selected = '#8B4513'),
                                                        hr(),
                                                        selectInput(inputId = 'CSeed.fail', label = h5('Failed to Emerge'), Kchoices, selected = '#FF0000'),
                                                        hr(),
                                                        selectInput(inputId = 'CSeed.hit', label = h5('Stuck Under Clod'), Kchoices, selected = '#8A2BE2'),
                                                        hr(),
                                                        selectInput(inputId = 'CSeed.cfail', label = h5('Tried to Navigate Clod but Failed'), Kchoices, selected = '#0000FF'),
                                                        hr(),
                                                        selectInput(inputId = 'CSeed.sup', label = h5('Tried to Navigate Clod and Emerged'), Kchoices, selected = '#458B74'),
                                                        hr(),
                                                        selectInput(inputId = 'CSeed.best', label = h5('Emerged without Incident'), Kchoices, selected = '#00FF00'),
                                                        br()
                                               ),#/end of tabpanal
                                               tabPanel("Help",
                                                        includeMarkdown("help_text/Graph.Rmd")
                                               )
                                           )#/end of tabsetpanal
                                    )#/collom
                                ) #/fluid row
                            ))#/ shiny ui & fluidpage
                   ), #/ Tab Graph out
                   
                   tabPanel("Data Output",
                            shinyUI(fluidPage(
                                fluidRow(
                                    column(12, offset = 0, 
                                           tabsetPanel(
                                               tabPanel(h4("Save Data", align = "center"),
                                                        fluidRow(
                                                            column(12, offset = 0,
                                                                   h5("Save the whole model, so it can be shown again"),
                                                                   textInput("zip.name", "file name", value = "zipofall"),
                                                                   actionButton('zip.all', 'Make a .zip of this whole model'),
                                                                   helpText(paste("This will be saved in...")),
                                                                   uiOutput("DIR1"),
                                                                   hr(),
                                                                   fileInput('InputFile.All', h6('Select File'), multiple = FALSE, accept = c('.zip')),
                                                                   checkboxInput(inputId = 'use.zip', label = 'use this file for the graph', value = F),
                                                                   helpText("If an inported file is used all data & graphs will use that file as a reference"), 
                                                                   hr(),
                                                                   h5("Save specific data as .csv files")
                                                                   
                                                            )
                                                        ),
                                                        
                                                        fluidRow(
                                                            column(8, offset = 2, wellPanel(
                                                                h5("Gremination and Emergence Data"),
                                                                textInput("csv.Line", "file name", value = "Tree"),
                                                                actionButton('LineD', 'Make a .csv of the final states data'),
                                                                helpText(paste("This will be saved in...")),
                                                                uiOutput("DIR2")
                                                            ))
                                                        ),
                                                        fluidRow(
                                                            column(8, offset = 2, wellPanel(
                                                                h5("Customizable over time plot")
                                                            ))
                                                        ),
                                                        fluidRow(
                                                            column(8, offset = 2, wellPanel(
                                                                h5("Final State Data"),
                                                                textInput("csv.Tree", "file name", value = "Tree"),
                                                                actionButton('TreeD', 'Make a .csv of the final states data'),
                                                                helpText(paste("This will be saved in...")),
                                                                uiOutput("DIR3")
                                                            ))
                                                        )
                                                        
                                               ),#/end of tabpanal
                                               tabPanel(h4("Graph Data", align = "center"),
                                                        fluidRow(
                                                            column(12, offset = 0,
                                                                   actionButton('All.Plt', 'Make All plots'),
                                                                   helpText("This will plot using the latest data generated by the model")
                                                            )
                                                        ),
                                                        fluidRow(
                                                            column(10, offset = 1, wellPanel(
                                                                h5("Germination with Time"),
                                                                htmlOutput("LineG"),
                                                                checkboxInput('useTT', 'Use Thermal Time', value = F)
                                                            ))
                                                        ),
                                                        fluidRow(
                                                            column(10, offset = 1, wellPanel(
                                                                h5("No plot yet")
                                                            ))
                                                        ),
                                                        fluidRow(
                                                            column(10, offset = 1, wellPanel(
                                                                h5("A Tree Graph"),
                                                                helpText("of the states of the seed at the end of the experiment"),
                                                                htmlOutput("TreeG"),
                                                                checkboxInput('flatTree', 'Flatten The Tree', value = T)
                                                            ))
                                                        )
                                               ),#/end of tabpanal
                                               tabPanel(h4("Help", align = "center"),
                                                        includeMarkdown("help_text/Data.Rmd")
                                               )#/end of tabpanal
                                           )#/end of tabsetpanal
                                    )#/collom 
                                ) #/fluid row
                            ))#/ shiny ui & fluidpage
                   ), #/ Tab Graph out
                   
                   
                   navbarMenu("Options",
                              tabPanel("Save Location",
                                shinyUI(fluidPage(
                                  fluidRow(
                                      column(10, offset = 1, 
                                             h3("Current output folder"),
                                             uiOutput("DIR"),
                                             hr(),
                                             h3("New output folder"),
                                             actionButton('DirGet', 'Pick a directory to save files in'),
                                             helpText(paste("Defaults to", getwd(), "if selection is cancelled"))
                                             
                                                        )
                                                          ))))
                                
                              )
))