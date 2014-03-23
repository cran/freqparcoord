\name{regdiag}
\alias{regdiag}
\alias{regdiagbas}

\title{
Diagnosing regression model fit using parallel coordinates.
}

\description{

Performs parametric regression model fit diagnostics, based on
\link{freqparcoord}.  One axis is the "divergences," the differences
beween the parametric and nonparametric estimates of the population
regression function, while the other axes are the predictor variables.
Note that the divergences are NOT the parametric model residuals, e.g.
differences between fitted model values and response ("Y") values.  

The question addressed is, "In what regions of predictor space is the
parametric fit poorer?"  To answer that, the divergences are
grouped into upper and lower tails; e.g. if \code{tail} is set to 0.10,
we find the data points that have divergences in the lower and upper
10\%, then plot both groups, as well as the middle.

The parallel coordinates plot then can be used to identify regions in
which the parametric model tends to either under- or overpredict the
response, thus indicating possible addition of interaction or
polynomial terms.

Furthermore, in the case for \code{regdiag} in which an \code{lm} object
is input, the adjusted R-squared value for the parametric model and the
R-squared value from the nonparametric fit are computed.  If the
nonparametric value is substantially larger than the parametric one,
this is an indication of some deficiency in the parametric model, thus
providing some quantitative information on whether inclusion of 
interaction and/or polynomial terms may be useful. 

The term \emph{regression} is used in the sense of condtional mean
response given the predictors.  Thus parametric classification models
such as the logistic may also be used, with the regression function
being the condtional probability of response = 1, given the predictors.

}

\usage{
regdiag(regout, tail=0.10, k=NULL, m=5,
      checkna = TRUE, cls = NULL, nchunks = length(cls))
regdiagbas(preds, resp, parest, tail=0.10, k=NULL, m=5,
      checkna = TRUE, cls = NULL, nchunks = length(cls))
}

\arguments{
   \item{regout}{Output of \code{lm} or \code{glm}}
   \item{preds}{Matrix of predictor values.}
   \item{resp}{Vector of response values.}
   \item{parest}{Parametric model estimates of the population
      regression function at the predictor data points.}
   \item{tail}{Proportion of most negative and most positive divergences
      to use in grouping.}
   \item{k}{See \link{freqparcoord}.}
   \item{m}{See \link{freqparcoord}.}
   \item{checkna}{See \link{freqparcoord}.}
   \item{cls}{See \link{freqparcoord}.}
   \item{nchunks}{See \link{freqparcoord}.}
}


\details{ 
The population regression function (including the case of a probability
function in a classification problem) is estimated nonparametrically at the
observation points, using \link{knnreg}.

The nonparametric estimates are subtracted from the parametric ones,
yielding the divergences.  A frequency-parallel coordinates plot is
displayed as described above. 

The R-squared values are available in the situation noted earlier.  The
nonparametric R-squared value is calculated as the squared correlation
between estimated regression value and the response value.

It is possible that in one of the tail groups the response value is
constant, in which case an error message appears.  If so, try a larger
value of \code{tail}.

}

\value{
An object of type "gg" (a \pkg{ggplot2} object, displays when printed), 
with new components added:

   \itemize{
   \item{The nonparametric regression estimates, in \code{nonparest}.}
   \item{In the case of a linear model specified via \code{regout}, the
   adjusted R-squared value for the parametric model, in \code{paramr2},
   and \code{nonparamr2}, the R-squared value from the nonparametric 
   fit.  The latter is the squared correlation between predicted and 
   actual response values} 
  }
}

\author{
Norm Matloff <matloff@cs.ucdavis.edu> and Yingkang Xie
<yingkang.xie@gmail.com>
}

% \keyword{
% }

% \seealso{
% }

\examples{
data(mlb)

lmout <- lm(mlb$Weight ~ mlb$Height + mlb$Age)
p <- regdiag(lmout,0.10,k=50,m=25)
p
# taller, older players are overpredicted, with shorter, younger players
# underpredicted; suggests that adding quadratic terms for Height, Age
# may help in the tails
# let's compare the R-squared values
p$paramr2 
p$nonparamr2 
# not much difference (param. model a bit better), possibly due to 
# small sample size 

# doing it "the long way" (showing use without an lm/glm object)
parest <- lmout$fitted.values
regdiagbas(mlb[c("Height","Age")], mlb$Weight,parest,0.10,k=50,m=25)

data(prgeng)
pg <- prgeng
pg1 <- pg[pg$wageinc >= 40000 & pg$wkswrkd >= 48,]
l1 <- lm(wageinc ~ age+educ+sex,data=pg1)
p <- regdiag(l1)
p
p$paramr2
p$nonparamr2
# young men's wages underpredicted, older women overpredicted; both
# R-squared values low, but nonpar is about 27% higher, indicating room
# for improvement; interaction and polynomial terms may help

\dontrun{
data(newadult)
g1 <- glm(gt50 ~ edu + age + gender + mar, data=newadult, family=binomial)
regdiag(g1)
# parametric model underpredicts older highly-educated married men,
# and overpredicts young female lesser-educated singles; might try adding 
# interaction terms 
}
}


