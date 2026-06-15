###############################################################################################
###                        Lucrare de diplomă - Claudiu Bogdan - iulie 2026                 ###
###############################################################################################
###                             1a. Import rezultate execuție interogări                    ###
###############################################################################################
# ultima actualizare: 2026-04-23

options(scipen = 999)
library(tidyverse)
library(readxl)

###############################################################################################
###           Import rezultate ale rulării celor 99 de interogări standard din TPC-DS 

dir_baza <- 'C:/Users/claud/OneDrive/Desktop/2025-2026/Licenta_rezultate/Licenta_rezultate/Rezultate_99_Interogari'
setwd(dir_baza)
fisiere_rezultate <- list.files(pattern = '^summary_sf')

rezultate_set99 <- tibble()

fisier <- fisiere_rezultate[3]
for (fisier in fisiere_rezultate) {
  marime_bd_ <- as.integer(str_extract(fisier, '[0-9]{1,4}'))
  
  rezultate_crt_sf <- read_csv(fisier, col_names = FALSE) |>
    filter(str_detect(X1, '^([\\-]{3,3}|Execution)')) |>
    mutate (id_init = row_number()) |>
    mutate(interogare_nr = ceiling (id_init / 2)) |>
    group_by(interogare_nr) |>
    mutate(linie_nr = row_number()) |>
    ungroup() |>
    arrange(interogare_nr, linie_nr) |>
    select(-id_init) |>
    pivot_wider(names_from = linie_nr, values_from = X1) |>
    set_names(c('interogare_nr_init', 'query_no', 'execution_time')) |>
    mutate(
      query_no = as.integer(str_extract(str_extract(query_no, 'Query [0-9]{1,4}'), '[0-9]{1,4}')),
      execution_time = as.numeric(str_remove_all(execution_time, 'Execution Time: | ms'))) |> 
    transmute(marime_bd = marime_bd_, interogare_nr = query_no, durata_executie_ms = execution_time)
  
  rezultate_set99 <- bind_rows(rezultate_set99, rezultate_crt_sf)
}

rezultate_set99_final <- rezultate_set99 |>
  mutate(durata_executie_sec = durata_executie_ms / 1000) |>
  mutate(succes_timeout20 = case_when(
    durata_executie_sec <= 1200 ~ 'success',
    durata_executie_sec > 1200 ~ 'abandon',
    is.na(durata_executie_sec) ~ 'abandon',
    .default = 'abandon'
  ))

table(rezultate_set99_final$succes_timeout20)

temp <- rezultate_set99_final |>
  filter(is.na(durata_executie_sec))

table(temp$marime_bd)


###############################################################################################
###           Import rezultate ale rulării celor 250 de interogări proprii

dir_baza <- 'C:/Users/claud/OneDrive/Desktop/2025-2026/Licenta_rezultate/Licenta_rezultate/Rezultate_250_Interogari'
setwd(dir_baza)
fisiere_rezultate <- list.files(pattern = '^summary_sf')

rezultate_set250 <- tibble()

fisier <- fisiere_rezultate[3]
for (fisier in fisiere_rezultate) {
  marime_bd_ <- as.integer(str_extract(fisier, '[0-9]{1,4}'))
  
  rezultate_crt_sf <- read_csv(fisier, col_names = FALSE) |>
    filter(str_detect(X1, '^([\\-]{3,3}|Execution)')) |>
    mutate (id_init = row_number()) |>
    mutate(interogare_nr = ceiling (id_init / 2)) |>
    group_by(interogare_nr) |>
    mutate(linie_nr = row_number()) |>
    ungroup() |>
    arrange(interogare_nr, linie_nr) |>
    select(-id_init) |>
    pivot_wider(names_from = linie_nr, values_from = X1) |>
    set_names(c('interogare_nr_init', 'query_no', 'execution_time')) |>
    mutate(
      query_no = as.integer(str_extract(str_extract(query_no, 'Query [0-9]{1,4}'), '[0-9]{1,4}')),
      execution_time = as.numeric(str_remove_all(execution_time, 'Execution Time: | ms'))) |> 
    transmute(marime_bd = marime_bd_, interogare_nr = query_no, durata_executie_ms = execution_time)
  
  rezultate_set250 <- bind_rows(rezultate_set250, rezultate_crt_sf)
}

rezultate_set250_final <- rezultate_set250 |>
  mutate(durata_executie_sec = durata_executie_ms / 1000) |>
  mutate(succes_timeout20 = case_when(
    durata_executie_sec <= 1200 ~ 'success',
    durata_executie_sec > 1200 ~ 'abandon',
    is.na(durata_executie_sec) ~ 'abandon',
    .default = 'abandon'
  ))

table(rezultate_set250_final$succes_timeout20)

temp <- rezultate_set250_final |>
  filter(is.na(durata_executie_sec))

table(temp$marime_bd)

getwd()
setwd('C:/Users/claud/OneDrive/Desktop/2025-2026/R')
save(rezultate_set99_final, rezultate_set250_final, file = 'rezultate_finale.RData')