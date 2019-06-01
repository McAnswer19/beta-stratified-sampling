# Simple demonstration of the algorithm. Very crude code, with issues still to be worked out. 

require(HDInterval)


# Returns the inverse of a given scalar or vector on the interval 0-1. 
# This is necessary for reversing the credibility region endpoints. 
reflection <- function(x){    
  
  x <- (1 - x)

  
  # for vectors. 
  temp <- x[1]
  x[1] <- x[2]
  x[2] <- temp 
  
  return(x)
  
}


# Some variables for the call to HDI. 
HDI_width_per_cell <- 0.95**(1/3)
granularity <- c(0:100000)/100000       


# The objective counts for each outcome type. i.e. what was actually observed. 
objective_a <- 44
objective_b <- 89
objective_c <- 6 
objective_d  <- 7

objective_ab <- objective_a + objective_b
objective_cd <- objective_c + objective_d


# The modifiers for each level of the tree. See the pdf for a more thorough explanation. 
bottom_modifier <- 0.5
top_modifier <- 1         


# Vectors to hold the final 95% CR's for each variable. 
overall_a <- 0
overall_b <- 0 
overall_c <- 0 
overall_d <- 0 

# Heads/the right side is shape 1!  


 bottom <- hdi(qbeta(p = granularity,  shape1 = 2 + (objective_cd * bottom_modifier), shape2 = 2 + (objective_ab * bottom_modifier), ncp = 0,
                     lower.tail = TRUE, log.p = FALSE), credMass = HDI_width_per_cell, tol = 1e-5, allowSplit = TRUE ) 

  top_left <- hdi(qbeta(p = granularity,  shape1 = 1 + (objective_b * top_modifier), shape2 = 1 +(objective_a * top_modifier), ncp = 0, 
                        lower.tail = TRUE, log.p = FALSE), credMass = HDI_width_per_cell, tol = 1e-5, allowSplit = TRUE ) # A B 

  top_right <- hdi(qbeta(p = granularity ,  shape1 = 1 + (objective_d * top_modifier), shape2 = 1 + (objective_c * top_modifier ), ncp = 0, 
                         lower.tail = TRUE, log.p = FALSE), credMass = HDI_width_per_cell, tol = 1e-5, allowSplit = TRUE ) # C D 



 # Some manual calculation down here, and them we get our final intervals. 

 overall_a <- reflection(bottom)  * reflection(top_left)  # heads/left side is shape 1! 
 overall_b <- reflection(bottom)  * top_left
 overall_c <- bottom * reflection(top_right) 
 overall_d <- bottom * top_right 
 
print('overall_a:', overall_a)
print('overall_b:', overall_b)
print('overall_c:', overall_c)
print('overall_d:', overall_d)


 

   
