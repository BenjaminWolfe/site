library(tidyverse)
library(rvest)
library(lubridate)

acl <- read_html("https://www.aclfestival.com/lineup/interactive-lineup/")

test_acl <- acl %>% 
  html_nodes(".c-lineup__artist") %>% 
  html_attrs() %>% {
    tibble(
      id           = map_chr(., "data-id") %>% as.integer(),
      position     = map_chr(., "data-position") %>% as.integer(),
      artist       = map_chr(., "data-title"),
      october_date = map_chr(., "data-day-titles") %>% 
        str_replace_all(fixed("\\/"), "/") %>% 
        str_extract_all("10/\\d{1,2}")
    )
  } %>% 
  unnest(october_date) %>% 
  mutate(october_date = ymd(paste0("2019/", october_date)))

test_acl %>% 
  filter(october_date == ymd("2019-10-06")) %>% 
  View()
