### Lesson 2 DataTypes.R
require(tidyverse)
require(readr)

### DataFrame or (in this case a tibble) ----

# We Import the FIES csv data

# Reading in CSV files using tidyverse
system.time(df<-read_csv("FIES 2015 Volume 2.puf - Detailed Expenditure/FIES2015_PUF/FIES2015.csv"))
#   user  system elapsed 
# 32.609   2.519  35.469 

# Reading in CSV files using baseR
system.time(df2<-read.csv("FIES 2015 Volume 2.puf - Detailed Expenditure/FIES2015_PUF/FIES2015.csv"))
#   user  system elapsed 
# 114.039   2.742 117.751 

# I choose either read_csv or data.table's fread

# What is a Dataframes?
##    It is a collection of columns, each witha given datatype
##    Since we will be using dplyr, i'll skip over the 
##    baseR methods for doing things -- we can do that later

head(str(df)[1])
#Classes ‘tbl_df’, ‘tbl’ and 'data.frame':	41544 obs. of  2117 variables:
#$ W_REGN            : int  14 14 14 14 14 14 14 14 14 14 ...
#$ W_ID              : chr  "0101008000" "0101008000" "0101008000" "0101008000" ...
#$ W_SHSN            : chr  "0001" "0002" "0003" "0004" ...
#$ W_HCN             : chr  "0008" "0019" "0031" "0042" ...
#$ RFACT             : chr  "00211.1572" "00211.1572" "00211.1572" "00211.1572" ...
#$ TOINC_DECILE      : chr  "09" "06" "02" "03" ...
#....

#Note that read_csv imports them as characters. Our options:
# 1) We could reimport it -- *** Q: reimport such that all columns are numeric ***
# 2) we could change the datatype of the columns we want to change

# most of the dataframe manipulations will involve dplyr and tidyr
# but i will stress that the dataframe is essentially a group of vectors of the same length, and
# each vector is a column

# read_csv and dplyr generally will create tibbles
# a tibble is just a special data.frame that prints in a pretty way
# other than that, its a data.frame

### extract a column
df[1] #the first column
df[[1]] #the first column as a vector
df[-1] # all but the first

#note that this not only extracts but you can also edit the column (in the dataframe) using methods we
# will get into later

### extract a row
df[1,] #note that this is a dataframe also

## how do you make a row of a dataframe a vector
## typically, this is harder to do, as there is a big chance that each column in a dataframe
## are of a different type.
## hence, extracting rows is a job for matrices (later)

# But if you ABSOLUTELY HAD TO:
unlist(df[1,]) #... will give a named vector, all of it will be forced to be a common character type
# which is usually character

## Names of the columns
# like vectors, you can extract columns by their name
df["TOINC"]
df[["TOINC"]]
df[c("TOINC","PCINC")] # ONLY THE COLUMNS YOU WANT

#to see all the names, you use
names(df)
## ***Q typically a vector will only show a limited set
## *** use google to determin how to change the max.print option

### Matrix ------

#each element in the matrix has to be the same type, either character, numeric, logical

# An example of a matrix -- What packages do you have installed?
packages<-installed.packages()
str(packages) # the differences between matrix and dataframe
# is if all the columns have the same datatype, in this case, its "chr"


packages[,1] # extract 1 column
packages[1,] # extract 1 row
packages[1,1] #one element

#it has row.names and col.names
row.names(packages) #the row names are the packages
colnames(packages) #note, its not names()

### List -----

# a list is a very useful way to organize your data, although its not easy to manipulate
# because it is inherently flexible
# a list is basically a collection of objects in R, and they don't have to be the same 
# data type or object

# a list could contain a vector, a dataframe, and a plot, in the same list
# a list could contain lists

# for our purposes, we will use very simple lists
list("apple","banana","grape") #each 1-element vectors here, and the list is length 3
#[[1]]
#[1] "apple"

#[[2]]
#[1] "banana"

#[[3]]
#[1] "grape"

list(c("apple","banana","grape")) # only 1 element, a 3 element vector, list is length 1
#[[1]]
#[1] "apple"  "banana" "grape" 

lst<-list("apple","banana","grape")
lst[1] #accessing the first element in list, as a list
lst[[1]] # as a vector

# we will be using lists as place holders for our loops

