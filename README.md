# TechCities Shiny App

Simple Shiny (RStudio web framework) app showing the density of jobs by programming languages available in each city.

## Development Setup

* Download and install the latest R for your OS from http://cran.us.r-project.org/
* Download and install the latest RStudio for your OS from https://www.rstudio.com/products/rstudio/download/#download
* Clone the project

```
$ git clone https://github.com/Softhatch/r-shiny-app.git
$ cd r-shiny-app
```

* Instal the required packages
```
$ R < install.R
```

* Seed the required data for testing
```
$ R < seed.R --no-save
```

## Running the app

```
R -e "shiny::runApp('~/path/to/folder')"
```

