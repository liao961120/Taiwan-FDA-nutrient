library(dplyr)
library(tidyr)
dir.create("made/db", recursive = T)
dir.create("made/json", recursive = T)

d = d0 = readr::read_csv("made/data.csv")
names(d) = stom::as_vec("FOOD_TYPE, DATA_TYPE, ID, ITEM, COMMON_NAMES,
                        ENGLISH_NAME, CONTENT_DESC, DISPOSAL_RATE,
                        ANALY_CATEGORY, ANALY_ITEM, UNIT_TYPE, UNIT_PER_100g,
                        SAMPLE_SIZE, SD, CONTAIN_PER_BATCH, PER_PORTION_WEIGHT, 
                        CONTAIN_PER_PORTION_WEIGHT")

d_item = d |> 
    select(ID, ITEM, COMMON_NAMES, ENGLISH_NAME, CONTENT_DESC, 
           DISPOSAL_RATE, PER_PORTION_WEIGHT, FOOD_TYPE, DATA_TYPE) |> 
    mutate(PER_PORTION_WEIGHT = gsub("克", "", PER_PORTION_WEIGHT, fixed=T),
           PER_PORTION_WEIGHT = as.numeric(PER_PORTION_WEIGHT),
           DISPOSAL_RATE = ifelse(is.na(DISPOSAL_RATE), 0, DISPOSAL_RATE)) |> 
    distinct()
# glimpse(d_item)


# Nutrition measurement unit
d_unit = d |> 
    select(ANALY_ITEM, UNIT_TYPE) |> 
    distinct()

# Nutrition vector
dn = d |> 
    select(ID, ANALY_ITEM, SAMPLE_SIZE, 
           CONTAIN_PER_BATCH, SD) |> 
    pivot_wider(id_cols = ID, 
                names_from = ANALY_ITEM,
                values_from = CONTAIN_PER_BATCH) 

# Merged data
dv = left_join(d_item, dn, by=c("ID"="ID")) 


#################
#### OUTPUTS ####
#################
# Tabular data format
openxlsx::write.xlsx( list(main=dv, unit=d_unit), 
                      "made/nutrition.xlsx", 
                      asTable=T, firstActiveCol = 3, 
                      firstActiveRow = 2)
readr::write_csv(dv, "made/nutrition.csv")

# Separate data tables
readr::write_csv(d_item, "made/db/item.csv")
readr::write_csv(d_unit, "made/db/unit.csv")
readr::write_csv(dn, "made/db/nutrition.csv")


######################
#### JSON OUTPUTS ####
######################
jsonlite::write_json(d_item, "made/json/d_item.json", 
                     auto_unbox = T, pretty=T, na="null")


dn_vec = lapply(1:nrow(dn), \(i) unlist(dn[i, -1]))
names(dn_vec) = dn$ID
jsonlite::write_json(dn_vec, "made/json/dn_vec.json", pretty=T, na="null")
jsonlite::write_json(colnames(dn)[-1], "made/json/dn_vec_ord.json", na="null")

d_unit_vec = as.list(d_unit$UNIT_TYPE)
names(d_unit_vec) = d_unit$ANALY_ITEM
jsonlite::write_json(d_unit_vec, "made/json/d_unit_vec.json", 
                     auto_unbox = T, na="null")

file.create(".nojekyll")

