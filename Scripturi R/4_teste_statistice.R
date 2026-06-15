###############################################################################################
###                        Lucrare de diplomă - Claudiu Bogdan - iulie 2026                 ###
###############################################################################################
###              3. Analiza experimentală a performanței interogărilor SQL                  ###
###############################################################################################
# ultima actualizare: 2026-06-15
#
# Testele statistice (Chi-Square, Kruskal/Mann, Spearman)
# pentru fiecare variabila structurala in parte.

options(scipen = 999)
library(tidyverse)
library(ggstatsplot)
library(effectsize)
library(patchwork)


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
    marime_bd    = factor(marime_bd, levels = sf_levels),
    succes_label = factor(if_else(succes_timeout20 == 'success', 'Succes', 'Abandon'),
                          levels = c('Succes', 'Abandon')),
    status       = if_else(succes_timeout20 == 'success', 'Succes', 'Abandon'),
    cat_joinuri  = factor(case_when(
      nr_joinuri == 0  ~ '0',
      nr_joinuri <= 2  ~ '1-2',
      nr_joinuri <= 5  ~ '3-5',
      TRUE             ~ '6+'
    ), levels = c('0', '1-2', '3-5', '6+')),
    cat_where    = factor(case_when(
      nr_where <= 1 ~ '0-1',
      TRUE          ~ '2+'
    ), levels = c('0-1', '2+')),
    cat_group    = factor(case_when(
      nr_group == 0 ~ '0',
      nr_group == 1 ~ '1',
      TRUE          ~ '2+'
    ), levels = c('0', '1', '2+')),
    are_having   = factor(if_else(nr_having > 0, 'Cu HAVING', 'Fara HAVING'),
                          levels = c('Fara HAVING', 'Cu HAVING')),
    are_limit    = factor(if_else(nr_limit  > 0, 'Cu LIMIT',  'Fara LIMIT'),
                          levels = c('Fara LIMIT',  'Cu LIMIT'))
  )
glimpse(date_set99)

date_set250 <- rezultate_set250_final |>
  left_join(metadata_set250, by = 'interogare_nr') |>
  mutate(
    marime_bd    = factor(marime_bd, levels = sf_levels),
    succes_label = factor(if_else(succes_timeout20 == 'success', 'Succes', 'Abandon'),
                          levels = c('Succes', 'Abandon')),
    status       = if_else(succes_timeout20 == 'success', 'Succes', 'Abandon'),
    cat_joinuri  = factor(case_when(
      nr_joinuri == 0  ~ '0',
      nr_joinuri <= 2  ~ '1-2',
      nr_joinuri <= 5  ~ '3-5',
      TRUE             ~ '6+'
    ), levels = c('0', '1-2', '3-5', '6+')),
    cat_where    = factor(case_when(
      nr_where <= 1 ~ '0-1',
      TRUE          ~ '2+'
    ), levels = c('0-1', '2+')),
    cat_group    = factor(case_when(
      nr_group == 0 ~ '0',
      nr_group == 1 ~ '1',
      TRUE          ~ '2+'
    ), levels = c('0', '1', '2+')),
    are_having   = factor(if_else(nr_having > 0, 'Cu HAVING', 'Fara HAVING'),
                          levels = c('Fara HAVING', 'Cu HAVING')),
    are_limit    = factor(if_else(nr_limit  > 0, 'Cu LIMIT',  'Fara LIMIT'),
                          levels = c('Fara LIMIT',  'Cu LIMIT'))
  )
glimpse(date_set250)

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

cat('Set99  - total:', nrow(date_set99),  '| finalizate:', nrow(timpi_set99),  '\n')
cat('Set250 - total:', nrow(date_set250), '| finalizate:', nrow(timpi_set250), '\n')

vars_structurale <- c('nr_joinuri', 'nr_where', 'nr_group',
                      'nr_having', 'nr_limit', 'nr_select', 'nr_from')

labels_vars_ro <- c(
  nr_joinuri = 'Numar join-uri',
  nr_where   = 'Numar WHERE',
  nr_group   = 'Numar GROUP BY',
  nr_having  = 'Numar HAVING',
  nr_limit   = 'Numar LIMIT',
  nr_select  = 'Numar SELECT',
  nr_from    = 'Numar FROM'
)

setwd(paste(base_dir, 'test', sep = '/'))


###############################################################################################
###                         Teste statistice inferentiale                                  ###
###############################################################################################
###
### Structura pentru fiecare variabila:
###   - Chi-square: asocierea cu rata de finalizare (succes/abandon)
###   - Kruskal-Wallis sau Mann-Whitney: diferente in timpii de executie
###   - Spearman: corelatia cu log10(durata)
###
### Pas preliminar: Verificarea normalitatii variabilei durata_executie_sec
### Test folosit: Shapiro-Wilk
### Ipoteza nula (H0): distributia este normala
set.seed(123)
shapiro.test(sample(timpi_set99$durata_executie_sec,  min(5000, nrow(timpi_set99))))
shapiro.test(sample(timpi_set250$durata_executie_sec, min(5000, nrow(timpi_set250))))
### p-value < 0.05 => H0 respinsa => variabila NU este normal distribuita
### Se justifica utilizarea testelor non-parametrice in continuare


###############################################################################################
###                     Scale Factor — Chi-square + Kruskal-Wallis + Spearman             ###
###############################################################################################

#########################################################################
### RQ1: Exista o asociere intre marimea bazei de date (Scale Factor)
###      si rata de finalizare a interogarilor (succes/abandon)?
### Ambele variabile sunt nominale => Chi-square test of independence
### H0: variabilele sunt independente
#########################################################################

table(date_set99$marime_bd,  date_set99$succes_label)
table(date_set250$marime_bd, date_set250$succes_label)

g1 <- ggbarstats(
  data       = date_set99,
  x          = marime_bd,
  y          = succes_label,
  label      = 'both',
  bf.message = FALSE,
  title      = 'Set standard (99)',
  xlab       = 'Status executie') +
  theme(legend.position = 'bottom') +
  theme(text          = element_text(size = 13),
        plot.title    = element_text(size = 14, hjust = 0.5),
        plot.subtitle = element_text(size = 12, hjust = 0.5),
        plot.caption  = element_blank(),
        legend.text   = element_text(size = 12))

g2 <- ggbarstats(
  data       = date_set250,
  x          = marime_bd,
  y          = succes_label,
  label      = 'both',
  bf.message = FALSE,
  title      = 'Set propriu (250)',
  xlab       = 'Status executie') +
  theme(legend.position = 'bottom') +
  theme(text          = element_text(size = 13),
        plot.title    = element_text(size = 14, hjust = 0.5),
        plot.subtitle = element_text(size = 12, hjust = 0.5),
        plot.caption  = element_blank(),
        legend.text   = element_text(size = 12))

x <- g1 + g2 + plot_layout(ncol = 2, guides = 'collect') & theme(legend.position = 'bottom')
x

# effectsize::interpret_cramers_v(0.26) 
### Set99:  V = 0,43 => intensitate very large
### Set250: V = ??? => intensitate medium


#########################################################################
### RQ2: Difera timpii de executie in functie de Scale Factor?
### Variabila x: nominala (marime_bd); variabila y: numerica, non-normala
### => Kruskal-Wallis (echivalent non-parametric al ANOVA)
### H0: distributiile sunt identice pentru toate nivelurile Scale Factor
#########################################################################

set.seed(1234)
g1 <- ggbetweenstats(
  data  = timpi_set99,
  x     = marime_bd,
  y     = log_timp,
  type  = 'np',
  title = 'Set standard (99)',
  xlab  = 'Scale Factor',
  ylab  = 'log10(Timp executie, secunde)') +
  theme(text          = element_text(size = 13),
        plot.title    = element_text(size = 14, hjust = 0.5),
        plot.subtitle = element_text(size = 12, hjust = 0.5),
        plot.caption  = element_blank(),
        legend.text   = element_text(size = 12))

set.seed(1234)
g2 <- ggbetweenstats(
  data  = timpi_set250,
  x     = marime_bd,
  y     = log_timp,
  type  = 'np',
  title = 'Set propriu (250)',
  xlab  = 'Scale Factor',
  ylab  = 'log10(Timp executie, secunde)') +
  theme(text          = element_text(size = 13),
        plot.title    = element_text(size = 14, hjust = 0.5),
        plot.subtitle = element_text(size = 12, hjust = 0.5),
        plot.caption  = element_blank(),
        legend.text   = element_text(size = 12))

x <- g1 + g2 + plot_layout(ncol = 2)
x

#effectsize::interpret_epsilon_squared(0.49)   
### Set99:  epsilon^2 = 0.68 => marime efect large
### Set250: epsilon^2 = 0.49 => marime efect large


#########################################################################
### RQ3: Exista o corelatie intre Scale Factor (numeric) si
###      durata de executie (log)?
### Ambele variabile sunt numerice, non-normale => Spearman
### H0: cele doua variabile sunt independente (rho = 0)
#########################################################################

set.seed(1234)
g1 <- ggscatterstats(
  data  = timpi_set99  |> mutate(sf_num = as.numeric(as.character(marime_bd))),
  x     = sf_num,
  y     = log_timp,
  type  = 'np',
  title = 'Set standard (99)',
  xlab  = 'Scale Factor',
  ylab  = 'log10(Timp executie, secunde)')

set.seed(1234)
g2 <- ggscatterstats(
  data  = timpi_set250 |> mutate(sf_num = as.numeric(as.character(marime_bd))),
  x     = sf_num,
  y     = log_timp,
  type  = 'np',
  title = 'Set propriu (250)',
  xlab  = 'Scale Factor',
  ylab  = 'log10(Timp executie, secunde)')

x <- g1 + g2 + plot_layout(ncol = 2)
x

#effectsize::interpret_r(0.69, rules = 'cohen1988')  
### Set99:  rho = 0.81 => intensitate large
### Set250: rho = 0.69 => intensitate  large
### rho > 0: Scale Factor mai mare = timpi mai mari


###############################################################################################
###                     JOIN-uri — Chi-square + Kruskal-Wallis + Spearman                  ###
###############################################################################################

#########################################################################
### RQ4: Exista o asociere intre numarul de JOIN-uri si
###      rata de finalizare a interogarilor?
### Ambele variabile sunt nominale => Chi-square test of independence
### H0: variabilele sunt independente
#########################################################################

#table(date_set99$cat_joinuri,  date_set99$succes_label)
#table(date_set250$cat_joinuri, date_set250$succes_label)

g1 <- ggbarstats(
  data         = date_set99,
  x            = cat_joinuri,
  y            = succes_label,
  label        = 'both',
  bf.message   = FALSE,
  title        = 'Set standard (99)',
  xlab         = 'Status executie',
  legend.title = 'Nr. JOIN-uri') +
  theme(legend.position = 'bottom') +
  theme(text          = element_text(size = 13),
        plot.title    = element_text(size = 14, hjust = 0.5),
        plot.subtitle = element_text(size = 12, hjust = 0.5),
        plot.caption  = element_blank(),
        legend.text   = element_text(size = 12))

g2 <- ggbarstats(
  data         = date_set250,
  x            = cat_joinuri,
  y            = succes_label,
  label        = 'both',
  bf.message   = FALSE,
  title        = 'Set propriu (250)',
  xlab         = 'Status executie',
  legend.title = 'Nr. JOIN-uri') +
  theme(legend.position = 'bottom') +
  theme(text          = element_text(size = 13),
        plot.title    = element_text(size = 14, hjust = 0.5),
        plot.subtitle = element_text(size = 12, hjust = 0.5),
        plot.caption  = element_blank(),
        legend.text   = element_text(size = 12))

x <- g1 + g2 + plot_layout(ncol = 2, guides = 'collect') & theme(legend.position = 'bottom')
x

#effectsize::interpret_cramers_v(0.21)   
### Set99:  V = 0.12 => intensitate small
### Set250: V = 0.21 => intensitate medium


#########################################################################
### RQ5: Difera timpii de executie in functie de numarul de JOIN-uri?
### Variabila x: nominala (cat_joinuri); variabila y: numerica
### => Kruskal-Wallis
### H0: distributiile sunt identice pentru toate categoriile de JOIN-uri
#########################################################################

set.seed(1234)
g1 <- ggbetweenstats(
  data  = timpi_set99,
  x     = cat_joinuri,
  y     = log_timp,
  type  = 'np',
  title = 'Set standard (99)',
  xlab  = 'Nr. JOIN-uri (categorii)',
  ylab  = 'log10(Timp executie, secunde)') +
  theme(text          = element_text(size = 13),
        plot.title    = element_text(size = 14, hjust = 0.5),
        plot.subtitle = element_text(size = 12, hjust = 0.5),
        plot.caption  = element_blank(),
        legend.text   = element_text(size = 12))

set.seed(1234)
g2 <- ggbetweenstats(
  data  = timpi_set250,
  x     = cat_joinuri,
  y     = log_timp,
  type  = 'np',
  title = 'Set propriu (250)',
  xlab  = 'Nr. JOIN-uri (categorii)',
  ylab  = 'log10(Timp executie, secunde)') +
  theme(text          = element_text(size = 13),
        plot.title    = element_text(size = 14, hjust = 0.5),
        plot.subtitle = element_text(size = 12, hjust = 0.5),
        plot.caption  = element_blank(),
        legend.text   = element_text(size = 12))

x <- g1 + g2 + plot_layout(ncol = 2)
x

#effectsize::interpret_epsilon_squared(0.14)   
### Set99:  epsilon^2 = 0.003, p = 0.80 => marime efect neglijabila, diferentele nu sunt semnificative
### Set250: epsilon^2 = 0.14,  p = 3.34e-37 => marime efect large, diferentele sunt semnificative


#########################################################################
### RQ6: Exista o corelatie intre numarul de JOIN-uri (numeric) si
###      durata de executie (log)?
### Ambele variabile sunt numerice, non-normale => Spearman
### H0: cele doua variabile sunt independente (rho = 0)
#########################################################################

set.seed(1234)
g1 <- ggscatterstats(
  data  = timpi_set99,
  x     = nr_joinuri,
  y     = log_timp,
  type  = 'np',
  title = 'Set standard (99)',
  xlab  = 'Nr. JOIN-uri',
  ylab  = 'log10(Timp executie, secunde)')

set.seed(1234)
g2 <- ggscatterstats(
  data  = timpi_set250,
  x     = nr_joinuri,
  y     = log_timp,
  type  = 'np',
  title = 'Set propriu (250)',
  xlab  = 'Nr. JOIN-uri',
  ylab  = 'log10(Timp executie, secunde)')

x <- g1 + g2 + plot_layout(ncol = 2)
x

#effectsize::interpret_r(0.38, rules = 'cohen1988')   
### Set99:  rho = 0.06 => intensitate very smal
### Set250: rho = 0.38 => intensitate moderate
### rho pozitiv: mai multe JOIN-uri = durata mai mare


###############################################################################################
###                      WHERE — Chi-square + Kruskal-Wallis + Spearman                   ###
###############################################################################################

#########################################################################
### RQ7: Exista o asociere intre numarul de clauze WHERE si
###      rata de finalizare a interogarilor?
### Ambele variabile sunt nominale => Chi-square test of independence
### H0: variabilele sunt independente
#########################################################################

table(date_set99$cat_where,  date_set99$succes_label)
table(date_set250$cat_where, date_set250$succes_label)

g1 <- ggbarstats(
  data         = date_set99,
  x            = cat_where,
  y            = succes_label,
  label        = 'both',
  bf.message   = FALSE,
  title        = 'Set standard (99)',
  xlab         = 'Status executie',
  legend.title = 'Nr. WHERE') +
  theme(legend.position = 'bottom') +
  theme(text          = element_text(size = 13),
        plot.title    = element_text(size = 14, hjust = 0.5),
        plot.subtitle = element_text(size = 12, hjust = 0.5),
        plot.caption  = element_blank(),
        legend.text   = element_text(size = 12))

g2 <- ggbarstats(
  data         = date_set250,
  x            = cat_where,
  y            = succes_label,
  label        = 'both',
  bf.message   = FALSE,
  title        = 'Set propriu (250)',
  xlab         = 'Status executie',
  legend.title = 'Nr. WHERE') +
  theme(legend.position = 'bottom') +
  theme(text          = element_text(size = 13),
        plot.title    = element_text(size = 14, hjust = 0.5),
        plot.subtitle = element_text(size = 12, hjust = 0.5),
        plot.caption  = element_blank(),
        legend.text   = element_text(size = 12))

x <- g1 + g2 + plot_layout(ncol = 2, guides = 'collect') & theme(legend.position = 'bottom')
x

#effectsize::interpret_cramers_v(0.00)  
### Set99:  V = 0.19 => intensitate small
### Set250: V = 0.00=> intensitate tiny


#########################################################################
### RQ8: Difera timpii de executie in functie de numarul de clauze WHERE?
### Variabila x: nominala (cat_where); variabila y: numerica, non-normala
### => Kruskal-Wallis
### H0: distributiile sunt identice pentru toate categoriile WHERE
#########################################################################

set.seed(1234)
g1 <- ggbetweenstats(
  data  = timpi_set99,
  x     = cat_where,
  y     = log_timp,
  type  = 'np',
  title = 'Set standard (99)',
  xlab  = 'Nr. WHERE (categorii)',
  ylab  = 'log10(Timp executie, secunde)') +
  theme(text          = element_text(size = 13),
        plot.title    = element_text(size = 14, hjust = 0.5),
        plot.subtitle = element_text(size = 12, hjust = 0.5),
        plot.caption  = element_blank(),
        legend.text   = element_text(size = 12))

set.seed(1234)
g2 <- ggbetweenstats(
  data  = timpi_set250,
  x     = cat_where,
  y     = log_timp,
  type  = 'np',
  title = 'Set propriu (250)',
  xlab  = 'Nr. WHERE (categorii)',
  ylab  = 'log10(Timp executie, secunde)') +
  theme(text          = element_text(size = 13),
        plot.title    = element_text(size = 14, hjust = 0.5),
        plot.subtitle = element_text(size = 12, hjust = 0.5),
        plot.caption  = element_blank(),
        legend.text   = element_text(size = 12))

x <- g1 + g2 + plot_layout(ncol = 2)
x

#effectsize::interpret_rank_biserial(-0.14)
### Set99:  epsilon^2 = ??? => marime efect small
### Set250: epsilon^2 = ??? => marime efect la fel


#########################################################################
### RQ9: Exista o corelatie intre numarul de clauze WHERE (numeric) si
###      durata de executie (log)?
### Ambele variabile sunt numerice, non-normale => Spearman
### H0: cele doua variabile sunt independente (rho = 0)
#########################################################################

set.seed(1234)
g1 <- ggscatterstats(
  data  = timpi_set99,
  x     = nr_where,
  y     = log_timp,
  type  = 'np',
  title = 'Set standard (99)',
  xlab  = 'Nr. WHERE',
  ylab  = 'log10(Timp executie, secunde)')

set.seed(1234)
g2 <- ggscatterstats(
  data  = timpi_set250,
  x     = nr_where,
  y     = log_timp,
  type  = 'np',
  title = 'Set propriu (250)',
  xlab  = 'Nr. WHERE',
  ylab  = 'log10(Timp executie, secunde)')

x <- g1 + g2 + plot_layout(ncol = 2)
x

#effectsize::interpret_r(-0.10, rules = 'cohen1988')   
### Set99:  rho = 0.14 => intensitate small
### Set250: rho = -0.10 => intensitate small
### rho negativ posibil: filtrele WHERE reduc setul de date si scurteaza durata


###############################################################################################
###                    GROUP BY — Chi-square + Kruskal-Wallis + Spearman                   ###
###############################################################################################

#########################################################################
### RQ10: Exista o asociere intre numarul de clauze GROUP BY si
###       rata de finalizare a interogarilor?
### Ambele variabile sunt nominale => Chi-square test of independence
### H0: variabilele sunt independente
#########################################################################

#table(date_set99$cat_group,  date_set99$succes_label)
#table(date_set250$cat_group, date_set250$succes_label)

g1 <- ggbarstats(
  data         = date_set99,
  x            = cat_group,
  y            = succes_label,
  label        = 'both',
  bf.message   = FALSE,
  title        = 'Set standard (99)',
  xlab         = 'Status executie',
  legend.title = 'Nr. GROUP BY') +
  theme(legend.position = 'bottom') +
  theme(text          = element_text(size = 13),
        plot.title    = element_text(size = 14, hjust = 0.5),
        plot.subtitle = element_text(size = 12, hjust = 0.5),
        plot.caption  = element_blank(),
        legend.text   = element_text(size = 12))

g2 <- ggbarstats(
  data         = date_set250,
  x            = cat_group,
  y            = succes_label,
  label        = 'both',
  bf.message   = FALSE,
  title        = 'Set propriu (250)',
  xlab         = 'Status executie',
  legend.title = 'Nr. GROUP BY') +
  theme(legend.position = 'bottom') +
  theme(text          = element_text(size = 13),
        plot.title    = element_text(size = 14, hjust = 0.5),
        plot.subtitle = element_text(size = 12, hjust = 0.5),
        plot.caption  = element_blank(),
        legend.text   = element_text(size = 12))

x <- g1 + g2 + plot_layout(ncol = 2, guides = 'collect') & theme(legend.position = 'bottom')
x

#effectsize::interpret_cramers_v(0.14)   
### Set99:  V = 0.10 => intensitate mic
### Set250: V = 0.14 => intensitate mic


#########################################################################
### RQ11: Difera timpii de executie in functie de numarul de GROUP BY?
### Variabila x: nominala (cat_group); variabila y: numerica, non-normala
### => Kruskal-Wallis
### H0: distributiile sunt identice pentru toate categoriile GROUP BY
#########################################################################

set.seed(1234)
g1 <- ggbetweenstats(
  data  = timpi_set99,
  x     = cat_group,
  y     = log_timp,
  type  = 'np',
  title = 'Set standard (99)',
  xlab  = 'Nr. GROUP BY (categorii)',
  ylab  = 'log10(Timp executie, secunde)') +
  theme(text          = element_text(size = 13),
        plot.title    = element_text(size = 14, hjust = 0.5),
        plot.subtitle = element_text(size = 12, hjust = 0.5),
        plot.caption  = element_blank(),
        legend.text   = element_text(size = 12))

set.seed(1234)
g2 <- ggbetweenstats(
  data  = timpi_set250,
  x     = cat_group,
  y     = log_timp,
  type  = 'np',
  title = 'Set propriu (250)',
  xlab  = 'Nr. GROUP BY (categorii)',
  ylab  = 'log10(Timp executie, secunde)') +
  theme(text          = element_text(size = 13),
        plot.title    = element_text(size = 14, hjust = 0.5),
        plot.subtitle = element_text(size = 12, hjust = 0.5),
        plot.caption  = element_blank(),
        legend.text   = element_text(size = 12))

x <- g1 + g2 + plot_layout(ncol = 2)
x

#effectsize::interpret_epsilon_squared(0.04)  
### Set99:  epsilon^2 = 0.00551 => marime efect foarte mic
### Set250: epsilon^2 = 0.04 => marime efect micu
### GROUP BY implica agregare — poate creste durata semnificativ la volume mari


#########################################################################
### RQ12: Exista o corelatie intre numarul de GROUP BY (numeric) si
###       durata de executie (log)?
### Ambele variabile sunt numerice, non-normale => Spearman
### H0: cele doua variabile sunt independente (rho = 0)
#########################################################################

set.seed(1234)
g1 <- ggscatterstats(
  data  = timpi_set99,
  x     = nr_group,
  y     = log_timp,
  type  = 'np',
  title = 'Set standard (99)',
  xlab  = 'Nr. GROUP BY',
  ylab  = 'log10(Timp executie, secunde)')

set.seed(1234)
g2 <- ggscatterstats(
  data  = timpi_set250,
  x     = nr_group,
  y     = log_timp,
  type  = 'np',
  title = 'Set propriu (250)',
  xlab  = 'Nr. GROUP BY',
  ylab  = 'log10(Timp executie, secunde)')

x <- g1 + g2 + plot_layout(ncol = 2)
x

#effectsize::interpret_r(0.2, rules = 'cohen1988') 
### Set99:  rho = 0.06 => intensitate very small
### Set250: rho = 0.2 => intensitate small


###############################################################################################
###                      HAVING — Chi-square + Mann-Whitney + Spearman                     ###
###############################################################################################

#########################################################################
### RQ13: Exista o asociere intre prezenta clauzei HAVING si
###       rata de finalizare a interogarilor?
### Ambele variabile sunt nominale => Chi-square test of independence
### H0: variabilele sunt independente
#########################################################################

#table(date_set99$are_having,  date_set99$succes_label)
#table(date_set250$are_having, date_set250$succes_label)

g1 <- ggbarstats(
  data         = date_set99,
  x            = are_having,
  y            = succes_label,
  label        = 'both',
  bf.message   = FALSE,
  title        = 'Set standard (99)',
  xlab         = 'Status executie',
  legend.title = 'HAVING') +
  theme(legend.position = 'bottom') +
  theme(text          = element_text(size = 13),
        plot.title    = element_text(size = 14, hjust = 0.5),
        plot.subtitle = element_text(size = 12, hjust = 0.5),
        plot.caption  = element_blank(),
        legend.text   = element_text(size = 12))

g2 <- ggbarstats(
  data         = date_set250,
  x            = are_having,
  y            = succes_label,
  label        = 'both',
  bf.message   = FALSE,
  title        = 'Set propriu (250)',
  xlab         = 'Status executie',
  legend.title = 'HAVING') +
  theme(legend.position = 'bottom') +
  theme(text          = element_text(size = 13),
        plot.title    = element_text(size = 14, hjust = 0.5),
        plot.subtitle = element_text(size = 12, hjust = 0.5),
        plot.caption  = element_blank(),
        legend.text   = element_text(size = 12))

x <- g1 + g2 + plot_layout(ncol = 2, guides = 'collect') & theme(legend.position = 'bottom')
x

#effectsize::interpret_cramers_v(0.07)
#effectsize::interpret_cramers_v(0.11)  
### Set99:  V = 0.07 => intensitate foarte mica
### Set250: V = 0.11 => intensitate mica


#########################################################################
### RQ14: Difera timpii de executie in functie de prezenta HAVING?
### Variabila x: binara (are_having); variabila y: numerica, non-normala
### => Mann-Whitney (Wilcoxon rank-sum test)
### H0: distributiile sunt identice pentru cele doua grupuri
#########################################################################

timpi_set99_hav <- timpi_set99 |>
  mutate(are_having = factor(if_else(nr_having > 0, 'Cu HAVING', 'Fara HAVING'),
                             levels = c('Fara HAVING', 'Cu HAVING')))

timpi_set250_hav <- timpi_set250 |>
  mutate(are_having = factor(if_else(nr_having > 0, 'Cu HAVING', 'Fara HAVING'),
                             levels = c('Fara HAVING', 'Cu HAVING')))

set.seed(1234)
g1 <- ggbetweenstats(
  data  = timpi_set99_hav,
  x     = are_having,
  y     = log_timp,
  type  = 'np',
  title = 'Set standard (99)',
  xlab  = 'Prezenta HAVING',
  ylab  = 'log10(Timp executie, secunde)') +
  theme(text          = element_text(size = 13),
        plot.title    = element_text(size = 14, hjust = 0.5),
        plot.subtitle = element_text(size = 12, hjust = 0.5),
        plot.caption  = element_blank(),
        legend.text   = element_text(size = 12))

set.seed(1234)
g2 <- ggbetweenstats(
  data  = timpi_set250_hav,
  x     = are_having,
  y     = log_timp,
  type  = 'np',
  title = 'Set propriu (250)',
  xlab  = 'Prezenta HAVING',
  ylab  = 'log10(Timp executie, secunde)') +
  theme(text          = element_text(size = 13),
        plot.title    = element_text(size = 14, hjust = 0.5),
        plot.subtitle = element_text(size = 12, hjust = 0.5),
        plot.caption  = element_blank(),
        legend.text   = element_text(size = 12))

x <- g1 + g2 + plot_layout(ncol = 2)
x

#effectsize::interpret_rank_biserial(-0.06)   
### Set99:  r_biserial = -0.10 => marime efect mică
### Set250: r_biserial = -0.06 => marime efect foarte mică
### HAVING apare rar — efect poate fi nesemnificativ la set99


#########################################################################
### RQ15: Exista o corelatie intre numarul de HAVING (numeric) si
###       durata de executie (log)?
### Ambele variabile sunt numerice, non-normale => Spearman
### H0: cele doua variabile sunt independente (rho = 0)
#########################################################################

set.seed(1234)
g1 <- ggscatterstats(
  data  = timpi_set99,
  x     = nr_having,
  y     = log_timp,
  type  = 'np',
  title = 'Set standard (99)',
  xlab  = 'Nr. HAVING',
  ylab  = 'log10(Timp executie, secunde)')

set.seed(1234)
g2 <- ggscatterstats(
  data  = timpi_set250,
  x     = nr_having,
  y     = log_timp,
  type  = 'np',
  title = 'Set propriu (250)',
  xlab  = 'Nr. HAVING',
  ylab  = 'log10(Timp executie, secunde)')

x <- g1 + g2 + plot_layout(ncol = 2)
x

#effectsize::interpret_r(0.02, rules = 'cohen1988')  
### Set99:  rho = 0.04 => intensitate f mic
### Set250: rho = 0.02 => intensitate f mică


###############################################################################################
###                       LIMIT — Chi-square + Mann-Whitney + Spearman                     ###
###############################################################################################

#########################################################################
### RQ16: Exista o asociere intre prezenta clauzei LIMIT si
###       rata de finalizare a interogarilor?
### Ambele variabile sunt nominale => Chi-square test of independence
### H0: variabilele sunt independente
#########################################################################

table(date_set99$are_limit,  date_set99$succes_label)
table(date_set250$are_limit, date_set250$succes_label)
### LIMIT reduce numarul de randuri returnate — poate creste rata de succes

g1 <- ggbarstats(
  data         = date_set99,
  x            = are_limit,
  y            = succes_label,
  label        = 'both',
  bf.message   = FALSE,
  title        = 'Set standard (99)',
  xlab         = 'Status executie',
  legend.title = 'LIMIT') +
  theme(legend.position = 'bottom') +
  theme(text          = element_text(size = 13),
        plot.title    = element_text(size = 14, hjust = 0.5),
        plot.subtitle = element_text(size = 12, hjust = 0.5),
        plot.caption  = element_blank(),
        legend.text   = element_text(size = 12))

g2 <- ggbarstats(
  data         = date_set250,
  x            = are_limit,
  y            = succes_label,
  label        = 'both',
  bf.message   = FALSE,
  title        = 'Set propriu (250)',
  xlab         = 'Status executie',
  legend.title = 'LIMIT') +
  theme(legend.position = 'bottom') +
  theme(text          = element_text(size = 13),
        plot.title    = element_text(size = 14, hjust = 0.5),
        plot.subtitle = element_text(size = 12, hjust = 0.5),
        plot.caption  = element_blank(),
        legend.text   = element_text(size = 12))

x <- g1 + g2 + plot_layout(ncol = 2, guides = 'collect') & theme(legend.position = 'bottom')
x

#effectsize::interpret_cramers_v(0.09)
### Set99:  V = 0.10 => intensitate small
### Set250: V = 0.09 => intensitate v small


#########################################################################
### RQ17: Difera timpii de executie in functie de prezenta LIMIT?
### Variabila x: binara (are_limit); variabila y: numerica, non-normala
### => Mann-Whitney (Wilcoxon rank-sum test)
### H0: distributiile sunt identice pentru cele doua grupuri
#########################################################################

timpi_set99_lim <- timpi_set99 |>
  mutate(are_limit = factor(if_else(nr_limit > 0, 'Cu LIMIT', 'Fara LIMIT'),
                            levels = c('Fara LIMIT', 'Cu LIMIT')))

timpi_set250_lim <- timpi_set250 |>
  mutate(are_limit = factor(if_else(nr_limit > 0, 'Cu LIMIT', 'Fara LIMIT'),
                            levels = c('Fara LIMIT', 'Cu LIMIT')))

set.seed(1234)
g1 <- ggbetweenstats(
  data  = timpi_set99_lim,
  x     = are_limit,
  y     = log_timp,
  type  = 'np',
  title = 'Set standard (99)',
  xlab  = 'Prezenta LIMIT',
  ylab  = 'log10(Timp executie, secunde)') +
  theme(text          = element_text(size = 13),
        plot.title    = element_text(size = 14, hjust = 0.5),
        plot.subtitle = element_text(size = 12, hjust = 0.5),
        plot.caption  = element_blank(),
        legend.text   = element_text(size = 12))

set.seed(1234)
g2 <- ggbetweenstats(
  data  = timpi_set250_lim,
  x     = are_limit,
  y     = log_timp,
  type  = 'np',
  title = 'Set propriu (250)',
  xlab  = 'Prezenta LIMIT',
  ylab  = 'log10(Timp executie, secunde)') +
  theme(text          = element_text(size = 13),
        plot.title    = element_text(size = 14, hjust = 0.5),
        plot.subtitle = element_text(size = 12, hjust = 0.5),
        plot.caption  = element_blank(),
        legend.text   = element_text(size = 12))

x <- g1 + g2 + plot_layout(ncol = 2)
x

effectsize::interpret_rank_biserial(-(0.29))   
### Set99:  r_biserial = 0.04 => marime efect tiny
### Set250: r_biserial = -0.29 => marime efect medium
### r negativ asteptat: Cu LIMIT -> timpi mai mici


#########################################################################
### RQ18: Exista o corelatie intre numarul de LIMIT (numeric) si
###       durata de executie (log)?
### Ambele variabile sunt numerice, non-normale => Spearman
### H0: cele doua variabile sunt independente (rho = 0)
#########################################################################

set.seed(1234)
g1 <- ggscatterstats(
  data  = timpi_set99,
  x     = nr_limit,
  y     = log_timp,
  type  = 'np',
  title = 'Set standard (99)',
  xlab  = 'Nr. LIMIT',
  ylab  = 'log10(Timp executie, secunde)')

set.seed(1234)
g2 <- ggscatterstats(
  data  = timpi_set250,
  x     = nr_limit,
  y     = log_timp,
  type  = 'np',
  title = 'Set propriu (250)',
  xlab  = 'Nr. LIMIT',
  ylab  = 'log10(Timp executie, secunde)')

x <- g1 + g2 + plot_layout(ncol = 2)
x

effectsize::interpret_r(0.23, rules = 'cohen1988')   
### Set99:  rho = -0.02 => intensitate v small
### Set250: rho = 0.23 => intensitate small
### rho negativ: LIMIT scurteaza durata — confirma chi-square


###############################################################################################
###                             Sinteza Spearman                                           ###
###   Corelatia dintre toate variabilele structurale si log10(durata executie)             ###
###   Toate variabilele analizate simultan, ordonate dupa rho                              ###
###############################################################################################

spearman_set99 <- map_dfr(vars_structurale, function(var) {
  test <- cor.test(timpi_set99[[var]], timpi_set99$log_timp,
                   method = 'spearman', exact = FALSE)
  tibble(
    variabila    = labels_vars_ro[var],
    rho          = round(test$estimate, 3),
    p_value      = round(test$p.value, 6),
    semn         = case_when(
      test$p.value < 0.001 ~ '***',
      test$p.value < 0.01  ~ '**',
      test$p.value < 0.05  ~ '*',
      TRUE                 ~ 'ns'
    ),
    interpretare = as.character(interpret_r(test$estimate, rules = 'cohen1988'))
  )
})

spearman_set250 <- map_dfr(vars_structurale, function(var) {
  test <- cor.test(timpi_set250[[var]], timpi_set250$log_timp,
                   method = 'spearman', exact = FALSE)
  tibble(
    variabila    = labels_vars_ro[var],
    rho          = round(test$estimate, 3),
    p_value      = round(test$p.value, 6),
    semn         = case_when(
      test$p.value < 0.001 ~ '***',
      test$p.value < 0.01  ~ '**',
      test$p.value < 0.05  ~ '*',
      TRUE                 ~ 'ns'
    ),
    interpretare = as.character(interpret_r(test$estimate, rules = 'cohen1988'))
  )
})

print(spearman_set99)
print(spearman_set250)
### rho > 0: variabila creste durata de executie
### rho < 0: variabila scurteaza durata de executie
### Coloana 'interpretare' contine deja rezultatul interpret_r aplicat automat pentru fiecare variabila

g1 <- ggplot(spearman_set99, aes(x = reorder(variabila, rho), y = rho)) +
  geom_col(width = 0.55, fill = '#2980b9') +
  geom_text(aes(label = paste0('rho = ', rho, ' ', semn),
                hjust = ifelse(rho >= 0, -0.08, 1.08)), size = 3.8) +
  coord_flip() +
  labs(title    = 'Set standard (99)',
       subtitle = '*** p<0.001  ** p<0.01  * p<0.05  ns = nesemnificativ',
       x = '', y = 'Coeficient Spearman (rho)') +
  theme(plot.title       = element_text(face = 'bold', hjust = 0.5),
        plot.subtitle    = element_text(hjust = 0.5, size = 10),
        panel.grid.minor = element_blank())

g2 <- ggplot(spearman_set250, aes(x = reorder(variabila, rho), y = rho)) +
  geom_col(width = 0.55, fill = '#27ae60') +
  geom_text(aes(label = paste0('rho = ', rho, ' ', semn),
                hjust = ifelse(rho >= 0, -0.08, 1.08)), size = 3.8) +
  coord_flip() +
  labs(title    = 'Set propriu (250)',
       subtitle = '*** p<0.001  ** p<0.01  * p<0.05  ns = nesemnificativ',
       x = '', y = 'Coeficient Spearman (rho)') +
  theme(plot.title       = element_text(face = 'bold', hjust = 0.5),
        plot.subtitle    = element_text(hjust = 0.5, size = 10),
        panel.grid.minor = element_blank())

x <- g1 + g2 + plot_layout(ncol = 2)
x


###############################################################################################
###              SELECT — Chi-square + Kruskal-Wallis + Spearman                           ###
###  Nota: nr_select si nr_from sunt identice structural in ambele seturi de date          ###
###  (fiecare SELECT are un FROM corespondent), de aceea sunt analizate impreuna           ###
###  si rezultatele lor sunt in mod asteptat identice                                      ###
###############################################################################################

#########################################################################
### RQ19: Exista o asociere intre numarul de clauze SELECT si
###       rata de finalizare a interogarilor?
### Ambele variabile sunt nominale => Chi-square test of independence
### H0: variabilele sunt independente
#########################################################################

table(date_set99$nr_select,  date_set99$succes_label)
table(date_set250$nr_select, date_set250$succes_label)

date_set99 <- date_set99 |>
  mutate(cat_select = factor(case_when(
    nr_select == 1 ~ '1',
    nr_select <= 3 ~ '2-3',
    TRUE           ~ '4+'
  ), levels = c('1', '2-3', '4+')))

date_set250 <- date_set250 |>
  mutate(cat_select = factor(case_when(
    nr_select == 1 ~ '1',
    nr_select <= 3 ~ '2-3',
    TRUE           ~ '4+'
  ), levels = c('1', '2-3', '4+')))

g1 <- ggbarstats(
  data         = date_set99,
  x            = cat_select,
  y            = succes_label,
  label        = 'both',
  bf.message   = FALSE,
  title        = 'Set standard (99)',
  xlab         = 'Status executie',
  legend.title = 'Nr. SELECT') +
  theme(legend.position = 'bottom') +
  theme(text          = element_text(size = 13),
        plot.title    = element_text(size = 14, hjust = 0.5),
        plot.subtitle = element_text(size = 12, hjust = 0.5),
        plot.caption  = element_blank(),
        legend.text   = element_text(size = 12))

g2 <- ggbarstats(
  data         = date_set250,
  x            = cat_select,
  y            = succes_label,
  label        = 'both',
  bf.message   = FALSE,
  title        = 'Set propriu (250)',
  xlab         = 'Status executie',
  legend.title = 'Nr. SELECT') +
  theme(legend.position = 'bottom') +
  theme(text          = element_text(size = 13),
        plot.title    = element_text(size = 14, hjust = 0.5),
        plot.subtitle = element_text(size = 12, hjust = 0.5),
        plot.caption  = element_blank(),
        legend.text   = element_text(size = 12))

x <- g1 + g2 + plot_layout(ncol = 2, guides = 'collect') & theme(legend.position = 'bottom')
x

#effectsize::interpret_cramers_v(0.16)   
### Set99:  V = 0.16 => intensitate small
### Set250: V = ??? => intensitate ???


#########################################################################
### RQ20: Difera timpii de executie in functie de numarul de SELECT?
### Variabila x: nominala (cat_select); variabila y: numerica, non-normala
### => Kruskal-Wallis
### H0: distributiile sunt identice pentru toate categoriile SELECT
#########################################################################

timpi_set99 <- timpi_set99 |>
  mutate(cat_select = factor(case_when(
    nr_select == 1 ~ '1',
    nr_select <= 3 ~ '2-3',
    TRUE           ~ '4+'
  ), levels = c('1', '2-3', '4+')))

timpi_set250 <- timpi_set250 |>
  mutate(cat_select = factor(case_when(
    nr_select == 1 ~ '1',
    nr_select <= 3 ~ '2-3',
    TRUE           ~ '4+'
  ), levels = c('1', '2-3', '4+')))

set.seed(1234)
g1 <- ggbetweenstats(
  data  = timpi_set99,
  x     = cat_select,
  y     = log_timp,
  type  = 'np',
  title = 'Set standard (99)',
  xlab  = 'Nr. SELECT (categorii)',
  ylab  = 'log10(Timp executie, secunde)') +
  theme(text          = element_text(size = 13),
        plot.title    = element_text(size = 14, hjust = 0.5),
        plot.subtitle = element_text(size = 12, hjust = 0.5),
        plot.caption  = element_blank(),
        legend.text   = element_text(size = 12))

set.seed(1234)
g2 <- ggbetweenstats(
  data  = timpi_set250,
  x     = cat_select,
  y     = log_timp,
  type  = 'np',
  title = 'Set propriu (250)',
  xlab  = 'Nr. SELECT (categorii)',
  ylab  = 'log10(Timp executie, secunde)') +
  theme(text          = element_text(size = 13),
        plot.title    = element_text(size = 14, hjust = 0.5),
        plot.subtitle = element_text(size = 12, hjust = 0.5),
        plot.caption  = element_blank(),
        legend.text   = element_text(size = 12))

x <- g1 + g2 + plot_layout(ncol = 2)
x

#effectsize::interpret_epsilon_squared(0.01)
# effectsize::interpret_rank_biserial(-0.26)
### Set99:  epsilon^2 = ??? => marime efect small
### Set250: r_biserial = ??? => marime efect medium

#########################################################################
### RQ21: Exista o corelatie intre numarul de SELECT (numeric) si
###       durata de executie (log)?
### Ambele variabile sunt numerice, non-normale => Spearman
### H0: cele doua variabile sunt independente (rho = 0)
#########################################################################

set.seed(1234)
g1 <- ggscatterstats(
  data  = timpi_set99,
  x     = nr_select,
  y     = log_timp,
  type  = 'np',
  title = 'Set standard (99)',
  xlab  = 'Nr. SELECT',
  ylab  = 'log10(Timp executie, secunde)')

set.seed(1234)
g2 <- ggscatterstats(
  data  = timpi_set250,
  x     = nr_select,
  y     = log_timp,
  type  = 'np',
  title = 'Set propriu (250)',
  xlab  = 'Nr. SELECT',
  ylab  = 'log10(Timp executie, secunde)')

x <- g1 + g2 + plot_layout(ncol = 2)
x

#effectsize::interpret_r(0.14, rules = 'cohen1988')   
### Set99:  rho = ??? => intensitate small
### Set250: rho = ??? => intensitate smalll
### nr_select si nr_from produc rezultate identice — nr_from nu este analizat separat