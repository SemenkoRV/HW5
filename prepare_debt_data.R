library(tidyverse)
library(dplyr)
prepare_debt_data <- function(.debt_original){
  #removing years 1800-1959 and converting to longer format
  debt_longer <- .debt_original %>% select(-(2:161))
  
  debt_longer <- debt_longer %>%
    pivot_longer(
      cols = -1,                       # keep first column (country)
      names_to = "year",
      values_to = "debt_as_percent_of_gdp"
    )
  
  #no data to NA
  debt_longer <- debt_longer %>% mutate(across(debt_as_percent_of_gdp, ~na_if(.x,"no data")))
  #rename Debt % of gdp to country
  debt_longer <- debt_longer %>% rename(country = 'DEBT (% of GDP)')
  
  #Convert type of debt_as_percent_of_gdp to numeric
  debt_longer$debt_as_percent_of_gdp <- as.numeric(debt_longer$debt_as_percent_of_gdp)
  debt_longer$year <- as.numeric(debt_longer$year)
  return(debt_longer)
}