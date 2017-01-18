pkgTest <- function(x)
{
    if (!require(x, character.only = TRUE))
    {
        install.packages(x,dep=TRUE)
        if(!require(x, character.only = TRUE)) stop("Package not found")
    }
}

# pkgTest("devtools")
pkgTest("shiny")
# pkgTest('googleVis')
# # #pkgTest('Rcpp')
# # #pkgTest('rgl')
# pkgTest('shinyRGL')
# # #install_github("shinyRGL", "trestletech")
# install_github("rgl", "trestletech", "js-class")
# # library("rgl")
# # #library("shinyRGL")


require(devtools)
require(shiny)
require(googleVis)
require(rgl)
require(shinyRGL)