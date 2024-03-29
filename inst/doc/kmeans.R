## ----setup, include = FALSE---------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)
library(dplyr)
library(purrr)
library(rlang)
library(nycflights13)

## -----------------------------------------------------------------------------
library(dplyr)

con <- DBI::dbConnect(RSQLite::SQLite(), path = ":memory:")
RSQLite::initExtension(con)

db_flights <- copy_to(con, nycflights13::flights, "flights")

## -----------------------------------------------------------------------------
library(modeldb)

km <- db_flights %>%
  simple_kmeans_db(dep_time, distance)

## -----------------------------------------------------------------------------
km %>% pull(k_center)

## -----------------------------------------------------------------------------
dbplyr::remote_query(km)

## -----------------------------------------------------------------------------
km <- db_flights %>%
  simple_kmeans_db(dep_time, distance, max_repeats = 10)

## -----------------------------------------------------------------------------
km <- db_flights %>%
  simple_kmeans_db(dep_time, distance, initial_kmeans = read.csv(file.path(tempdir(), "kmeans.csv")))

