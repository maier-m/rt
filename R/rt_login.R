#' Log in to RT
#'
#' Use this to log into RT at the start of your session.
#'
#' @param user (character) Your username
#' @param pass (character) Your password
#' @param rt_base (character) The base URL that hosts RT for your organization. Set the base URL in your R session using \code{options(rt_base = "https://server.name/rt/")}
#'
#' @export
#'
#' @import stringr
#'
#' @examples
#' \dontrun{
#' options(rt_base = "https://demo.bestpractical.com")
#' rt_login(user = "guest", pass = "guest")
#' }

rt_login <- function(user, pass, rt_base = getOption("rt_base")) {
  if(!is.character(rt_base)){
    stop('Check your base URL. Set it in your R session using option(rt_base = "https://server.name/rt/")', call. = FALSE)
  }

  base_api <- paste(stringr::str_replace(rt_base, "\\/$", ""), # removes trailing slash from base URL just in case
                "REST", "1.0", sep = "/")
  req <- httr::POST(base_api, body = list('user' = user, 'pass' = pass))

  # Check that login worked

  if(stringr::str_detect(httr::content(req), "Credentials required")){
    invisible(FALSE)
    stop("Your log-in was unsuccessful. Check your username, password, and base URL and try again.",
         call. = FALSE)
  } else {
    message("Successfully logged in.")
    invisible(TRUE)
  }
}

#' Log in to RT interactively
#'
#' Wrapper for \code{\link{rt_login}} to interactively log into RT at the start of your
#' session. Keeps your log-in information private.
#'
#' @param rt_base (character) The base URL that hosts RT for your organization. Set the base URL in your R session using \code{options(rt_base = "https://server.name/rt/")}
#'
#' @importFrom getPass getPass
#'
#' @export
#'
#' @examples
#' \dontrun{
#' options(rt_base = "https://demo.bestpractical.com")
#' rt_login_interactive()
#' }

rt_login_interactive <- function(rt_base = getOption("rt_base")) {
  rt_login(user = readline("Enter username: "),
           pass = getPass::getPass(),
           rt_base = rt_base)
}
