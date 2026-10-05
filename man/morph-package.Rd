\name{morph-package}

\alias{morph-package}

\alias{morph}

\docType{package}

\title{
\packageTitle{morph}
}

\description{
\packageDescription{morph}
}

\details{
The DESCRIPTION file:
\packageDESCRIPTION{morph}
\packageIndices{morph}
This package handles the segmentation of binary voxel data, provided as a numeric 3D array, into its constituent morphological classes. Each voxel is assigned to one of nine mutually exclusive morpholocal classes: OUTSIDE, MASS, SKIN, CRUMB, CIRCUIT, ANTENNA, BOND, VOID-SKIN, or VOID-VOLUME.

The current version of morph 2.0.0 is a substantial update to the original release. While the ole functions remain, their use is discouraged. The new version is simpler, cleaner, more adaptable, but maintains consistency in result codes produced. The intent is to retire the original functions in the next release, and to have the current functions persist. The first function is runmorph3d() which processes an input 3D array (representing voxels), to produce a 3D morphological segmentation. The results are stored in a standardized cartridge (a list of objects) that can subsequnetly be passed to plotmorph3d() to handle a wide range of plotting functionality.
}

\author{
\packageAuthor{morph}
Maintainer: \packageMaintainer{morph}
}

\references{
Remmel, T.K. 2022. Extending morphological pattern analysis to 3D voxels. Landscape Ecology 37(2):373-380.
}

\keyword{ package }
\keyword{ manip }
\keyword{ iplot }

\seealso{
See Also \code{\link[reshape2]{melt}}
}

\examples{
# Need to provide some simple examples here.
}
