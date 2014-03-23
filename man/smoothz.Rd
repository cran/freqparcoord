\name{smoothz}
\alias{smoothz}
\alias{smoothzpred}
\alias{knnreg}
\alias{knndens}

\title{
Smoothing functions.
}

\description{

Routines for k-Nearest Neighbor density and regression estimation,
optionally using parallel computation.

}

\usage{
smoothz(z,sf,k,checkna=TRUE,cls=NULL,nchunks=length(cls),scalefirst=FALSE)
smoothzpred(newx,oldx,oldxregest,checkna=TRUE,cls=NULL,nchunks=length(cls))
knnreg(data,k) 
knndens(data,k) 
}

\arguments{
   \item{z}{The data, in data frame or matrix form.  In the regression
   case, the response variable is assumed to be in the last column.}
   \item{sf}{Smoothing function (unquoted), \code{knnreg} for regression or
   \code{knndens} for density estimation.}
   \item{k}{Number of nearest neighbors.}
   \item{nchunks}{Number of chunks to break the computation into.}
   \item{newx}{New X data to predict from}
   \item{oldx}{X-variable values in the training set.}
   \item{oldxregest}{Estimated regression values in the training set.}
   \item{checkna}{If TRUE, remove any row having at least one NA value.}
   \item{cls}{Cluster to use (see the \code{parallel} package) for
      parallel computation.}
   \item{data}{Data to be smoothed.}
   \item{scalefirst}{Apply \link{scale} to the data before smoothing.}
}

\details{The smoothed values are calculated at the input data points
(needed in this form for another application).  So, for instance, the
i-th value of the output of \code{smoothz} in the regression case is the
estimated regression function at the i-th row of \code{z}.

The density estimates are not mormalized to having total
hypervolume equal to 1.0.

In the case of non-null \code{nchunks}, smoothing is done within-chunk
only.  The smoothed value at a point will be computed only from its
neighbors in the point's chunk.

The \code{smoothzpred} function applies only to the regression case.
It is assumed that \code{smoothz} has been previously called on
\code{oldx}, yielding regression function estimates \code{oldxregest} at
those points.  The \code{smoothzpred} function then finds, for each
point \code{newx[i]}, the closest point \code{oldx[j]} in \code{oldx}, and
uses the corresponding value \code{oldxregest[j]} as the predicted value
at \code{newx[i]}.

}

\value{Vector of smoothed values, or in the case of \code{smoothzpred},
vector of predicted Y values for \code{newx}.  
}

\author{
Norm Matloff <matloff@cs.ucdavis.edu> and Yingkang Xie
<yingkang.xie@gmail.com>
}

\examples{

# programmers and engineers in Silicon Valley, 2000 census, age 25-65
data(prgeng)
pg <- prgeng
pg1 <- pg[pg$age >= 25 & pg$age <= 65,]
estreg <- smoothz(pg1[,c(1,8)],sf=knnreg,k=100)
age <- pg1[,1]
p <- ggplot(data.frame(age,estreg))
p + geom_smooth(aes(x=age,y=estreg))
# peak earnings appear to occur around age 45

}

% \keyword{
% }

% \seealso{
% }


