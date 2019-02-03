# this is a testbed for testing hypotheses relating to which alogrithm is best for updates. 


reflection <- function(x){    # this one is obvious... 
  
  x <- (1 - x)

  
  # for vectors. 
  temp <- x[1]
  x[1] <- x[2]
  x[2] <- temp 
  
  return(x)
  
}

require(HDInterval)

key <- 0.95**(1/3)
x <- c(0:100000)/100000       

objective_a <- 6
objective_b <- 6
objective_c <- 6 
objective_d  <- 6

objective_ab <- objective_a + objective_b
objective_cd <- objective_c + objective_d

bottom_modifier <- 0.5
top_modifier <- 1         

overall_a <- 0
overall_b <- 0 
overall_c <- 0 
overall_d <- 0 

# Heads/The RIGHT SIDE is shape 1!  ___________________________________________________________________________________________________________________________


 bottom <- hdi(qbeta(p = x,  shape1 = 2 + (objective_cd * bottom_modifier), shape2 = 2 + (objective_ab * bottom_modifier), ncp = 0, lower.tail = TRUE, log.p = FALSE), 
              credMass = key, tol = 1e-5, allowSplit = TRUE ) 

  top_left <- hdi(qbeta(p = x,  shape1 = 1 + (objective_b * top_modifier), shape2 = 1 +(objective_a * top_modifier), ncp = 0, lower.tail = TRUE, log.p = FALSE), 
                credMass = key, tol = 1e-5, allowSplit = TRUE ) # A B 

  top_right <- hdi(qbeta(p = x ,  shape1 = 1 + (objective_d * top_modifier), shape2 = 1 + (objective_c * top_modifier ), ncp = 0, lower.tail = TRUE, log.p = FALSE), 
                 credMass = key, tol = 1e-5, allowSplit = TRUE ) # C D 
  
  
  
  # equal tailed intervals version. certainty = 0.98 cubed. Because I'm lazy. 
 
#  bottom <- qbeta(p = c(0.01, 0.99),  shape1 = 1 + (objective_cd * bottom_modifier), shape2 = 1 + (objective_ab * bottom_modifier), ncp = 0, lower.tail = TRUE, log.p = FALSE) 
               
  
#  top_left <- qbeta(p = c(0.01, 0.99),  shape1 = 1 + (objective_b * top_modifier), shape2 = 1 +(objective_a * top_modifier), ncp = 0, lower.tail = TRUE, log.p = FALSE)  # A B 
  
            
#  top_right <- qbeta(p = c(0.01, 0.99) ,  shape1 = 1 + (objective_d * top_modifier), shape2 = 1 + (objective_c * top_modifier ), ncp = 0, lower.tail = TRUE, log.p = FALSE) # C D 
  
  
 
 
 overall_a <- reflection(bottom)  * reflection(top_left)  # heads/left side is shape 1! 
 overall_b <- reflection(bottom)  * top_left
 overall_c <- bottom * reflection(top_right) 
 overall_d <- bottom * top_right 
 
 
 #For the jiggle problem. Will only get worse when we add more cells. Probably, anyway... 
 # Not a bug? Maybe if only organized according to an ordinal scale... 
 
 # Equal tailed posterior does not work... PROBABLY, ANYWAY 
 
 
 #.... WHAT ELSE IS THERE! 
 
 
 
 
#------------------------------------------------------------------------------------------------------------------------------------------------------------------------
   

print("xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx")
 # this is a test of only three outcomes. 
 
 key <- 0.95**(1/2)

 objective_a <- 44
 objective_b <- 44
 objective_c <- 44 
 objective_d  <- -1   # only three outcomes 
 
 
 objective_bc <- objective_b + objective_c
 
 bottom_modifier <- 0.5
 top_modifier <- 1         
 
# overall_a <- 0
# overall_b <- 0 
# overall_c <- 0 
# overall_d <- -1 
 
 
# bottom <- hdi(qbeta(p = x,  shape1 = 100, shape2 = 3, ncp = 0, lower.tail = TRUE, log.p = FALSE), 
 #               credMass = key, tol = 1e-5, allowSplit = TRUE ) 
 
 
# top_right <- hdi(qbeta(p = x ,  shape1 = 1 + (objective_b * top_modifier), shape2 = 1 + (objective_c * top_modifier ), ncp = 0, lower.tail = TRUE, log.p = FALSE), 
  #                credMass = key, tol = 1e-5, allowSplit = TRUE ) # B C 
 
# overall_a <- reflection(bottom) 
# overall_b <- bottom  * top_right 
# overall_c <- bottom * reflection(top_right) 
 
# print(overall_a[1])
# print(overall_b[1])
# print(overall_c[1])
# print(overall_d[1])


print(bottom)

 
print(overall_a)
print(overall_b)
print(overall_c)
print(overall_d)

   
