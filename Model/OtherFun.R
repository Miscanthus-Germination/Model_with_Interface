Size <- function (Lenth, Hight, Depth) {
    #   calculates the radius of an object
    #   reterns: The mean Radius
    a <- Lenth/2
    b <- Hight/2
    c <- Depth/2
    
    Size <- (4/3)*pi*a*b*c  # try Ellipsoid
    #Size <- (Lenth * Hight * Depth) # of a cube ## try Ellipsoid
    Size <- (Size/((3/4)*pi))
    Size <- exp(log(Size)/3) # Calculate raius if it was a sphear
    
    return(Size) 
}