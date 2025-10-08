library(dplyr)
merge_two_tables <- function(.table1, .table2){
  merged_df <- left_join(.table1, .table2, by = c("country", "year"))
  return(merged_df)
}