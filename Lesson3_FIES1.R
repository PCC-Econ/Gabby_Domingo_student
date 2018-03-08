### Lesson 3: Starting with FIES

## Read in data ------
df<-read_csv("FIES 2015 Volume 2.puf - Detailed Expenditure/FIES2015_PUF/FIES2015.csv",col_types = cols(.default="n"))

# above imports all columns as numeric

### Replicating the Tables
require(tidyverse)

### Replicate the number of Families by Region --------

View(df[1:100,c("W_REGN","W_ID","W_HCN","W_SHSN","RFACT")])

### Lets take a look at a how the HHs are arranged
### Lets use dplyr, and use "piping"
### %>% says, take the item on the left, and do the function on the right

df %>% select(c("W_REGN","W_ID","W_HCN","W_SHSN","RFACT")) %>% ### select some columns
  # select allows you to get columns based on rules... 
  filter(W_REGN==1) %>% # filter looks at rows that fulfills the condition
  arrange(W_ID,W_HCN,W_SHSN) %>% # this orders the columns, decreasing order
  print(n=100) # this shows the top 100, 

### examine this subset of the data first, looking at how these columns vary by Region
### knowing these are regional data

### We will explain the basics of dplyr using this example: How do we replicate the FIES tables

### We know that the survey is regionally representative. This means that the Weights, when used,
### will give us statistics per region.

### We know each Row is a Household/Family

### We know that the weights [RFACT] vary at the same time as W_ID. 

### We know that within W_ID, W_SHSN and W_HCN varies, but there may be duplicates of each within
#### W_ID

## Count number of elements per W_ID
count.df<-df %>% group_by(W_REGN,W_ID,RFACT)  %>% #group_by identifies the groups upon which
  # some computations will be made
  summarise(count=n()) %>% # summarise give you a statistic based on unique combinations in the variables
  # in the group_by. In this case, its a count, and the function is n()
  mutate(rfact_count=RFACT*count) # mutate gives you a new column, defined as  each row
# is the product of two columns

### A note on surveys: the HHs are rows, and each HH "represents" RFACT families
### so the number of families is basically the product of the number of observations per ID
### multiplied by the Weights per ID

### The total number of families in the Philippines should be:
sum(count.df$rfact_count)
#[1] 22730410 -- this matches the pdf report in the thousands
prettyNum(round(sum(count.df$rfact_count)/1000),big.mark = ",")
#[1] "22,730"

count.df<-count.df %>% group_by(W_REGN) %>% summarise(sum_count=sum(rfact_count))

## To tidy this up, we need to attach text labels
## and then change the column names
## and then reformat the numbers to be in the thousands, with PrettyNum

dictionary[Label.name] ## the first element is the region
# u generated the start and end indices separately
Region.label<-dictionary[Label.valueset.start[1]:end[1]]
Region.label
# there a few ways to do this, lets use separate

Region.label<-as_tibble(Region.label) %>% # turn it into a tibble
  separate(col=1,sep=";",into=c("Value","Region")) # separate functon,?separate
Region.label<-Region.label %>%  mutate(Value=gsub("Value=","",Value)) #then re-write
  # the Value column, taking out the word "Value="

count.df<-count.df %>% mutate(W_REGN=factor(W_REGN,levels=as.numeric(Region.label[["Value"]]),
                labels=Region.label[["Region"]])) %>% 
  #Notice we used factor to create overwrite the W_REGN column
  mutate(sum_count=prettyNum(round(sum_count/1000),big.mark = ",")) %>%
  # We prettified the sums
  arrange(W_REGN) %>% select(Region=W_REGN,`Number of Families (thousands)`=sum_count)
  ## we changed the names to make it look professional :)

str(count.df)
View(count.df)

### then we can export as a xls or csv for use in a report
#write_csv() from readr
#write.csv() from base
### there are several packages for xls/xlsx; use google


#### ASSIGNMENT -------------
# PICK A COLUMN, COMPUTE PSA'S TABLE 1, UPLOAD TO GITHUB
# AND WE WILL LOOK AT EACH OTHERS WORK
# TRY TO RUN EACH OTHERS CODES

