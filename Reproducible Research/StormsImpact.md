# Severe Weather Events: Public Health and Economic Impact
Desmond Wallace  
Sunday, July 27, 2014  

## Synopsis

It is known to many that severe weather events, such as thunderstorms, results in a host of problems for the communities and municipalities affected by such events. These problems include, but are not limited to, economic and public health problems. Not only are communities and municipalities are affected by severe weather events, individuals residing in these locations are affected as well. The reason for this is that severe weather events are capable of causing severe hardships, such as fatalities, injuries, and property damage. Thus, the main concern facing policymakers is minimizing these hardships as best as possible.

In this report, we examine the impact severe weather has on both local public health and economy. Using the storm database compiled by the United States National Oceanic and Atmospheric Administration (NOAA) from 1950 - 2011, two major findings are revealed. First, there is a difference with regards to which severe weather events has the most impact on public health. Tornadoes has the biggest impact on public health when examining the entire period covered by the data set, while excessive heat and tornadoes have the biggest impact on public health for the period beginning in 1990. Second, floods and droughts have the biggest economic impact on communities and municipalities, irrespective of period.


## Settings

Before I conduct any data processing or analysis, I will first load the necessary packages in order to conduct such processes.


```r
library(ggplot2)
library(gridExtra)
```

```
## Loading required package: grid
```

```r
library(plyr)
library(R.utils)
```

```
## Loading required package: R.oo
## Loading required package: R.methodsS3
## R.methodsS3 v1.6.1 (2014-01-04) successfully loaded. See ?R.methodsS3 for help.
## R.oo v1.18.0 (2014-02-22) successfully loaded. See ?R.oo for help.
## 
## Attaching package: 'R.oo'
## 
## The following objects are masked from 'package:methods':
## 
##     getClasses, getMethods
## 
## The following objects are masked from 'package:base':
## 
##     attach, detach, gc, load, save
## 
## R.utils v1.32.4 (2014-05-14) successfully loaded. See ?R.utils for help.
## 
## Attaching package: 'R.utils'
## 
## The following object is masked from 'package:utils':
## 
##     timestamp
## 
## The following objects are masked from 'package:base':
## 
##     cat, commandArgs, getOption, inherits, isOpen, parse, warnings
```


## Data Processing

The first step in processing the data is to download, and unzip, the data file. The data file can be downloaded from the following link: [https://d396qusza40orc.cloudfront.net/repdata%2Fdata%2FStormData.csv.bz2](https://d396qusza40orc.cloudfront.net/repdata%2Fdata%2FStormData.csv.bz2)


```r
# Unzipping data file
bunzip2("repdata-data-StormData.csv.bz2", overwrite = TRUE, remove = FALSE)
```

The next step is to read the .csv file, which contains the data, into R.


```r
Storms <- read.csv("repdata-data-StormData.csv")
```


## Overview of Data

The following code displays the first six entries in the data set.


```r
head(Storms)
```

```
##   STATE__           BGN_DATE BGN_TIME TIME_ZONE COUNTY COUNTYNAME STATE
## 1       1  4/18/1950 0:00:00     0130       CST     97     MOBILE    AL
## 2       1  4/18/1950 0:00:00     0145       CST      3    BALDWIN    AL
## 3       1  2/20/1951 0:00:00     1600       CST     57    FAYETTE    AL
## 4       1   6/8/1951 0:00:00     0900       CST     89    MADISON    AL
## 5       1 11/15/1951 0:00:00     1500       CST     43    CULLMAN    AL
## 6       1 11/15/1951 0:00:00     2000       CST     77 LAUDERDALE    AL
##    EVTYPE BGN_RANGE BGN_AZI BGN_LOCATI END_DATE END_TIME COUNTY_END
## 1 TORNADO         0                                               0
## 2 TORNADO         0                                               0
## 3 TORNADO         0                                               0
## 4 TORNADO         0                                               0
## 5 TORNADO         0                                               0
## 6 TORNADO         0                                               0
##   COUNTYENDN END_RANGE END_AZI END_LOCATI LENGTH WIDTH F MAG FATALITIES
## 1         NA         0                      14.0   100 3   0          0
## 2         NA         0                       2.0   150 2   0          0
## 3         NA         0                       0.1   123 2   0          0
## 4         NA         0                       0.0   100 2   0          0
## 5         NA         0                       0.0   150 2   0          0
## 6         NA         0                       1.5   177 2   0          0
##   INJURIES PROPDMG PROPDMGEXP CROPDMG CROPDMGEXP WFO STATEOFFIC ZONENAMES
## 1       15    25.0          K       0                                    
## 2        0     2.5          K       0                                    
## 3        2    25.0          K       0                                    
## 4        2     2.5          K       0                                    
## 5        2     2.5          K       0                                    
## 6        6     2.5          K       0                                    
##   LATITUDE LONGITUDE LATITUDE_E LONGITUDE_ REMARKS REFNUM
## 1     3040      8812       3051       8806              1
## 2     3042      8755          0          0              2
## 3     3340      8742          0          0              3
## 4     3458      8626          0          0              4
## 5     3412      8642          0          0              5
## 6     3450      8748          0          0              6
```

The following code displays the last six entries in the data set


```r
tail(Storms)
```

```
##        STATE__           BGN_DATE    BGN_TIME TIME_ZONE COUNTY
## 902292      47 11/28/2011 0:00:00 03:00:00 PM       CST     21
## 902293      56 11/30/2011 0:00:00 10:30:00 PM       MST      7
## 902294      30 11/10/2011 0:00:00 02:48:00 PM       MST      9
## 902295       2  11/8/2011 0:00:00 02:58:00 PM       AKS    213
## 902296       2  11/9/2011 0:00:00 10:21:00 AM       AKS    202
## 902297       1 11/28/2011 0:00:00 08:00:00 PM       CST      6
##                                  COUNTYNAME STATE         EVTYPE BGN_RANGE
## 902292 TNZ001>004 - 019>021 - 048>055 - 088    TN WINTER WEATHER         0
## 902293                         WYZ007 - 017    WY      HIGH WIND         0
## 902294                         MTZ009 - 010    MT      HIGH WIND         0
## 902295                               AKZ213    AK      HIGH WIND         0
## 902296                               AKZ202    AK       BLIZZARD         0
## 902297                               ALZ006    AL     HEAVY SNOW         0
##        BGN_AZI BGN_LOCATI           END_DATE    END_TIME COUNTY_END
## 902292                    11/29/2011 0:00:00 12:00:00 PM          0
## 902293                    11/30/2011 0:00:00 10:30:00 PM          0
## 902294                    11/10/2011 0:00:00 02:48:00 PM          0
## 902295                     11/9/2011 0:00:00 01:15:00 PM          0
## 902296                     11/9/2011 0:00:00 05:00:00 PM          0
## 902297                    11/29/2011 0:00:00 04:00:00 AM          0
##        COUNTYENDN END_RANGE END_AZI END_LOCATI LENGTH WIDTH  F MAG
## 902292         NA         0                         0     0 NA   0
## 902293         NA         0                         0     0 NA  66
## 902294         NA         0                         0     0 NA  52
## 902295         NA         0                         0     0 NA  81
## 902296         NA         0                         0     0 NA   0
## 902297         NA         0                         0     0 NA   0
##        FATALITIES INJURIES PROPDMG PROPDMGEXP CROPDMG CROPDMGEXP WFO
## 902292          0        0       0          K       0          K MEG
## 902293          0        0       0          K       0          K RIW
## 902294          0        0       0          K       0          K TFX
## 902295          0        0       0          K       0          K AFG
## 902296          0        0       0          K       0          K AFG
## 902297          0        0       0          K       0          K HUN
##                       STATEOFFIC
## 902292           TENNESSEE, West
## 902293 WYOMING, Central and West
## 902294          MONTANA, Central
## 902295          ALASKA, Northern
## 902296          ALASKA, Northern
## 902297            ALABAMA, North
##                                                                                                                                                            ZONENAMES
## 902292 LAKE - LAKE - OBION - WEAKLEY - HENRY - DYER - GIBSON - CARROLL - LAUDERDALE - TIPTON - HAYWOOD - CROCKETT - MADISON - CHESTER - HENDERSON - DECATUR - SHELBY
## 902293                                                                              OWL CREEK & BRIDGER MOUNTAINS - OWL CREEK & BRIDGER MOUNTAINS - WIND RIVER BASIN
## 902294                                                                                     NORTH ROCKY MOUNTAIN FRONT - NORTH ROCKY MOUNTAIN FRONT - EASTERN GLACIER
## 902295                                                                                                 ST LAWRENCE IS. BERING STRAIT - ST LAWRENCE IS. BERING STRAIT
## 902296                                                                                                                 NORTHERN ARCTIC COAST - NORTHERN ARCTIC COAST
## 902297                                                                                                                                             MADISON - MADISON
##        LATITUDE LONGITUDE LATITUDE_E LONGITUDE_
## 902292        0         0          0          0
## 902293        0         0          0          0
## 902294        0         0          0          0
## 902295        0         0          0          0
## 902296        0         0          0          0
## 902297        0         0          0          0
##                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        REMARKS
## 902292                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    EPISODE NARRATIVE: A powerful upper level low pressure system brought snow to portions of Northeast Arkansas, the Missouri Bootheel, West Tennessee and extreme north Mississippi. Most areas picked up between 1 and 3 inches of with areas of Northeast Arkansas and the Missouri Bootheel receiving between 4 and 6 inches of snow.EVENT NARRATIVE: Around 1 inch of snow fell in Carroll County.
## 902293                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           EPISODE NARRATIVE: A strong cold front moved south through north central Wyoming bringing high wind to the Meeteetse area and along the south slopes of the western Owl Creek Range. Wind gusts to 76 mph were recorded at Madden Reservoir.EVENT NARRATIVE: 
## 902294                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      EPISODE NARRATIVE: A strong westerly flow aloft produced gusty winds at the surface along the Rocky Mountain front and over the plains of Central Montana. Wind gusts in excess of 60 mph were reported.EVENT NARRATIVE: A wind gust to 60 mph was reported at East Glacier Park 1ENE (the Two Medicine DOT site).
## 902295 EPISODE NARRATIVE: A 960 mb low over the southern Aleutians at 0300AKST on the 8th intensified to 945 mb near the Gulf of Anadyr by 2100AKST on the 8th. The low crossed the Chukotsk Peninsula as a 956 mb low at 0900AKST on the 9th, and moved into the southern Chukchi Sea as a 958 mb low by 2100AKST on the 9th. The low then tracked to the northwest and weakened to 975 mb about 150 miles north of Wrangel Island by 1500AKST on the 10th. The storm was one of the strongest storms to impact the west coast of Alaska since November 1974. \n\nZone 201: Blizzard conditions were observed at Wainwright from approximately 1153AKST through 1611AKST on the 9th. The visibility was frequently reduced to one quarter mile in snow and blowing snow. There was a peak wind gust to 43kt (50 mph) at the Wainwright ASOS. During this event, there was also a peak wind gust to \n68 kt (78 mph) at the Cape Lisburne AWOS. \n\nZone 202: Blizzard conditions were observed at Barrow from approximately 1021AKST through 1700AKST on the 9th. The visibility was frequently reduced to one quarter mile or less in blowing snow. There was a peak wind gust to 46 kt (53 mph) at the Barrow ASOS. \n\nZone 207: Blizzard conditions were observed at Kivalina from approximately 0400AKST through 1230AKST on the 9th. The visibility was frequently reduced to one quarter of a mile in snow and blowing snow. There was a peak wind gust to 61 kt (70 mph) at the Kivalina ASOS.  The doors to the village transportation shed were blown out to sea.  Many homes lost portions of their tin roofing, and satellite dishes were ripped off of roofs. One home had its door blown off.  At Point Hope, severe blizzard conditions were observed. There was a peak wind gust of 68 kt (78 mph) at the Point Hope AWOS before power was lost to the AWOS. It was estimated that the wind gusted as high as 85 mph in the village during the height of the storm during the morning and early afternoon hours on the 9th. Five power poles were knocked down in the storm EVENT NARRATIVE: 
## 902296 EPISODE NARRATIVE: A 960 mb low over the southern Aleutians at 0300AKST on the 8th intensified to 945 mb near the Gulf of Anadyr by 2100AKST on the 8th. The low crossed the Chukotsk Peninsula as a 956 mb low at 0900AKST on the 9th, and moved into the southern Chukchi Sea as a 958 mb low by 2100AKST on the 9th. The low then tracked to the northwest and weakened to 975 mb about 150 miles north of Wrangel Island by 1500AKST on the 10th. The storm was one of the strongest storms to impact the west coast of Alaska since November 1974. \n\nZone 201: Blizzard conditions were observed at Wainwright from approximately 1153AKST through 1611AKST on the 9th. The visibility was frequently reduced to one quarter mile in snow and blowing snow. There was a peak wind gust to 43kt (50 mph) at the Wainwright ASOS. During this event, there was also a peak wind gust to \n68 kt (78 mph) at the Cape Lisburne AWOS. \n\nZone 202: Blizzard conditions were observed at Barrow from approximately 1021AKST through 1700AKST on the 9th. The visibility was frequently reduced to one quarter mile or less in blowing snow. There was a peak wind gust to 46 kt (53 mph) at the Barrow ASOS. \n\nZone 207: Blizzard conditions were observed at Kivalina from approximately 0400AKST through 1230AKST on the 9th. The visibility was frequently reduced to one quarter of a mile in snow and blowing snow. There was a peak wind gust to 61 kt (70 mph) at the Kivalina ASOS.  The doors to the village transportation shed were blown out to sea.  Many homes lost portions of their tin roofing, and satellite dishes were ripped off of roofs. One home had its door blown off.  At Point Hope, severe blizzard conditions were observed. There was a peak wind gust of 68 kt (78 mph) at the Point Hope AWOS before power was lost to the AWOS. It was estimated that the wind gusted as high as 85 mph in the village during the height of the storm during the morning and early afternoon hours on the 9th. Five power poles were knocked down in the storm EVENT NARRATIVE: 
## 902297                           EPISODE NARRATIVE: An intense upper level low developed on the 28th at the base of a highly amplified upper trough across the Great Lakes and Mississippi Valley.  The upper low closed off over the mid South and tracked northeast across the Tennessee Valley during the morning of the 29th.   A warm conveyor belt of heavy rainfall developed in advance of the low which dumped from around 2 to over 5 inches of rain across the eastern two thirds of north Alabama and middle Tennessee.  The highest rain amounts were recorded in Jackson and DeKalb Counties with 3 to 5 inches.  The rain fell over 24 to 36 hour period, with rainfall remaining light to moderate during most its duration.  The rainfall resulted in minor river flooding along the Little River, Big Wills Creek and Paint Rock.   A landslide occurred on Highway 35 just north of Section in Jackson County.  A driver was trapped in his vehicle, but was rescued unharmed.  Trees, boulders and debris blocked 100 to 250 yards of Highway 35.\n\nThe rain mixed with and changed to snow across north Alabama during the afternoon and  evening hours of the 28th, and lasted into the 29th.  The heaviest bursts of snow occurred in northwest Alabama during the afternoon and evening hours, and in north central and northeast Alabama during the overnight and morning hours.  Since ground temperatures were in the 50s, and air temperatures in valley areas only dropped into the mid 30s, most of the snowfall melted on impact with mostly trace amounts reported in valley locations.  However, above 1500 foot elevation, snow accumulations of 1 to 2 inches were reported.  The heaviest amount was 2.3 inches on Monte Sano Mountain, about 5 miles northeast of Huntsville.EVENT NARRATIVE: Snowfall accumulations of up to 2.3 inches were reported on the higher elevations of eastern Madison County.  A snow accumulation of 1.5 inches was reported 2.7 miles south of Gurley, while 2.3 inches was reported 3 miles east of Huntsville atop Monte Sano Mountain.
##        REFNUM
## 902292 902292
## 902293 902293
## 902294 902294
## 902295 902295
## 902296 902296
## 902297 902297
```

Finally, the following code displays summary statistics for the data set.


```r
summary(Storms)
```

```
##     STATE__                  BGN_DATE             BGN_TIME     
##  Min.   : 1.0   5/25/2011 0:00:00:  1202   12:00:00 AM: 10163  
##  1st Qu.:19.0   4/27/2011 0:00:00:  1193   06:00:00 PM:  7350  
##  Median :30.0   6/9/2011 0:00:00 :  1030   04:00:00 PM:  7261  
##  Mean   :31.2   5/30/2004 0:00:00:  1016   05:00:00 PM:  6891  
##  3rd Qu.:45.0   4/4/2011 0:00:00 :  1009   12:00:00 PM:  6703  
##  Max.   :95.0   4/2/2006 0:00:00 :   981   03:00:00 PM:  6700  
##                 (Other)          :895866   (Other)    :857229  
##    TIME_ZONE          COUNTY         COUNTYNAME         STATE       
##  CST    :547493   Min.   :  0   JEFFERSON :  7840   TX     : 83728  
##  EST    :245558   1st Qu.: 31   WASHINGTON:  7603   KS     : 53440  
##  MST    : 68390   Median : 75   JACKSON   :  6660   OK     : 46802  
##  PST    : 28302   Mean   :101   FRANKLIN  :  6256   MO     : 35648  
##  AST    :  6360   3rd Qu.:131   LINCOLN   :  5937   IA     : 31069  
##  HST    :  2563   Max.   :873   MADISON   :  5632   NE     : 30271  
##  (Other):  3631                 (Other)   :862369   (Other):621339  
##                EVTYPE         BGN_RANGE       BGN_AZI      
##  HAIL             :288661   Min.   :   0          :547332  
##  TSTM WIND        :219940   1st Qu.:   0   N      : 86752  
##  THUNDERSTORM WIND: 82563   Median :   0   W      : 38446  
##  TORNADO          : 60652   Mean   :   1   S      : 37558  
##  FLASH FLOOD      : 54277   3rd Qu.:   1   E      : 33178  
##  FLOOD            : 25326   Max.   :3749   NW     : 24041  
##  (Other)          :170878                  (Other):134990  
##          BGN_LOCATI                  END_DATE             END_TIME     
##               :287743                    :243411              :238978  
##  COUNTYWIDE   : 19680   4/27/2011 0:00:00:  1214   06:00:00 PM:  9802  
##  Countywide   :   993   5/25/2011 0:00:00:  1196   05:00:00 PM:  8314  
##  SPRINGFIELD  :   843   6/9/2011 0:00:00 :  1021   04:00:00 PM:  8104  
##  SOUTH PORTION:   810   4/4/2011 0:00:00 :  1007   12:00:00 PM:  7483  
##  NORTH PORTION:   784   5/30/2004 0:00:00:   998   11:59:00 PM:  7184  
##  (Other)      :591444   (Other)          :653450   (Other)    :622432  
##    COUNTY_END COUNTYENDN       END_RANGE      END_AZI      
##  Min.   :0    Mode:logical   Min.   :  0          :724837  
##  1st Qu.:0    NA's:902297    1st Qu.:  0   N      : 28082  
##  Median :0                   Median :  0   S      : 22510  
##  Mean   :0                   Mean   :  1   W      : 20119  
##  3rd Qu.:0                   3rd Qu.:  0   E      : 20047  
##  Max.   :0                   Max.   :925   NE     : 14606  
##                                            (Other): 72096  
##            END_LOCATI         LENGTH           WIDTH            F         
##                 :499225   Min.   :   0.0   Min.   :   0   Min.   :0       
##  COUNTYWIDE     : 19731   1st Qu.:   0.0   1st Qu.:   0   1st Qu.:0       
##  SOUTH PORTION  :   833   Median :   0.0   Median :   0   Median :1       
##  NORTH PORTION  :   780   Mean   :   0.2   Mean   :   8   Mean   :1       
##  CENTRAL PORTION:   617   3rd Qu.:   0.0   3rd Qu.:   0   3rd Qu.:1       
##  SPRINGFIELD    :   575   Max.   :2315.0   Max.   :4400   Max.   :5       
##  (Other)        :380536                                   NA's   :843563  
##       MAG          FATALITIES     INJURIES         PROPDMG    
##  Min.   :    0   Min.   :  0   Min.   :   0.0   Min.   :   0  
##  1st Qu.:    0   1st Qu.:  0   1st Qu.:   0.0   1st Qu.:   0  
##  Median :   50   Median :  0   Median :   0.0   Median :   0  
##  Mean   :   47   Mean   :  0   Mean   :   0.2   Mean   :  12  
##  3rd Qu.:   75   3rd Qu.:  0   3rd Qu.:   0.0   3rd Qu.:   0  
##  Max.   :22000   Max.   :583   Max.   :1700.0   Max.   :5000  
##                                                               
##    PROPDMGEXP        CROPDMG        CROPDMGEXP          WFO        
##         :465934   Min.   :  0.0          :618413          :142069  
##  K      :424665   1st Qu.:  0.0   K      :281832   OUN    : 17393  
##  M      : 11330   Median :  0.0   M      :  1994   JAN    : 13889  
##  0      :   216   Mean   :  1.5   k      :    21   LWX    : 13174  
##  B      :    40   3rd Qu.:  0.0   0      :    19   PHI    : 12551  
##  5      :    28   Max.   :990.0   B      :     9   TSA    : 12483  
##  (Other):    84                   (Other):     9   (Other):690738  
##                                STATEOFFIC    
##                                     :248769  
##  TEXAS, North                       : 12193  
##  ARKANSAS, Central and North Central: 11738  
##  IOWA, Central                      : 11345  
##  KANSAS, Southwest                  : 11212  
##  GEORGIA, North and Central         : 11120  
##  (Other)                            :595920  
##                                                                                                                                                                                                     ZONENAMES     
##                                                                                                                                                                                                          :594029  
##                                                                                                                                                                                                          :205988  
##  GREATER RENO / CARSON CITY / M - GREATER RENO / CARSON CITY / M                                                                                                                                         :   639  
##  GREATER LAKE TAHOE AREA - GREATER LAKE TAHOE AREA                                                                                                                                                       :   592  
##  JEFFERSON - JEFFERSON                                                                                                                                                                                   :   303  
##  MADISON - MADISON                                                                                                                                                                                       :   302  
##  (Other)                                                                                                                                                                                                 :100444  
##     LATITUDE      LONGITUDE        LATITUDE_E     LONGITUDE_    
##  Min.   :   0   Min.   :-14451   Min.   :   0   Min.   :-14455  
##  1st Qu.:2802   1st Qu.:  7247   1st Qu.:   0   1st Qu.:     0  
##  Median :3540   Median :  8707   Median :   0   Median :     0  
##  Mean   :2875   Mean   :  6940   Mean   :1452   Mean   :  3509  
##  3rd Qu.:4019   3rd Qu.:  9605   3rd Qu.:3549   3rd Qu.:  8735  
##  Max.   :9706   Max.   : 17124   Max.   :9706   Max.   :106220  
##  NA's   :47                      NA's   :40                     
##                                            REMARKS           REFNUM      
##                                                :287433   Min.   :     1  
##                                                : 24013   1st Qu.:225575  
##  Trees down.\n                                 :  1110   Median :451149  
##  Several trees were blown down.\n              :   569   Mean   :451149  
##  Trees were downed.\n                          :   446   3rd Qu.:676723  
##  Large trees and power lines were blown down.\n:   432   Max.   :902297  
##  (Other)                                       :588294
```

According to the results displayed above, the data set begins in 1950, and ends in 2011. Most likely due to poor record-keeping, more events are recorded for later years as compared to the early years. This trend is displayed visually in the following histogram.


```r
# Create a new variable: "year"
Storms$YEAR <- as.numeric(format(as.Date(Storms$BGN_DATE, 
                                       format = "%m/%d/%Y %H:%M:%S"), "%Y"))

# Create histogram that shows growth in number of completed records
hist(Storms$YEAR, xlab = "Year", main = "Number of Records per Year")
```

![plot of chunk unnamed-chunk-7](./StormsImpact_files/figure-html/unnamed-chunk-7.png) 

According to the histogram above, the bulk of the records occur after 1990. Thus, the results section will include plots that not only utilize the entire data set, but also a subset of the whole data set, with emphasis on the years 1990 to 2011.


```r
# Create subset of dataset, for years 1990 to 2011.
Storms.9011 <- Storms[Storms$YEAR >= 1990, ]
```


## Results

In this section, we analyze the data in order to answer the following questions:

* Across the United States, which types of events (as indicated in the EVTYPE variable) are most harmful with respect to population health?

* Across the United States, which types of events have the greatest economic consequences?

### Public Health Impact

In this section, we identify the ***fatalities*** and ***injuries*** that are most caused by severe weather events. The first set of code helps identify the fatalities and injuries most caused by severe weather events for the complete period covered by the data set.


```r
# Aggregating Fatalities and Injuries from Original Dataset
sortingPubHealth <- function(pubhealth, top = 20, data = Storms) {
    ind <- which(colnames(data) == pubhealth)
    ph <- aggregate(data[, ind], by = list(data$EVTYPE), FUN = "sum")
    names(ph) <- c("EVTYPE", pubhealth)
    ph <- arrange(ph, ph[, 2], decreasing = TRUE)
    ph <- head(ph, n = top)
    ph <- within(ph, EVTYPE <- factor(x = EVTYPE, levels = ph$EVTYPE))
    return(ph)
}

# Aggregating Fatalities and Injuries from Subset Dataset
sortingPubHealth.9011 <- function(pubhealth, top = 20, data = Storms.9011) {
    ind <- which(colnames(data) == pubhealth)
    ph <- aggregate(data[, ind], by = list(data$EVTYPE), FUN = "sum")
    names(ph) <- c("EVTYPE", pubhealth)
    ph <- arrange(ph, ph[, 2], decreasing = TRUE)
    ph <- head(ph, n = top)
    ph <- within(ph, EVTYPE <- factor(x = EVTYPE, levels = ph$EVTYPE))
    return(ph)
}

# List of Fatalities and Injuries from Original Dataset
Fatalities <- sortingPubHealth("FATALITIES", data = Storms)
Injuries <- sortingPubHealth("INJURIES", data = Storms)

# List of Fatalities and Injuries from Subset Dataset
Fatalities.9011 <- sortingPubHealth("FATALITIES", data = Storms.9011)
Injuries.9011 <- sortingPubHealth("INJURIES", data = Storms.9011)
```

### Economic Impact

In this section, we convert both ***property*** and ***crop*** damages into their respective numerical forms for proper data analysis. Again, this process is done for both the original and subset data sets.


```r
# Conversion for Original Dataset
convertingEcon <- function(data = Storms, damage, newdamage) {
  totlen <- dim(data)[2]
  ind <- which(colnames(data) == damage)
  data[, ind] <- as.character(data[, ind])
  log <- !is.na(toupper(data[, ind]))
  data[log & toupper(data[, ind]) == "B", ind] <- "9"
  data[log & toupper(data[, ind]) == "M", ind] <- "6"
  data[log & toupper(data[, ind]) == "K", ind] <- "3"
  data[log & toupper(data[, ind]) == "H", ind] <- "2"
  data[log & toupper(data[, ind]) == "", ind] <- "0"
  data[, ind] <- as.numeric(data[, ind])
  data[is.na(data[, ind]), ind] <- 0
  data <- cbind(data, data[, ind - 1] * 10^data[, ind])
  names(data)[totlen + 1] <- newdamage
  return(data)
}

Storms <- convertingEcon(Storms, "PROPDMGEXP", "PropertyDamage")
```

```
## Warning: NAs introduced by coercion
```

```r
Storms <- convertingEcon(Storms, "CROPDMGEXP", "CropDamage")
```

```
## Warning: NAs introduced by coercion
```

```r
# Conversion for Subset Dataset 
convertingEcon.9011 <- function(data = Storms.9011, damage, newdamage) {
  totlen <- dim(data)[2]
  ind <- which(colnames(data) == damage)
  data[, ind] <- as.character(data[, ind])
  log <- !is.na(toupper(data[, ind]))
  data[log & toupper(data[, ind]) == "B", ind] <- "9"
  data[log & toupper(data[, ind]) == "M", ind] <- "6"
  data[log & toupper(data[, ind]) == "K", ind] <- "3"
  data[log & toupper(data[, ind]) == "H", ind] <- "2"
  data[log & toupper(data[, ind]) == "", ind] <- "0"
  data[, ind] <- as.numeric(data[, ind])
  data[is.na(data[, ind]), ind] <- 0
  data <- cbind(data, data[, ind - 1] * 10^data[, ind])
  names(data)[totlen + 1] <- newdamage
  return(data)
}

Storms.9011 <- convertingEcon(Storms.9011, "PROPDMGEXP", "PropertyDamage")
```

```
## Warning: NAs introduced by coercion
```

```r
Storms.9011 <- convertingEcon(Storms.9011, "CROPDMGEXP", "CropDamage")
```

```
## Warning: NAs introduced by coercion
```

```r
# Aggregating Property and Crop Damages from Original Dataset
sortingDamage <- function(damage, top = 20, data = Storms) {
    ind <- which(colnames(data) == damage)
    dmg <- aggregate(data[, ind], by = list(data$EVTYPE), FUN = "sum")
    names(dmg) <- c("EVTYPE", damage)
    dmg <- arrange(dmg, dmg[, 2], decreasing = TRUE)
    dmg <- head(dmg, n = top)
    dmg <- within(dmg, EVTYPE <- factor(x = EVTYPE, levels = dmg$EVTYPE))
    return(dmg)
}

# Aggregating Property and Crop Damages from Subset Dataset
sortingDamage.9011 <- function(damage, top = 20, data = Storms.9011) {
    ind <- which(colnames(data) == damage)
    dmg <- aggregate(data[, ind], by = list(data$EVTYPE), FUN = "sum")
    names(dmg) <- c("EVTYPE", damage)
    dmg <- arrange(dmg, dmg[, 2], decreasing = TRUE)
    dmg <- head(dmg, n = top)
    dmg <- within(dmg, EVTYPE <- factor(x = EVTYPE, levels = dmg$EVTYPE))
    return(dmg)
}

# List of Property and Crop Damages from Original Dataset
Property <- sortingDamage("PropertyDamage", data = Storms)
Crops <- sortingDamage("CropDamage", data = Storms)

# List of Property and Crop Damages from Subset Dataset
Property.9011 <- sortingDamage("PropertyDamage", data = Storms.9011)
Crops.9011 <- sortingDamage("CropDamage", data = Storms.9011)
```

### Analysis and Figures - Public Health Impact

After compiling the code above, we now have four sorted lists which shows the impact severe weather has on public health, based on the number of individuals affected. Listed below are the two sorted lists based on the original data set.


```r
# Sorted Lists for Original Dataset
Fatalities
```

```
##                     EVTYPE FATALITIES
## 1                  TORNADO       5633
## 2           EXCESSIVE HEAT       1903
## 3              FLASH FLOOD        978
## 4                     HEAT        937
## 5                LIGHTNING        816
## 6                TSTM WIND        504
## 7                    FLOOD        470
## 8              RIP CURRENT        368
## 9                HIGH WIND        248
## 10               AVALANCHE        224
## 11            WINTER STORM        206
## 12            RIP CURRENTS        204
## 13               HEAT WAVE        172
## 14            EXTREME COLD        160
## 15       THUNDERSTORM WIND        133
## 16              HEAVY SNOW        127
## 17 EXTREME COLD/WIND CHILL        125
## 18             STRONG WIND        103
## 19                BLIZZARD        101
## 20               HIGH SURF        101
```

```r
Injuries
```

```
##                EVTYPE INJURIES
## 1             TORNADO    91346
## 2           TSTM WIND     6957
## 3               FLOOD     6789
## 4      EXCESSIVE HEAT     6525
## 5           LIGHTNING     5230
## 6                HEAT     2100
## 7           ICE STORM     1975
## 8         FLASH FLOOD     1777
## 9   THUNDERSTORM WIND     1488
## 10               HAIL     1361
## 11       WINTER STORM     1321
## 12  HURRICANE/TYPHOON     1275
## 13          HIGH WIND     1137
## 14         HEAVY SNOW     1021
## 15           WILDFIRE      911
## 16 THUNDERSTORM WINDS      908
## 17           BLIZZARD      805
## 18                FOG      734
## 19   WILD/FOREST FIRE      545
## 20         DUST STORM      440
```

Below are two histograms that show the impact severe weather events have on public health. These histograms reflect the data from the original data set.


```r
FatalitiesGraph <- qplot(EVTYPE, data = Fatalities, weight = FATALITIES, 
                         geom = "bar") + scale_y_continuous("FATALITIES") +
                         theme(axis.text.x = element_text(angle = 90, 
                                                          hjust = 1)) +
                         xlab("Severe Weather") + 
                         ggtitle("Total Number of Fatalities\n by Severe 
                                Weather Type\n in the U.S. from 1950 - 2011")
InjuriesGraph <- qplot(EVTYPE, data = Injuries, weight = INJURIES, 
                       geom = "bar") + scale_y_continuous("INJURIES") +
                       theme(axis.text.x = element_text(angle = 90, 
                                                          hjust = 1)) +
                       xlab("Severe Weather") + 
                       ggtitle("Total Number of Injuries\n by Severe 
                                Weather Type\n in the U.S. from 1950 - 2011")
grid.arrange(FatalitiesGraph, InjuriesGraph, ncol = 2)
```

![plot of chunk unnamed-chunk-12](./StormsImpact_files/figure-html/unnamed-chunk-12.png) 

Based on the lists and graphs above, the severe weather event that has the biggest impact on communities and municipalities, based on the total number of fatalities and injuries, are **tornadoes**.

Listed below are the sorted lists of fatalities and injuries, based on the subset data set.


```r
# Sorted Lists for Subset Dataset
Fatalities.9011
```

```
##                     EVTYPE FATALITIES
## 1           EXCESSIVE HEAT       1903
## 2                  TORNADO       1752
## 3              FLASH FLOOD        978
## 4                     HEAT        937
## 5                LIGHTNING        816
## 6                    FLOOD        470
## 7              RIP CURRENT        368
## 8                TSTM WIND        327
## 9                HIGH WIND        248
## 10               AVALANCHE        224
## 11            WINTER STORM        206
## 12            RIP CURRENTS        204
## 13               HEAT WAVE        172
## 14            EXTREME COLD        160
## 15       THUNDERSTORM WIND        133
## 16              HEAVY SNOW        127
## 17 EXTREME COLD/WIND CHILL        125
## 18             STRONG WIND        103
## 19                BLIZZARD        101
## 20               HIGH SURF        101
```

```r
Injuries.9011
```

```
##                EVTYPE INJURIES
## 1             TORNADO    26674
## 2               FLOOD     6789
## 3      EXCESSIVE HEAT     6525
## 4           LIGHTNING     5230
## 5           TSTM WIND     5022
## 6                HEAT     2100
## 7           ICE STORM     1975
## 8         FLASH FLOOD     1777
## 9   THUNDERSTORM WIND     1488
## 10       WINTER STORM     1321
## 11  HURRICANE/TYPHOON     1275
## 12               HAIL     1139
## 13          HIGH WIND     1137
## 14         HEAVY SNOW     1021
## 15           WILDFIRE      911
## 16 THUNDERSTORM WINDS      908
## 17           BLIZZARD      805
## 18                FOG      734
## 19   WILD/FOREST FIRE      545
## 20         DUST STORM      440
```

Based on these lists, tornadoes remain the biggest cause of injuries. However, the severe weather event most responsible for the total number of fatalities, between the period of 1990 and 2011, is **excessive heat**.

### Analysis and Figures - Economic Impact

Listed below are two sorted lists, based on the original data set, which shows the impact severe weather has on property and crops.


```r
# Sorted Lists for Original Dataset
Property
```

```
##                       EVTYPE PropertyDamage
## 1                      FLOOD      1.447e+11
## 2          HURRICANE/TYPHOON      6.931e+10
## 3                    TORNADO      5.695e+10
## 4                STORM SURGE      4.332e+10
## 5                FLASH FLOOD      1.682e+10
## 6                       HAIL      1.574e+10
## 7                  HURRICANE      1.187e+10
## 8             TROPICAL STORM      7.704e+09
## 9               WINTER STORM      6.688e+09
## 10                 HIGH WIND      5.270e+09
## 11               RIVER FLOOD      5.119e+09
## 12                  WILDFIRE      4.765e+09
## 13          STORM SURGE/TIDE      4.641e+09
## 14                 TSTM WIND      4.485e+09
## 15                 ICE STORM      3.945e+09
## 16         THUNDERSTORM WIND      3.483e+09
## 17            HURRICANE OPAL      3.173e+09
## 18          WILD/FOREST FIRE      3.002e+09
## 19 HEAVY RAIN/SEVERE WEATHER      2.500e+09
## 20        THUNDERSTORM WINDS      1.945e+09
```

```r
Crops
```

```
##               EVTYPE CropDamage
## 1            DROUGHT  1.397e+10
## 2              FLOOD  5.662e+09
## 3        RIVER FLOOD  5.029e+09
## 4          ICE STORM  5.022e+09
## 5               HAIL  3.026e+09
## 6          HURRICANE  2.742e+09
## 7  HURRICANE/TYPHOON  2.608e+09
## 8        FLASH FLOOD  1.421e+09
## 9       EXTREME COLD  1.293e+09
## 10      FROST/FREEZE  1.094e+09
## 11        HEAVY RAIN  7.334e+08
## 12    TROPICAL STORM  6.783e+08
## 13         HIGH WIND  6.386e+08
## 14         TSTM WIND  5.540e+08
## 15    EXCESSIVE HEAT  4.924e+08
## 16            FREEZE  4.462e+08
## 17           TORNADO  4.150e+08
## 18 THUNDERSTORM WIND  4.148e+08
## 19              HEAT  4.015e+08
## 20          WILDFIRE  2.955e+08
```

Below are two histograms that shows the economic impact severe weather has on communities and municipalities. Again, these histograms reflect the data from the original data set.


```r
PropertyGraph <- qplot(EVTYPE, data = Property, weight = PropertyDamage, 
                       geom = "bar") + 
                       scale_y_continuous("Property Damage in USD") +
                       theme(axis.text.x = element_text(angle = 90, 
                                                        hjust = 1)) +
                       xlab("Severe Weather") + 
                       ggtitle("Total Amount of Property\n Damage by Severe 
                                Weather Type\n in the U.S. from 1950 - 2011")
CropsGraph <- qplot(EVTYPE, data = Crops, weight = CropDamage, 
                    geom = "bar") + 
                    scale_y_continuous("Crops Damage in USD") +
                    theme(axis.text.x = element_text(angle = 90, 
                                                     hjust = 1)) +
                    xlab("Severe Weather") + 
                    ggtitle("Total Amount of Crops\n Damage by Severe 
                             Weather Type\n in the U.S. from 1950 - 2011")
grid.arrange(PropertyGraph, CropsGraph, ncol = 2)
```

![plot of chunk unnamed-chunk-15](./StormsImpact_files/figure-html/unnamed-chunk-15.png) 

According to the lists and figures above, the severe weather event that resulted in the most damage to property was **floods**. In regards to the severe weather event that resulted in the most damage to crops was **drought**.

Listed below are the two ordered lists for property and crops damages, based on the subset data set.


```r
# Sorted Lists for Original Dataset
Property.9011
```

```
##                       EVTYPE PropertyDamage
## 1                      FLOOD      1.447e+11
## 2          HURRICANE/TYPHOON      6.931e+10
## 3                STORM SURGE      4.332e+10
## 4                    TORNADO      3.047e+10
## 5                FLASH FLOOD      1.682e+10
## 6                       HAIL      1.574e+10
## 7                  HURRICANE      1.187e+10
## 8             TROPICAL STORM      7.704e+09
## 9               WINTER STORM      6.688e+09
## 10                 HIGH WIND      5.270e+09
## 11               RIVER FLOOD      5.119e+09
## 12                  WILDFIRE      4.765e+09
## 13          STORM SURGE/TIDE      4.641e+09
## 14                 TSTM WIND      4.485e+09
## 15                 ICE STORM      3.945e+09
## 16         THUNDERSTORM WIND      3.483e+09
## 17            HURRICANE OPAL      3.173e+09
## 18          WILD/FOREST FIRE      3.002e+09
## 19 HEAVY RAIN/SEVERE WEATHER      2.500e+09
## 20        THUNDERSTORM WINDS      1.945e+09
```

```r
Crops.9011
```

```
##               EVTYPE CropDamage
## 1            DROUGHT  1.397e+10
## 2              FLOOD  5.662e+09
## 3        RIVER FLOOD  5.029e+09
## 4          ICE STORM  5.022e+09
## 5               HAIL  3.026e+09
## 6          HURRICANE  2.742e+09
## 7  HURRICANE/TYPHOON  2.608e+09
## 8        FLASH FLOOD  1.421e+09
## 9       EXTREME COLD  1.293e+09
## 10      FROST/FREEZE  1.094e+09
## 11        HEAVY RAIN  7.334e+08
## 12    TROPICAL STORM  6.783e+08
## 13         HIGH WIND  6.386e+08
## 14         TSTM WIND  5.540e+08
## 15    EXCESSIVE HEAT  4.924e+08
## 16            FREEZE  4.462e+08
## 17           TORNADO  4.150e+08
## 18 THUNDERSTORM WIND  4.148e+08
## 19              HEAT  4.015e+08
## 20          WILDFIRE  2.955e+08
```

Based on the lists above, floods remains as the biggest cause of property damage, while drought remains as the biggest cause of damages to crops.


## Conclusion

Based on the analysis conducted above, we find that tornadoes have the biggest impact on public health, with regards to the total number of fatalities and injuries. However, this conclusion does not hold entirely if the period is reduced to 1990 - 2011. Under this period, tornadoes remain as the severe weather event most responsible for injuries. However, excessive heat is now found as the severe weather event most responsible for fatalities.

In regards to the economic impact of severe weather, we found that both floods and droughts have the biggest impact on communities and municipalities' economies, irrespective of the period.
