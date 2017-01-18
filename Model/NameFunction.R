Def_Name <- function(Files) {
    Names <- c()
    for (File in Files) {
        Names <- c(Names, substring(File, 1, nchar(File)-4))
    }
    return(Names)
}


