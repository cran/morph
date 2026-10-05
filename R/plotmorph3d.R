plotmorph3d <- function(CARTRIDGE=NULL,
                              colours = c(
                                "red",             # 1 OUTSIDE
                                "green",           # 2 MASS
                                "darkgrey",        # 3 SKIN
                                "brown",           # 4 CRUMB
                                "orange",          # 5 CIRCUIT
                                "pink",            # 6 ANTENNA
                                "cornflowerblue",  # 7 BOND
                                "navy",            # 8 VOID-SKIN
                                "seagreen"         # 9 VOID-VOLUME
                              ),
                              alphas = c(
                                0.00,              # 1 OUTSIDE
                                0.65,              # 2 MASS
                                0.65,              # 3 SKIN
                                0.65,              # 4 CRUMB
                                0.65,              # 5 CIRCUIT
                                0.90,              # 6 ANTENNA
                                0.65,              # 7 BOND
                                0.65,              # 8 VOID-SKIN
                                0.65               # 9 VOID-VOLUME
                              ),
                              voxel_size = 1,
                              show_axes = TRUE,
                              show_box = TRUE,
                              show_wireframe = FALSE,
                              show_labels = FALSE,
                              label_array = NULL,
                              wireframe_colour = "black",
                              wireframe_alpha = 0.5,
                              label_colour = "black",
                              label_cex = 1) {

                                  
  #--------------------------------------------------------------
  #
  # TITLE:     plotmorph3d()
  # FILENAME:  plotmorph3d.R
  # AUTHOR:    TARMO K REMMEL
  # DATE:      5 October 2026 (Tartu)
  # CALLS:
  # CALLED BY:
  # NEEDS:     An inpud morphological segementation result cartridge from runmorph3d()
  # NOTES:
  # ARGS:
  #
  #--------------------------------------------------------------

  morphCode <- CARTRIDGE
  
  if (!requireNamespace("rgl", quietly = TRUE)) {
    stop("Package 'rgl' is required. Install with install.packages('rgl').")
  }

  if (length(dim(morphCode)) != 3) {
    stop("morphCode must be a 3-dimensional array.")
  }

  if (length(colours) != 9) {
    stop("colours must contain exactly 9 colours.")
  }

  if (length(alphas) != 9) {
    stop("alphas must contain exactly 9 values.")
  }

  if (any(alphas < 0 | alphas > 1)) {
    stop("alphas must be between 0 and 1.")
  }

  # Check label array
  if (show_labels) {

    if (is.null(label_array)) {
      stop("label_array must be supplied when show_labels = TRUE.")
    }

    if (!identical(dim(label_array), dim(morphCode))) {
      stop("label_array must have the same dimensions as morphCode.")
    }
  }

  rgl::open3d()

  # ------------------------------------------------------------
  # Plot each morphology class
  # ------------------------------------------------------------

  for (code in 1:9) {

    if (alphas[code] == 0)
      next

    cells <- which(morphCode == code, arr.ind = TRUE)

    if (nrow(cells) == 0)
      next

    n <- nrow(cells)

    xyz <- matrix(
      NA_real_,
      nrow = n * 24,
      ncol = 3
    )

    for (i in seq_len(n)) {

      x0 <- (cells[i, 1] - 1) * voxel_size
      x1 <- cells[i, 1] * voxel_size

      y0 <- (cells[i, 2] - 1) * voxel_size
      y1 <- cells[i, 2] * voxel_size

      z0 <- (cells[i, 3] - 1) * voxel_size
      z1 <- cells[i, 3] * voxel_size

      v <- rbind(

        # Bottom (-Z)
        c(x0, y0, z0),
        c(x1, y0, z0),
        c(x1, y1, z0),
        c(x0, y1, z0),

        # Top (+Z)
        c(x0, y0, z1),
        c(x0, y1, z1),
        c(x1, y1, z1),
        c(x1, y0, z1),

        # Front (-Y)
        c(x0, y0, z0),
        c(x0, y0, z1),
        c(x1, y0, z1),
        c(x1, y0, z0),

        # Back (+Y)
        c(x0, y1, z0),
        c(x1, y1, z0),
        c(x1, y1, z1),
        c(x0, y1, z1),

        # Left (-X)
        c(x0, y0, z0),
        c(x0, y1, z0),
        c(x0, y1, z1),
        c(x0, y0, z1),

        # Right (+X)
        c(x1, y0, z0),
        c(x1, y0, z1),
        c(x1, y1, z1),
        c(x1, y1, z0)
      )

      start <- (i - 1) * 24 + 1
      end   <- i * 24

      xyz[start:end, ] <- v
    }

    rgl::quads3d(
      x = xyz[, 1],
      y = xyz[, 2],
      z = xyz[, 3],
      color = colours[code],
      alpha = alphas[code]
    )
  }

  # ------------------------------------------------------------
  # Determine visible voxels
  # ------------------------------------------------------------

  visible <- which(
    morphCode >= 1 &
    morphCode <= 9 &
    alphas[morphCode] > 0,
    arr.ind = TRUE
  )

  # ------------------------------------------------------------
  # Wireframe
  # ------------------------------------------------------------

  if (show_wireframe && nrow(visible) > 0) {

    for (i in seq_len(nrow(visible))) {

      x0 <- (visible[i, 1] - 1) * voxel_size
      x1 <- visible[i, 1] * voxel_size

      y0 <- (visible[i, 2] - 1) * voxel_size
      y1 <- visible[i, 2] * voxel_size

      z0 <- (visible[i, 3] - 1) * voxel_size
      z1 <- visible[i, 3] * voxel_size

      edges <- rbind(

        # Bottom
        c(x0, y0, z0), c(x1, y0, z0),
        c(x1, y0, z0), c(x1, y1, z0),
        c(x1, y1, z0), c(x0, y1, z0),
        c(x0, y1, z0), c(x0, y0, z0),

        # Top
        c(x0, y0, z1), c(x1, y0, z1),
        c(x1, y0, z1), c(x1, y1, z1),
        c(x1, y1, z1), c(x0, y1, z1),
        c(x0, y1, z1), c(x0, y0, z1),

        # Vertical
        c(x0, y0, z0), c(x0, y0, z1),
        c(x1, y0, z0), c(x1, y0, z1),
        c(x1, y1, z0), c(x1, y1, z1),
        c(x0, y1, z0), c(x0, y1, z1)
      )

      rgl::segments3d(
        x = edges[, 1],
        y = edges[, 2],
        z = edges[, 3],
        color = wireframe_colour,
        alpha = wireframe_alpha
      )
    }
  }

  # ------------------------------------------------------------
  # Labels
  # ------------------------------------------------------------

  if (show_labels && nrow(visible) > 0) {

    labels <- label_array[cbind(
      visible[, 1],
      visible[, 2],
      visible[, 3]
    )]

    x <- (visible[, 1] - 0.5) * voxel_size
    y <- (visible[, 2] - 0.5) * voxel_size
    z <- (visible[, 3] - 0.5) * voxel_size

    rgl::text3d(
      x = x,
      y = y,
      z = z,
      texts = as.character(labels),
      color = label_colour,
      cex = label_cex
    )
  }

  # ------------------------------------------------------------
  # Display settings
  # ------------------------------------------------------------

  rgl::aspect3d(1, 1, 1)

  rgl::par3d(
    scale = c(1, 1, 1),
    FOV = 0
  )

  if (show_axes) {
    rgl::axes3d()

    rgl::title3d(
      xlab = "X",
      ylab = "Y",
      zlab = "Z"
    )
  }

  if (show_box) {
    rgl::box3d()
  }

  invisible(NULL)
  
} # END FUNCTION: plot_morphCode_3d
