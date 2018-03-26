### Lesson 4 on FIES-----
require(tidyverse)


### Plot count.df (Number of Families) -----

#here i introduce2 ggplot2

g<-ggplot(count.df,aes(x=Region,y=`Number of Families (thousands)`))#alone this does nothing

#but you can build your plot in layers. 

g+geom_point()
### whats the problem and why?


str(count.df) ## its a character!
count.df <- count.df %>%  
  mutate(`Number of Families (thousands)`=gsub(",","",`Number of Families (thousands)`)) %>%
  #why do this? try it without it
  mutate(`Number of Families (thousands)`=as.numeric(`Number of Families (thousands)`))

###
g<-ggplot(count.df,aes(x=Region,y=`Number of Families (thousands)`))#alone this does nothing

g+geom_point() ### can't really 
### in an advanced lesson, we can increase the 
### distances between factors

g+geom_point()+coord_flip() #better for the region

#bar plot is usually how this is shown,
## and its usually how we should show this data

g+ geom_col()+coord_flip()

# you may want to change the distance
#between the axis labels and the bars

g+geom_col()+scale_y_continuous(expand=c(0,.1))+
  coord_flip()

### *** HW: How can you make pretty numbers for your  ***
### *** y axis?

#to change the look, use the different themes
g+geom_col()+scale_y_continuous(expand=c(0,.1))+
  coord_flip()+theme_bw()
g+geom_col()+scale_y_continuous(expand=c(0,.1))+
  coord_flip()+theme_classic()


#### Another challenge, what if instead of thousands
### you want 500's
g+geom_col()+
  scale_y_continuous(expand=c(0,10),breaks = seq(0,3500,500))+
  coord_flip()+theme_classic()

#### Another challenge: extend the y axis arbitrarily
g+geom_col()+
  scale_y_continuous(expand=c(0,10),breaks = seq(0,3500,500),
                     limits=c(0,5000))+
  coord_flip()+theme_classic()


### putting the axis line on the top
g+geom_col()+
  scale_y_continuous(expand=c(0,10),position="right")+
  coord_flip()+theme_classic()

#### Lets reorder the factors to make the bars
### decreasing

count.df<-arrange(count.df,`Number of Families (thousands)`)
count.df$Region<-factor(count.df$Region,levels=count.df$Region)

g<-ggplot(count.df,aes(x=Region,y=`Number of Families (thousands)`))#alone this does nothing
g+geom_col()+
  scale_y_continuous(expand=c(0,10),position="right")+
  coord_flip()+theme_classic()


#### Adding number labels
g+geom_col()+
  geom_text(aes(label=`Number of Families (thousands)`),hjust=-0.1)+
  scale_y_continuous(expand=c(0,10),position="right",limits = c(0,3500))+
  coord_flip()+theme_classic()

### **** HW: make the number labels pretty *****
#### Changing the axis labels
g+geom_col()+
  geom_text(aes(label=`Number of Families (thousands)`),hjust=-0.1)+
  scale_y_continuous(expand=c(0,10),position="right",limits = c(0,3500))+
  coord_flip()+theme_classic()+
  ylab(NULL)+ #no y axis title
  ggtitle("Number of Families (in Thousands) by Region")+
  theme(plot.title=element_text(size=20,face = "bold",hjust = .4))


#### Lets make other challenges, as  part of our HW
#### I dont know how to do these
#### *** Don't have to use the FIES data necessarily

#### 1) Change the font of the ggplot

#### 2) Add images to a ggplot barplot on top of the bars

##### Hints! ----
# Dummy plot
df2 <- data.frame(x = 1:10, y = 1:10)
base <- ggplot(df, aes(x, y)) +
  geom_blank() +
  theme_bw()

# Full panel annotation
base + annotation_custom(
  grob = grid::roundrectGrob(),
  xmin = -Inf, xmax = Inf, ymin = -Inf, ymax = Inf
)

# Inset plot
df3 <- data.frame(x = 1 , y = 1)
g <- ggplotGrob(ggplot(df3, aes(x, y)) +
                  geom_point() +
                  theme(plot.background = element_rect(colour = "black")))
base +
  annotation_custom(grob = g, xmin = 1, xmax = 2, ymin = .5, ymax = 10)


# https://www.r-bloggers.com/change-fonts-in-ggplot2-and-create-xkcd-style-graphs/



### Lets Generate Total Income and Expenditure by Region -------

### total income is
dictionary[Label.item[32]]
dictionary[Label.name[32]]
# variable is TOINC

### total expenditure
dictionary[Label.item[27]]
dictionary[Label.name[27]]


#Region.label is assumed to be part of the environment

count.df2<-df %>% mutate(TOINC_W=TOINC*RFACT,TTOTEX_W=TTOTEX*RFACT) %>%
  group_by(W_REGN) %>% summarise(sum_toinc_wt=sum(TOINC_W)/1000000,
                      sum_ttotex_wt=sum(TTOTEX_W)/1000000) %>%
  mutate(W_REGN=factor(W_REGN,levels=as.numeric(Region.label[["Value"]]),
                       labels=Region.label[["Region"]])) %>%
  select(Region=W_REGN,sum_toinc_wt,sum_ttotex_wt)

### its that easy!

### Lets learn to plot the two variables we just generated
data<-left_join(count.df,count.df2) %>% mutate(sum_toinc_wt=sum_toinc_wt*1000,
                                               sum_ttotex_wt=sum_ttotex_wt*1000)
# to put them both in thousands

data <- data %>%  
  mutate(`Number of Families (thousands)`=gsub(",","",`Number of Families (thousands)`)) %>%
  #why do this? try it without it
  mutate(`Number of Families (thousands)`=as.numeric(`Number of Families (thousands)`))


ggplot(data,aes(x=`Number of Families (thousands)`,y=sum_toinc_wt))+
  geom_point()+geom_smooth()

ggplot(data,aes(x=sum_ttotex_wt,y=sum_toinc_wt))+
  geom_point()+geom_abline(slope=1,intercept = 0)+coord_fixed()

## Then you notice some standard econ stuff -- savings are rising in income,
## But are savings rates rising in income?

data <- data %>% mutate(sav_rt=(1-(sum_ttotex_wt/sum_toinc_wt))*100)

ggplot(data,aes(x=sum_toinc_wt,y=sav_rt))+
  geom_point()+geom_smooth()+scale_x_log10() 

ggplot(data,aes(x=sum_toinc_wt,y=sav_rt))+
  geom_point()+geom_smooth(method="lm")

### Some plotting choices
### we can add lines about average saving rates and average total income
### *** HW: use geom_vline or geom_hline to add averages ***

### we can add labels
require(ggrepel)
ggplot(data,aes(x=sum_toinc_wt,y=sav_rt))+
  geom_point()+geom_smooth(method="lm")+geom_text_repel(aes(label=Region))


#### We can normalize by calculating regional income per family
data <-data %>% mutate(totinc_fam=sum_toinc_wt/`Number of Families (thousands)`,
                ttotex_fam=sum_ttotex_wt/`Number of Families (thousands)`)

ggplot(data,aes(x=ttotex_fam,y=totinc_fam))+
  geom_point()+geom_abline(slope=1,intercept = 0)+coord_fixed()

data <- data %>% mutate(sav_rt_fam=(1-(ttotex_fam/totinc_fam))*100)

ggplot(data,aes(x=totinc_fam,y=sav_rt_fam))+
  geom_point()+geom_smooth(method="lm",formula=y~x+I(x^2)) # much better pattern

ggplot(data,aes(x=totinc_fam,y=sav_rt_fam))+
  geom_point()+geom_smooth(method="lm")+geom_smooth(color="red")+scale_x_log10() 

ggplot(data,aes(x=totinc_fam,y=sav_rt_fam))+scale_x_log10()+
  geom_point()+geom_smooth(method="lm",formula=y~x+I(x^2)) # quadratic pattern


