##########################################################
# Erstellen Sie edx- und final_holdout_test-Datensätze 
##########################################################
# Hinweis: Dieser Prozess kann einige Minuten in Anspruch nehmen
if(!require(tidyverse)) install.packages("tidyverse", repos = "http://cran.us.r-project.org")  # paktete prüfen & laden 
if(!require(caret)) install.packages("caret", repos = "http://cran.us.r-project.org")
library(tidyverse)
library(caret)
# MovieLens 10M Datensatz:
# https://grouplens.org/datasets/movielens/10m/
# http://files.grouplens.org/datasets/movielens/ml-10m.zip
options(timeout = 120)

dl <- "ml-10M100K.zip"  # Datensatz herunterladen
if(!file.exists(dl))    
  download.file("https://files.grouplens.org/datasets/movielens/ml-10m.zip", dl)

ratings_file <- "ml-10M100K/ratings.dat"  # Datein entpacken - nur die benötigten Dateien ratings und movies
if(!file.exists(ratings_file))
  unzip(dl, ratings_file)

movies_file <- "ml-10M100K/movies.dat"
if(!file.exists(movies_file))
  unzip(dl, movies_file)

ratings <- as.data.frame(str_split(read_lines(ratings_file), fixed("::"), simplify = TRUE),
                         stringsAsFactors = FALSE)  # Ratingsdaten einlesen und bereinigen - jede Zeile wird von : getrennt
colnames(ratings) <- c("userId", "movieId", "rating", "timestamp")

ratings <- ratings %>%            # Typumwandlung - in userid / movieid / rating / timestamp
  mutate(userId = as.integer(userId),
         movieId = as.integer(movieId),
         rating = as.numeric(rating),
         timestamp = as.integer(timestamp))

# Moviedaten einlesen
movies <- as.data.frame(str_split(read_lines(movies_file), fixed("::"), simplify = TRUE), 
                        stringsAsFactors = FALSE)    
colnames(movies) <- c("movieId", "title", "genres")
movies <- movies %>%
  mutate(movieId = as.integer(movieId))
movielens <- left_join(ratings, movies, by = "movieId")   # Zusammenführen rating mit filminfos  

# Finaler Hold-out-Testdatensatz umfasst 10% der MovieLens-Daten
set.seed(1, sample.kind="Rounding") # falls Sie R 3.6 oder höher verwenden
# set.seed(1) # falls Sie R 3.5 oder früher verwenden - set Seed setzt die Reproduzierbarkeit
test_index <- createDataPartition(y = movielens$rating, times = 1, p = 0.1, list = FALSE) # 10% der Daten werden als Testdaten ausgewählt 
edx <- movielens[-test_index,]  # Trainingsdaten (90%) 
temp <- movielens[test_index,]  # Kandidaten für TEstdaten (10%) 

# Stellen Sie sicher, dass userId und movieId im finalen Hold-out-Testdatensatz auch im edx-Datensatz vorhanden sind
final_holdout_test <- temp %>% 
  semi_join(edx, by = "movieId") %>%     # wichtig: Filtert nur Filme, die im Training vorkommen
  semi_join(edx, by = "userId")          # wichtig: Filtert nur Nutzer, die im Training vorkommen 
# Warum? Ein REcommender kann sonst nicht neuer User (Cold Start), neuen Filme (Cold Start) ... ohne diese Schritte für das Modell crashen

# Fügen Sie die aus dem finalen Hold-out-Testdatensatz entfernten Zeilen wieder in den edx-Datensatz ein
removed <- anti_join(temp, final_holdout_test)
edx <- rbind(edx, removed)

rm(dl, ratings, movies, test_index, temp, movielens, removed)   # Speicher aufräumen - entfernt unnötige Objecte aus Speicher - wichtig bei großen Datensätzen
