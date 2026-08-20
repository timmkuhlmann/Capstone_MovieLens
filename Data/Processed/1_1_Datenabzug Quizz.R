# ------------ Quiz: MovieLens-Datensatz -----------------------------------------
#1
# Wie viele Zeilen und Spalten gibt es im edx-Datensatz?
dim(edx)
# Alternativ
ncol(edx)
nrow(edx)

#2 
#Wie viele Nullen wurden als Bewertungen im edx-Datensatz vergeben?
sum(edx$rating == 0, na.rm = TRUE)
#Wie viele Dreier wurden als Bewertungen im edx-Datensatz vergeben?
sum(edx$rating == 3, na.rm = TRUE)
# Alternativ
table(edx$rating)

#3
# Wie viele verschiedene Filme sind im edx Datensatz?
edx %>%
  summarize(anzahl_filme = n_distinct(movieId))
#Alternativ
n_distinct(edx$movieId)

#4
# Wie viele verschiedene Benutzer gibt es im edx-Datensatz?
edx %>%
  summarize(anzahl_user = n_distinct(userId))
#alternativ
n_distinct(edx$userId)

#5
# Wie viele Filmbewertungen gibt es in jedem der folgenden Genres im edx-Datensatz?
edx %>%
  filter(str_detect(genres, "Drama")) %>%
  nrow()
edx %>%
  filter(str_detect(genres, "Comedy")) %>%
  nrow()
edx %>%
  filter(str_detect(genres, "Thriller")) %>%
  nrow()
edx %>%
  filter(str_detect(genres, "Romance")) %>%
  nrow()

table(edx$genres)

#6 Welcher Film hat die meisten Bewertungen?
edx %>%
  count(title, sort = TRUE)

#7 Was sind die fünf am häufigsten vergebenen Bewertungen in der Reihenfolge von den meisten zur wenigsten?
edx %>%
  count(rating, sort = TRUE) %>%
  slice(1:5)

# 8 Wahr oder Falsch: Im Allgemeinen sind halbe Sternebewertungen seltener als ganze Sternebewertungen
#(z. B. gibt es weniger Bewertungen von 3,5 als Bewertungen von 3 oder 4 usw.).
edx %>%
  group_by(rating) %>%
  summarize(count = n()) %>%
  ggplot(aes(x = rating, y = count)) +
  geom_line()
