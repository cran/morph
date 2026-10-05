

flood_fill_3d <- function(x) {
    
  #--------------------------------------------------------------
  #
  # TITLE:     flood_fill_3d()
  # FILENAME:  morph3d.R
  # AUTHOR:    TARMO K REMMEL
  # DATE:      2 October 2026 (Tartu)
  # CALLS:
  # CALLED BY: runmorph3d()
  # NEEDS:     An inpud data cube (3D array)
  # NOTES:     Moved functionality into separate function to simplify
  #            main morph3d() function.
  # ARGS:      x = A 3D array with categories representing a
  #            a binary feature that is to be processed. This needs to
  #            be a numeric array (it does not need to be integer).
  #
  #            Used to flood-fill the outside of a 3D volume with -1
  #            leaving 0 to identify holes or VOID-VOLUME voxels within
  #            the dataset. All voxels belonging to the feature of interest
  #            are coded as 1. Neighbourhood structure is orthogonal (6-neighbour rule),
  #            whereby voxels (or cells) are considere neighbours if they share a face.
  #
  #--------------------------------------------------------------

  stopifnot(length(dim(x)) == 3L)
  stopifnot(all(x %in% c(-1, 0, 1)))

  d <- dim(x)
  nx <- d[1]
  ny <- d[2]
  nz <- d[3]

  # Identify zero-valued voxels on the outer boundary
  boundary <- array(FALSE, dim = d)
  boundary[c(1, nx), , ] <- TRUE
  boundary[, c(1, ny), ] <- TRUE
  boundary[, , c(1, nz)] <- TRUE

  starts <- which(x == 0 & boundary)

  # Convert array indices to linear indices
  # R's column-major array indexing is used throughout.
  visited <- logical(length(x))
  visited[starts] <- TRUE

  # Queue for breadth-first search
  queue <- integer(sum(x == 0))
  head <- 1L
  tail <- length(starts)

  if (tail > 0L) {
    queue[seq_len(tail)] <- starts
  }

  # Linear index offsets for the six face neighbours
  offsets <- c(
    1L, -1L,
    nx, -nx,
    nx * ny, -nx * ny
  )

  while (head <= tail) {
    idx <- queue[head]
    head <- head + 1L

    # Recover voxel coordinates
    i <- ((idx - 1L) %% nx) + 1L
    j <- (((idx - 1L) %/% nx) %% ny) + 1L
    k <- ((idx - 1L) %/% (nx * ny)) + 1L

    # Check the six face-sharing neighbours
    neighbours <- c(
      if (i > 1L)     idx - 1L,
      if (i < nx)     idx + 1L,
      if (j > 1L)     idx - nx,
      if (j < ny)     idx + nx,
      if (k > 1L)     idx - nx * ny,
      if (k < nz)     idx + nx * ny
    )

    for (nb in neighbours) {
      if (x[nb] == 0 && !visited[nb]) {
        visited[nb] <- TRUE
        tail <- tail + 1L
        queue[tail] <- nb
      }
    }
  }

  # Convert all externally connected zeros to -1
  x[visited] <- -1

  x
  return(x)
  
} # END FUNCTION: flood_fill_3d






cubepadding <- function(INCUBE=NULL) {

  #--------------------------------------------------------------
  #
  # TITLE:     cubepadding()
  # FILENAME:  morph3d.R
  # AUTHOR:    TARMO K REMMEL
  # DATE:      1 October 2026 (Tartu)
  # CALLS:
  # CALLED BY: runmorph3d()
  # NEEDS:     An inpud data cube (3D array)
  # NOTES:     Moved functionality into separate function to simplify
  #            main morph3d() function.
  # ARGS:      INCUBE = A 3D array with categories representing a
  #            a binary feature that is to be processed. This needs to
  #            be a numeric array (it does not need to be integer).
  #
  #            PADVAL = Selects the integer value with which to pad the
  #            array. 0 or -1 provide the two versions required by the code.
  #
  #--------------------------------------------------------------

  # GET DIMENSIONS OF THE INPUT DATA CUBE
  cubedim <- dim(INCUBE)
  
  # MAKE A CUBE THAT IS LARGER BY TWO IN ALL DIMENSIONS
  lrgdatacube <- array(data=0, dim=c(cubedim[1] + 2, cubedim[2] + 2, cubedim[3] + 2))
  # MAKE A SECOND CUBE
  lrgdatacube2 <- lrgdatacube - 1
  
  # PLACE THE ORIGINAL CUBE INSIDE THE NEW LARGER CUBES SUCH THAT THERE ARE ALWAYS ZEROS (0s) ON THE OUTSIDE
  lrgdatacube[2:(cubedim[1] + 1), 2:(cubedim[2] + 1), 2:(cubedim[3] + 1)] <- INCUBE
  lrgdatacube2[2:(cubedim[1] + 1), 2:(cubedim[2] + 1), 2:(cubedim[3] + 1)] <- INCUBE
  
  # RETURN THE PADDED CUBE
  return(list("lrgdatacube"=lrgdatacube, "lrgdatacube2"=lrgdatacube2))
  
} # END FUNCTION: cubepadding
  



initializearrays <- function(INCUBE=NULL) {

  #--------------------------------------------------------------
  #
  # TITLE:     initializearrays()
  # FILENAME:  morph3d.R
  # AUTHOR:    TARMO K REMMEL
  # DATE:      2 October 2026 (Tartu)
  # CALLS:
  # CALLED BY: runmorph3d()
  # NEEDS:     An inpud data cube (3D array)
  # NOTES:     Moved functionality into separate function to simplify
  #            main morph3d() function.
  # ARGS:      INCUBE = A 3D array with categories representing a
  #            a binary feature that is to be processed. This needs to
  #            be a numeric array (it does not need to be integer).
  #
  #            Based on the input array, a series of additional
  #            and necessary objects (arrays) are initialized and returned
  #            to the calling function as a list.
  #
  #            Argument should be INCUBE=DATACUBE
  #
  #--------------------------------------------------------------
    
  # BUILD AN ARRAY FOR HOLDING THE INDEX OF VOXELS IDS
  voxelID <- array(1:prod(dim(INCUBE)), dim=c(dim(INCUBE)[1], dim(INCUBE)[2], dim(INCUBE)[3]))
  # INITIALIZE AN ARRAY FOR HOLDING UNIQUE OBJECT IDS
  objectID <- voxelID * 0
  # INITIALIZE AN ARRAY FOR HOLDING MASS-CORE CODES
  coreCode <- objectID * 0
  # INITIALIZE AN ARRAY FOR HOLDING EXPANDED CORE CODES
  expandedCoreCode <- coreCode
  # INITIALIZE AN ARRAY FOR HOLDING MORPHOLOGY CODES
  morphCode <- objectID
  return(list("voxelID" = voxelID, "objectID" = objectID, "coreCode" = coreCode, "extendedCoreCode" = expandedCoreCode, "morphCode" = morphCode))

} # END FUNCTION: initializearrays



label_objects_3d <- function(x) {

  #--------------------------------------------------------------
  #
  # TITLE:     label_objects_3d()
  # FILENAME:  morph3d.R
  # AUTHOR:    TARMO K REMMEL
  # DATE:      3 October 2026 (Tartu)
  # CALLS:
  # CALLED BY: runmorph3d()
  # NEEDS:     An inpud data cube (3D array)
  # NOTES:
  # ARGS:
  #
  #--------------------------------------------------------------
    
  stopifnot(length(dim(x)) == 3L)
  stopifnot(all(x %in% c(-1, 0, 1)))

  d <- dim(x)
  nx <- d[1]
  ny <- d[2]
  nz <- d[3]

  # Only voxels belonging to objects
  foreground <- which(x == 1)

  # Output: zero for background, unique ID for each object
  labels <- integer(length(x))

  # Queue for breadth-first search
  queue <- integer(length(foreground))

  # Six face-sharing neighbours
  offsets <- c(1L, -1L, nx, -nx,
               nx * ny, -nx * ny)

  n_objects <- 0L

  for (start in foreground) {
    if (labels[start] != 0L) next

    n_objects <- n_objects + 1L
    head <- 1L
    tail <- 1L
    queue[1L] <- start
    labels[start] <- n_objects

    while (head <= tail) {
      idx <- queue[head]
      head <- head + 1L

      i <- ((idx - 1L) %% nx) + 1L
      j <- (((idx - 1L) %/% nx) %% ny) + 1L
      k <- ((idx - 1L) %/% (nx * ny)) + 1L

      neighbours <- c(
        if (i > 1L)  idx - 1L,
        if (i < nx)  idx + 1L,
        if (j > 1L)  idx - nx,
        if (j < ny)  idx + nx,
        if (k > 1L)  idx - nx * ny,
        if (k < nz)  idx + nx * ny
      )

      for (nb in neighbours) {
        if (x[nb] == 1 && labels[nb] == 0L) {
          tail <- tail + 1L
          queue[tail] <- nb
          labels[nb] <- n_objects
        }
      }
    }
  }

  # Return labelled array and object count
  return(list(
    labels = array(labels, dim = d),
    n_objects = n_objects
  ))
} # END FUNCTION: label_objects





interior_voxels_3d <- function(labels) {

  #--------------------------------------------------------------
  #
  # TITLE:     interior_voxels_3d()
  # FILENAME:  morph3d.R
  # AUTHOR:    TARMO K REMMEL
  # DATE:      3 October 2026 (Tartu)
  # CALLS:
  # CALLED BY: runmorph3d()
  # NEEDS:     An inpud data cube (3D array)
  # NOTES:
  # ARGS:
  #
  #--------------------------------------------------------------
    
  d <- dim(labels)
  nx <- d[1]
  ny <- d[2]
  nz <- d[3]

  result <- array(0L, dim = d)

  # Only voxels that can have six neighbours
  for (k in 2:(nz - 1L)) {
    for (j in 2:(ny - 1L)) {
      for (i in 2:(nx - 1L)) {

        object <- labels[i, j, k]

        # Ignore background
        if (object <= 0) next

        # Six face-sharing neighbours
        neighbours <- c(
          labels[i - 1L, j, k],
          labels[i + 1L, j, k],
          labels[i, j - 1L, k],
          labels[i, j + 1L, k],
          labels[i, j, k - 1L],
          labels[i, j, k + 1L]
        )

        # All six neighbours must belong to the same object
        if (all(neighbours == object)) {
          result[i, j, k] <- 2L
        }
      }
    }
  }

  result
  
  return(result)
} # END FUNCTION: interior_voxels_3d




find_adjacent_to_interior <- function(x) {
 
  #--------------------------------------------------------------
  #
  # TITLE:     find_adjacent_to_interior()
  # FILENAME:  morph3d.R
  # AUTHOR:    TARMO K REMMEL
  # DATE:      5 October 2026 (Tartu)
  # CALLS:
  # CALLED BY: runmorph3d()
  # NEEDS:     An inpud data cube (3D array)
  # NOTES:
  # ARGS:
  #
  #--------------------------------------------------------------
    
  d <- dim(x)
  nx <- d[1]
  ny <- d[2]
  nz <- d[3]

  result <- array(0L, dim = d)

  for (k in 1:nz) {
    for (j in 1:ny) {
      for (i in 1:nx) {

        # Only consider currently unassigned voxels
        if (x[i, j, k] != -10) next

        # Check the six face-sharing neighbours
        neighbours <- c(
          if (i > 1L)  x[i - 1L, j, k],
          if (i < nx)  x[i + 1L, j, k],
          if (j > 1L)  x[i, j - 1L, k],
          if (j < ny)  x[i, j + 1L, k],
          if (k > 1L)  x[i, j, k - 1L],
          if (k < nz)  x[i, j, k + 1L]
        )

        # At least one face-sharing neighbour is an interior voxel
        if (any(neighbours == 2L)) {
          result[i, j, k] <- 3L
        }
      }
    }
  }

  result
  return(result)
  
} # END FUNCTION: find_adjacent_to_interior





find_3_adjacent_to_9 <- function(x) {

  #--------------------------------------------------------------
  #
  # TITLE:     find_3_adjacent_to_9()
  # FILENAME:  morph3d.R
  # AUTHOR:    TARMO K REMMEL
  # DATE:      3 October 2026 (Tartu)
  # CALLS:
  # CALLED BY: runmorph3d()
  # NEEDS:     An inpud data cube (3D array)
  # NOTES:
  # ARGS:
  #
  #--------------------------------------------------------------
      
  d <- dim(x)
  nx <- d[1]
  ny <- d[2]
  nz <- d[3]

  result <- array(0L, dim = d)

  for (k in 1:nz) {
    for (j in 1:ny) {
      for (i in 1:nx) {

        # Only consider voxels coded as 3
        if (x[i, j, k] != 3L) next

        # Six face-sharing neighbours
        neighbours <- c(
          if (i > 1L)  x[i - 1L, j, k],
          if (i < nx)  x[i + 1L, j, k],
          if (j > 1L)  x[i, j - 1L, k],
          if (j < ny)  x[i, j + 1L, k],
          if (k > 1L)  x[i, j, k - 1L],
          if (k < nz)  x[i, j, k + 1L]
        )

        # At least one neighbour is coded 9
        if (any(neighbours == 9L)) {
          result[i, j, k] <- 8L
        }
      }
    }
  }

  result
  return(result)
  
} # END FUNCTION: find_3_adjacent_to_9





# ===== START: IDENTIFY CRUMB VOXELS (4) =====
find_thin_features <- function(objectID, morphCode) {

  #--------------------------------------------------------------
  #
  # TITLE:     label_objects_3d()
  # FILENAME:  morph3d.R
  # AUTHOR:    TARMO K REMMEL
  # DATE:      3 October 2026 (Tartu)
  # CALLS:
  # CALLED BY: runmorph3d()
  # NEEDS:     An inpud data cube (3D array)
  # NOTES:
  # ARGS:
  #
  #--------------------------------------------------------------
      
  stopifnot(identical(dim(objectID), dim(morphCode)))

  result <- array(0L, dim = dim(objectID))

  # UNIQUE FEATRUE IDs, EXCLUDING BACKGROUND
  ids <- sort(unique(objectID))
  ids <- ids[ids > 0]

  for(id in ids) {

    # VOXELS BELONGING TO THIS FEATURE
    feature <- objectID == id

    # DOES THIS FEATURE CONTAIN ANY INTERIOR VOXELS?
    has_interior <- any(morphCode[feature] == 2L)

    # IF NOT, CLASSIFY THE ENTIRE FEATURE AS CRUMBS (4)
    if (!has_interior) {
      result[feature] <- 4L
    } # END IF
    
  } # END FOR: id

  result
  return(result)
} # END FUNCTION: find_thin_features
# ===== END: IDENTIFY CRUMB VOXELS (4) =====



classify_remaining_morphology <- function(objectID, morphCode) {

  #--------------------------------------------------------------
  #
  # TITLE:     classify_remaining_morphology()
  # FILENAME:  morph3d.R
  # AUTHOR:    TARMO K REMMEL
  # DATE:      3 October 2026 (Tartu)
  # CALLS:
  # CALLED BY: runmorph3d()
  # NEEDS:     An inpud data cube (3D array)
  # NOTES:
  # ARGS:
  #
  #--------------------------------------------------------------
      
  stopifnot(identical(dim(objectID), dim(morphCode)))

  d <- dim(objectID)
  nx <- d[1]
  ny <- d[2]
  nz <- d[3]

  result <- array(0L, dim = d)

  # ------------------------------------------------------------
  # Helper: return the six face-sharing neighbours of a voxel
  # ------------------------------------------------------------

  get_neighbours <- function(idx) {

    i <- ((idx - 1L) %% nx) + 1L
    j <- (((idx - 1L) %/% nx) %% ny) + 1L
    k <- ((idx - 1L) %/% (nx * ny)) + 1L

    c(
      if (i > 1L)  idx - 1L,
      if (i < nx)  idx + 1L,
      if (j > 1L)  idx - nx,
      if (j < ny)  idx + nx,
      if (k > 1L)  idx - nx * ny,
      if (k < nz)  idx + nx * ny
    )
  }

  # ------------------------------------------------------------
  # Process each feature separately
  # ------------------------------------------------------------

  feature_ids <- sort(unique(objectID))
  feature_ids <- feature_ids[feature_ids > 0]

  for (feature_id in feature_ids) {

    feature <- which(objectID == feature_id)

    # Remaining unassigned voxels in this feature
    unassigned <- feature[morphCode[feature] == -10L]

    if (length(unassigned) == 0L)
      next

    # ----------------------------------------------------------
    # Find connected components of the remaining -10 voxels
    # ----------------------------------------------------------

    unvisited <- rep(TRUE, length(unassigned))
    names(unvisited) <- unassigned

    while (any(unvisited)) {

      start <- as.integer(names(unvisited)[which(unvisited)[1]])

      component <- integer(0)
      queue <- start
      unvisited[as.character(start)] <- FALSE

      head <- 1L

      while (head <= length(queue)) {

        current <- queue[head]
        head <- head + 1L

        component <- c(component, current)

        neighbours <- get_neighbours(current)

        # Only traverse remaining -10 voxels
        neighbours <- neighbours[
          neighbours %in% unassigned &
          unvisited[as.character(neighbours)]
        ]

        if (length(neighbours) > 0L) {

          unvisited[as.character(neighbours)] <- FALSE

          queue <- c(queue, neighbours)
        }
      }

      # --------------------------------------------------------
      # Determine what this -10 component connects to
      # --------------------------------------------------------

      contact_voxels <- integer(0)

      for (v in component) {

        neighbours <- get_neighbours(v)

        # Existing interior-related voxels
        contacts <- neighbours[
          objectID[neighbours] == feature_id &
          morphCode[neighbours] %in% c(2L, 3L, 8L)
        ]

        if (length(contacts) > 0L)
          contact_voxels <- c(contact_voxels, contacts)
      }

      contact_voxels <- unique(contact_voxels)

      # No connection to the established feature
      if (length(contact_voxels) == 0L)
        next

      # --------------------------------------------------------
      # Determine which interior region(s) these contacts belong
      # to.
      #
      # We identify connected components of the interior voxels
      # (code 2) within this object.
      # --------------------------------------------------------

      interior <- feature[morphCode[feature] == 2L]

      # If there are no interiors, this should already have been
      # handled by the code-4 operation.
      if (length(interior) == 0L)
        next

      # Label connected interior regions
      interior_remaining <- interior
      interior_regions <- list()

      while (length(interior_remaining) > 0L) {

        start_i <- interior_remaining[1]

        region <- start_i
        queue_i <- start_i
        interior_remaining <- interior_remaining[
          interior_remaining != start_i
        ]

        head_i <- 1L

        while (head_i <= length(queue_i)) {

          current_i <- queue_i[head_i]
          head_i <- head_i + 1L

          neighbours <- get_neighbours(current_i)

          neighbours <- neighbours[
            neighbours %in% interior_remaining
          ]

          if (length(neighbours) > 0L) {

            region <- c(region, neighbours)

            queue_i <- c(queue_i, neighbours)

            interior_remaining <- interior_remaining[
              !interior_remaining %in% neighbours
            ]
          }
        }

        interior_regions[[length(interior_regions) + 1L]] <- region
      }

      # --------------------------------------------------------
      # Determine which interior regions are contacted.
      #
      # A contact through 3/8 is traced back to its associated
      # interior region.
      # --------------------------------------------------------

      contacted_regions <- integer(0)
      contact_locations <- list()

      for (r in seq_along(interior_regions)) {

        region <- interior_regions[[r]]

        # Find 3/8 voxels associated with this interior region.
        # Start from the interior and expand through 3/8.
        frontier <- region
        visited <- region

        while (length(frontier) > 0L) {

          next_frontier <- integer(0)

          for (v in frontier) {

            neighbours <- get_neighbours(v)

            candidates <- neighbours[
              objectID[neighbours] == feature_id &
              morphCode[neighbours] %in% c(3L, 8L) &
              !neighbours %in% visited
            ]

            if (length(candidates) > 0L) {
              next_frontier <- c(next_frontier, candidates)
            }
          }

          next_frontier <- unique(next_frontier)

          if (length(next_frontier) > 0L) {
            visited <- c(visited, next_frontier)
          }

          frontier <- next_frontier
        }

        # Does this existing interior region connect to the
        # candidate -10 component?
        contacts <- integer(0)

        for (v in visited) {

          neighbours <- get_neighbours(v)

          hits <- neighbours[
            neighbours %in% component
          ]

          contacts <- c(contacts, hits)
        }

        contacts <- unique(contacts)

        if (length(contacts) > 0L) {

          contacted_regions <- c(
            contacted_regions,
            r
          )

          contact_locations[[r]] <- contacts
        }
      }

      contacted_regions <- unique(contacted_regions)

      # --------------------------------------------------------
      # CLASSIFICATION
      # --------------------------------------------------------

      if (length(contacted_regions) >= 2L) {

        # Connects two or more interior regions
        result[component] <- 7L  #5L

      } else if (length(contacted_regions) == 1L) {

        region <- contacted_regions[1]

        contacts <- contact_locations[[region]]

        if (length(contacts) >= 2L) {

          # Connects back to the same interior region
          result[component] <- 5L #6L

        } else {

          # One-way protrusion
          result[component] <- 6L  #7L
        }
      }
    }
  }

  result
  return(result)
  
} # END FUNCTION: classify_remaining_morphology




runmorph3d <- function(DATA=NULL) {

  #--------------------------------------------------------------
  #
  # TITLE:     runmorph3d()
  # FILENAME:  morph3d.R
  # AUTHOR:    TARMO K REMMEL
  # DATE:      5 October 2026 (Tartu, Estonia)
  # CALLS:     cubepadding(), flood_fill_3d(), interior_voxels_3d(), find_adjacent_to_interior(),
  #            find_3_adjacent_to_9(), find_thin_features(), classify_remaining_morphology
  # CALLED BY: NA
  # NEEDS:     An inpud data cube (3D array)
  # NOTES:     A completely re-built function to improve processing
  #            speed, overcome some data size limitations, and to
  #            handle some bugs.
  #
  #            1 OUTSIDE
  #            2 MASS
  #            3 SKIN
  #            4 CRUMB
  #            5 CIRCUIT
  #            6 ANTENNA
  #            7 BOND
  #            8 VOID-SKIN
  #            9 VOID-VOLUME
  #
  #            The following is one example of how the function can be called to produce a
  #            cartridge called 'result' and then plotted, assuming vox is a 3D binary array:
  #
  #            result <- runmorph3d(DATA=vox)
  #            plotmorph3d(result$MORPHCODE, colours=morphCodeColours, alphas=morphCodeAlphas, show_wireframe=TRUE, show_labels=TRUE, label_array=result$MORPHCODE)
  #
  # ARGS:      DATA = A 3D array with categories representing a
  #            a binary feature that is to be processed. This needs to
  #            be a numeric array [0,1]. Here the 1s represent voxels
  #            belonging to the feature of interest and 0s do not.
  #
  # RETURNS:   The function rerurns a list object (cartridge) that
  #            contains the following items:
  #            $DATE       The date/time at which the segmentaiton was run
  #            $NOTE       Statement: "3D Morphological Segmentation"
  #            $INPUTDATA  The input 3D array prior to processing (DATA)
  #            $SUMMARY    A data frame with 9 rows and 4 columns that summarizes
  #                        the number of voxels in each morphological class
  #                        after segmentation.
  #            $MORPHCODE  The 3D array of morphologic classes that can be
  #                        used for plotting and visualizing the spatial
  #                        position of each morphologically classified voxel.
  #
  #--------------------------------------------------------------
    
    # PAD THE VOXEL CUBE TO HAVE LARGER VOLUME TO HANDLE EDGE EFFECTS
    voxPadded <- as.array(cubepadding(INCUBE=DATA))

    # FLOOD FILL TO SEPARATE EXTERNAL VERSUS INTERNAL HOLES
    voxPaddedFilled <- flood_fill_3d(voxPadded[[1]])
    
    # BUILD OBJECT OF OBJECT IDS (DISCONNECTED OBJECTS)
    cat(".....Identifying discrete objects.\n", sep="")
    objectID <- label_objects_3d(voxPaddedFilled)
    nobjects <- objectID[[2]]
    cat(".....There are ", nobjects, " objects to process in the data cube.\n", sep="")
    cat(".....Starting 3D morphological segmentation\n", sep="")
    
    # MAKE A 3D ARRAY TO HOLD RESULTS (-10 MEANS UNASSIGNED MORPH CODE)
    morphCode <- objectID[[1]] * 0 -10
    # MAKE A LAYER OF VOXELIDS
    voxelID <- array(1:prod(dim(voxPadded[[1]])), dim=c(dim(voxPadded[[1]])[1], dim(voxPadded[[1]])[2], dim(voxPadded[[1]])[3]))

    # FILL VOID-VOLUME CODES
    cat(".....Coding VOID-VOLUME (category 9) voxels\n", sep="")
    morphCode[voxPaddedFilled==0] <- 9L

    #nobjects <- objectID[[2]]
    #cat("\n\nThere are ", nobjects, " objects to process in the data cube.\n", sep="")
    #cat("Starting 3D morphological segmentation\n", sep="")

    # FILL OUTSIDE CODES
    cat(".....Coding OUTSIDE (category 1) voxels\n", sep="")
    morphCode[voxPaddedFilled==-1] <- 1L

    # FILL MASS CODES (2)
    cat(".....Coding MASS (category 2) voxels\n", sep="")
    morphCode[interior_voxels_3d(objectID[[1]]) > 0] <- 2L

    # FILL SKIN CODES (3)
    cat(".....Coding SKIN (category 3) voxels\n", sep="")
    morphCode[find_adjacent_to_interior(morphCode) == 3] <- 3L

    # NOW FIX SOME SKIN TO BE VOID-SKIN (8)
    morphCode[find_3_adjacent_to_9(morphCode) == 8] <- 8L

    # FILL CRUMB CODES (4)
    cat(".....Coding CRUMB (category 4) voxels\n", sep="")
    morphCode[find_thin_features(objectID[[1]], morphCode) == 4] <- 4L

    # FILL CIRCUIT, BOND, ANTENNA
    cat(".....Coding CIRCUIT (category 5) voxels\n", sep="")
    cat(".....Coding ANTENNA (category 6) voxels\n", sep="")
    cat(".....Coding BOND (category 7) voxels\n", sep="")
    a <- classify_remaining_morphology(objectID[[1]], morphCode)
    morphCode[a > 0] <- a[a>0]
    
    cat("Done.\n", sep="")

    # BUILD COMPONENTS FOR RETURNED (CARTRIDGE) OF RESULTS
    descriptions <- c("OUTSIDE","MASS","SKIN","CRUMB","CIRCUIT","ANTENNA","BOND","VOID-SKIN","VOID-VOLUME")
    tabsummary <- as.data.frame(table(factor(morphCode, levels = 1:9)))
    pct <- tabsummary[,2]/sum(tabsummary[,2])*100
    tabsummary <- as.data.frame(cbind(1:9, descriptions, tabsummary[,2], pct))
    names(tabsummary) <- c("Code", "Description", "NVoxels", "Percentage")
    tabsummary$Code <- as.integer(tabsummary$Code)
    tabsummary$NVoxels <- as.integer(tabsummary$NVoxels)
    tabsummary$Percentage <- as.numeric(tabsummary$Percentage)
    
    # ASSEMBLE THE RETURN OBJECT LIST
    returnobj <- list("DATE"=date(), "NOTE"=c("3D Morphological Segmentation"), "INPUTDATA"=DATA, "SUMMARY"=tabsummary, "MORPHCODE"=morphCode)
    
    # RETURN THE RESULTS CARTRIDGE
    return(returnobj)

} # END FUNCTION: runmorph3d

