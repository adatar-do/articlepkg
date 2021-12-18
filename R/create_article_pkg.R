#' Create an article package structure
#' `r lifecycle::badge('experimental')`
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

  if (stringr::str_detect(path, "/")) {
    pp <- stringr::str_split(path, "/")[[1]]
  } else {
    pp <- stringr::str_split(path, "\\\\")[[1]]
  }

  name <- pp[length(pp)]

  usethis::create_package(path = path, open = FALSE, ...)

  add_article_(path, pkg, fn, name, use_home)
}


#' Add article to existing project
#' `r lifecycle::badge('experimental')`
#'
#' @param name name of the article
#' @param path path to the project
#' @param template_pkg template package to use
#' @param template_fn template function to use
#'
#' @return [NULL]
#'
#' @export
#'
#' @examples
#' \dontrun{
#'   add_article("foolestfactors")
#'
add_article <- function(name,
                        path = getwd(),
                        template_pkg = "Rmdx",
                        template_fn = "rmdx_paper"
){
  add_article_(path, template_pkg, template_fn, name, FALSE)
}


#' Add article to existing project
#' `r lifecycle::badge('experimental')`
#'
#' @param path path to the project
#' @param pkg template package to use
#' @param fn template function to use
#' @param name name of the article
#' @param use_home indicates if home page is used to display the article online version
#'
#' @keywords internal
#'
#' @return [NULL]
add_article_ <- function(path, pkg, fn, name, use_home){

  setwd(path)

  if (use_home) {
    dest <- "article"
    name <- "index"
    # TODO: add files to build ignore
  } else {
    dest <- "vignettes"
  }
  suppressWarnings(dir.create(paste0(path, paste0("/", dest))))

  pkg_resource <- function(pkg, ...) {
    system.file(..., package = pkg)
  }

  templates <- list.dirs(
    paste0(pkg_resource(pkg), "/rmarkdown/templates"),
    recursive = FALSE,
    full.names = FALSE
  )

  temp_dir <- templates[stringr::str_detect(fn, templates)]

  files_list <- list.files(
    paste0(pkg_resource(pkg), "/rmarkdown/templates/", temp_dir, "/skeleton"),
    pattern = ".*[^Rmd]$"
  )

  for (fil in files_list) {
    file.copy(
      paste0(pkg_resource(pkg), "/rmarkdown/templates/", temp_dir, "/skeleton/", fil),
      paste0(path, "/", dest, "/", fil)
    )
  }

  rmd <- paste0(pkg_resource(pkg), "/rmarkdown/templates/", temp_dir, "/skeleton/skeleton.Rmd")
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
  file_path <- paste0(path, "/", dest, "/", name, ".Rmd")
  wrt <- TRUE
  if(file.exists(file_path)){
    if(utils::menu(c("Yes", "No"), title = paste0("Do you want to overwrite the '", name,".Rmd' existing file?")) == 1){
      print("Yes")
    } else {
      message("A file with this name already exists. Please edit this or specify a different name.")
      wrt <- FALSE
    }
  }
  if(wrt){
  readr::write_file(rmd, file = paste0(path, "/", dest, "/", name, ".Rmd"))
  }
}
