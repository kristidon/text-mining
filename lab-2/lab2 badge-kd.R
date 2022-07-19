
library(dplyr)
library(readr)
library(tidyr)
library(rtweet)
library(writexl)
library(readxl)
library(tidytext)
library(textdata)
library(ggplot2)
library(textdata)
library(scales)

# reading in ngss & common core tweet data
ngss_tweets <- read_xlsx("lab-2/data/ngss_tweets.xlsx")
ccss_tweets <- read_xlsx("lab-2/data/csss_tweets.xlsx")

# restrict to tweets in english; retain screen name, date/time, and tweet; add indicator for ngss/ccss; reorder ngss/ccss indicator to first
ngss_text <-
  ngss_tweets |>
  filter(lang == "en") |>
  select(screen_name, created_at, text) |>
  mutate(standards = "ngss") |>
  relocate(standards)
ccss_text <-
  ccss_tweets |>
  filter(lang == "en") |>
  select(screen_name, created_at, text) |>
  mutate(standards = "ccss") |>
  relocate(standards)

# appending ngss & common core tweets
tweets <- bind_rows(ngss_text, ccss_text)

# first step in text mining: tokenizing
tweet_tokens <- 
tweets %>%
  unnest_tokens(output = word, 
                input = text, 
                token = "tweets")

# remove stop words
tidy_tweets <-
tweet_tokens %>%
  anti_join(stop_words, by = "word")

# looking at counts of words
count(tidy_tweets, word, sort = T)
# common, core, and #ngss in top 10. are there other hashtags included in these words?

grepl("#",tidy_tweets$word)
# there are a number that contain a hashtag; i'm not sure how to list to see
sort(tidy_tweets$word)
# a lot of @ usernames - not sure how to drop & not include; to focus on the content of the texts vs. who they're directed at 

filter(tweets, grepl('@', text))
filter(tweets, grepl('amp', text))
















