\name{runmorph3d}
\alias{runmorph3d}

\title{
Performs a morphological segmentation of a binary 3D array
}

\description{
This is the extension of 2D morphological segmentation of binary pixels in a planar raster setting to the 3D domain of voxels. A 3D binary array with 1 (belonging to the feature of interest) and 0 (not belonging to the feature of interest) is the only input required for the mathematical morphological segmentation to proceed. The result is a list object containing the original input data (a results cartridge), the categorical segmentation layer, and various summary outputs that may be necessary at later interpretation stages. The algorithm assigns voxels into mutually exclusive categories: OUTSIDE (1), MASS (2), SKIN (3), CRUMB (4), CIRCUIT (5), ANTENNA (6), BOND (7), VOID-VOLUME (8), and VOID-SKIN (9) based on their relative positioning and connectivity within the feature of interest.
}

\usage{
runmorph3d(DATA = NULL)
}

\arguments{
  \item{DATA}{
This is the input 3D data array. The dimensions do not need to be equal, but the data must be binary integers (0,1).
}
}

\details{
Each voxel can belong to only a single 3D morphological class. The concept expands the planar morphological segmentation avaliable in the MSPA software package and establishes corresponding terminology to distinguish the 3D case. The processessing logic is presented and a fully-functional environment allows any binary 3D data to be processed with this engine. This tool is currenlty limited by dataset size, where processing can take a very long time and produce strange artifacts. Once the segmentation is complete, all plotting options are performed with the function plotmorph3d}

\value{
The function returns a LIST object with the following items:
\item{DATE }{The date and time that the morphological segmentation was performed.}
\item{NOTE }{A simple character string stating "3D Morphological Segmentation" to identify the contents of the cartridge.}
\item{INPUTDATA }{This is the original input 3D data array of 0,1 values.}
\item{SUMMARY }{This is a data.frame summary of the morphological segmentation by class. The classification number (as an integer), the class name, the number of voxels, and the percentage of the total volume is summarized for the actual data processed.}
\item{MORPHCODE }{This is a 3D array containing the morphological code assigned to each voxel. This is the spatial result that corresponds to the tabular SUMMARY above.}
}

\references{
Remmel, T.K. 2022. Extending morphological pattern analysis to 3D voxels. Landscape Ecology 37(2):373-380. DOI: 10.1007/s10980-021-01384-7
}

\author{
Tarmo K. Remmel
}

\note{
Current implementation consideres voxels as neighbours if they share a face only (orthogonal neighbours). Expansion to include diagonal neighbours, where voxels share an edge or a point, are being considered. The use of rgl provides functionality to produce interactive 3D plots that greatly facilitate visualization, but dramatically slow the processing as input volumes increase in size. Avoid plotting unless explicitly required. You are able to plot from the stored list object at anytime afterwards too, it is not necessary to plot during the segmentation call.
}

\seealso{
See Also \code{\link{plotmorph3d}}
}

\examples{
# PERFORM THE 3D SEGMENTATION ON THE DEMO DATA OBJECT
\donttest{result <- runmorph3d(DATA=LEdemo)
# LOOK AT THE STRUCTURE OF THE CARTRIDGE PRODUCED
str(result)
# VIEW THE TABULAR SUMMARY
result$SUMMARY}
}

\keyword{ manip }
\keyword{ array }
