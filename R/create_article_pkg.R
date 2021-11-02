#' Create an article package structure
#'
#'   `r lifecycle::badge('experimental')`
#'
#' @param path where project will be located
#' @param template base document to use. You can go with the default. Or set any
#'   of the \href{https://pkgs.rstudio.com/rticles/}{rticles} formats.
#'   Theoretically any format that follows the conventions of rticles can be used.
#' @param use_home indicates if home page is used to display the article online version
#' @param ... other arguments passed to \code{usethis::\link[usethis:create_package]{create_package}}
#'
#' @return [NULL]
#' @export
#'
#' @examples
#' \dontrun{
#' create_article_pkg("~/foofactors")
#' }
create_article_pkg <- function(path,
                               template = Rmdx::rmdx_paper,
                               use_home = TRUE,
                               ...) {
  pkg <- as.character(substitute(template))[[2]]

  fn <- as.character(substitute(template))[[3]]

  path <- suppressWarnings(normalizePath(path))

  if(stringr::str_detect(path, "/")){
    pp <- stringr::str_split(path, "/")[[1]]
  } else {
    pp <- stringr::str_split(path, "\\\\")[[1]]
  }

  name <- pp[length(pp)]

  usethis::create_package(path = path, open = FALSE, ...)

  setwd(path)

  if (use_home) {
    dest <- "article"
    dir.create(paste0(path, paste0("/", dest)))
  } else {
    dest <- "vignettes"
    dir.create(paste0(path, paste0("/", dest)))
  }

  pkg_resource <- function(pkg0 = pkg, ...) {
    system.file(..., package = pkg0)
  }

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
      paste0(path, "/", dest, "/", fil)
    )
  }

  rmd <- paste0(pkg_resource(), "/rmarkdown/templates/", temp_dir, "/skeleton/skeleton.Rmd")
  rmd <- readr::read_file(rmd)
  rmd <- stringr::str_replace_all(rmd, "\r\n", "\n")
  inlines <- stringr::str_split(rmd, "\n")[[1]]
  output_opts <- trimws(
    inlines[match(1, stringr::str_detect(inlines, "output:"))]
  ) == "output:"
  rmd <- stringr::str_replace(
    rmd,
    "\n---",
    paste0(
      ifelse(output_opts, "\n", ": default\n"),
      "knit: articlepkg::knit",
      "\n---"
    )
  )
  rmd <- stringr::str_replace(
    rmd,
    "output: ",
    "output:\n  rmarkdown::github_document: default\n  "
  )
  if (!use_home) {
    rmd <- stringr::str_replace(
      rmd,
      "rmarkdown::github_document",
      "rmarkdown::html_vignette"
    )
    rmd <- stringr::str_replace(
      rmd,
      "knit: articlepkg::knit",
      paste0(
        "vignette: >\n  \\%\\\\VignetteIndexEntry{", name, "}\n  ",
        "\\%\\\\VignetteEngine{knitr::rmarkdown}\n  ",
        "\\%\\\\VignetteEncoding{UTF-8}\nknit: articlepkg::knit"
      )
    )
  }
  readr::write_file(rmd, file = paste0(path, "/", dest,"/", ifelse(use_home, "index", name), ".Rmd"))
}
