require(HDInterval)

reflection <- function(x){    # this method reverse the HDI interval. So if it was originally 0.7-0.9, it will return 0.1-0.3
  
  x <- (1 - x)
  
  temp <- x[1]
  x[1] <- x[2]
  x[2] <- temp 
  
  return(x)
  
}

compute_posterior_intervals <- function(confidence, observation_vector){    # labels???  
  
    # assigning global variables. 
     assign("credibility_regions", NULL, envir = .GlobalEnv)                                              # empty vector to contain the final intervals. 
     assign("credmass_per_cell", confidence**(1/(length(observation_vector) - 1)),  envir = .GlobalEnv)   # HDI width to calculate for each cell. 
     assign("outcome_size", length(observation_vector), envir = .GlobalEnv)                               # number of outcome types. 
     assign("tree_height", ceiling(log2(outcome_size)), envir =  .GlobalEnv)                              # height of the tree to be parsed by braching()
     assign("granularity", c(0:100000)/100000, envir = .GlobalEnv)                                        # granularity for each HDI func call. 
     assign("observation_vector", observation_vector, envir = .GlobalEnv)                                 # converting vector of observations into a global. 
    
     
  
  branching <- function(left_endpoint, right_endpoint, level, previous_interval = null){ # recursive sub-function that works up the tree.
    
         midpoint = trunc(((left_endpoint + right_endpoint)/2))                   # we always round down for the midpoint, just for convenience.  
  
         
         # the total number of observations for each outcome category, discounted by the distance they are from the top of the tree. 
         a <- sum(observation_vector[left_endpoint:midpoint])    
         b <- sum(observation_vector[(midpoint+1):right_endpoint]) 
         a <- a * 2**(level - tree_height)   
         b <- b * 2**(level - tree_height)
  
        # pseudocounts for each side of a cell. Each outcome type increments them by one. 
        left_base <- length(observation_vector[left_endpoint:midpoint])
        right_base <- length(observation_vector[(midpoint+1):right_endpoint])
        
        # TODO we need a special edge case if only three outcome types. 
        

    if(abs(left_endpoint - right_endpoint) == 1){                    # if they're right next to each other. i.e. at a leaf
          
          current_interval <- hdi(qbeta(p = granularity,  shape1 = right_base + b, shape2 = left_base + a, ncp = 0, lower.tail = TRUE, log.p = FALSE), 
                                  credMass = credmass_per_cell, tol = 1e-5, allowSplit = TRUE )   # this does NOT get returned. REMEMBER: heads/left side is shape 1!  
          
          current_inverse_interval <- reflection(current_interval) 
          
          level <- (level + 1)
          
          new_left_interval <- previous_interval * current_inverse_interval 
          new_right_interval <- previous_interval *  current_interval
          
          credibility_regions <<- append(credibility_regions, new_left_interval)                # probability estimate for the variable on the left side of the beta. 
          credibility_regions <<- append(credibility_regions, new_right_interval)               # ditto for the right
          
          return()
          
          
    } else if (left_endpoint ==  midpoint ){                                               # if the cell only branches on side side instead of two or none. 
          

          current_interval <- hdi(qbeta(p = granularity,  shape1 = right_base + b, shape2 = left_base + a, ncp = 0, lower.tail = TRUE, log.p = FALSE), 
                                  credMass = credmass_per_cell, tol = 1e-5, allowSplit = TRUE )   # this does NOT get returned. REMEMBER: heads/left side is shape 1!  
          
          current_inverse_interval <- reflection(current_interval)
          
          level <- (level + 1)
          
          new_left_interval <- previous_interval * current_inverse_interval 
          
          
          branching(left_endpoint, midpoint, level, new_left_interval)                    
        
          
          credibility_regions <<- append(credibility_regions, current_interval)
          
          
          return()  

            
    }else if(left_endpoint == 1 && right_endpoint == outcome_size){          # if we are at the root
          
          current_interval <- hdi(qbeta(p = granularity,  shape1 = right_base + b, shape2 = left_base + a, ncp = 0, lower.tail = TRUE, log.p = FALSE), 
                                  credMass = credmass_per_cell, tol = 1e-5, allowSplit = TRUE )   # this does NOT get returned. REMEMBER: heads/left side is shape 1!  
          
          current_inverse_interval <- reflection(current_interval) 
          
          level <- (level + 1)
          
          new_left_interval <- current_inverse_interval 
          new_right_interval <- current_interval
          
          branching(left_endpoint, midpoint, level, new_left_interval)                       # the one on the left
          branching(midpoint + 1, right_endpoint, level, new_right_interval)                 # the one on the right
          return()
          
          
          
    } else{                                                      # if we are branching twice i.e. the standard case with an intermediary node. 
          

          current_interval <- hdi(qbeta(p = granularity,  shape1 = right_base + b, shape2 = left_base + a, ncp = 0, lower.tail = TRUE, log.p = FALSE), 
                                  credMass = credmass_per_cell, tol = 1e-5, allowSplit = TRUE )   # this does not get returned. heads/left side is shape 1!  
          
          current_inverse_interval <- reflection(current_interval) 
          
          level <- (level + 1)
          
          
          
          new_left_interval <- previous_interval * current_inverse_interval 
          new_right_interval <- previous_interval *  current_interval
          
          
          # send them up
          
          branching(left_endpoint, midpoint, level, new_left_interval)        # the one on the left
          branching(midpoint + 1, right_endpoint, level, new_right_interval ) # the one on the right
          return()
          
         
          
          
    }
  
  }
  
  
  
  # Branching() gets called here. Assigns the results to credibility_regions, a global variable.
  
  branching(1, length(observation_vector), 1)
  final_estimate_vector <- credibility_regions
  
  
  
  labels_vector  <- vector(mode="character", length = length(observation_vector))
  
  for(i in c(1:length(credibility_regions))){
  
    suffix <- NULL
    
    if(i %% 2 == 1){
      suffix <- 'Lower'
    } else{ 
      suffix <- 'Upper'
    }
    
  
    
    labels_vector[i] <- paste(names(observation_vector)[ceiling(i/2)], suffix, sep = "_")

  }
  
  
  names(final_estimate_vector) <- labels_vector 
  
  # removing all the global variables that we no long have any use for. Cleaning up the namespace. 
  rm(credibility_regions, pos = ".GlobalEnv")  
  rm(credmass_per_cell, pos = ".GlobalEnv")
  rm(outcome_size, pos = ".GlobalEnv")
  rm(tree_height, pos = ".GlobalEnv")
  rm(granularity, pos = ".GlobalEnv" )
  rm(observation_vector, pos = ".GlobalEnv")

  
  
  return(final_estimate_vector)        # TODO change this so that it also returns the labels. 
}








# We call the function down here: 

print('starting...')
samples_vector <- c(4, 66, 16, 43)
names(samples_vector) <- c('A', 'B', 'C', 'D')              # Names for the different (unique) outcomes. 
output <- compute_posterior_intervals(0.95, samples_vector)  

print('finished.')
print('final 95% Confidence Intervals for the variables are:')
print('-------------------------------------------------------------')


print(output)





