# added the packages
install.packages("dplyr")    # alternative installation of the %>%
install.packages("ggplot2")
  
library(ggplot2)
library(dplyr)

#read dataframe and save as wdye
wdye <- read.csv('where_do_you_eat.csv')

# Think we want to use the total surveyed population not the sum(population) as that will have duplicates
# Not sure how to do this within dplyr
total_pop <- wdye %>% distinct(population)
sum_total_pop <- sum(total_pop)

wdye_weight <- wdye %>%
  mutate(
    # Take the popluation before grouping
    pop_deci = population/sum_total_pop,
    pop_percent = pop_deci*100
  ) %>%
  group_by(country) %>%
  mutate(
    freq_deci = freq/sum(freq), 
    freq_percent = freq_deci*100
  )

wdye_aves <- wdye_weight %>% 
  group_by(home_w_fam_v_outside_w_friends) %>% 
  mutate(freq_aves = weighted.mean(x = freq_deci, w = pop_deci)*100)

# freq_aves seems off
# Doesn't sum to 100
ggplot(wdye_aves, aes(region, freq_aves)) + geom_col()


#group by country and determine the weight by country population as a percentage of total population
#FOR SOME FUCKING REASON SO MANY ARE THE SAME NUMBER AND I CAN"T FIX IT
#wdye_pop_weight <- wdye %>% dplyr::mutate(weights = (population/sum(population)*100))

##I then use freq_perc as the scores and weights as the weights to get weighted means. These should be different 
#values for each country that I then average together that give me average rates for each answer by region.
#I should have one score for each answer, instead I have thi garbage...fuck

# wtf is a weighted mean?
# google to the rescue
wt <- c(5,  5,  4,  1)/15
x <- c(3.7,3.3,3.5,2.8)
xm <- weighted.mean(x, wt)
# > 3.45333
# By hand:
3.7*5/15 + 3.3*5/15 + 3.5*4/15 + 2.8*1/15
# = 3.45333


