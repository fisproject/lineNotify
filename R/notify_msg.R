#' Send a message to LINE
#'
#' @param message message (chr)
#' @param token the LINE Notify personal access token (chr)
#' @return \code{httr} response object (invisibly)
#'
#' @importFrom httr POST
#' @importFrom httr add_headers
#' @importFrom httr warn_for_status
#' @export
#' @examples
#' \dontrun{
#' Sys.setenv(LINE_API_TOKEN="xxxxxxxxxxxxxxxxxx")
#' notify_msg("hello world")
#' }
notify_msg <- function(message, token = Sys.getenv("LINE_API_TOKEN")) {
  if (token == "") {
    stop("No token specified.", call. = FALSE)
  }

  url <- "https://notify-api.line.me/api/notify"

  auth <- paste0("Bearer ", token)

  resp <- POST(url,
              httr::add_headers(Authorization = auth),
              body = list(message = message),
              encode = "multipart")

  httr::warn_for_status(resp)

  invisible(resp)
}
