
<!-- README.md is generated from README.Rmd. Please edit that file -->

# articlepkg <img src='man/figures/logo.png' align="right" height="138" />

<!-- badges: start -->

[![Project Status: WIP – Initial development is in progress, but there
has not yet been a stable, usable release suitable for the
public.](https://www.repostatus.org/badges/latest/wip.svg)](https://www.repostatus.org/#wip)
[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![R-CMD-check](https://github.com/adatar-do/articlepkg/workflows/R-CMD-check/badge.svg)](https://github.com/adatar-do/articlepkg/actions)
[![Codecov test
coverage](https://codecov.io/gh/adatar-do/articlepkg/branch/main/graph/badge.svg)](https://codecov.io/gh/adatar-do/articlepkg?branch=main)
[![CRAN
status](https://www.r-pkg.org/badges/version/articlepkg)](https://CRAN.R-project.org/package=articlepkg)
<!-- badges: end -->

With the use of this package you will be able to write an article/paper
with the structure and methodology of an [R package
development](https://r-pkgs.org/). Being able to write and keep updated
the functions, data and documents in a structured way. In addition, it
allows you to easily share the entire project or even publish it using
[pkgdown](https://pkgdown.r-lib.org/).

## Installation

articlepkg is not yet in CRAN.

<!-- You can install the released version of articlepkg from [CRAN](https://CRAN.R-project.org) with: -->
<!-- ``` r -->
<!-- install.packages("articlepkg") -->
<!-- ``` -->

You can install the development version from
[GitHub](https://github.com/) with:

``` r
tryCatch(
  library(remotes),
  error = function(e){
    install.packages('remotes')
  }
)
remotes::install_github("adatar-do/articlepkg")
```

## Roadmap

1.  Write the getting started guide.

## Contributing

Have a feedback or want to contribute?

Please take a look at the [contributing
guidelines](https://drdsdaniel.github.io/pipenvr/CONTRIBUTING.html)
before filing an issue or pull request.

Please note that the pipenvr project is released with a [Contributor
Code of
Conduct](https://contributor-covenant.org/version/2/0/CODE_OF_CONDUCT.html).
By contributing to this project, you agree to abide by its terms.

<hr/>

<a href="./articles/articlepkg.html">
  <svg width="50%" height="30" xmlns="http://www.w3.org/2000/svg">
  <linearGradient id="a" x2="0" y2="100%">
    <stop offset="0" stop-color="#bbb" stop-opacity="0.2"/>
  <stop offset="1" stop-opacity="0.1"/>
    </linearGradient>
    <rect rx="4" x="0" width="50%" height="30" fill="#555"/>
    <rect rx="4" x="0" width="50%" height="30" fill="#00a65a"/>
    <rect rx="4" width="50%" height="30" fill="url(#a)"/>
    <g fill="#fff" text-anchor="middle" font-size="18">
    <text x="25%" y="21">Get started</text>
    </g>
    </svg>
    </a>
