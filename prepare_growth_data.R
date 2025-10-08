library(tidyverse)
library(dplyr)
prepare_growth_data <- function(.growth_original){
  #removing countries that are not countries
  growth_cleaned_countries <- .growth_original %>%
    filter(!`Country Code` %in% c('AFE',	'AFW',	'ARB',	'CSS',	'CEB',	'EAR',
                                  'EAS',	'EAP',	'TEA',	'EMU',	'ECS',	'ECA',
                                  'TEC',	'EUU',	'FCS',	'HPC',	'HIC',	'IBD',
                                  'IBT',	'IDB',	'IDX',	'IDA',	'LTE',	'LCN',
                                  'LAC',	'TLA',	'LDC',	'LMY',	'LIC',	'LMC',
                                  'MEA',	'MNA',	'TMN',	'MIC',	'NAC',	'INX',
                                  'OED',	'OSS',	'PSS',	'PST',	'PRE',	'SST',
                                  'SAS',	'TSA',	'SSF',	'SSA',	'TSS',	'UMC',
                                  'WLD',	'ASM',	'AND',	'ABW',	'BMU',	'VGB',
                                  'CYM',	'CHI',	'CUB',	'CUW',	'FRO',	'PYF',
                                  'GIB',	'GRL',	'GRD',	'IMN',	'MAC',	'MCO',
                                  'NRU',	'NCL',	'MNP',	'PLW',	'STP',	'SXM',
                                  'SOM',	'MAF',	'TLS',	'TCA',	'VIR',	'PSE',
                                  'GUM', 'KOR')) #maybe LIE?
  #renaming Country Name to country
  growth_cleaned_countries <- growth_cleaned_countries %>% rename(country = 'Country Name')
  #renaming countries that have different name in the debt table
  growth_cleaned_countries <- growth_cleaned_countries %>%
    mutate(country = case_when(
      `Country Code` == 'CHN' ~ "China, People's Republic of",
      `Country Code` == 'COD' ~ "Congo, Dem. Rep. of the",
      `Country Code` == 'COG' ~ "Congo, Republic of",
      `Country Code` == 'CIV' ~ "Côte d'Ivoire",
      `Country Code` == 'EGY' ~ "Egypt",
      `Country Code` == 'HKG' ~ "Hong Kong SAR",
      `Country Code` == 'IRN' ~ "Iran",
      `Country Code` == 'PRK' ~ "Korea, Republic of", ##double check
      `Country Code` == 'LAO' ~ "Lao P.D.R.", 
      `Country Code` == 'FSM' ~ "Micronesia, Fed. States of", 
      `Country Code` == 'SSD' ~ "South Sudan, Republic of", 
      `Country Code` == 'KNA' ~ "Saint Kitts and Nevis", 
      `Country Code` == 'LCA' ~ "Saint Lucia", 
      `Country Code` == 'VCT' ~ "Saint Vincent and the Grenadines", 
      `Country Code` == 'SYR' ~ "Syria", 
      `Country Code` == 'TUR' ~ "Turkey", 
      `Country Code` == 'VEN' ~ "Venezuela", 
      `Country Code` == 'YEM' ~ "Yemen", 
      TRUE    ~ country
    ))
  #make table in longer format
  growth_longer <- growth_cleaned_countries %>%
    pivot_longer(
      cols = -c(1:4),                       # keep first column (country)
      names_to = "year",
      values_to = "growth_as_percent"
    )
  
  #Convert type of growth_as_percent, year to numeric
  growth_longer$growth_as_percent <- as.numeric(growth_longer$growth_as_percent)
  growth_longer$year <- as.numeric(growth_longer$year)
  return(growth_longer)
}