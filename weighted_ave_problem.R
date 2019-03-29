

#region - dear god seb please help me
#i need averages of each answer (home_w_fam_v_outside_w_friends) per region (south asia etc) 
#as a weighted averages by population of each country (moldova == 2%, Russia == 10% etc)
#....it is killing me. This is what I have got.

#read dataframe and save as wdye
wdye <- read.csv('where_do_you_eat.csv')


# group it by country then create a variable called freq_perc which is the percentage of each answer by country 
#(sum of all answers/ country = 100)
wdye_weight <- wdye %>% group_by(country) %>% dplyr::mutate(freq_perc = freq/sum(freq)*100)

#group by country and determine the weight by country population as a percentage of total population
#FOR SOME FUCKING REASON SO MANY ARE THE SAME NUMBER AND I CAN"T FIX IT
wdye_weight <- wdye_weight %>% dplyr::group_by(country) %>% dplyr::mutate(weights = (population/sum(population)*100))

##I then use freq_perc as the scores and weights as the weights to get weighted means. These should be different 
#values for each country that I then average together that give me average rates for each answer by region.
#I should have one score for each answer, instead I have thi garbage...fuck
wdye_aves <- wdye_weight %>% dplyr::group_by(home_w_fam_v_outside_w_friends) %>% 
  dplyr::mutate(freq_aves = weighted.mean(x = freq_perc, w = weights)*100)





ggplot(wdye_aves, aes(region, freq_aves)) + geom_col()