\name{posjitter}
\alias{posjitter}

\title{
Add positive jitter.
}

\description{

Similar to \link{jitter}, but only generating values in (0,1).  A
typical example of use is for an age variable, which in many data sets
is truncated to the lowest integer.

}

\usage{
posjitter(x)
}

\arguments{
   \item{x}{Vector to which jitter is to be added.}
}


% \details{ 
% }

\value{
The vector \code{x + runif(length(x))}.
}

\author{
Norm Matloff <matloff@cs.ucdavis.edu> 
}

% \keyword{
% }

% \seealso{
% }



