\name{rmixmvnorm}
\alias{rmixmvnorm}

\title{
Random vectors from mixtures of multivariate normal
distributions.
}

\description{

Generates random vectors from mixtures of multivariate normal
distributions.

}

\usage{
rmixmvnorm(n,dm,nmix,means,covs,wts=rep(1/nmix,nmix)) 
}

\arguments{
   \item{n}{Number of random vectors to generate.}
   \item{dm}{Dimension i.e. length of each random vector.}
   \item{nmix}{Number of components in the mixture.}
   \item{means}{Mean vectors of the MV normal distributions; an R list
      of \code{nmix} vectors of length \code{dm} each}
   \item{covs}{Covariance matrices of the MV normal distributions; an R
      list of \code{nmix} , each \code{d}m x \code{dm}.}
   \item{wts}{Mixture probabilities.}
}


% \details{ 
% }

\value{
An \code{n} by \code{dm} matrix of random vectors of length \code{dm},
grouped by MV normal distribution of origin.
}

\author{
Norm Matloff <matloff@cs.ucdavis.edu> 
}

% \keyword{
% }

% \seealso{
% }



