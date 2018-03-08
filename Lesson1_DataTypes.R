### Lesson 1: Data Types and Objects ----
# use the tidyverse package
require(tidyverse)
require(readr)
#install.packages(tidyverse)

#Shortcuts
## Mac: Control+Alt+o -- Collapse all
## Mac: Expand all -- Shift+Ctrl+Alt+o

### String Vectors -----
load("FIES_label.RData")

dictionary # is a character vector
str(dictionary)
# chr [1:26456] "[Dictionary]" "Version=CSPro 4.1" "Label=Fies 2015" "Name=FIES15V2_DICT" ...
# it gives you the length of the dictionary: 26456 elements
length(dictionary)
#[1] 26456 
# also gives you the length of the dictionary

# Subsetting vectors
## If you knew what parts of the vector you need, you can just grab that part
## and subset the vector by number

# A common application is getting the first element of a long vector
dictionary[1]
# [1] "[Dictionary]"

# Another application is getting the last
dictionary[length(dictionary)]
#[1] "Value=0;  '"

## A common application -- get the index/location
## of a string in a vector

## use regex -- grep(pattern,string)
## looking for Rice, case sensitive
## grep is a function
## its input is a patter, in quotation marks
## the second input is the string vector
## the output is a vector of numbers, indices
## which gives you the location of the matches
## grep("pattern",nameofstring)

grep("Rice",dictionary)
#[1]   727   734   739   746   751   758   763   770   775   782   787   794
#[13]   799   806   811   818   823   830   835   842   847   854   859   866
#[25]   871   878   883   890   895   902   907   914   919   926   931   938
#[37]   943   950 25351 25659

#what did the regex find?, use the indexes identified by grep
# to read which entries in dictionary have rice
dictionary[grep("Rice",dictionary)]
#[1] "Label=Total Rice Expenditure"              
#[2] "Label=Total Rice Expenditure"              
#[3] "Label=Total Rice In Cash"                  
#[4] "Label=Total Rice In Cash"    
# ....
Rice<-dictionary[grep("Rice",dictionary)]

# we can ask functions to tell us more about the distribution 
# of strings
dist.Rice<-table(dictionary[grep("Rice",dictionary)])

#now dist.Rice is also a vector, a numeric vector...
# but its has names!

### Make your own character vector

ex<-c("apple","banana","grape")

### You can name it
setNames(ex,c("1st Fav","2nd Fav","Least Fav"))

### Common issue with Vectors -- Set intersection
Letters<-rep(letters,3) #give letters chr vector
## **** Q2 Type ?rep, understand the function *****
## **** What are the inputs to rep? Other parameters?

Letters #its 78 characters long

### take only vowels
Letters %in% c("a","e","i","o","u")
#[1]  TRUE FALSE FALSE FALSE  TRUE FALSE FALSE FALSE  TRUE FALSE FALSE FALSE
#[13] FALSE FALSE  TRUE FALSE FALSE FALSE FALSE FALSE  TRUE FALSE FALSE FALSE
#[25] FALSE FALSE
# the output is a logical vector, see below

#but they work as indices as well
Letters[Letters %in% c("a","e","i","o","u")]
#[1] "a" "e" "i" "o" "u" "a" "e" "i" "o" "u" "a" "e" "i" "o" "u"

### pick only non-vowels
Letters[!Letters %in% c("a","e","i","o","u")]
#[1] "b" "c" "d" "f" "g" "h" "j" "k" "l" "m" "n" "p" "q" "r"
#[15] "s" "t" "v" "w" "x" "y" "z" "b" "c" "d" "f" "g" "h" "j"
#[29] "k" "l" "m" "n" "p" "q" "r" "s" "t" "v" "w" "x" "y" "z"
#[43] "b" "c" "d" "f" "g" "h" "j" "k" "l" "m" "n" "p" "q" "r"
#[57] "s" "t" "v" "w" "x" "y" "z"


### Numerical Vector ----
Label.name # this is an index, where I used grep
dictionary[Label.name] 
###   ****Q: What is the grep command i used?*****

#What can be done with numeric vectors?

#Subset/Extract elements
Label.name[1];Label.name[c(3,5,2)];Label.name[length(Label.name)]

# apply statistics functions
summary(Label.name)
#Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
#  23    6500   12848   12865   19202   26446 

mean(Label.name);var(Label.name);median(Label.name)
### *** Q: type ?mean and find out what the parameter to enter
### *** if there are any missing values, NAs

## Plot them
plot(Label.name,type="l")

### You can apply math operations
Label.name*2;Label.name/1000
Label.name^2

### you can make your own vectors 
c(1,2,3)
c(1:3)
seq(1,3)


### Notice this:
Label.name*c(.5,1,10)
# What happened?
# First there is a warning --
#Warning message:
#  In Label.name * c(0.5, 1, 10) :
#  longer object length is not a multiple of shorter object length

# Meaning one vector is longer than the other, clearly true here
# but it still computes something. the shorter vector gets "recycled"
# its value gets extended until its equal to the length of the first 
# vector

### Call me by your name -- Numeric Vector Edition ----
dist.Rice
names(dist.Rice)
#[1] "Label=Rice (NFA) Expenditure"              
#[2] "Label=Rice (NFA) In Cash"                  
#[3] "Label=Rice (NFA) Received as Gifts" 
# ....

#We can subset dist.Rice based on Index, but also on the 
# names themselves

dist.Rice["Label=Rice (NFA) Expenditure"]
#Label=Rice (NFA) Expenditure 
# 2

dist.Rice[c("Label=Rice (NFA) Expenditure",
            "Label=Rice (NFA) Received as Gifts")]
#Label=Rice (NFA) Expenditure Label=Rice (NFA) Received as Gifts 
#                       2                                  2 

### Logical Vectors ----

# the value is either T or F; or TRUE or FALSE

## a standard application is to match each element of a vector
## if its matches, its T; if not its F

letters=="a"
# [1]  TRUE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
#[14] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
#[27]  TRUE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
#[40] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
#[53]  TRUE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
#[66] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE

## and use it to subset
letters[letters=="a"]

## another common application is to count instances of matches
## these logical vectors can be added, T is 1, F is 0
sum(letters=="a")
# [1] 3

### Another type -- Factor ----
## A factor is an ordered string
## factors are important in sorting, because it will
## sort in the order specified in the factor
## also, important in plotting; we will often need to reorder a
## factor in terms of decreasing size of some statistic we calculated

# In FIES, the column W_REGN gives you numbers
# but these numeric variables represents regions, but they are
# ordered by the values of the numbers

region<-sort(unique(df$W_REGN))[1:5]
#here, i created a numeric vector, of unique and sorted
# values of W_REGN, got only the first 5

#Lets turn it into a factor
# you need labels:
r.label<-c("Ilocos Region","Cagayan Valley","Central Luzon",
           "Bicol Region","Western Visayas")
region2<-factor(region,labels=r.label)
region2
#[1] I - Ilocos Region    II - Cagayan Valley  III - Central Luzon  V - Bicol Region    
#[5] VI - Western Visayas
#5 Levels: I - Ilocos Region II - Cagayan Valley ... VI - Western Visayas

## What happened?
# The numbers became strings
# But they are ordered, as if they were ordered by numbers
# you can select them as strings
region2 %in% "Ilocos Region"
#[1]  TRUE FALSE FALSE FALSE FALSE

# But they are ordered
is.factor(region2)
#[1] TRUE


#### Another type -- Date ----
## Which we won't talk about here, coz we are working with
## cross-sectional data

#### Changing data types -----
# In R, we can change data types often

# to take an example, we create the following vector
char2num<-c("010522","111231","050342")
num2char<-as.numeric(char2num)
#[1]  10522 111231  50342 -- note that the leading zeroes go away
# in this case this is probably what we want, except if it is an ID identifier

#sometimes a numeric should be changed to character
char2num<-as.character(num2char)
char2num #its a character but the leading zeroes go away




