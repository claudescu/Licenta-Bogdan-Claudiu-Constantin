###############################################################################################
###                        Lucrare de diplomă - Claudiu Bogdan - iulie 2026                 ###
###############################################################################################
###             1b. Parsare interogări SQL pentru a extrage parametrii interogărilor        ###
###############################################################################################
# ultima actualizare: 2026-06-13

options(scipen = 999)
library(tidyverse)
library(readtext)

baza_interogari <- 'C:/Users/claud/OneDrive/Desktop/2025-2026/Licenta_rezultate/Licenta_rezultate/Tabele+Interogari'

###############################################################################################
###           Parsare cele 99 de interogări standard

setwd(paste(baza_interogari, 'Interogari_99', sep = '/'))
fisiere_interogari <- list.files(pattern = '^query_[0-9]+')

metadata_set99 <- tibble()

fisier <- fisiere_interogari[1]
for (fisier in fisiere_interogari) {
  interogare_nr_ <- as.integer(str_extract(fisier, '[0-9]{1,4}'))
  
  text_interogare <- str_replace_all(tolower(readtext(fisier)$text[1]), '\\n', ' ')
  
  nr_select  <- str_count(text_interogare, 'select ')
  nr_from    <- str_count(text_interogare, 'from ')
  nr_where   <- str_count(text_interogare, 'where ')
  nr_group   <- str_count(text_interogare, 'group by ')
  nr_having  <- str_count(text_interogare, 'having ')
  nr_limit   <- str_count(text_interogare, '\\blimit\\b')
  
  clauze_from <- str_extract_all(text_interogare, 'from .*?(where|group|$|UNION|\\))')[[1]]
  nr_joinuri  <- str_count(paste(clauze_from, collapse = ''), ',')
  
  metadata_set99 <- bind_rows(metadata_set99, tibble(
    interogare_nr = interogare_nr_,
    nr_select, nr_from, nr_where, nr_group, nr_having, nr_joinuri, nr_limit
  ))
}

###############################################################################################
###           Parsare cele 250 de interogări proprii

setwd(paste(baza_interogari, 'Interogari_250', sep = '/'))
fisiere_interogari <- list.files(pattern = '^Q[0-9]+')

metadata_set250 <- tibble()

fisier <- fisiere_interogari[1]
for (fisier in fisiere_interogari) {
  interogare_nr_ <- as.integer(str_extract(fisier, '[0-9]{1,4}'))
  
  text_interogare <- str_replace_all(tolower(readtext(fisier)$text[1]), '\\n', ' ')
  
  nr_select  <- str_count(text_interogare, 'select ')
  nr_from    <- str_count(text_interogare, 'from ')
  nr_where   <- str_count(text_interogare, 'where ')
  nr_group   <- str_count(text_interogare, 'group by ')
  nr_having  <- str_count(text_interogare, 'having ')
  nr_joinuri <- str_count(text_interogare, ' join ')
  nr_limit   <- str_count(text_interogare, '\\blimit\\b')
  
  metadata_set250 <- bind_rows(metadata_set250, tibble(
    interogare_nr = interogare_nr_,
    nr_select, nr_from, nr_where, nr_group, nr_having, nr_joinuri, nr_limit
  ))
}

getwd()
setwd('C:/Users/claud/OneDrive/Desktop/2025-2026/R')
save(metadata_set99, metadata_set250, file = 'metadata_interogari.RData')