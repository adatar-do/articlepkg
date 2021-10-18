
knit <- function(input, ...) {
  rmarkdown::render(
    input,
    output_format = "all",
    output_file = c(
      paste0(
        stringr::str_remove(xfun::sans_ext(input), "/vignettes"),
        knitr::opts_knit$get("rmarkdown.pandoc.to")[[1]]
      ), paste0(
        stringr::str_remove(xfun::sans_ext(input), "/vignettes"),
        knitr::opts_knit$get("rmarkdown.pandoc.to")[[1]]
      )
    ),
    envir = globalenv()
  )
}
