# Beta-Stratified-Sampling
An undergraduate poster project I did involving a method of stratified sampling using recursive beta distributions as alternative to applying MCMC. It is still a work in progress, and the final result will probably involve gradient descent of some kind. The project was heavily inspired by the book "Probability Theory: The Logic Of Science" by E.T. Jaynes. Specifically, the section where he gives a generalized formula for Laplace's Rule of Succession that works with any number of outcomes. I was intrigued and started working on the project as a possible alternative to frequentist statistical inference. 

For a complete explanation of the algorithm, please take a look at "Recursive Beta Poster Presentation.pdf." It is mostly just a simple recursive application of the beta distribution, but there are a few nuances that make more sense with some knowledge of Bayesianism. 

I've also added a python port of the code with a few extra features that allow sampling from the tree in various different ways. This is my preferred version as it has the most features and it runs noticibly faster in Python, which allows for easier experimentation.


## Additional goals (when I finally have enough time): 

1. Do several systematic trial runs to compare the algorithm's performance against the Metropolis–Hastings algorithm on a known dirchlet distribution. The best way to do this is with the PYMC library, which I am still trying to self-teach. 

2. Compute the Bayesian information criterion (BIC) for each cell as well as the overall tree. It is likely that a little knowledge of information theory may make a significant difference in how expectations are calculated. 
