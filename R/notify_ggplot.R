#' generate random strings
#'
#' @param len length of random strings
#' @return random strings
#'
#' @importFrom stats runif
rand_strings <- function(len = 16) {
  len <- ifelse(len > 0, len, 16)
  letter <- c("a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p",
              "q","r","s","t","u","v","w","x","y","z","1","2","3","4","5","6",
              "7","8","9","0")
  paste0(letter[round(runif(len, 1, length(letter)))], collapse = "")
}

#' Send a ggplot object to LINE
#'
#' @param message message (chr)
#' @param token the LINE Notify full API token (chr)
#' @param plot ggplot object to save, defaults to last plot displayed
#' @param path path to save plot. (chr)
#' @param scale scaling factor
#' @param width width (defaults to the width of current plotting window)
#' @param height height (defaults to the height of current plotting window)
#' @param units units for width and height when either one is explicitly specified
#'        (in, cm, or mm)
#' @param dpi dpi to use for raster graphics
#' @param limitsize when TRUE (the default), ggsave will not save images larger
#'        than 50x50 inches, to prevent the common error of specifying dimensions in pixels.
#' @param ... other arguments passed to graphics device
#' @return \code{httr} response object (invisibly)
#'
#' @importFrom graphics par
#' @importFrom httr POST
#' @importFrom httr upload_file
#' @importFrom httr add_headers
#' @importFrom httr warn_for_status
#' @importFrom ggplot2 last_plot
#' @importFrom ggplot2 ggsave
#' @export
#' @examples
#' \dontrun{
#' library(ggplot2)
#' Sys.setenv(LINE_API_TOKEN="xxxxxxxxxxxxxxxxxx")
#' data(iris)
#' p <- ggplot(iris, aes(x = Sepal.Width, y = Sepal.Length)) +
#'  geom_point()
#' notify_ggplot("Plotting the Iris", plot = p)
#' }
notify_ggplot <- function(message = "", token = Sys.getenv("LINE_API_TOKEN"),
                        plot = last_plot(), path = NULL, scale = 1,
                        width = par("din")[1], height = par("din")[2], units = c("in", "cm", "mm"),
                        dpi = 300, limitsize = TRUE, ...) {
  if (token == "") {
    stop("No token specified.", call. = FALSE)
  }

  url <- "https://notify-api.line.me/api/notify"

  td <- ifelse(is.null(path), file.path(tempdir(), "line_notify"), path)

  if(!dir.exists(td)) {
    dir.create(td)
  }

  tmp_path <- file.path(td, paste0(rand_strings(16), ".png"))

  ggsave(filename = tmp_path, plot = plot, scale = scale,
         width = width, height = height, units = units, dpi = dpi,
         limitsize = limitsize, ...)

  auth <- paste0("Bearer ", token)
  body <- list(imageFile = httr::upload_file(tmp_path),
               message = message)

  resp <- POST(url,
              httr::add_headers(Authorization = auth),
              body = body,
              encode = "multipart")

  httr::warn_for_status(resp)

  # clean up
  file.remove(list.files(td, full.names = TRUE))
  if(is.null(path)) {
    unlink(td, recursive = TRUE)
  }

  invisible(resp)
}
