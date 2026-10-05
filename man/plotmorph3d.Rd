\name{plotmorph3d}
\alias{plotmorph3d}

\title{
A plotting function for morphological segmentation results.
}

\description{
This plot function is intended to be used with a morphological segmentation produced by runmorph3d() and the corresponding cartridge that contains the results (a standardized list object). The function offers many arguments that permit control over what is plotted, in what colours, with how much transparency, whether voxel boundaries are to be drawn and so on. The intent is that this plotting function funs completely independently of the segmentation function and that it can be run on cartridges at any time, rather than relying on plotting only during the segmentation process. This offers greater flexibility and speed. The default is to use standardsized colours and display settings for viewing all morphological codes simultaneously on an interactive 3D output viewer.
}

\usage{
plotmorph3d(CARTRIDGE = NULL, colours = c("red", "green",
    "darkgrey", "brown", "orange", "pink", "cornflowerblue", "navy",
    "seagreen"), alphas = c(0, 0.65, 0.65, 0.65, 0.65, 0.9, 0.65,
    0.65, 0.65), voxel_size = 1, show_axes = TRUE, show_box = TRUE,
    show_wireframe = FALSE, show_labels = FALSE, label_array = NULL,
    wireframe_colour = "black", wireframe_alpha = 0.5, label_colour = "black",
    label_cex = 1)
}

\arguments{
  \item{CARTRIDGE}{
This is the voxel data to be plotted and needs to be produced with morph3dprep() first.
}
  \item{colours}{
An optional vector of colours that are to be used for controlling plot colours for specific categories.
}
  \item{alphas}{
An optional vector of identical length to colours, providing an alpha level (transparency, between 0 and 1) for each colour.
}
  \item{voxel_size}{
A number that controls voxel size in plots. The default is set to 1; likely best to leave it at that until you have a reason to change it.
}
  \item{show_axes}{
A Boolean conrol on whether axes are plotted or not.
}
  \item{show_box}{
A Boolean conrol on whether the bounding box is plotted or not.
}
  \item{show_wireframe}{
A Boolean conrol on whether voxel outlines (the wireframe) are plotted or not.
}
  \item{show_labels}{
A Boolean conrol on whether voxel labels are plotted or not.
}
  \item{label_array}{
If show_labels = TRUE, then provide a 3D array of the same dimensions as the morphological segmentation result with voxel values to be used as voxel labels. The default is to use the $MORPHCODE morphological segmentation results.
}
  \item{wireframe_colour}{
An option to include a colour for drawing the wireframe.
}
  \item{wireframe_alpha}{
An optional numeric value controlling the transparency of the wireframe.
}
  \item{label_colour}{
An optional opportunity to control label colour.
}
  \item{label_cex}{
An optional opportunity to control the size of label text.
}


}

\details{
Output classes are coloured (with varying degrees of transparency to make classes easier to see) as follows. MASS = "green", SKIN = "darkgrey",
CRUMB = "brown", CIRCUIT = "orange", ANTENNA = "pink", BOND = "cornflowerblue", VOID-SKIN = "navy", and VOID-VOLUME = "seagreen".
}

\value{
The output is an interactive 3D rgl plot of the voxels supplied as input. Morphological segmentations produced by runmorph3d() will always have elements drawn in consistent color for ease of interpretation.
}

\references{
Remmel, T.K. 2022. Extending morphological pattern analysis to 3D voxels. Landscape Ecology 37(2):373-380.
}

\author{
Tarmo K. Remmel
}

\note{
No further notes available at this time.
}

\seealso{
See Also \code{\link{runmorph3d}}
}

\examples{


# PERFORM A 3D MORPHOLOGICAL SEGMENTATION TO PRODUCE A RESULT CARTRIDGE
\donttest{result <- runmorph3d(LEdemo)

# CALL THE PLOT FUNCTION
plotmorph3d(result$MORPHCODE)}

}

\keyword{ iplot }
\keyword{ array }
