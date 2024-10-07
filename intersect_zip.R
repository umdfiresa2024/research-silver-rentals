library("terra")
library("tidyverse")

metro<-vect("Metro_Lines_Regional/Metro_Lines_Regional.shp")
silver<-subset(metro, metro$NAME=="silver")
silver_df<-as.data.frame(silver)

dc<-vect("DC_zips/Zip_Codes.shp")
dc_project<-project(dc, crs(silver))
dc_silver<-terra::intersect(dc_project, silver)
dc_silver_df<-as.data.frame(dc_silver) |>
  select(ZIPCODE) |>
  mutate(silver=1) 




md<-vect("MD/Maryland_Political_Boundaries_-_ZIP_Codes_-_5_Digit.shp")
md_project<-project(md, crs(silver))
md_silver<-terra::intersect(md_project, silver)
md_silver_df<-as.data.frame(md_silver) |>
  select(ZIPCODE1) |>
  rename(ZIPCODE=ZIPCODE1) |>
  mutate(silver=1)



va<-terra::makeValid(vect("VA/VA_Zip_Codes.shp"))
va_project<-project(va, crs(silver))
va_silver<-terra::intersect(va_project, silver)
va_silver_df<-as.data.frame(va_silver) |>
    select(ZIP_CODE) |>
    rename(ZIPCODE=ZIP_CODE) |>
  mutate(silver=1)


dc_centroid<-terra::centroids(dc_project)
dc_centroid_dist<-terra::distance(dc_centroid, silver, unit = "m")
dc_dist_df<-as.data.frame(dc_centroid_dist)
dc_df<-cbind(dc_centroid$ZIPCODE, dc_dist_df)
colnames(dc_df)[colnames(dc_df) == "dc_centroid$ZIPCODE"] <- "ZIPCODE"

md_centroid<-terra::centroids(md_project)
md_centroid_dist<-terra::distance(md_centroid, silver, unit = "m")
md_dist_df<-as.data.frame(md_centroid_dist)
md_df<-cbind(md_centroid$ZIPCODE1, md_dist_df)
colnames(md_df)[colnames(md_df) == "md_centroid$ZIPCODE1"] <- "ZIPCODE"

va_centroid<-terra::centroids(va_project)
va_centroid_dist<-terra::distance(va_centroid, silver, unit = "m")
va_dist_df<-as.data.frame(va_centroid_dist)
va_df<-cbind(va_centroid$ZIP_CODE, va_dist_df)
colnames(va_df)[colnames(va_df) == "va_centroid$ZIP_CODE"] <- "ZIPCODE"

silver_dist_df<-rbind(dc_df, md_df, va_df)
colnames(silver_dist_df)[colnames(silver_dist_df) == "V1"] <- "dist"





zip_silver<-rbind(dc_silver_df, md_silver_df, va_silver_df)

write.csv(zip_silver, "zip_silver.csv", row.names = F)

zori<-read.csv("zori.csv") |>
  mutate(date=as.Date(Date, format="%Y.%m.%d")) %>%
  rename(ZIPCODE=ZipCode)

table(zori$ZIPCODE)

df1<-merge(zori, zip_silver, by="ZIPCODE", all.x=TRUE) |>
  mutate(silver=ifelse(is.na(silver), 0, silver))

fdf<-merge(df1, silver_dist_df, by="ZIPCODE")

write.csv(fdf, "panel.csv", row.names=F)
