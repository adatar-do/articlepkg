
#' Custom knit function for rticle
#'
#' @param input The input file to be rendered
#' @param ... other arguments passed to \code{rmarkdown::\link[rmarkdown:render]{render}}
#'
#' @return the compiled document
#' @export
#'
#' @examples
#' \dontrun{
#' ---
#' ...
#' knit: rticle.pkgr::knit
#' ---
#' }
knit <- function(input, ...) {
  rmarkdown::render(
    input,
    output_format = "all",
    output_dir = dirname(dirname(input)),
    envir = globalenv()
  )
}
