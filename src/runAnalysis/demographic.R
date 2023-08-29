
library(geodata)
library(tidyverse)
library(sf)
library(ggplot2)
library(ggalluvial)
library(stringr)
library(dplyr)
library(tidyr)
library(DescTools)

# Demographic Information of Study Participants 
###############################################

# Age - All
###########
png(paste0(dir_out, "kobaniAnalysis-demographic-age-all-title.png", sep=""), pointsize=10, width=1600, height=960, res=200)
plot_age <- hist(kobani_dialect_metainfo$Age, breaks = 20, col=rgb(0,1,0,0.2), xlim=c(30, 90),
                 xlab='Year', ylab='Occurences', main='Age distribution of participants')
dev.off()

# Version without title for LaTeX-Document
png(paste0(dir_out, "kobaniAnalysis-demographic-age-all-notitle.png", sep=""), pointsize=10, width=1600, height=960, res=200)
plot_age <- hist(kobani_dialect_metainfo$Age, breaks = 20, col=rgb(0,1,0,0.2), xlim=c(30, 90),
                 xlab='Year', ylab='Occurences', main='')
dev.off()

kobani_dialect_metainfo_male_eng <- kobani_dialect_metainfo[kobani_dialect_metainfo$Gender_Eng == "male",]
kobani_dialect_metainfo_female_eng <- kobani_dialect_metainfo[kobani_dialect_metainfo$Gender_Eng == "female",]

kobani_dialect_metainfo_male_kur <- kobani_dialect_metainfo[kobani_dialect_metainfo$Gender_Kur == "Nêr/Mêr",]
kobani_dialect_metainfo_female_kur <- kobani_dialect_metainfo[kobani_dialect_metainfo$Gender_Kur == "Mê/Jin",]

# Age - by Gender
#################
png(paste0(dir_out, "kobaniAnalysis-demographic-age-gender-title-eng.png", sep=""), pointsize=10, width=1600, height=960, res=200)
plot_age_all <- hist(kobani_dialect_metainfo_male_eng$Age, breaks = 20, col=rgb(0,0,1,0.2), xlim=c(30, 90), ylim=c(0,4),
                     xlab='Year', ylab='Number of occurences', main='Age distribution of male and female participants')
plot_age_all <- hist(kobani_dialect_metainfo_female_eng$Age, breaks = 20, col=rgb(1,0,0,0.2), add=TRUE)
legend('topright', c('Male', 'Female'), fill=c(rgb(0,0,1,0.2), rgb(1,0,0,0.2)))
dev.off()

png(paste0(dir_out, "kobaniAnalysis-demographic-age-gender-title-kur.png", sep=""), pointsize=10, width=1600, height=960, res=200)
plot_age_all <- hist(kobani_dialect_metainfo_male_kur$Age, breaks = 20, col=rgb(0,0,1,0.2), xlim=c(30, 90), ylim=c(0,4),
                     xlab='Sal', ylab='Hejmara okurences', main='Dabeşkirina temenê beşdarên mêr û jin')
plot_age_all <- hist(kobani_dialect_metainfo_female_kur$Age, breaks = 20, col=rgb(1,0,0,0.2), add=TRUE)
legend('topright', c('Nêr/Mêr', 'Mê/Jin'), fill=c(rgb(0,0,1,0.2), rgb(1,0,0,0.2)))
dev.off()


################################################################################
# Plotting Gender and Education Level
# Still work in progress- probably some issue with "grouping" resulting in 200% instead of 100%

df <- kobani_dialect_metainfo %>% group_by(Gender_Eng, EducationLevel) %>% summarise(count = n()) %>% group_by(Gender_Eng) %>% mutate(Gender_Eng_Num=count/sum(count)) %>% ungroup()
png(paste0(dir_out, "kobaniAnalysis-demographic-gender-education-title.png", sep=""), pointsize=10, width=1600, height=960, res=200)
plot_sex_school <- ggplot(df, aes(x = "", y = Gender_Eng_Num, fill=EducationLevel)) + 
  geom_col() +
  facet_wrap(~Gender_Eng)+
  ggtitle(" ") +
  coord_polar("y", start=0) +
  scale_y_continuous(labels = scales::percent) +
  xlab("Distribution") +
  ylab("Gender") +
  scale_fill_manual(values=c('pink', 'lightblue', 'khaki', 'lightgreen')) +
  ggtitle("Distribution of gender and education level of participants")
print(plot_sex_school)
dev.off()

png(paste0(dir_out, "kobaniAnalysis-demographic-gender-education-notitle.png", sep=""), pointsize=10, width=1600, height=960, res=200)
plot_sex_school <- ggplot(df, aes(x = "", y = Gender_Eng_Num, fill=EducationLevel)) + 
  geom_col() +
  facet_wrap(~Gender_Eng)+
  ggtitle(" ") +
  coord_polar("y", start=0) +
  scale_y_continuous(labels = scales::percent) +
  xlab("Distribution") +
  ylab("Gender") +
  scale_fill_manual(values=c('pink', 'lightblue', 'khaki', 'lightgreen')) +
print(plot_sex_school)
dev.off()

# 
# df <- kobani_dialect_metainfo %>% group_by(EducationLevel, Gender_Eng) %>% summarise(count = n()) %>% group_by(EducationLevel) %>% mutate(EducationLevel=count/sum(count)) %>% ungroup()
# png(paste0(dir_out, "kobaniAnalysis-demographic-education-gender-title.png", sep=""), pointsize=10, width=1600, height=960, res=200)
# plot_sex_school <- ggplot(df, aes(x = "", y = EducationLevel, fill=Gender_Eng)) + 
#   geom_col() +
#   facet_wrap(~EducationLevel)+
#   ggtitle(" ") +
#   coord_polar("y", start=0) +
#   scale_y_continuous(labels = scales::percent) +
#   xlab("Distribution") +
#   scale_fill_manual(values=c('pink', 'lightblue')) +
#   ggtitle("Distribution of education level and gender of participants")
# print(plot_sex_school)
# dev.off()
