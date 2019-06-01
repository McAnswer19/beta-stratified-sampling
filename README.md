# Beta-Stratified-Sampling
An undergraduate poster project I did involving a method of stratified sampling using recursive beta distributions as alternative to applying MCMCC. It is still a work in progress, and the final result will probably involve gradient descent of some kind. The project was heavily inspired by the book "Probability Theory: The Logic Of Science" by E.T. Jaynes. Specifically, the section where he a gives a generalized formula for Laplace's Rule of Succession that works with any number of outcomes. I was intrigued and started working on the project as a possible alternative to frequentist statistical inference. 

For a complete explanation of the algorithm, please take a look at "Recursive Beta Poster Presentation.pdf." It is mostly just a simple recursive application of the beta distribution, but there are a few nuances that make more sense with some knowledge of Bayesianism. 


## Additional goals (when I finally have enough time): 

1. Port the project to python. The algorithms's flow will be much more obvious with a couple of objects. Might also want to consider using cython for speeding up computation on the credibillity intervals. 

2. Do several trial runs to compare the algorithm's performance against the Metropolis–Hastings algorithm on a known dirchlet distribution. 

3. Compute the Bayesian information criterion (BIC) for each cell as well as well as the overall tree. It is likely that a little knowledge of information theory may make the difference in how expectations are calculated. 
