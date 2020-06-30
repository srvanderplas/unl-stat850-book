# Clean up General Payment Data

library(tidyverse)
gpd <- read_csv("data/General_Payment_Data_Full.csv", guess_max = 36000)
gpd2 <- gpd %>%
  select(-matches("Teaching_Hospital"), -ends_with(c("2", "3", "4", "5")),
         -Form_of_Payment_or_Transfer_of_Value,
         -Covered_Recipient_Type, -Physician_Primary_Type,
         -Delay_in_Publication_Indicator, -Program_Year,
         -Payment_Publication_Date, -Related_Product_Indicator,
         -Dispute_Status_for_Publication,
         -Physician_First_Name, -Physician_Middle_Name,
         -Physician_Last_Name, -Physician_Name_Suffix,
         -matches("Physician_License_State")) # Remove less informative columns

gpd2 %>% summarize_all(~length(unique(.))) %>% t()

write_csv(gpd2, "data/General_Payment_Data.csv", na = '.')

gpd2 %>%
  sample_frac(.25) %>%
  write_csv("data/General_Payment_Data_Sample.csv", na = '.')

