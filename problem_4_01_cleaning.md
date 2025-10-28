# Re-evaluating Growth in the Time of Debt


- [<span class="toc-section-number">1</span> Domain problem
  formulation](#domain-problem-formulation)
- [<span class="toc-section-number">2</span> Data source
  overview](#data-source-overview)
- [<span class="toc-section-number">3</span> Step 1: Review background
  information](#sec-bg-info)
  - [<span class="toc-section-number">3.1</span> Data
    dictionary](#data-dictionary)
- [<span class="toc-section-number">4</span> Step 2: Loading in the
  data](#step-2-loading-in-the-data)
- [<span class="toc-section-number">5</span> Step 3: Examine the data
  and create action
  items](#step-3-examine-the-data-and-create-action-items)
  - [<span class="toc-section-number">5.1</span> Assessing Column
    names](#assessing-column-names)
  - [<span class="toc-section-number">5.2</span> Assessing variable
    type](#assessing-variable-type)
  - [<span class="toc-section-number">5.3</span> Assessing data
    completeness](#assessing-data-completeness)
- [<span class="toc-section-number">6</span> Step 4: Clean and
  pre-process the data](#step-4-clean-and-pre-process-the-data)

## Domain problem formulation

The goal is to try and reproduce the findings of Reinhart and Rogoff’s
study (introduced in Chapter 3) using historical public debt data as
well as gross domestic product (GDP) growth data.

## Data source overview

historical public debt data (debt.xls) from the International Monetary
Fund (IMF),  
Gross domestic product (GDP) growth data (growth.csv).

## Step 1: Review background information

### Data dictionary

## Step 2: Loading in the data

``` r
#install.packages("readxl")
#library(readxl)
library(tidyverse)
```

    ── Attaching core tidyverse packages ──────────────────────── tidyverse 2.0.0 ──
    ✔ dplyr     1.1.4     ✔ readr     2.1.5
    ✔ forcats   1.0.0     ✔ stringr   1.5.1
    ✔ ggplot2   4.0.0     ✔ tibble    3.2.1
    ✔ lubridate 1.9.3     ✔ tidyr     1.3.1
    ✔ purrr     1.0.2     
    ── Conflicts ────────────────────────────────────────── tidyverse_conflicts() ──
    ✖ dplyr::filter() masks stats::filter()
    ✖ dplyr::lag()    masks stats::lag()
    ℹ Use the conflicted package (<http://conflicted.r-lib.org/>) to force all conflicts to become errors

``` r
library(dplyr)

#Data first was fixed in Google sheets, and now I am loading corrected data
growth_original <- read_csv('/Users/romansemenko/Documents/FALL 2025/Practical data analysis/HW5/growth_original.csv')
```

    Rows: 266 Columns: 66
    ── Column specification ────────────────────────────────────────────────────────
    Delimiter: ","
    chr  (4): Country Name, Country Code, Indicator Name, Indicator Code
    dbl (61): 1961, 1962, 1963, 1964, 1965, 1966, 1967, 1968, 1969, 1970, 1971, ...
    lgl  (1): 1960

    ℹ Use `spec()` to retrieve the full column specification for this data.
    ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.

``` r
head(growth_original)
```

    # A tibble: 6 × 66
      `Country Name`  `Country Code` `Indicator Name` `Indicator Code` `1960` `1961`
      <chr>           <chr>          <chr>            <chr>            <lgl>   <dbl>
    1 Aruba           ABW            GDP growth (ann… NY.GDP.MKTP.KD.… NA     NA    
    2 Africa Eastern… AFE            GDP growth (ann… NY.GDP.MKTP.KD.… NA      0.240
    3 Afghanistan     AFG            GDP growth (ann… NY.GDP.MKTP.KD.… NA     NA    
    4 Africa Western… AFW            GDP growth (ann… NY.GDP.MKTP.KD.… NA      1.85 
    5 Angola          AGO            GDP growth (ann… NY.GDP.MKTP.KD.… NA     NA    
    6 Albania         ALB            GDP growth (ann… NY.GDP.MKTP.KD.… NA     NA    
    # ℹ 60 more variables: `1962` <dbl>, `1963` <dbl>, `1964` <dbl>, `1965` <dbl>,
    #   `1966` <dbl>, `1967` <dbl>, `1968` <dbl>, `1969` <dbl>, `1970` <dbl>,
    #   `1971` <dbl>, `1972` <dbl>, `1973` <dbl>, `1974` <dbl>, `1975` <dbl>,
    #   `1976` <dbl>, `1977` <dbl>, `1978` <dbl>, `1979` <dbl>, `1980` <dbl>,
    #   `1981` <dbl>, `1982` <dbl>, `1983` <dbl>, `1984` <dbl>, `1985` <dbl>,
    #   `1986` <dbl>, `1987` <dbl>, `1988` <dbl>, `1989` <dbl>, `1990` <dbl>,
    #   `1991` <dbl>, `1992` <dbl>, `1993` <dbl>, `1994` <dbl>, `1995` <dbl>, …

``` r
debt_original <- read_csv('/Users/romansemenko/Documents/FALL 2025/Practical data analysis/HW5/debt_original.csv')
```

    Rows: 194 Columns: 217
    ── Column specification ────────────────────────────────────────────────────────
    Delimiter: ","
    chr (217): DEBT (% of GDP), 1800, 1801, 1802, 1803, 1804, 1805, 1806, 1807, ...

    ℹ Use `spec()` to retrieve the full column specification for this data.
    ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.

## Step 3: Examine the data and create action items

“No data” values should be “NA” Data should be converted to long format
\###Debt: remove data for “debt” before 1960 first columns should be
renamed to “country” convert debt % rate, year from char to numeric
\###Growth remove non-existing countries renaming countries that have
different name in the debt table convert growth % rate, year char to
numeric \### Finding invalid values

``` r
#Debt
source('prepare_debt_data.R')
debt_clean <- prepare_debt_data(debt_original)
#Growth 
source("prepare_growth_data.R")
growth_clean <- prepare_growth_data(growth_original)
```

### Assessing Column names

Done above

### Assessing variable type

done before

### Assessing data completeness

``` r
#For the DEBT data
dim(debt_clean)
```

    [1] 10864     3

``` r
#note it's 194 (countries) times 56 years 

debt_clean |> 
  # keep only numeric variables
  select(where(is.numeric)) |> 
  # for each column, compute a data frame with the min, mean, and max.
  map_df(function(.col) { data.frame(min = min(.col, na.rm = TRUE),
                                     mean = mean(.col, na.rm = TRUE),
                                     max = max(.col, na.rm = TRUE)) },
         .id = "variable")
```

                    variable  min       mean     max
    1                   year 1960 1987.50000 2015.00
    2 debt_as_percent_of_gdp    0   56.11386 2092.92

``` r
debt_clean %>%
  sample_n(10)
```

    # A tibble: 10 × 3
       country                   year debt_as_percent_of_gdp
       <chr>                    <dbl>                  <dbl>
     1 Haiti                     2001                   49.5
     2 Greece                    2007                  103. 
     3 New Zealand               1969                   62.6
     4 Seychelles                1989                   79.9
     5 Côte d'Ivoire             2015                   48.9
     6 Saint Kitts and Nevis     1990                   44.4
     7 Taiwan Province of China  1961                   NA  
     8 Hungary                   1961                   NA  
     9 Vanuatu                   1999                   33.8
    10 Montenegro                1976                   NA  

``` r
#For the GROWTH data
dim(growth_clean)
```

    [1] 11532     6

``` r
growth_clean |> 
  # keep only numeric variables
  select(where(is.numeric)) |> 
  # for each column, compute a data frame with the min, mean, and max.
  map_df(function(.col) { data.frame(min = min(.col, na.rm = TRUE),
                                     mean = mean(.col, na.rm = TRUE),
                                     max = max(.col, na.rm = TRUE)) },
         .id = "variable")
```

               variable        min        mean      max
    1              year 1960.00000 1990.500000 2021.000
    2 growth_as_percent  -64.04711    3.699121  149.973

``` r
growth_clean %>%
  sample_n(10)
```

    # A tibble: 10 × 6
       country       `Country Code` `Indicator Name`      `Indicator Code`   year
       <chr>         <chr>          <chr>                 <chr>             <dbl>
     1 Liechtenstein LIE            GDP growth (annual %) NY.GDP.MKTP.KD.ZG  1966
     2 Lebanon       LBN            GDP growth (annual %) NY.GDP.MKTP.KD.ZG  2007
     3 Djibouti      DJI            GDP growth (annual %) NY.GDP.MKTP.KD.ZG  1995
     4 Mauritius     MUS            GDP growth (annual %) NY.GDP.MKTP.KD.ZG  1980
     5 Guinea-Bissau GNB            GDP growth (annual %) NY.GDP.MKTP.KD.ZG  1994
     6 Ukraine       UKR            GDP growth (annual %) NY.GDP.MKTP.KD.ZG  1985
     7 Honduras      HND            GDP growth (annual %) NY.GDP.MKTP.KD.ZG  2001
     8 Nigeria       NGA            GDP growth (annual %) NY.GDP.MKTP.KD.ZG  1989
     9 Zimbabwe      ZWE            GDP growth (annual %) NY.GDP.MKTP.KD.ZG  2014
    10 Ukraine       UKR            GDP growth (annual %) NY.GDP.MKTP.KD.ZG  1990
    # ℹ 1 more variable: growth_as_percent <dbl>

\###Comparing Australia as on gradescope

``` r
debt_clean %>% filter(country == 'Australia')
```

    # A tibble: 56 × 3
       country    year debt_as_percent_of_gdp
       <chr>     <dbl>                  <dbl>
     1 Australia  1960                   31.5
     2 Australia  1961                   30.3
     3 Australia  1962                   30.4
     4 Australia  1963                   29.3
     5 Australia  1964                   27.6
     6 Australia  1965                   NA  
     7 Australia  1966                   41.2
     8 Australia  1967                   39.2
     9 Australia  1968                   38.2
    10 Australia  1969                   35.7
    # ℹ 46 more rows

``` r
growth_clean %>% filter(country == 'Australia') %>% 
  select(country, year, growth_as_percent)
```

    # A tibble: 62 × 3
       country    year growth_as_percent
       <chr>     <dbl>             <dbl>
     1 Australia  1960             NA   
     2 Australia  1961              2.48
     3 Australia  1962              1.29
     4 Australia  1963              6.21
     5 Australia  1964              6.98
     6 Australia  1965              5.98
     7 Australia  1966              2.38
     8 Australia  1967              6.30
     9 Australia  1968              5.10
    10 Australia  1969              7.04
    # ℹ 52 more rows

## Step 4: Clean and pre-process the data

done in steps before Now merging two tables

``` r
source("merge_two_tables.R")
result <- merge_two_tables(growth_clean,debt_clean)

#Check the result for Australia
result %>% filter(country == 'Australia') %>%
  select(country,year,growth_as_percent,debt_as_percent_of_gdp)
```

    # A tibble: 62 × 4
       country    year growth_as_percent debt_as_percent_of_gdp
       <chr>     <dbl>             <dbl>                  <dbl>
     1 Australia  1960             NA                      31.5
     2 Australia  1961              2.48                   30.3
     3 Australia  1962              1.29                   30.4
     4 Australia  1963              6.21                   29.3
     5 Australia  1964              6.98                   27.6
     6 Australia  1965              5.98                   NA  
     7 Australia  1966              2.38                   41.2
     8 Australia  1967              6.30                   39.2
     9 Australia  1968              5.10                   38.2
    10 Australia  1969              7.04                   35.7
    # ℹ 52 more rows
