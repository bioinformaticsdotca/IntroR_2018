###############################################
#
#     INTRO TO R INTEGRATED ASSIGNMENT: ggplot2
#
###############################################

## library in ggplot2 (if you haven't installed it yet, use the command install.packages("ggplot2"))
library('ggplot2')

## First set your working directory
my.wd <- "<ENTER YOUR WORKING DIRECTORY (WHERE YOUR DATA SITS) HERE>"
setwd(my.wd)

## READ IN DATA FOR YOUR PLOT
myplot.df <- readRDS("MYC-let-7-ggplot-data.rds")

## This is the normalized expression of MYC 
##  and a member of the miRNA let-7 family from the TCGA HNSC data set 
##  This data frame also contains gender and 
##  "tumor_nuclei_percent" to indicate sample purity
head(<FILL WITH YOUR DATA FRAME OBJECT NAME>)

## 
##   GGPLOT2 SCATTER PLOT WITH REGRESSION LINE
##

## Use ggplot to make a simple scatter plot of y=MYC vs x=let-7
## Color it by gender, add a regression line, make new axis labels
(scatter1 <- ggplot(data = <DATA FRAME>, aes(y=<ENTER YOUR Y VARIABLE>,x=<ENTER YOUR X VARIABLE>)) + 
  geom_point(aes(col=<WHAT TO COLOR BY?>)) + 
  geom_smooth(method="lm") + 
  xlab(<X LABEL>) + 
  ylab(<Y LABEL>))

## Now change the colors and the legend
(scatter2 <- scatter1 + scale_color_manual(values=c(<ENTER YOUR COLOR VALUES>),name=<NAME OF YOUR LEGEND>))

## Now make your points bigger
(scatter3 <- scatter2 + geom_point(aes(col=gender),size=<CHANGE SIZE>))

## Now change the background and make the legend title larger and bold
(scatter4  <-  scatter3 + 
  theme(legend.title = element_text(size=16, face="bold")) + 
    <CHANGE THEME>) 

## Now chnage the size of the points based on the variable: tumor_nuclei_percent
(scatter5 <- scatter4 + 
    <MAKE POINT SIZE VARIABLE>)

## It's super cluttered so it's hard to see a pattern. 
##  Let's create a variable that separates our variable 'tumor_nuclei_percent'
##    into 4 categories based their values 
myplot.df$tum.nucl.cl <- NA
myplot.df$tum.nucl.cl[myplot.df$tumor_nuclei_percent < summary(myplot.df$tumor_nuclei_percent)["Median"]] <- "Low"
myplot.df$tum.nucl.cl[myplot.df$tumor_nuclei_percent >= summary(myplot.df$tumor_nuclei_percent)["Median"]] <- "High"

## create a factor variable of our "Low" and "High" categories so they are ordered in our graphs
myplot.df$tum.ncl.fac <- factor(myplot.df$tum.nucl.cl,levels = c("Low","High"))

## Check the distribution of indivdiuals who fall into "Low" and "High" using the table() function
table(<VECTOR OF YOUR GROUP ASSIGNMENTS>)

## First let's use facet_grid to look at the histograms of these groups by their membership
##    using facet_wrap
full_hist <- ggplot(myplot.df,aes(x=tumor_nuclei_percent)) + geom_histogram()
full_hist + facet_grid(. ~ tum.ncl.fac)

## Now facet our scatterplot we made based on membership in the groups we created
(facet_plot1 <- ggplot(data = myplot.df, aes(y=MYC,x=hsa.let.7e.3p)) + 
    geom_smooth(method="lm") + 
    xlab("hsa-let-7a-3p") + 
    ylab("MYC") +
    geom_point(aes(col=gender,size=tumor_nuclei_percent)) +
    theme_bw() +
    scale_color_manual(values=c("male"="blue","female"="red"),name="Legend") +
    theme(legend.title = element_text(size=16, face="bold")) +
    <ADD FACET_GRID ARGUMENT>

## Try splitting by gender
facet_plot1 + <ADD FACET_GRID ARGUMENT>

## 
##   GGPLOT2 OVERLAYED HISTOGRAMS
##

## First, use ggplot to make a basic histogram of let-7's expression

## plotting histogram for let-7's normalized expression
(hist1 <- ggplot(data = myplot.df, aes(x=hsa.let.7e.3p)) + <ADD HISTOGRAM GEOM>)

## Now make a plot with the two histograms of each gender on top of each other 
## with different colors for each

## Now change the colors within each histogram
## (for example: "forestgreen" and "darkorchid4")

  
## The histogram looks really blocky, let's increase the number of bins

  
## Now make the background different from the default (e.g. make it black and white themed)

  
## Change the legend title from "gender" to "legend" and
##  the x-axis label from "hsa.let.7e.3p" to "hsa-let-7e-3p"

  
## What if we do facet_wrap instead of overlaying the histograms? 


## 
##   GGPLOT2 BOXPLOTS
##

## First, let's make boxplots of normalized MYC expression
##  split by our "low" and "high" tumour_nuclei_percent groups
##  recall, the variable is "tum.ncl.fac"

## Name the axes, change the colors, make the lengend title blank, 
##    and change the background from the default
(bp1 <- <ENTER THE FULL CODE FOR YOUR PLOT HERE>)

## Now let's annotate the outliers in the "High" group as "outliers" 
(bp2 <- bp1 + annotate("text", x = 1.8, y = 4, label = "Outliers",cex = 8))

## Finally, let's split these graphs into facets based on sex: 
bp2 + <FACET BY GENDER>
  ## Note that facet_grid will apply everything that has been done in the original graph
  ## to both graphs (i.e 2 labes of outliers)
  
