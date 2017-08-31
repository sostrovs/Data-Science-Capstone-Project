library(data.table)
library(shiny)
library(lattice)
library(plyr)
library(qdapRegex)
library(Rmisc)

options(warn=-1)

load_data <- function(name) {
    data <- list()
    for(n in 1:4) {
        data[[n]] <- fread(paste("csv_count", name, n, "gram.csv", sep = ""),
                           sep=",", header = TRUE, data.table = TRUE,
                           key = paste("word", 1:n, sep = ""))
    }
    return(data)
}

backoff_prediction <- function(words, N, n=4) {
    words <- rm_white(words)
    if(words == "") {
        result <- data[[N]][[1]][order(-count), 1:2]
        return(head(result, n=10))
    }
    
    w <- unlist(strsplit(words, " ")) 
    if((length(w) + 1) > n) {
        w <- w[((length(w)+1)-(n-1)):length(w)]
        print(w)
    } else {
        n <- (length(w)+1)
    }
    result <- data[[N]][[n]][as.list(w, list(n:(n+1)))][order(-count), n:(n+1)]
    if(is.na(result)) {
        return(backoff_prediction(paste(w[-1], collapse = " "), N, n-1))
    } else {
        return(head(result, n = 10))
    }
}


names <- c('blogs', 'twitter', 'news', 'combined')
data <- list()

for(i in 1:length(names)) {
    system.time(data[[i]] <- load_data(names[[i]]))
}
