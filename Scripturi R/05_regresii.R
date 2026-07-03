###############################################################################################
###                        Lucrare de diplomă - Claudiu Bogdan - iulie 2026                 ###
###############################################################################################
###                         4. Modele de regresie logistica si liniara                     ###
###############################################################################################
# ultima actualizare: 2026-07/03
###############################################################################################
###            Modele de regresie    (durata)                                                ###
###############################################################################################

options(scipen = 999)
library(tidyverse)

base_dir <- 'C:/Users/claud/OneDrive/Desktop/2025-2026/R'
setwd(base_dir)

load('rezultate_finale.RData')
load('metadata_interogari.RData')

sf_levels <- c(1, 5, 10, 50, 100)


predictori <- c('nr_joinuri', 'nr_where', 'nr_group',
                'nr_having', 'nr_limit', 'nr_select')

pregateste <- function(rezultate, metadata) {
  rezultate |>
    left_join(metadata, by = 'interogare_nr') |>
    mutate(
      sf_num     = as.numeric(as.character(factor(marime_bd, levels = sf_levels))),
      succes_bin = if_else(succes_timeout20 == 'success', 1L, 0L)
    )
}

date_set99  <- pregateste(rezultate_set99_final,  metadata_set99)
date_set250 <- pregateste(rezultate_set250_final, metadata_set250)

timpi_set99  <- date_set99  |> filter(succes_bin == 1) |>
  mutate(log_timp = log10(durata_executie_ms / 1000))
timpi_set250 <- date_set250 |> filter(succes_bin == 1) |>
  mutate(log_timp = log10(pmax(durata_executie_ms / 1000, 0.001)))

f_log <- as.formula(paste('succes_bin ~ sf_num +', paste(predictori, collapse = ' + ')))
f_lin <- as.formula(paste('log_timp ~ sf_num +',   paste(predictori, collapse = ' + ')))

###############################################################################################
# REGRESIE LOGISTICA (succes) 
###############################################################################################
glm_set99  <- glm(f_log, data = date_set99,  family = binomial())
glm_set250 <- glm(f_log, data = date_set250, family = binomial())

summary(glm_set99)
summary(glm_set250)

# Odds Ratios
exp(coef(glm_set99))  |> round(4)
exp(coef(glm_set250)) |> round(4)

# Pseudo R2 McFadden
cat('McFadden 99 :', round(1 - glm_set99$deviance  / glm_set99$null.deviance,  3), '\n')
cat('McFadden 250:', round(1 - glm_set250$deviance / glm_set250$null.deviance, 3), '\n')


# ========== 2. REGRESIE LINIARA (log10 durata) ==========

lm_set99  <- lm(f_lin, data = timpi_set99)
lm_set250 <- lm(f_lin, data = timpi_set250)

summary(lm_set99)
summary(lm_set250)

cat('R2 ajustat 99 :', round(summary(lm_set99)$adj.r.squared,  3), '\n')
cat('R2 ajustat 250:', round(summary(lm_set250)$adj.r.squared, 3), '\n')
