library(DBI)
library(RMySQL)

con <- dbConnect(MySQL(), user="root", password="", 
    dbname="tech_cities", host="localhost", client.flag=CLIENT_MULTI_STATEMENTS)

# Create a database name tech-cities if it doesn't exist
dbSendQuery(con, "CREATE DATABASE IF NOT EXISTS tech_cities;")

dbSendQuery(con, 
    "CREATE TABLE IF NOT EXISTS jobs_geo_census (
        id INTEGER,
        skill VARCHAR(250),
        num_rel_jobs INTEGER,
        main_city VARCHAR(250),
        city VARCHAR(250),
        state VARCHAR(250),
        latitude VARCHAR(250),
        longitude VARCHAR(250),
        population_2013 INTEGER,
        created_at DATE,
        updated_at DATE);")

# Seed the data from the CSV file
dbSendQuery(con,
    "LOAD DATA LOCAL INFILE './data/jobs_geo_census.csv' 
    INTO TABLE jobs_geo_census
    FIELDS TERMINATED BY ',' ENCLOSED BY '\"'
    LINES TERMINATED BY '\n'
    IGNORE 1 LINES
    (id, skill, num_rel_jobs, main_city, city, state, latitude, longitude, population_2013, created_at, updated_at);")

# watch out with the overwrite argument it does what it says :)
dbDisconnect(con)