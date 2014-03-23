\name{freqparcoord}
\alias{freqparcoord}

\title{
Frequency-based parallel coordinates.
}

\description{

A novel approach to the parallel coordinates method for visualizing many
variables at once.

(a) Addresses the screen-clutter problem in parallel coordinates, by only
plotting the "most typical" cases, meaning those with the highest estimated
multivariate density values.  This makes it easier to discern relations
between variables, especially those whose axes are "distant" from each
other.  

(b) One can also plot the "least typical" cases, i.e. those with the
lowest density values, in order to find outliers.  

(c) One can plot only cases that are "local maxima" in terms of density,
as a means of performing clustering.  

}

\usage{
freqparcoord(x,m,dispcols=1:ncol(x),grpvar=NULL,
      method="maxdens",faceting="vert",k=50,klm=5*k,
            keepidxs=NULL,plotidxs=FALSE,cls=NULL)
}

\arguments{
   \item{x}{The data, in data frame or matrix form.  If there are
      indicator }
   \item{m}{Number of lines to plot for each group.  A negative value in
      conjunction with \code{method} being "maxdens" indicates that the
      lowest-density lines are to be plotted.  If \code{method} is
      "locmax", \code{m} is forced to 1.}
   \item{dispcols}{Numbers of the columns of \code{x} to be displayed.}
   \item{grpvar}{Column number for the grouping variable, if any (if none, 
      all the data is treated as a single group); vector or factor.  Must
      not be in \code{dispcols}.  If
      \code{method} is "locmax", \code{grpvar} is forced to NULL}
   \item{method}{What to display:  "maxdens" for plotting the most
      (or least) typical lines, "locmax" for cluster hunting, or 
      "randsamp" for plotting a random sample of lines.}
   \item{faceting}{How to display groups, if present.  Use "vert" for
      vertical stacking of group plots, "horiz" for horizontal ones, or
      "none" to draw all lines in one plot, color-coding by group.}
   \item{k}{Number of nearest neighbors to use for density estimation.}
   \item{klm}{If method is "locmax", number of nearest neighbors to 
      use for finding local maxima for cluster hunting.  Generally needs
      to be much larger than \code{k}, to avoid "noise fitting."}
   \item{keepidxs}{If not NULL, the indices of the rows of \code{x} that 
      are plotted will be stored in a component \code{idxs} of the
      return value.  The rows themselves will be in a component
      \code{xdisp}, ordered by \code{x[,dispcols[1]}.]}
   \item{plotidxs}{If TRUE, lines in the display will be annotated 
      with their case numbers, i.e. their row numbers within \code{x}.  
      Use only with small values of \code{m}, as overplotting may occur.}
   \item{cls}{Cluster, if any (see the \code{parallel} package) for
      parallel computation.}
}


\details{ 

In general, a parallel coordinates plot draws each data point as a
polygonal line.  Say for example we have variables Height, Weight and
Age (inches, pounds, years).  The vertical axes are drawn, one for each
variable.  Then each point, "connects the dots" on the vertical axes.
For instance, the point (70, 160, 28) would be represented as a
segmented line connecting 70 on the Height axis, 160 on the Weight axis
and 28 on the Age axis.  See for example \code{parcoord} in the
\pkg{MASS} package.

The problem with the parallel coordinates method is screen clutter--too
many lines filling the screen. The treatment here avoids this problem by
plotting only the lines having the highest estimated multivariate
density (or variants discussed below).

If \code{method} = "maxdens", the \code{m} most frequent (\code{m}
positive) or least frequent (\code{m} negative) rows of \code{x} will be
plotted from each group, where frequency is measured by density value
(the nongroup case being considered one group).   

If  \code{method = "locmax"}, the rows having the property that their
density value is highest in their \code{klm}-neighborhood will be plotted.  

Otherwise, \code{m} random rows will be displayed.  

The lines will be color-coded according to density value.  Density
values are computed separately within groups.

If \code{cls} is non-null, the computation will be done in parallel.
See \link{knndens}.

The data is centered and scaled using \code{scale} before analysis,
including before any grouping operations.  Thus the selected rows are
still plotted on the scale of the entire data set; for instance, a
vertical axis value of 0 corresponds to the mean of the given variable.
If some variable is constant, scaling is impossible, and an error
message, "arguments imply differing number of rows: 0, 1," will appear.
In such case, try a larger value of \code{m}. 

Density estimation is done through the k-Nearest Neighbor method, in the
function \code{smoothz}.  (Due to use above-mentioned use of
\code{scale}, this is meaningful even if some variables are of the
indicator/dummy type, i.e. 1-0 valued to indicate the presence or
absence of some trait.  This way such variables are comparable to the
continuous ones in the distance compuations.) For any point, the k
nearest data points are found, requiring powers of distances in a
denominator.  With large, discrete data, the denominator may be 0.  In
such cases, it is recommended that you apply \code{jitter} or (from
this package) \code{posjitter}.  The same visual patterns will emerge. 

As with any exploratory tool, the user should experiment with the values
of the arguments, especially the \code{klm} argument with the method
"locmax".  

Note that with long-tailed distributions, the scaled data will be
disproportionately negative.  Thus the magnitude of the scaled variables
should be viewed relative to each other, rather than to 0.

If you use too large a value for \code{k}, it may be larger than some
group size, generating an error message like "k should be less than
sample size."  If so, try a smaller \code{k}.  If a plot would contain
only one line, this may cause a problem with some graphics systems.

}

\value{
Object of type "gg" (\pkg{ggplot2} object), with components \code{idxs}
and \code{xdisp} added if \code{keepidxs} is not NULL (see argument
\code{keepidxs} above).
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
# baseball player data courtesy of UCLA Stat. Dept., www.socr.ucla.edu
data(mlb)

# plot baseball data, broken down by position category (infield,
# outfield, etc.); plot the 5 higest-density values in each group
freqparcoord(mlb,5,4:6,7,method="maxdens")
# we see that the most typical pitchers are tall and young, while the
# catchers are short and heavy

# same, but no grouping
freqparcoord(mlb,5,4:6,method="maxdens")

# find the outliers, 1 for each position 
freqparcoord(mlb,-1,4:6,7)
# for instance we see an infielder of average height and weight, but
# extremely high age, worth looking into

# do the same, but also plot and retain the indices of the rows being
# plotted, and the rows themselves
p <- freqparcoord(mlb,-1,4:6,7,keepidxs=4,plotidxs=TRUE)
p
p$idxs
p$xdisp
# ah, that outlier infielder was case number 674,
# Julio Franco, 48 years old!

# olive oil data courtesy of Dr. Martin Theus
data(oliveoils)
olv <- oliveoils

# there are 9 olive-oil producing areas of Italy, named Area here
# check whether the area groups have distinct patterns (yes)
freqparcoord(olv,1,3:10,1,k=15)

# same check but looking at within-group variation (turns out that some
# variables are more diverse in some areas than others)
freqparcoord(olv,25,3:10,1,k=15)
# yes, definitely, e.g. wide variation in stearic in Sicily

# look at it without stacking the groups
freqparcoord(olv,25,3:10,1,faceting="none",k=15)
# prettier this way, with some patterns just as discernible

\dontrun{
# programmers and engineers in Silicon Valley, 2000 census
data(prgeng)
pg <- prgeng

# compare men and women
freqparcoord(pg,10,dispcols=c(1,3,8),grpvar=7,faceting="horiz")
# men seem to fall into 2 subgroups, one with very low wages; let's get 
# a printout of the plotted points, grouped by gender
p <-
   freqparcoord(pg,10,dispcols=c(1,3,8),grpvar=7,faceting="horiz",keepidxs=7);
p$xdisp
# ah, there are some wages like $3000; delete those and look again;
pg1 <- pg[pg$wageinc >= 40000 & pg$wkswrkd >= 48,]
freqparcoord(pg1,50,dispcols=c(1,3,8),grpvar=7,faceting="horiz",keepidxs=7)
# the women seem to fall in 2 age groups, but not the men, worth further 
# analysis 
# note that all have the same education, a bachelor's degree, the 
# most frequent level

# generate some simulated data with clusters at (0,0), (1,2) and (3,3),
# and see whether "locmax" (clustering) picks them up
cv <- 0.5*diag(2)
x <- rmixmvnorm(10000,2,3,list(c(0,0),c(1,2),c(3,3)),list(cv,cv,cv))
p <- freqparcoord(x,m=1,method="locmax",keepidxs=1,k=50,klm=800)
p$xdisp  # worked well in this case, centers near (0,0), (1,2), (3,3)

# see how well outlier detection works
x <- rmixmvnorm(10000,2,3,list(c(0,0),c(1,2),c(8,8)),list(cv,cv,cv),
   wts=c(0.49,0.49,0.02))
# most of the outliers should be out toward (8,8)
p <- freqparcoord(x,m=-10,keepidxs=1)
p$xdisp
}

}


