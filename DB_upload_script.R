rm(list=ls())
library(dplyr)

###########################################################################
###########################################################################
# This is the script we use to check over the needle locations sheets
# before uploading them to the AWS database

# In the needle locations file we create a field called LOCATION_ASSIGNED
#   which should be a concatenation of the reported location string and
#    the zip code

###########################################################################
###########################################################################
###########################################################################

setwd('/Users/aaronmamula/Documents/R projects/santa-cruz-NIPS/')
needles <- read.csv('SC-NiPS-Map/needle_locs.csv')
jan2020 <- read.csv('needle_logs/jan_2020.csv')
feb2020 <- read.csv('needle_logs/feb_2020.csv')
april2019 <- read.csv('needle_logs/april_2019.csv')
may2019 <- read.csv('needle_logs/may_2019.csv')

jan2020$LOCATION_RECORDED <- trimws(as.character(jan2020$LOCATION_RECORDED))
feb2020$LOCATION_RECORDED <- trimws(as.character(feb2020$LOCATION_RECORDED))
april2019$LOCATION_RECORDED <- trimws(as.character(april2019$LOCATION_RECORDED))
may2019$LOCATION_RECORDED <- trimws(as.character(may2019$LOCATION_RECORDED))
#-------------------------------------------------------------
# First create the LOCATION_ASSIGNED field
needles$LOCATION_RECORDED <- trimws(needles$LOCATION_RECORDED)
needles <- tbl_df(needles) %>% mutate(LOCATION_ASSIGNED=ifelse(is.na(ZIP),toupper(LOCATION_RECORDED),
                                                               paste(toupper(LOCATION_RECORDED),"_",ZIP,sep="")))
jan2020 <- tbl_df(jan2020) %>% mutate(LOCATION_ASSIGNED=ifelse(is.na(ZIP),toupper(LOCATION_RECORDED),
                                                               paste(toupper(LOCATION_RECORDED),"_",ZIP,sep="")))
feb2020 <- tbl_df(feb2020) %>% mutate(LOCATION_ASSIGNED=ifelse(is.na(ZIP),toupper(LOCATION_RECORDED),
                                                               paste(toupper(LOCATION_RECORDED),"_",ZIP,sep="")))
april2019 <- tbl_df(april2019) %>% mutate(LOCATION_ASSIGNED=ifelse(is.na(ZIP),toupper(LOCATION_RECORDED),
                                                               paste(toupper(LOCATION_RECORDED),"_",ZIP,sep="")))
may2019 <- tbl_df(may2019) %>% mutate(LOCATION_ASSIGNED=ifelse(is.na(ZIP),toupper(LOCATION_RECORDED),
                                                                   paste(toupper(LOCATION_RECORDED),"_",ZIP,sep="")))

#------------------------------------------------------------

#-------------------------------------------------------------
# next we bring in the locations file and merge the two

locs <- read.csv('needle_logs/locations_geo.csv')

# make sure there's no whitespace in the location geo data
locs$LOCATION_ASSIGNED <- trimws(locs$LOCATION_ASSIGNED)

# now merge the two and figure out what is missing from the geo file
needles <- needles %>% left_join(locs,by=c('LOCATION_ASSIGNED')) 
jan2020 <- jan2020 %>% left_join(locs,by=c('LOCATION_ASSIGNED'))
feb2020 <- feb2020 %>% left_join(locs,by=c('LOCATION_ASSIGNED'))
april2019 <- april2019 %>% left_join(locs,by=c('LOCATION_ASSIGNED'))
may2019 <- may2019 %>% left_join(locs,by=c('LOCATION_ASSIGNED'))

#print.data.frame(needles %>% filter(is.na(LAT)) %>% select(LOCATION_RECORDED.x,LOCATION_RECORDED.y,LOCATION_ASSIGNED))
#print.data.frame(jan2020 %>% filter(is.na(LAT)) %>% select(LOCATION_RECORDED.x,LOCATION_RECORDED.y,LOCATION_ASSIGNED))
#print.data.frame(feb2020 %>% filter(is.na(LAT)) %>% select(LOCATION_RECORDED.x,LOCATION_RECORDED.y,LOCATION_ASSIGNED))
#print.data.frame(april2019 %>% filter(is.na(LAT)) %>% select(LOCATION_RECORDED.x,LOCATION_RECORDED.y,LOCATION_ASSIGNED))
print.data.frame(may2019 %>% filter(is.na(LAT)) %>% select(LOCATION_RECORDED.x,LOCATION_RECORDED.y,LOCATION_ASSIGNED))
#------------------------------------------------------------

#------------------------------------------------------------
#If we are satisfied with the needle events file here we 
# clean it up and write it back to a csv
needle.events <- needles %>% 
  select(DATE,LOCATION_RECORDED.x,CITY,STATE,ZIP,DEPT_ID,NEEDLE_QUANTITY,LOCATION_ASSIGNED) 
names(needle.events) <- c('DATE','LOCATION_RECORDED','CITY','STATE','ZIP','DEPT_ID','NEEDLE_QUANTITY','LOCATION_ASSIGNED')

jan2020 <- jan2020 %>% 
  select(DATE,LOCATION_RECORDED.x,CITY,STATE,ZIP,DEPT_ID,NEEDLE_QUANTITY,LOCATION_ASSIGNED) 
names(jan2020) <- c('DATE','LOCATION_RECORDED','CITY','STATE','ZIP','DEPT_ID','NEEDLE_QUANTITY','LOCATION_ASSIGNED')

feb2020 <- feb2020 %>% 
  select(DATE,LOCATION_RECORDED.x,CITY,STATE,ZIP,DEPT_ID,NEEDLE_QUANTITY,LOCATION_ASSIGNED) 
names(feb2020) <- c('DATE','LOCATION_RECORDED','CITY','STATE','ZIP','DEPT_ID','NEEDLE_QUANTITY','LOCATION_ASSIGNED')

april2019 <- april2019 %>% 
  select(DATE,LOCATION_RECORDED.x,CITY,STATE,ZIP,DEPT_ID,NEEDLE_QUANTITY,LOCATION_ASSIGNED) 
names(april2019) <- c('DATE','LOCATION_RECORDED','CITY','STATE','ZIP','DEPT_ID','NEEDLE_QUANTITY','LOCATION_ASSIGNED')

may2019 <- may2019 %>% 
  select(DATE,LOCATION_RECORDED.x,CITY,STATE,ZIP,DEPT_ID,NEEDLE_QUANTITY,LOCATION_ASSIGNED) 
names(may2019) <- c('DATE','LOCATION_RECORDED','CITY','STATE','ZIP','DEPT_ID','NEEDLE_QUANTITY','LOCATION_ASSIGNED')

write.csv(needle.events,file='needle_logs/needle_events_base.csv')
write.csv(jan2020,file='needle_logs/jan_2020.csv',row.names=F)
write.csv(feb2020,file='needle_logs/feb_2020.csv',row.names=F)
write.csv(april2019,file='needle_logs/april_2019.csv',row.names=F)
write.csv(may2019,file='needle_logs/may_2019.csv',row.names=F)
#-------------------------------------------------------------

