install.packages("readcsv")
install.packages("PDtoolkit")

data <- read.csv("C:\\Users\\Boss\\Desktop\\СФ\\statistics\\Data prep Homogeneity.csv")

View(data)
typeof(data)
names(data)

# Using supply to get the class of each column
sapply(data,class)

#Check if there are NA in the data
colSums(is.na(data))

#remove empty data from pd_model_class column
data = data[!is.na(data$pd_model_class)==TRUE, ]
#remove all rows with pd_model_class == -1
data = data[!(data$pd_model_class==-1)==TRUE, ]
#remove data that wasn't used for validation, as it was written in the task
data = data[!(data$Validation_sample==0)==TRUE, ]

#separate data in tertiles
data <- data %>%
  mutate(granted_tertile = ntile(granted_amt_EUR, 3))

#run homogeneity test on ratings based on the Credit Amount segments
results = homogeneity(app.port = data, 
            def.ind = "default_flg", 
            rating = "pd_model_class", 
            segment = "granted_tertile",
            segment.num = 3, 
            alpha = 0.025)
View(results)

write.csv(results,"C:\\Users\\Boss\\Desktop\\СФ\\statistics\\results.csv",row.names = FALSE)
