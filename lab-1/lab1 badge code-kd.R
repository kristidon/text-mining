
install.packages("summarytools")
library(dplyr)
library(tidyverse)
library(tidytext)
library(wordcloud2)
library(summarytools)

opd_survey <- read_csv("data/opd_survey.csv")
view(opd_survey) 

# examining responses to some of the other variables
# how are you using this resource Q20
# most beneficial aspect of this online resource Q21
# recommendations for improving online resource Q26; might want to remove "recommend"
# recommendations for making online learning more effective Q37
dfSummary(opd_survey)

# removing first two rows; not survey info, missing responses (for ease of wordcloud) & restricting to teacher responses only
opd_teacher <- opd_survey |>
  select(ResponseId, Role, Q26) |>
  slice(-1, -2) |>
  na.omit() |>
  filter(Role == "Teacher") |>
  unnest_tokens(word, Q26)
view(opd_teacher)

# removing stop words
opd_clean <- anti_join(opd_teacher, stop_words)
view(opd_clean)

# remove common words
remove <- data.frame(word=c("recommend", "recommendations", "recommendation", "user", "suggest", "suggestions"))
opd_clean <- anti_join(opd_clean, remove)
view(opd_clean)

opd_counts <- count(opd_clean, word, sort = TRUE)
head(opd_counts)

#   word            n
# 1 time          873
# 2 videos        248
# 3 easier        202
# 4 modules       172
# 5 information   146
# 6 module        142

wordcloud2(opd_counts)
