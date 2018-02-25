#' Send a plot to LINE
#'
#' @param message message (chr)
#' @param token the LINE Notify personal access token (chr)
#' @param file prefix for filenames
#' @return \code{httr} response object (invisibly)
#'
#' @importFrom grDevices dev.copy dev.off png
#' @importFrom httr POST
#' @importFrom httr add_headers
#' @importFrom httr upload_file
#' @importFrom httr warn_for_status
#' @importFrom ggplot2 ggsave
#' @export
#' @examples
#' \dontrun{
#' Sys.setenv(LINE_API_TOKEN="xxxxxxxxxxxxxxxxxx")
#' plot(iris)
#' notify_plot("Plotting the Iris")
#' }
notify_plot <- function(message = "", token = Sys.getenv("LINE_API_TOKEN"),
                        file = "line_notify") {
  if (token == "") {
    stop("No token specified.", call. = FALSE)
  }

  url <- "https://notify-api.line.me/api/notify"

  tmp_path <- tempfile(file, fileext = ".png")
  dev.copy(png, file = tmp_path)
  dev.off()

  auth <- paste0("Bearer ", token)
  body <- list(imageFile = httr::upload_file(tmp_path),
               message = message)

  resp <- POST(url,
              httr::add_headers(Authorization = auth),
              body = body,
              encode = "multipart")

  httr::warn_for_status(resp)

  invisible(resp)
}
