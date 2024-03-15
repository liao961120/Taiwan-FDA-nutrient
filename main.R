library(dplyr)

# Recode data
d = readr::read_csv("20_2.csv")
names(d) = stom::as_vec("FOOD_TYPE, DATA_TYPE, ID, ITEM, COMMON_NAMES,
                        ENGLISH_NAME, CONTENT_DESC, DISPOSAL_RATE,
                        ANALY_CATEGORY, ANALY_ITEM, UNIT_TYPE, UNIT_PER_100g,
                        SAMPLE_SIZE, SD, CONTAIN_PER_BATCH, PER_BATCH_WEIGHT, CONTAIN_PER_BATCH_WEIGHT")
glimpse(d)

# Check items in data
d_item = d |> 
    select(ID, ITEM, COMMON_NAMES) |> 
    distinct(ID, .keep_all = T)
glimpse(d_item)
