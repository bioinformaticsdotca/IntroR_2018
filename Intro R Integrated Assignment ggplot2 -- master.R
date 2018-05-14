###############################################
#
#     INTRO TO R INTEGRATED ASSIGNMENT: ggplot2
#
###############################################

## library in ggplot2 (if you haven't installed it yet, use the command install.packages("ggplot2"))
library('ggplot2')

## First set your working directory
my.wd <- "C:/Users/larun/Desktop/CBW/Intro to R/Data/"
setwd(my.wd)

## READ IN DATA FOR YOUR PLOT
myplot.df <- readRDS("MYC-let-7-ggplot-data.rds")

## This is the normalized expression of MYC 
##  and a member of the miRNA let-7 family from the TCGA HNSC data set 
##  This data frame also contains gender and 
##  "tumor_nuclei_percent" to indicate sample purity
head(myplot.df)

## 
##   GGPLOT2 SCATTER PLOT WITH REGRESSION LINE
##

## Use ggplot to make a simple scatter plot of y=MYC vs x=let-7
(scatter1 <- ggplot(data = myplot.df, aes(y=MYC,x=hsa.let.7e.3p)) + 
  geom_point(aes(col=gender)) + 
  geom_smooth(method="lm") + 
  xlab("hsa-let-7a-3p") + 
  ylab("MYC"))

## Now change the colors and the legend
(scatter2 <- scatter1 + scale_color_manual(values=c("male"="blue","female"="red"),name="Legend"))

## Now make your points bigger
(scatter3 <- scatter2 + geom_point(aes(col=gender),size=3))

## Now change the background and make the legend title larger and bold
(scatter4  <-  scatter3 +
  theme_bw() +
  theme(legend.title = element_text(size=16, face="bold"))) 

## Now chnage the size of the points based on the variable: tumor_nuclei_percent
(scatter5 <- scatter4 + geom_point(aes(col=gender,size=tumor_nuclei_percent)))

## It's super cluttered so it's hard to see a pattern. 
##  Let's create a variable that separates our variable 'tumor_nuclei_percent'
##    into 4 categories based their values 
myplot.df$tum.nucl.cl <- NA
myplot.df$tum.nucl.cl[myplot.df$tumor_nuclei_percent < summary(myplot.df$tumor_nuclei_percent)["Median"]] <- "Low"
myplot.df$tum.nucl.cl[myplot.df$tumor_nuclei_percent >= summary(myplot.df$tumor_nuclei_percent)["Median"]] <- "High"

## create a factor variable of our "Low" and "High" categories so they are ordered in our graphs
myplot.df$tum.ncl.fac <- factor(myplot.df$tum.nucl.cl,levels = c("Low","High"))

## Check the distribution of indivdiuals who fall into "Low" and "High" using the table() function
table(myplot.df$tum.nucl.cl)

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
    facet_grid(. ~ tum.ncl.fac))

## Try splitting by gender
facet_plot1 + facet_grid(. ~ gender)


## 
##   GGPLOT2 OVERLAYED HISTOGRAMS
##

## First, use ggplot to make a basic histogram of let-7's expression

## plotting histogram for let-7's normalized expression
(hist1 <- ggplot(data = myplot.df, aes(x=hsa.let.7e.3p)) + geom_histogram())

## Now make a plot with the two histograms of each gender on top of each other 
## with different colors for each
(hist2 <- hist1 + 
  geom_histogram(aes(fill = gender)))

## Now change the colors within each histogram
## (for example: "forestgreen" and "darkorchid4")
(hist3 <- hist2 +  
  scale_fill_manual(values = c("male" = "forestgreen","female" = "darkorchid4")))

## The histogram looks really blocky, let's increase the number of bins
(hist4 <- ggplot(data = myplot.df, aes(x=hsa.let.7e.3p)) +  
    scale_fill_manual(values = c("male" = "forestgreen","female" = "darkorchid4")) + 
  geom_histogram(bins = 100,aes(fill = gender)))

## Now make the background different from the default (e.g. make it black and white themed)
(hist5 <- hist4 + 
  theme_minimal())

## Change the legend title from "gender" to "legend" and
##  the x-axis label from "hsa.let.7e.3p" to "hsa-let-7e-3p"
(hist6 <- hist5  +  
  scale_fill_manual(values = c("male" = "forestgreen","female" = "darkorchid4"),name="Legend") + 
    xlab("hsa-let-7e-3p")) 

## What if we do facet_wrap instead of overlaying the histograms? 
hist6 + facet_grid(. ~ gender)

## 
##   GGPLOT2 BOXPLOTS
##

## First, let's make boxplots of normalized MYC expression
##  split by our "low" and "high" tumour_nuclei_percent groups
##  recall, the variable is "tum.ncl.fac"

## Name the axes, change the colors, make the lengend title blank, 
##    and change the background from the default
(bp1 <- ggplot(myplot.df,aes(x = tum.ncl.fac,y=MYC)) + 
  geom_boxplot(aes(fill = tum.ncl.fac)) + 
    xlab("Tumour Nuclei Percentage") + 
    scale_fill_manual(values = c("Low" = "seagreen","High"="red4"),name = "") + 
    theme_light())

## Now let's annotate the outliers in the "High" group as "outliers" 
(bp2 <- bp1 + annotate("text", x = 1.8, y = 4, label = "Outliers",cex = 8))

## Finally, let's split these graphs into facets based on sex: 
bp2 + facet_grid(. ~ gender)
  ## Note that facet_grid will apply everything that has been done in the original graph
  ## to both graphs (i.e 2 labes of outliers)
  
