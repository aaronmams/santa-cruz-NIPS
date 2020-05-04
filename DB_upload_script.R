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
june2019 <- read.csv('needle_logs/june_2019.csv')
july2019 <- read.csv('needle_logs/july_2019.csv')
aug2019 <- read.csv('needle_logs/aug_2019.csv')
sept2019 <- read.csv('needle_logs/sept_2019.csv')
oct2019 <- read.csv('needle_logs/oct_2019.csv')

jan2020$LOCATION_RECORDED <- trimws(as.character(jan2020$LOCATION_RECORDED))
feb2020$LOCATION_RECORDED <- trimws(as.character(feb2020$LOCATION_RECORDED))
april2019$LOCATION_RECORDED <- trimws(as.character(april2019$LOCATION_RECORDED))
may2019$LOCATION_RECORDED <- trimws(as.character(may2019$LOCATION_RECORDED))
june2019$LOCATION_RECORDED <- trimws(as.character(june2019$LOCATION_RECORDED))
july2019$LOCATION_RECORDED <- trimws(as.character(july2019$LOCATION_RECORDED))
aug2019$LOCATION_RECORDED <- trimws(as.character(aug2019$LOCATION_RECORDED))
sept2019$LOCATION_RECORDED <- trimws(as.character(sept2019$LOCATION_RECORDED))
oct2019$LOCATION_RECORDED <- trimws(as.character(oct2019$LOCATION_RECORDED))
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
june2019 <- tbl_df(june2019) %>% mutate(LOCATION_ASSIGNED=ifelse(is.na(ZIP),toupper(LOCATION_RECORDED),
                                                               paste(toupper(LOCATION_RECORDED),"_",ZIP,sep="")))
july2019 <- tbl_df(july2019) %>% mutate(LOCATION_ASSIGNED=ifelse(is.na(ZIP),toupper(LOCATION_RECORDED),
                                                                 paste(toupper(LOCATION_RECORDED),"_",ZIP,sep="")))
aug2019 <- tbl_df(aug2019) %>% mutate(LOCATION_ASSIGNED=ifelse(is.na(ZIP),toupper(LOCATION_RECORDED),
                                                                 paste(toupper(LOCATION_RECORDED),"_",ZIP,sep="")))
sept2019 <- tbl_df(sept2019) %>% mutate(LOCATION_ASSIGNED=ifelse(is.na(ZIP),toupper(LOCATION_RECORDED),
                                                                 paste(toupper(LOCATION_RECORDED),"_",ZIP,sep="")))
oct2019 <- tbl_df(oct2019) %>% mutate(LOCATION_ASSIGNED=ifelse(is.na(ZIP),toupper(LOCATION_RECORDED),
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
june2019 <- june2019 %>% left_join(locs,by=c('LOCATION_ASSIGNED'))
july2019 <- july2019 %>% left_join(locs,by=c('LOCATION_ASSIGNED'))
aug2019 <- aug2019 %>% left_join(locs,by=c('LOCATION_ASSIGNED'))
sept2019 <- sept2019 %>% left_join(locs,by=c('LOCATION_ASSIGNED'))
oct2019 <- oct2019 %>% left_join(locs,by=c('LOCATION_ASSIGNED'))

#print.data.frame(needles %>% filter(is.na(LAT)) %>% select(LOCATION_RECORDED.x,LOCATION_RECORDED.y,LOCATION_ASSIGNED))
#print.data.frame(jan2020 %>% filter(is.na(LAT)) %>% select(LOCATION_RECORDED.x,LOCATION_RECORDED.y,LOCATION_ASSIGNED))
#print.data.frame(feb2020 %>% filter(is.na(LAT)) %>% select(LOCATION_RECORDED.x,LOCATION_RECORDED.y,LOCATION_ASSIGNED))
#print.data.frame(april2019 %>% filter(is.na(LAT)) %>% select(LOCATION_RECORDED.x,LOCATION_RECORDED.y,LOCATION_ASSIGNED))
#print.data.frame(may2019 %>% filter(is.na(LAT)) %>% select(LOCATION_RECORDED.x,LOCATION_RECORDED.y,LOCATION_ASSIGNED))
#print.data.frame(june2019 %>% filter(is.na(LAT)) %>% select(LOCATION_RECORDED.x,LOCATION_RECORDED.y,LOCATION_ASSIGNED))
#print.data.frame(aug2019 %>% filter(is.na(LAT)) %>% select(LOCATION_RECORDED.x,LOCATION_RECORDED.y,LOCATION_ASSIGNED))
#print.data.frame(sept2019 %>% filter(is.na(LAT)) %>% select(LOCATION_RECORDED.x,LOCATION_RECORDED.y,LOCATION_ASSIGNED))
print.data.frame(oct2019 %>% filter(is.na(LAT)) %>% select(LOCATION_RECORDED.x,LOCATION_RECORDED.y,LOCATION_ASSIGNED))
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

june2019 <- june2019 %>% 
  select(DATE,LOCATION_RECORDED.x,CITY,STATE,ZIP,DEPT_ID,NEEDLE_QUANTITY,LOCATION_ASSIGNED) 
names(june2019) <- c('DATE','LOCATION_RECORDED','CITY','STATE','ZIP','DEPT_ID','NEEDLE_QUANTITY','LOCATION_ASSIGNED')

july2019 <- july2019 %>% 
  select(DATE,LOCATION_RECORDED.x,CITY,STATE,ZIP,DEPT_ID,NEEDLE_QUANTITY,LOCATION_ASSIGNED) 
names(july2019) <- c('DATE','LOCATION_RECORDED','CITY','STATE','ZIP','DEPT_ID','NEEDLE_QUANTITY','LOCATION_ASSIGNED')

aug2019 <- aug2019 %>% 
  select(DATE,LOCATION_RECORDED.x,CITY,STATE,ZIP,DEPT_ID,NEEDLE_QUANTITY,LOCATION_ASSIGNED) 
names(aug2019) <- c('DATE','LOCATION_RECORDED','CITY','STATE','ZIP','DEPT_ID','NEEDLE_QUANTITY','LOCATION_ASSIGNED')

sept2019 <- sept2019 %>% 
  select(DATE,LOCATION_RECORDED.x,CITY,STATE,ZIP,DEPT_ID,NEEDLE_QUANTITY,LOCATION_ASSIGNED) 
names(sept2019) <- c('DATE','LOCATION_RECORDED','CITY','STATE','ZIP','DEPT_ID','NEEDLE_QUANTITY','LOCATION_ASSIGNED')

oct2019 <- oct2019 %>% 
  select(DATE,LOCATION_RECORDED.x,CITY,STATE,ZIP,DEPT_ID,NEEDLE_QUANTITY,LOCATION_ASSIGNED) 
names(oct2019) <- c('DATE','LOCATION_RECORDED','CITY','STATE','ZIP','DEPT_ID','NEEDLE_QUANTITY','LOCATION_ASSIGNED')

#write.csv(needle.events,file='needle_logs/needle_events_base.csv')
#write.csv(jan2020,file='needle_logs/jan_2020.csv',row.names=F)
#write.csv(feb2020,file='needle_logs/feb_2020.csv',row.names=F)
#write.csv(april2019,file='needle_logs/april_2019.csv',row.names=F)
#write.csv(may2019,file='needle_logs/may_2019.csv',row.names=F)
#write.csv(june2019,file='needle_logs/june_2019.csv',row.names=F)
#write.csv(july2019,file='needle_logs/july_2019.csv',row.names=F)
#write.csv(aug2019,file='needle_logs/aug_2019.csv',row.names=F)
#write.csv(sept2019,file='needle_logs/sept_2019.csv',row.names=F)
write.csv(oct2019,file='needle_logs/sept_2019.csv',row.names=F)
#-------------------------------------------------------------

