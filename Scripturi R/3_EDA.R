###############################################################################################
###                        Lucrare de diplomă - Claudiu Bogdan - iulie 2026                 ###
###############################################################################################
###                    3b. EDA — Rata de succes, distribuția timpilor, comparație mediane   ###
###############################################################################################
# ultima actualizare: 2026-06-15

options(scipen = 999)
library(tidyverse)
library(patchwork)


###############################################################################################
###                                  Încărcare și pregătire date                            ###
###############################################################################################

setwd('C:/Users/claud/OneDrive/Desktop/2025-2026/R')
load('rezultate_finale.RData')
load('metadata_interogari.RData')

date_set99  <- rezultate_set99_final  |> left_join(metadata_set99,  by = 'interogare_nr')
date_set250 <- rezultate_set250_final |> left_join(metadata_set250, by = 'interogare_nr')

sf_levels <- c(1, 5, 10, 50, 100)
date_set99  <- date_set99  |> mutate(marime_bd = factor(marime_bd, levels = sf_levels))
date_set250 <- date_set250 |> mutate(marime_bd = factor(marime_bd, levels = sf_levels))

date_set99 <- date_set99 |>
  mutate(status = case_when(
    succes_timeout20 == 'success' ~ 'Finalizat',
    succes_timeout20 == 'abandon' ~ 'Abandon',
    TRUE ~ 'Oprit (timeout)'
  ))

date_set250 <- date_set250 |>
  mutate(status = case_when(
    succes_timeout20 == 'success' ~ 'Finalizat',
    succes_timeout20 == 'abandon' ~ 'Abandon',
    TRUE ~ 'Oprit (timeout)'
  ))

# Doar interogările finalizate cu succes pentru analizele de timpi
# cele cu abandon ar distorsiona distribuțiile
timpi_set99 <- date_set99 |>
  filter(succes_timeout20 == 'success') |>
  mutate(
    durata_executie_sec = durata_executie_ms / 1000,
    log_timp = log10(durata_executie_ms / 1000)
  )

timpi_set250 <- date_set250 |>
  filter(succes_timeout20 == 'success') |>
  mutate(
    durata_executie_sec = durata_executie_ms / 1000,
    log_timp = log10(pmax(durata_executie_ms / 1000, 0.001))
  )

glimpse(timpi_set99)
glimpse(timpi_set250)


###############################################################################################
###                                  Temă și culori comune                                  ###
###############################################################################################

tema_licenta <- theme_minimal(base_size = 13) +
  theme(
    plot.title       = element_text(face = 'bold', size = 14, hjust = 0.5),
    plot.subtitle    = element_text(hjust = 0.5, color = 'gray40'),
    axis.title       = element_text(face = 'bold'),
    legend.position  = 'bottom',
    panel.grid.minor = element_blank()
  )

culori_status <- c(
  'Finalizat' = '#2ecc71',
  'Abandon'   = '#e67e22'
)


###############################################################################################
##                        c. Rata de succes per Scale Factor                                ##
###############################################################################################

rata_set99 <- date_set99 |>
  count(marime_bd, status) |>
  group_by(marime_bd) |>
  mutate(pct = n / sum(n) * 100)

rata_set250 <- date_set250 |>
  count(marime_bd, status) |>
  group_by(marime_bd) |>
  mutate(pct = n / sum(n) * 100)

# Set standard (99)
g_rata99 <- ggplot(rata_set99, aes(x = marime_bd, y = pct, fill = status)) +
  geom_col(position = 'stack', width = 0.6) +
  geom_text(aes(label = ifelse(pct > 5, paste0(round(pct, 1), '%'), '')),
            position = position_stack(vjust = 0.5),
            size = 3.5, color = 'white', fontface = 'bold') +
  scale_fill_manual(values = culori_status) +
  scale_y_continuous(labels = function(x) paste0(x, '%')) +
  labs(title = 'Set standard (99)',
       x = 'Scale Factor', y = 'Procent interogări (%)') +
  tema_licenta +
  theme(legend.title = element_blank())
g_rata99

# Set propriu (250)
g_rata250 <- ggplot(rata_set250, aes(x = marime_bd, y = pct, fill = status)) +
  geom_col(position = 'stack', width = 0.6) +
  geom_text(aes(label = ifelse(pct > 5, paste0(round(pct, 1), '%'), '')),
            position = position_stack(vjust = 0.5),
            size = 3.5, color = 'white', fontface = 'bold') +
  scale_fill_manual(values = culori_status) +
  scale_y_continuous(labels = function(x) paste0(x, '%')) +
  labs(title = 'Set propriu (250)',
       x = 'Scale Factor', y = 'Procent interogări (%)') +
  tema_licenta +
  theme(legend.title = element_blank())
g_rata250

# Combinat
g_rata99 + g_rata250 +
  plot_layout(ncol = 2) +
  plot_annotation(
    title = 'Rata de finalizare a interogărilor',
    theme = theme(plot.title = element_text(face = 'bold', size = 15, hjust = 0.5))
  )


###############################################################################################
##                        d. Distribuția timpilor de execuție                               ##
###############################################################################################

# Set standard (99)
g_timpi99 <- ggplot(timpi_set99, aes(x = marime_bd, y = durata_executie_sec, fill = marime_bd)) +
  geom_boxplot(outlier.shape = 21, outlier.size = 2, alpha = 0.8) +
  scale_fill_brewer(palette = 'Blues') +
  scale_y_log10(labels = function(x) paste0(round(x, 1), 's')) +
  labs(title = 'Set standard (99)',
       x = 'Scale Factor', y = 'Timp execuție (secunde, log)') +
  tema_licenta +
  theme(legend.position = 'none')
g_timpi99

# Set propriu (250)
g_timpi250 <- ggplot(timpi_set250, aes(x = marime_bd, y = durata_executie_sec, fill = marime_bd)) +
  geom_boxplot(outlier.shape = 21, outlier.size = 2, alpha = 0.8) +
  scale_fill_brewer(palette = 'Greens') +
  scale_y_log10(labels = function(x) paste0(round(x, 1), 's')) +
  labs(title = 'Set propriu (250)',
       x = 'Scale Factor', y = 'Timp execuție (secunde, log)') +
  tema_licenta +
  theme(legend.position = 'none')
g_timpi250

# Combinat
g_timpi99 + g_timpi250 +
  plot_layout(ncol = 2) +
  plot_annotation(
    title = 'Distribuția timpilor de execuție',
    theme = theme(plot.title = element_text(face = 'bold', size = 15, hjust = 0.5))
  )


###############################################################################################
##                        l. Comparație timp median între cele două seturi                  ##
###############################################################################################

trend_set99 <- timpi_set99 |>
  group_by(marime_bd) |>
  summarise(median_sec = median(durata_executie_sec, na.rm = TRUE), .groups = 'drop') |>
  mutate(set = 'Standard (99)')

trend_set250 <- timpi_set250 |>
  group_by(marime_bd) |>
  summarise(median_sec = median(durata_executie_sec, na.rm = TRUE), .groups = 'drop') |>
  mutate(set = 'Propriu (250)')

trend_combined <- bind_rows(trend_set99, trend_set250) |>
  mutate(
    marime_bd_num = as.numeric(as.character(marime_bd)),
    label_vjust   = if_else(set == 'Standard (99)', -1.2, 1.5)
  )

ggplot(trend_combined, aes(x = marime_bd_num, y = median_sec, color = set, group = set)) +
  geom_line(linewidth = 1.2) +
  geom_point(size = 4) +
  geom_text(aes(label = paste0(round(median_sec, 1), 's'), vjust = label_vjust),
            size = 3.5, fontface = 'bold', show.legend = FALSE) +
  scale_color_manual(values = c('Standard (99)' = '#2980b9', 'Propriu (250)' = '#27ae60')) +
  scale_x_continuous(breaks = sf_levels, labels = paste0('SF', sf_levels)) +
  scale_y_continuous(expand = expansion(mult = c(0.1, 0.15))) +
  labs(title = 'Comparație timp median de execuție',
       x = 'Scale Factor', y = 'Timp median (secunde)', color = 'Set interogări') +
  tema_licenta


###############################################################################################
##                        e. Frecvența operațiilor SQL per set                              ##
##                        (câte interogări conțin cel puțin o apariție a clauzei)          ##
###############################################################################################

labels_clauze <- c(
  nr_select  = 'SELECT',
  nr_from    = 'FROM',
  nr_where   = 'WHERE',
  nr_group   = 'GROUP_BY',
  nr_having  = 'HAVING',
  nr_joinuri = 'JOIN',
  nr_limit   = 'LIMIT'
)

# Un rând per interogare (independent de Scale Factor)
meta99_unic  <- metadata_set99  |> distinct(interogare_nr, .keep_all = TRUE)
meta250_unic <- metadata_set250 |> distinct(interogare_nr, .keep_all = TRUE)

# Folosim doar coloanele care există efectiv în fiecare set
# (dacă metadata_interogari.RData e mai vechi și nu are nr_limit în set99,
#  rerulează 02a_parsare_interogari.R ca să îl regenerezi)
vars99  <- intersect(names(labels_clauze), names(meta99_unic))
vars250 <- intersect(names(labels_clauze), names(meta250_unic))

frecventa_99 <- meta99_unic |>
  summarise(across(all_of(vars99), ~ sum(. > 0, na.rm = TRUE))) |>
  pivot_longer(everything(), names_to = 'variabila', values_to = 'n') |>
  mutate(
    clauza = labels_clauze[variabila],
    grup   = if_else(n >= 60, 'frecvent', 'rar')
  )

frecventa_250 <- meta250_unic |>
  summarise(across(all_of(vars250), ~ sum(. > 0, na.rm = TRUE))) |>
  pivot_longer(everything(), names_to = 'variabila', values_to = 'n') |>
  mutate(
    clauza = labels_clauze[variabila],
    grup   = if_else(n >= 150, 'frecvent', 'rar')
  )

# Set standard (99)
g_freq99 <- ggplot(frecventa_99 |> arrange(desc(n)),
                   aes(x = reorder(clauza, n), y = n, fill = grup)) +
  geom_col(width = 0.35) +
  geom_text(aes(label = n), hjust = -0.2, fontface = 'bold', size = 4) +
  coord_flip() +
  scale_fill_manual(values = c('frecvent' = '#1a6fa8', 'rar' = '#74b4d8'), guide = 'none') +
  scale_y_continuous(limits = c(0, 115), expand = expansion(mult = c(0, 0.05))) +
  labs(title = 'Set standard (99)', x = '', y = 'Număr interogări') +
  tema_licenta
g_freq99

# Set propriu (250)
g_freq250 <- ggplot(frecventa_250 |> arrange(desc(n)),
                    aes(x = reorder(clauza, n), y = n, fill = grup)) +
  geom_col(width = 0.35) +
  geom_text(aes(label = n), hjust = -0.2, fontface = 'bold', size = 4) +
  coord_flip() +
  scale_fill_manual(values = c('frecvent' = '#1a6fa8', 'rar' = '#74b4d8'), guide = 'none') +
  scale_y_continuous(limits = c(0, 280), expand = expansion(mult = c(0, 0.05))) +
  labs(title = 'Set propriu (250)', x = '', y = 'Număr interogări') +
  tema_licenta
g_freq250

# Combinat — 99 primul, 250 al doilea, fără titlu global
g_freq99 + g_freq250 +
  plot_layout(ncol = 2)


###############################################################################################
##                        f. Distribuția structurală a variabilelor SQL                     ##
##                        (câte interogări au 0, 1, 2, ... apariții per clauză)             ##
###############################################################################################

dist99 <- meta99_unic |>
  select(interogare_nr, all_of(vars99)) |>
  pivot_longer(-interogare_nr, names_to = 'variabila', values_to = 'valoare') |>
  mutate(
    clauza = factor(labels_clauze[variabila],
                    levels = intersect(c('FROM', 'GROUP_BY', 'HAVING', 'JOIN',
                                         'LIMIT', 'SELECT', 'WHERE'),
                                       labels_clauze[vars99])),
    set = 'Standard (99)'
  )

dist250 <- meta250_unic |>
  select(interogare_nr, all_of(vars250)) |>
  pivot_longer(-interogare_nr, names_to = 'variabila', values_to = 'valoare') |>
  mutate(
    clauza = factor(labels_clauze[variabila],
                    levels = intersect(c('FROM', 'GROUP_BY', 'HAVING', 'JOIN',
                                         'LIMIT', 'SELECT', 'WHERE'),
                                       labels_clauze[vars250])),
    set = 'Propriu (250)'
  )

dist_combinat <- bind_rows(dist250, dist99) |>
  mutate(set = factor(set, levels = c('Propriu (250)', 'Standard (99)')))

# Breaks personalizate per clauză — valori discrete cu sens
breaks_clauze <- list(
  'FROM'     = 0:15,
  'GROUP_BY' = 0:6,
  'HAVING'   = 0:3,
  'JOIN'     = c(0, 2, 4, 6, 8, 10, 15, 20, 30),
  'LIMIT'    = 0:2,
  'SELECT'   = c(0, 1, 2, 3, 5, 10, 15),
  'WHERE'    = c(0, 1, 2, 3, 5, 10, 15)
)

# Construim câte un plot per clauză și le combinăm cu patchwork
clauze_ordine <- c('Nr. FROM', 'Nr. GROUP BY', 'Nr. HAVING', 'Nr. JOIN-uri',
                   'Nr. LIMIT', 'Nr. SELECT', 'Nr. WHERE')

plot_distributie <- function(clauza_cod, clauza_label) {
  brks <- breaks_clauze[[clauza_cod]]
  dist_combinat |>
    filter(clauza == clauza_cod) |>
    mutate(valoare_disc = factor(valoare)) |>
    count(set, valoare) |>
    ggplot(aes(x = valoare, y = n, fill = set)) +
    geom_col(width = 0.8) +
    facet_grid(set ~ ., scales = 'free_y', switch = 'y') +
    scale_fill_manual(values = c('Standard (99)' = '#4a90c4',
                                 'Propriu (250)' = '#2ecc71'),
                      guide = 'none') +
    scale_x_continuous(breaks = brks,
                       expand = expansion(mult = c(0.02, 0.05))) +
    labs(title = clauza_label, x = NULL, y = NULL) +
    tema_licenta +
    theme(
      plot.title    = element_text(size = 9, face = 'bold', hjust = 0.5),
      strip.text.y  = element_text(size = 7, angle = 0),
      axis.text.x   = element_text(size = 7),
      axis.text.y   = element_text(size = 7),
      panel.spacing = unit(0.3, 'lines'),
      plot.margin   = margin(2, 4, 2, 4)
    )
}

p_from    <- plot_distributie('FROM',     'Nr. FROM')
p_group   <- plot_distributie('GROUP_BY', 'Nr. GROUP BY')
p_having  <- plot_distributie('HAVING',   'Nr. HAVING')
p_join    <- plot_distributie('JOIN',     'Nr. JOIN-uri')
p_limit   <- plot_distributie('LIMIT',    'Nr. LIMIT')
p_select  <- plot_distributie('SELECT',   'Nr. SELECT')
p_where   <- plot_distributie('WHERE',    'Nr. WHERE')

(p_from | p_group | p_having | p_join | p_limit | p_select | p_where) +
  plot_annotation(
    title    = 'Distribuția variabilelor structurale per set de interogări',
    subtitle = 'Fiecare interogare numărată o singură dată (independent de Scale Factor)',
    theme = theme(
      plot.title    = element_text(face = 'bold', size = 14, hjust = 0.5),
      plot.subtitle = element_text(size = 10, hjust = 0.5, color = 'gray40')
    )
  )


###############################################################################################
##                        Tabel mediane comparative per Scale Factor                        ##
###############################################################################################

bind_rows(
  timpi_set99 |>
    group_by(marime_bd) |>
    summarise(median_sec = round(median(durata_executie_sec), 2),
              n = n(), .groups = 'drop') |>
    mutate(set = 'Standard (99)'),
  timpi_set250 |>
    group_by(marime_bd) |>
    summarise(median_sec = round(median(durata_executie_sec), 2),
              n = n(), .groups = 'drop') |>
    mutate(set = 'Propriu (250)')
) |>
  pivot_wider(names_from = set, values_from = c(median_sec, n))


###############################################################################################
###                            Heatmap succes per interogare                               ###
###############################################################################################
### Fiecare rand = o interogare | Fiecare coloana = un Scale Factor
### Verde = interogare finalizata in timeout | Portocaliu = interogare abandonata

# Set standard (99)
g_heatmap99 <- ggplot(heatmap_set99,
                      aes(x = factor(marime_bd), y = factor(interogare_nr), fill = status_label)) +
  geom_tile(color = 'white', linewidth = 0.1) +
  scale_fill_manual(values = culori_status, name = 'Status') +
  labs(title = 'Heatmap succes per interogare \u2014 Set standard (99)',
       x = 'Scale Factor', y = 'Nr. interogare') +
  theme(axis.text.y     = element_text(size = 5),
        plot.title      = element_text(face = 'bold', hjust = 0.5),
        legend.position = 'bottom')

g_heatmap99

# Set propriu (250)
g_heatmap250 <- ggplot(heatmap_set250,
                       aes(x = factor(marime_bd), y = factor(interogare_nr), fill = status_label)) +
  geom_tile(color = 'white', linewidth = 0.1) +
  scale_fill_manual(values = culori_status, name = 'Status') +
  labs(title = 'Heatmap succes per interogare \u2014 Set propriu (250)',
       x = 'Scale Factor', y = 'Nr. interogare') +
  theme(axis.text.y     = element_text(size = 3),
        plot.title      = element_text(face = 'bold', hjust = 0.5),
        legend.position = 'bottom')

g_heatmap250
