#' Web front end
#' 
#' This function starts a local webserver to run the shiny app distributed with
#' the package.
#' 
#' @export
web.flora <- function() {
  if (requireNamespace("shiny", quietly = TRUE)) {
    message("Press escape at any time to stop the application.\n")
    shiny::runApp(system.file("plantminer", package = "flora"))
  } else {
    stop("shiny needed for this function to work. Please install it.",
         call. = FALSE)
  }
  
}