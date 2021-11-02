#' Create an article package structure
#'
#'   `r lifecycle::badge('experimental')`
#'
#' @param path where project will be located
#' @param template base document to use. You can go with the default. Or set any
#'   of the \href{https://pkgs.rstudio.com/rticles/}{rticles} formats.
#'   Theoretically any format that follows the conventions of rticles can be used.
#' @param ... other arguments passed to \code{usethis::\link[usethis:create_package]{create_package}}
#'
#' @return [NULL]
#' @export
#'
#' @examples
#' \dontrun{
#'   create_article_pkg("~/foofactors")
#' }
create_article_pkg <- function(path,
                             template = Rmdx::rmdx_paper,
                             ...
                            ){
  pkg <- as.character(substitute(template))[[2]]

  fn <- as.character(substitute(template))[[3]]

  path <- suppressWarnings(normalizePath(path))

  usethis::create_package(path = path, open = FALSE, ...)

  setwd(path)

  dir.create(paste0(path, "/article"))

  pkg_resource <-  function(pkg0 = pkg, ...) {system.file(..., package = pkg0)}

  templates <- list.dirs(
    paste0(pkg_resource(), "/rmarkdown/templates"),
    recursive = FALSE,
    full.names = FALSE
  )

  temp_dir <- templates[stringr::str_detect(fn, templates)]

  files_list <- list.files(
    paste0(pkg_resource(), "/rmarkdown/templates/", temp_dir, "/skeleton"),
    pattern = ".*[^Rmd]$"
  )

  for (fil in files_list) {
    file.copy(
      paste0(pkg_resource(), "/rmarkdown/templates/", temp_dir, "/skeleton/", fil),
      paste0(path, "/", "article/", fil)
    )
  }

  rmd <-  paste0(pkg_resource(), "/rmarkdown/templates/", temp_dir, "/skeleton/skeleton.Rmd")
  rmd <- readr::read_file(rmd)
  rmd <- stringr::str_replace_all(rmd, "\r\n", "\n")
  inlines <- stringr::str_split(rmd, "\n")[[1]]
  output_opts <- trimws(
    inlines[match(1, stringr::str_detect(inlines, "output:"))]
    ) == "output:"
  rmd <- stringr::str_replace(rmd,
                              "\n---",
                              paste0(ifelse(output_opts, "\n", ": default\n"),
        "knit: articlepkg::knit",
        "\n---"))
  rmd <- stringr::str_replace(rmd,
                              "output: ",
                              "output:\n  rmarkdown::github_document: default\n  ")
  readr::write_file(rmd, file = paste0(path, "/article/index.Rmd"))
}
