library(DBI)
library(RMySQL)

# Connect to my-db as defined in ~/.my.cnf
initConn <- function(){
  dbConnect(MySQL(), user="root", password="", 
    dbname="tech_cities", host="localhost", client.flag=CLIENT_MULTI_STATEMENTS)
}

getDataBySkill <- function(skill){
  #remove the db credentials and use my.cnf file instead
  con <- initConn()
  sql <- sprintf("Select `id`, sum(`num_rel_jobs`) as total_jobs, `main_city`, `longitude`, `latitude`, `population_2013` from `jobs_geo_census` Where `skill` = '%s' Group by `main_city`;", skill)
  rs <- dbGetQuery(con, sql)
  on.exit(dbDisconnect(con))
  return(rs)
}

getTotalPopBySkill <- function(skill){
  con <- initConn()
  sql <- sprintf("Select sum(`population_2013`) as sum_pop, `main_city` from `jobs_geo_census`
where `skill` = '%s' group by `main_city`;", skill)
  rs <- dbGetQuery(con, sql)
  on.exit(dbDisconnect(con))
  return(rs)
}

getTotalPopByMainCityAndSkill <- function(city, skill){
  con <- initConn()
  sql <- sprintf("Select sum(`population_2013`) as sum_pop, `main_city`, sum(`num_rel_jobs`) as total_jobs, count(`city`) as num_cities from `jobs_geo_census`
where `skill` = '%s' and `main_city` = '%s';", skill, city)
  rs <- dbGetQuery(con, sql)
  on.exit(dbDisconnect(con))
  return(rs)
}

getDataByCity <- function(city, skill){
  con <- initConn()
  sql <- sprintf("Select `city`, `population_2013`, `num_rel_jobs` from `jobs_geo_census`
where `main_city` = '%s' And `skill` = '%s';", city, skill)
  rs <- dbGetQuery(con, sql)
  on.exit(dbDisconnect(con))
  return(rs)
}