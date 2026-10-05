# morph 2.0.0
* Improvements
    * The original code and functionality remain, though there are limitations related to input array size and complexity. The algorithm has been rebuilt from the ground up to run more efficiently. The two new functions, the only ones necessary, are runmorph3d() and plotmorphed().
    * Plotting and segmentation functionality are separated into two different functions, providing greater speed and flexibility.
    * The segmentation algorithm produces a cartridge (list object) that is self-contained and all plotting can readily be performed from the cartridge object. Similarly, the spatial and tabular results, along with the original input data are stored within the cartridge.
    * The cartridge stores the date/time stamp for when the segmentation was performed to help keep data and results organized.
    * Reliance on graphs is reduced to simplify processing and provide gains in processing speed.
    * Plotting is cleaner, more flexible, and offers more options, particularly for plotting from cartridges at any point after segmentation.
    * Manual pages were updated.
    * Dependencies were simplified.
    * Renamed VOID classes to VOID-VOLUME and VOID-SKIN to help clarify what each class means.

# morph 1.2.0
* Improvements
    * Fixed missing NAMESPACE export of necessary function morph3dlinks().
    * Adjusted size of rgl window for 3D plots to make things easier to see.
    * Implemented option to add class values to voxels during plotting with arg PLOTIDS=TRUE when calling morph3d().
    * Removed unnecessary lines of code.
    * Updated data integrity checks.
    * Improved plotting to allow voxel labels to be turned on or off.
* Bugfixes
    * Fixed an occasional bug that hindered VOID and VOID-VOLUME accounting (flood fill issue).

# morph 1.1.0
* Improvements
    * Updated calls to rgl due to depreciated functions in rgl.
    * Changes should work with both old and new versions of rgl.
    * Changes should speed-up drawing.
    * Updated man pages.
* Bugfixes
    * None.

# morph 1.0.0
* Improvements
    * Initial release.
    * Reference to: (Accepted December 2021). Extending morphological pattern segmentation to 3D voxels. Landscape Ecology. is temporary until the final publication details become available. 
* Bugfixes
    * Initial release.
