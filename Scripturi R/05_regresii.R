###############################################################################################
###                        Lucrare de diplomă - Claudiu Bogdan - iulie 2026                 ###
###############################################################################################
###                         4. Modele de regresie logistica si liniara                     ###
###############################################################################################
# ultima actualizare: 2026-06-15

options(scipen = 999)
library(tidyverse)
library(pROC)


###############################################################################################
###                              Incarcare si pregatire date                                ###
###############################################################################################

base_dir <- 'C:/Users/claud/OneDrive/Desktop/2025-2026/R'
setwd(base_dir)

load('rezultate_finale.RData')
load('metadata_interogari.RData')

sf_levels <- c(1, 5, 10, 50, 100)

date_set99 <- rezultate_set99_final |>
  left_join(metadata_set99, by = 'interogare_nr') |>
  mutate(
    marime_bd   = factor(marime_bd, levels = sf_levels),
    sf_num      = as.numeric(as.character(marime_bd)),
    succes_bin  = factor(if_else(succes_timeout20 == 'success', 1, 0),
                         levels = c(0, 1)),
    cat_joinuri = factor(case_when(
      nr_joinuri == 0  ~ '0',
      nr_joinuri <= 2  ~ '1-2',
      nr_joinuri <= 5  ~ '3-5',
      TRUE             ~ '6+'
    ), levels = c('0', '1-2', '3-5', '6+')),
    cat_where   = factor(case_when(
      nr_where <= 1 ~ '0-1',
      TRUE          ~ '2+'
    ), levels = c('0-1', '2+'))
  )

date_set250 <- rezultate_set250_final |>
  left_join(metadata_set250, by = 'interogare_nr') |>
  mutate(
    marime_bd  = factor(marime_bd, levels = sf_levels),
    sf_num     = as.numeric(as.character(marime_bd)),
    succes_bin = factor(if_else(succes_timeout20 == 'success', 1, 0),
                        levels = c(0, 1)),
    # are_limit — factor | nr_joinuri si nr_group numerice (evita complete separation)
    are_limit  = factor(if_else(nr_limit > 0, 'Cu LIMIT', 'Fara LIMIT'),
                        levels = c('Fara LIMIT', 'Cu LIMIT'))
  )

# Doar interogari finalizate — pentru regresia liniara
timpi_set99 <- date_set99 |>
  filter(succes_timeout20 == 'success') |>
  mutate(
    durata_executie_sec = durata_executie_ms / 1000,
    log_timp            = log10(durata_executie_ms / 1000)
  )

timpi_set250 <- date_set250 |>
  filter(succes_timeout20 == 'success') |>
  mutate(
    durata_executie_sec = durata_executie_ms / 1000,
    log_timp            = log10(pmax(durata_executie_ms / 1000, 0.001))
  )

setwd(paste(base_dir, 'test', sep = '/'))


###############################################################################################
###                         a. Regresie logistica — succes/abandon                         ###
###############################################################################################
### Variabila dependenta: succes_bin (1 = finalizat, 0 = abandon)
### Predictori alesi pe baza testelor Chi-square din scriptul anterior


###############################################################################################
###   a1. Set standard (99)                                                                 ###
###   Predictori: sf_num + cat_joinuri + cat_where                                         ###
###   SF: V=0.43 | JOIN-uri: V=0.12 | WHERE: V=0.19                                       ###
###############################################################################################

table(date_set99$succes_bin)
prop.table(table(date_set99$succes_bin))
### ~81% succes, ~19% abandon

glm_set99 <- glm(succes_bin ~ sf_num + cat_joinuri + cat_where,
                 data   = date_set99,
                 family = binomial())
summary(glm_set99)

### Odds Ratios — OR < 1 => scade sansele de succes | OR > 1 => creste sansele
### CI 95% care nu include 1 => semnificativ statistic
exp(cbind(OR = coef(glm_set99), confint(glm_set99)))

### Pseudo R² McFadden — 0.20-0.40 = bun
1 - (glm_set99$deviance / glm_set99$null.deviance)
### 0.242 => bun

### AIC
AIC(glm_set99)

### ROC & AUC — >0.80 = bun
roc_set99 <- roc(date_set99$succes_bin, fitted(glm_set99))
auc(roc_set99)
### 0.823 => bun
plot(roc_set99,
     main      = 'Curba ROC — Regresie logistica Set standard (99)',
     print.auc = TRUE,
     col       = '#2980b9',
     lwd       = 2)

### Matrice de confuzie
pred_class_99 <- ifelse(fitted(glm_set99) > 0.5, 1, 0)
cm_99 <- table(Predicted = pred_class_99, Actual = date_set99$succes_bin)
cm_99

### Acuratete | Senzitivitate | Specificitate
cat('Acuratete:',     round(sum(diag(cm_99)) / sum(cm_99), 3),
    '| Senzitivitate:', round(cm_99['1','1'] / sum(cm_99[,'1']), 3),
    '| Specificitate:', round(cm_99['0','0'] / sum(cm_99[,'0']), 3), '\n')
### 0.853 | 0.948 | 0.453


###############################################################################################
###   a2. Set propriu (250)                                                                 ###
###   Predictori: sf_num + nr_joinuri + nr_group + are_limit                               ###
###   SF: dominant | JOIN-uri: V=0.21 | GROUP BY: V=0.14 | LIMIT: V=0.09                  ###
###############################################################################################

table(date_set250$succes_bin)
prop.table(table(date_set250$succes_bin))
### ~96% succes, ~4% abandon — dezechilibru puternic => specificitate scazuta asteptata

glm_set250 <- glm(succes_bin ~ sf_num + nr_joinuri + nr_group + are_limit,
                  data   = date_set250,
                  family = binomial())
summary(glm_set250)

### Odds Ratios
exp(cbind(OR = coef(glm_set250), confint(glm_set250)))

### Pseudo R² McFadden
1 - (glm_set250$deviance / glm_set250$null.deviance)
### 0.323 => bun

### AIC
AIC(glm_set250)

### ROC & AUC
roc_set250 <- roc(date_set250$succes_bin, fitted(glm_set250))
auc(roc_set250)
### 0.912 => excelent
plot(roc_set250,
     main      = 'Curba ROC — Regresie logistica Set propriu (250)',
     print.auc = TRUE,
     col       = '#27ae60',
     lwd       = 2)

### Matrice de confuzie
pred_class_250 <- ifelse(fitted(glm_set250) > 0.5, 1, 0)
cm_250 <- table(Predicted = pred_class_250, Actual = date_set250$succes_bin)
cm_250

### Acuratete | Senzitivitate | Specificitate
cat('Acuratete:',     round(sum(diag(cm_250)) / sum(cm_250), 3),
    '| Senzitivitate:', round(cm_250['1','1'] / sum(cm_250[,'1']), 3),
    '| Specificitate:', round(cm_250['0','0'] / sum(cm_250[,'0']), 3), '\n')
### 0.958 | 0.990 | 0.180
### Specificitate scazuta — efect al dezechilibrului 96%/4%


###############################################################################################
###                    b. Regresie liniara — log10(durata executie)                        ###
###############################################################################################
### Variabila dependenta: log_timp = log10(durata_executie_sec)
### log10 justificat de non-normalitatea duratei (Shapiro-Wilk p<0.05)
### Doar interogari finalizate cu succes


###############################################################################################
###   b1. Set standard (99)                                                                 ###
###   Predictori: sf_num + nr_joinuri                                                      ###
###   SF: rho=0.81 dominant | JOIN-uri: semnificative (p=0.014 in comparatia de modele)   ###
###############################################################################################

lm_set99 <- lm(log_timp ~ sf_num + nr_joinuri,
               data = timpi_set99)
summary(lm_set99)
### R² ajustat = 0.629 => modelul explica 63% din varianta log_timp
### sf_num:     coef pozitiv => SF mai mare = durata mai mare
### nr_joinuri: coef pozitiv => mai multe JOIN-uri = durata mai mare


###############################################################################################
###   b2. Set propriu (250)                                                                 ###
###   Predictori: sf_num + nr_joinuri + nr_group + nr_where + nr_having                   ###
###   Toti semnificativi in testele anterioare                                             ###
###############################################################################################

lm_set250 <- lm(log_timp ~ sf_num + nr_joinuri + nr_group + nr_where + nr_having,
                data = timpi_set250)
summary(lm_set250)
### R² ajustat = 0.486 => modelul explica 49% din varianta log_timp
### sf_num:     coef pozitiv => SF mai mare = durata mai mare
### nr_joinuri: coef pozitiv => mai multe JOIN-uri = durata mai mare
### nr_group:   coef pozitiv => mai multe GROUP BY = durata mai mare
### nr_where:   coef pozitiv => mai multe WHERE = durata mai mare
### nr_having:  coef pozitiv => mai multe HAVING = durata mai mare
confint(lm_set250)
confint(lm_set99)
confint(glm_set99)
confint(glm_set250)