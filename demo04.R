library(tidyverse)
library(here)
library(sf)
library(janitor)
library(tmap)
library(countrycode)
#install.packages("countrycode")

#1.	数据导入
data_csv <- read_csv(here::here("homework/homework04/Data", 
                              "HDR21-22_Composite_indices_complete_time_series.csv"),
                   na= "NULL")
worldShape <- st_read(here::here("homework/homework04/Data/World_Countries_Generalized",
"World_Countries_Generalized.shp"))

#2.	差异计算
#3.	代码转换 
diffChange_csv <- data_csv %>% 
  clean_names()%>%
  select(gii_2010,gii_2019,iso3)%>%
  mutate(diffNum = gii_2019-gii_2010)%>%
  mutate(isoCode=countrycode(iso3, origin="iso3c",destination="iso2c"))

# clean_names() 列名格式化


#4.	空间连接 （左连接） 
join_shpCsv <- worldShape %>%
  clean_names()%>%
  left_join(.,
            diffChange_csv,
            by = c("iso"="isoCode"))

# 制图
tmap_mode("plot")
map <- join_shpCsv %>% 
  tm_shape(.) + 
  tm_fill('diffNum') +
  tm_layout(title = 'lwx mapping diff')
map
