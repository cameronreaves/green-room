#start here
library(data.table)
library(tidyr)
data = read_csv("qual.csv")
#cleans data initial
data = data[c(3:nrow(data)),]
data = data %>% setnames(old = c("RecordedDate","Q15","Q12","Q13","Q14","Q10","Q6","Q4"),
                  new = c("Date","Room_Id","Building","Floor","Entryway","House","Last","First")) %>% 
        mutate(row_id = row_number())
##build points data to calculate the score of the test
points =  data %>% select(row_id,contains("Q")) %>% 
          pivot_longer(-row_id , names_to = "Question", values_to = "Points") %>% 
          mutate(Points = recode(Points, "Always" = 2,"Sometimes" = 1,.default = 0)) %>% 
          group_by(row_id) %>% 
          tally(Points) %>% 
          rename(Score = n)
          
##joins tables together
data = data %>% left_join(points, by = "row_id")

#cleans data futher
data = data %>% select(row_id, First, Last,Score,everything(),Date,-contains("Q")) %>% 
    mutate(House = str_remove(House, " House"))
write.csv(data, "survey_data.csv")
