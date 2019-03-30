install.packages("dplyr")    # alternative installation of the %>%
install.packages("ggplot2")
  
library(ggplot2)
library(dplyr)

#region - dear god seb please help me
#i need averages of each answer (home_w_fam_v_outside_w_friends) per region (south asia etc) 
#as a weighted averages by population of each country (moldova == 2%, Russia == 10% etc)
#....it is killing me. This is what I have got.

#read dataframe and save as wdye
wdye <- read.csv('where_do_you_eat.csv')


# group it by country then create a variable called freq_perc which is the percentage of each answer by country 
#(sum of all answers/ country = 100)
country_group <- group_by(wdye, country)
wdye_with_freq_decimal <- dplyr::mutate(country_group, 
                                        freq_deci = freq/sum(freq), 
                                        freq_perc = freq_deci*100,
                                        pop_deci = population/sum(population),
                                        pop_freq = pop_deci*100
                                        )

wdye_weight <- wdye %>%
  mutate(
    pop_deci = population/sum(population),
    pop_percent = pop_deci*100
  ) %>%
  group_by(country) %>%
  mutate(
    freq_deci = freq/sum(freq), 
    freq_percent = freq_deci*100
  ) 
  

#group by country and determine the weight by country population as a percentage of total population
#FOR SOME FUCKING REASON SO MANY ARE THE SAME NUMBER AND I CAN"T FIX IT
#wdye_pop_weight <- wdye %>% dplyr::mutate(weights = (population/sum(population)*100))

##I then use freq_perc as the scores and weights as the weights to get weighted means. These should be different 
#values for each country that I then average together that give me average rates for each answer by region.
#I should have one score for each answer, instead I have thi garbage...fuck
wdye_aves <- wdye_weight %>% dplyr::group_by(home_w_fam_v_outside_w_friends) %>% 
  dplyr::mutate(freq_aves = weighted.mean(x = freq_perc, w = weights)*100)

ggplot(wdye_aves, aes(region, freq_aves)) + geom_col()