#' Create an article package structure
#'
#' @param path where project will be located
#' @param template base document to use. You can go with the default. Or set any
#'   of the \href{https://pkgs.rstudio.com/rticles/}{rticles} formats.
#'   Theoretically any format that follows the conventions of rticles can be used.
#' @param use_renv controls whether \href{https://rstudio.github.io/renv/index.html}{renv} is used in development
#' @param use_renv_args aditional arguments passed to \code{renv::\link[renv:init]{init}}
#' @param ... other arguments passed to \code{usethis::\link[usethis:create_package]{create_package}}
#'
#' @return [NULL]
#' @export
#'
#' @examples
#' \dontrun{
#'   create_paper_pkg("~/foofactors")
#' }
create_paper_pkg <- function(path,
                             template = Rmdx::rmdx_paper,
                             use_renv = TRUE,
                             use_renv_args = list(),
                             ...
                            ){
  pkg <- as.character(substitute(template))[[2]]

  fn <- as.character(substitute(template))[[3]]

  path <- suppressWarnings(normalizePath(path))

  pp <- stringr::str_split(path, "/")[[1]]
  pp <- stringr::str_split(path, "\\\\")[[1]]

  name <- pp[length(pp)]

  usethis::create_package(path = path, open = FALSE, ...)

  setwd(path)

  usethis::use_vignette(name = name)

  pkg_resource <-  function(...) {system.file(..., package = pkg)}

  templates <- list.dirs(
    paste0(pkg_resource(), "/rmarkdown/templates"),
    recursive = FALSE,
    full.names = FALSE
  )

  temp_dir <- templates[stringr::str_detect(fn, templates)]

  files_list <- list.files(
    pkg_resource(paste0("rmarkdown/templates/", temp_dir, "/skeleton")),
    pattern = ".*[^Rmd]$"
  )

  for (fil in files_list) {
    file.copy(
      pkg_resource(paste0("rmarkdown/templates/", temp_dir, "/skeleton/", fil)),
      paste0(path, "/", "vignettes/", fil)
    )
  }

  rmd <-  pkg_resource("rmarkdown/templates/", temp_dir, "/skeleton/skeleton.Rmd")
  rmd <- readr::read_file(rmd)
  rmd <- stringr::str_replace_all(rmd, "\r\n", "\n")
  rmd <- stringr::str_replace(rmd,
                              "output: ",
                              "output:\n  rmarkdown::html_vignette: default\n  ")
  rmd <- stringr::str_replace(rmd,
                              "\n---",
                              paste0(": default\n",
        "vignette: >\n  \\%\\\\VignetteIndexEntry{", name, "}\n  ",
        "\\%\\\\VignetteEngine{knitr::rmarkdown}\n  ",
        "\\%\\\\VignetteEncoding{UTF-8}\n---"))
  readr::write_file(rmd, file = paste0(path, "/", "vignettes/", name, ".Rmd"))
  if(use_renv){
    do.call(Dmisc::use_renv, c(list(project = path), use_renv_args))
  }
}
