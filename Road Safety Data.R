#Statistical Analysis using Road Safety Data
options(scipen = 999)
library("dplyr")
library(ggplot2)
library(ggstatsplot)
library("graphics")
library(corrplot)
library(vcd)
library(fastDummies)
library(MASS)

#Importing the data
#Reading in the collision-last-5-years CSV file.
collision_data <- read.csv("Documents/Uni/MSc BDA/CMP7205 Applied Statistics/Road Safety Dataset/dft-road-casualty-statistics-collision-last-5-years.csv")
View(collision_data)

#Reading in the vehicle-last-5-years CSV file.
vehicle_data <- read.csv("Documents/Uni/MSc BDA/CMP7205 Applied Statistics/Road Safety Dataset/dft-road-casualty-statistics-vehicle-last-5-years.csv")
View(vehicle_data)

#Data Cleaning - checking for missing values.
sum(is.na(vehicle_data))
sum(is.na(collision_data))

#No missing values found as they're often represented by -1, as stated in dataset's supporting documentation.
#So, manually removing the rows with values of -1.
vehicle_data = vehicle_data[vehicle_data$vehicle_type != -1,]
vehicle_data = vehicle_data[vehicle_data$age_of_vehicle != -1,]
vehicle_data = vehicle_data[vehicle_data$generic_make_model != -1,]
vehicle_data = vehicle_data[vehicle_data$engine_capacity_cc != -1,]
vehicle_data = vehicle_data[vehicle_data$propulsion_code != -1,]

##Testing for Normal Distribution
###Stratified Sample of vehicle_data 
vehicle_data_sample <- vehicle_data %>%
  group_by(accident_year) %>%
  sample_n(size=1000)


#Q1. Do the observed frequencies of road traffic accidents for different vehicle types differ significantly from the expected frequencies?
#EDA
##Univariate Analysis of Independent Variable (vehicle_type)
vehicle_type_counts <- table(vehicle_data$vehicle_type)
barplot(vehicle_type_counts, main = "Accident Counts By Vehicle Type Categories", xlab = "Vehicle Type Categories", ylab = "Accident Counts", font.main = 2, col = "#85c2ff", ylim = c(0, 600000))

#Statistical Test
##Chi-Square Goodness of Fit Test with vehicle_data
observed_vehicle_types <- table(vehicle_data$vehicle_type)

n_categories <- length(observed_vehicle_types)

#Expected proportions based on DVLA data.
expected_proportions <- c(car = 0.76, van = 0.18, lorry = 0.05, other = 0.1)
expected_proportions_normalized <- expected_proportions / sum(expected_proportions)

aggregated_vehicle_types <- c(
  car = sum(observed_vehicle_types[names(observed_vehicle_types) %in% c("8", "9")]),
  van = sum(observed_vehicle_types[names(observed_vehicle_types) == "19"]),
  lorry = sum(observed_vehicle_types[names(observed_vehicle_types) %in% c("20", "21", "98")]),
  other = sum(observed_vehicle_types[!names(observed_vehicle_types) %in% c("8", "9", "19", "20", "21", "98")])
)

vehicle_type_chisq <- chisq.test(x = aggregated_vehicle_types, p = expected_proportions_normalized)
print(vehicle_type_chisq)


#Visualisation of Statistical Test Result
std_residuals <- vehicle_type_chisq$stdres

#y-axis limit with 10% padding.
y_max <- max(abs(std_residuals)) * 1.1 
y_min <- -y_max  

barplot(std_residuals, main="Standardized Residuals by Vehicle Type Categories",
        xlab="Vehicle Type Categories", ylab="Standardized Residual", font.main = 2,
        col=ifelse(std_residuals > 0, "#85c2ff", "lightblue"),
        ylim=c(y_min, y_max))

#horizontal line at y=0
abline(h=0, lty=2)

#reference lines for significance
abline(h=c(-1.96, 1.96), lty=3, col="gray")

#labels
text(1:length(std_residuals), std_residuals, round(std_residuals, 2), pos=3)


#Q2. Is there a relationship between a vehicle’s engine capacity and its frequency of being involved in a road traffic accident?
#EDA 
##Univariate Analysis of Independent Variable (engine_capacity_cc)
engine_capacity_cc_counts <- table(vehicle_data$engine_capacity_cc)

range_values <- range(vehicle_data$engine_capacity_cc)
range_value <- range_values[2] - range_values[1]
bins_2000cc <- round(range_value/2000)

hist(engine_capacity_cc_counts, breaks = bins_2000cc, main = "Accident Counts By Engine Capacity CC", xlab = "Engine Capacity in CC", ylab = "Accident Counts", font.main = 2, col = "#85c2ff") #smoothest

#Subset of Vehicles With Engine Capacities Under 500 CC
engine_capacity_under500 <- subset(vehicle_data, engine_capacity_cc < 500)
vehicle_type_under500cc_counts <- table(engine_capacity_under500$vehicle_type)

barplot(vehicle_type_under500cc_counts, main = "Accident Counts By Vehicle Type Categories For Vehicles With Engine Capacities Under 500 CC", xlab = "Vehicle Type Categories", ylab = "Accident Counts", font.main = 2, col = "#85c2ff", , ylim = c(0, 35000))

#Statistical Test
##Pearson's Correlation
engine_capacity_cc_counts_names <- as.numeric(names(engine_capacity_cc_counts))
engine_capacity_cc_counts_numeric <- as.numeric(engine_capacity_cc_counts)

cor.test(engine_capacity_cc_counts_names, engine_capacity_cc_counts_numeric, method = "pearson")


#Q3. Do the observed frequencies of road traffic accidents for different vehicle propulsion types differ significantly from the expected frequencies?
#EDA 
##Univariate Analysis of Independent Variable (propulsion_code)
vehicle_propulsion_code_counts <- table(vehicle_data$propulsion_code)
barplot(vehicle_propulsion_code_counts, main = "Accident Counts By Propulsion Types", xlab = "Propulsion Type Categories", ylab = "Accident Counts", font.main = 2, col = "#85c2ff", ylim = c(0, 400000))

#Statistical Test
##Chi-Square Goodness of Fit Test with propulsion_code
observed_propulsion_codes <- table(vehicle_data$propulsion_code)

n_categories <- length(observed_propulsion_codes)

#Expected proportions based on DVLA data.
expected_proportions <- c(petrol = 0.57, heavy_oil = 0.34, hybrid = 0.06, electric = 0.02, other = 0.1)
expected_proportions_normalized <- expected_proportions / sum(expected_proportions)

aggregated_propulsion_codes <- c(
  petrol = sum(observed_propulsion_codes[names(observed_propulsion_codes) == "1"]),
  heavy_oil = sum(observed_propulsion_codes[names(observed_propulsion_codes) == "2"]),
  hybrid = sum(observed_propulsion_codes[names(observed_propulsion_codes) == "8"]),
  electric = sum(observed_propulsion_codes[!names(observed_propulsion_codes) %in% c("3", "12")]),
  other = sum(observed_propulsion_codes[names(observed_propulsion_codes) %in% c("1", "2", "3", "8", "12")])
)

propulsion_code_chisq <- chisq.test(x = aggregated_propulsion_codes, p = expected_proportions_normalized)
print(propulsion_code_chisq)

#Visualisation of Statistical Test Result
std_residuals <- propulsion_code_chisq$stdres

#y-axis limit with 10% padding.
y_max <- max(abs(std_residuals)) * 1.1 
y_min <- -y_max  

barplot(std_residuals, main="Standardized Residuals by Propulsion Types Categories",
        xlab="Propulsion Types Categories", ylab="Standardized Residual", font.main = 2,
        col=ifelse(std_residuals > 0, "#85c2ff", "lightblue"),
        ylim=c(-2000, 4000))

#horizontal line at y=0
abline(h=0, lty=2)

#reference lines for significance
abline(h=c(-1.96, 1.96), lty=3, col="gray")

#labels
pos_vector <- ifelse(std_residuals > 0, 3, 1)
text(1:length(std_residuals), std_residuals, round(std_residuals, 2), pos=pos_vector)


#Q4. Is there a relationship between a vehicle’s age and its frequency of being involved in a road traffic accident?

#EDA 
##Univariate Analysis of Independent Variable (age_of_vehicle)
age_of_vehicle_counts <- table(vehicle_data$age_of_vehicle)
barplot(age_of_vehicle_counts, main = "Number Of Vehicles Of Each Age", xlab = "Age in Years", ylab = "Number of Vehicles", font.main = 2, col = "#85c2ff", ylim = c(0, 50000))

#Statistical Test

##Shapiro Test on vehicle_data sample
shapiro.test(vehicle_data_sample$age_of_vehicle)

##Spearman's Correlation
age_of_vehicle_counts_names <- as.numeric(names(age_of_vehicle_counts))
age_of_vehicle_counts_numeric <- as.numeric(age_of_vehicle_counts)

age_of_vehicle_cor <- cor.test(age_of_vehicle_counts_names, age_of_vehicle_counts_numeric, method = "spearman", exact = FALSE)
age_of_vehicle_cor


#Q5. Among the UK's top ten vehicle makes identified by the DVLA, do the observed frequencies of road traffic accidents for different vehicle makes differ significantly from the expected frequencies?

#Data Pre-processing - Obtaining data for the UK's top ten vehicle makes.
vehicle_data_top_ten_makes <- vehicle_data[grep("Ford|Vauxhall|Volkswagen|BMW|Audi|Mercedes|Toyota|Nissan|Peugeot|Honda", vehicle_data$generic_make_model, ignore.case = TRUE),]
vehicle_data_top_ten_makes$generic_make_model <- ifelse(grepl("Ford", vehicle_data_top_ten_makes$generic_make_model, ignore.case = TRUE), "Ford",
                                       ifelse(grepl("Vauxhall", vehicle_data_top_ten_makes$generic_make_model, ignore.case = TRUE), "Vauxhall",
                                              ifelse(grepl("Volkswagen", vehicle_data_top_ten_makes$generic_make_model, ignore.case = TRUE), "Volkswagen",
                                                     ifelse(grepl("BMW", vehicle_data_top_ten_makes$generic_make_model, ignore.case = TRUE), "BMW",
                                                            ifelse(grepl("Audi", vehicle_data_top_ten_makes$generic_make_model, ignore.case = TRUE), "Audi",
                                                                   ifelse(grepl("Mercedes", vehicle_data_top_ten_makes$generic_make_model, ignore.case = TRUE), "Mercedes",
                                                                          ifelse(grepl("Toyota", vehicle_data_top_ten_makes$generic_make_model, ignore.case = TRUE), "Toyota",
                                                                                 ifelse(grepl("Nissan", vehicle_data_top_ten_makes$generic_make_model, ignore.case = TRUE), "Nissan",
                                                                                        ifelse(grepl("Peugeot", vehicle_data_top_ten_makes$generic_make_model, ignore.case = TRUE), "Peugeot",
                                                                                               ifelse(grepl("Honda", vehicle_data_top_ten_makes$generic_make_model, ignore.case = TRUE), "Honda", NA))))))))))


#EDA 
##Univariate Analysis of Independent Variable (generic_make_model)
vehicle_data_top_ten_makes_counts <- table(vehicle_data_top_ten_makes$generic_make_model)
barplot(vehicle_data_top_ten_makes_counts, main = "Accident Counts Of The UK's Top Ten Vehicle Makes (2019 - 2023)", xlab = "Vehicle Make", ylab = "Accident Counts", font.main = 2, col = "#85c2ff",  ylim = c(0, 100000))

#Statistical Test
##Chi-Square Goodness of Fit Test with generic_make_model
observed_top_ten_makes <- table(vehicle_data_top_ten_makes$generic_make_model)

n_categories <- length(observed_top_ten_makes)

#Expected proportions based on DVLA data.
expected_proportions <- c(Ford = 0.13, Vauxhall = 0.10, Volkswagen = 0.09, BMW = 0.06, Audi = 0.05, Mercedes = 0.05, Toyota = 0.04, Nissan = 0.04, Peugeot = 0.03, Honda = 0.03)
expected_proportions_normalized <- expected_proportions / sum(expected_proportions)

aggregated_top_ten_makes <- c(
  Ford = sum(observed_top_ten_makes[names(observed_top_ten_makes) == "Ford"]),
  Vauxhall = sum(observed_top_ten_makes[names(observed_top_ten_makes) == "Vauxhall"]),
  Volkswagen = sum(observed_top_ten_makes[names(observed_top_ten_makes) == "Volkswagen"]),
  BMW = sum(observed_top_ten_makes[names(observed_top_ten_makes) == "BMW"]),
  Audi = sum(observed_top_ten_makes[names(observed_top_ten_makes) == "Audi"]),
  Mercedes = sum(observed_top_ten_makes[names(observed_top_ten_makes) == "Mercedes"]),
  Toyota = sum(observed_top_ten_makes[names(observed_top_ten_makes) == "Toyota"]),
  Nissan = sum(observed_top_ten_makes[names(observed_top_ten_makes) == "Nissan"]),
  Peugeot = sum(observed_top_ten_makes[names(observed_top_ten_makes) == "Peugeot"]),
  Honda = sum(observed_top_ten_makes[names(observed_top_ten_makes) == "Honda"])
)

top_ten_makes_chisq <- chisq.test(x = aggregated_top_ten_makes, p = expected_proportions_normalized)
print(top_ten_makes_chisq)

#Visualisation of Statistical Test Result
std_residuals <- top_ten_makes_chisq$stdres

#Y-axis limit with 10% padding.
y_max <- max(abs(std_residuals)) * 1.1 
y_min <- -y_max  

barplot(std_residuals, main="Standardised Residuals by Vehicle Make",
        xlab="Vehicle Make", ylab="Standardised Residual", font.main = 2,
        col=ifelse(std_residuals > 0, "#85c2ff", "lightblue"), ylim=c(-55, 150))  

#Horizontal line at y=0.
abline(h=0, lty=2)

#Reference lines for significance.
abline(h=c(-1.96, 1.96), lty=3, col="gray")

#labels
pos_vector <- ifelse(std_residuals > 0, 3, 1)
text(1:length(std_residuals), std_residuals, round(std_residuals, 2), pos=3)

#Q6. Are certain vehicle makes, among the UK’s top ten makes identified by the DVLA, associated with more severe road traffic accidents?

#Data Pre-processing - Merging collision_data and vehicle_data_top_ten_makes by accident_index to obtain vehicle makes and accident severity.
accident_severity <- subset(collision_data, select = c(accident_index, accident_severity))
vehicle_make <- subset(vehicle_data_top_ten_makes, select = c(accident_index, generic_make_model))
accident_severity_per_vehicle_with_id <- merge(accident_severity, vehicle_make, by="accident_index")

accident_severity_per_vehicle <- subset(accident_severity_per_vehicle_with_id, select = -c(accident_index))


#EDA 
##Univariate Analysis of Independent Variable (accident_severity).
accident_severity_counts <- table(accident_severity_per_vehicle$accident_severity)
barplot(accident_severity_counts, main = "Accident Severity Level Counts For The UK's Top Ten Vehicle Makes (2019 - 2023)", xlab = "Accident Severity Categories", ylab = "Accident Counts", font.main = 2, col = "#85c2ff", ylim = c(0, 400000)) 

##Bivariate Analysis of accident_severity and generic_make_model.
ggplot(accident_severity_per_vehicle, aes(x = generic_make_model)) +
  geom_bar(fill = "#85c2ff") + 
  facet_wrap(~ accident_severity) + 
  labs(title = "Accident Severity Level Counts Separated By The UK's Top Ten Vehicle Makes (2019 - 2023)",
       x = "Vehicle Make",
       y = "Accident Count") +
  theme(plot.title=element_text(hjust=0.5),
        axis.text.x = element_text(angle = 45, hjust = 1, size = 10))

#Statistical Test
accident_severity_per_make_table <- table(accident_severity_per_vehicle$accident_severity, accident_severity_per_vehicle$generic_make_model)

##Chi-Square Test of Independence
accident_severity_per_make_chisq <- chisq.test(accident_severity_per_make_table)
accident_severity_per_make_chisq


#Visualisation of Statistical Test Result
mosaicplot(accident_severity_per_make_table, 
           main = "Mosaic Plot of Accident Severity by Vehicle Make",
           xlab = "Accident Severity",
           ylab = "Vehicle Make",
           las = 1, shade = TRUE) 


#Regression Model

##Data Pre-processing

###Data Integration - Inner merge on accident severity and vehicle data.
vehicle_data_with_accident_severity <- merge(accident_severity_per_vehicle_with_id, vehicle_data, by="accident_index")

###Data Transformation (Feature Selection) - Selecting features to keep. 
vehicle_data_with_accident_severity <- subset(vehicle_data_with_accident_severity, select = c(vehicle_type, engine_capacity_cc, propulsion_code, generic_make_model.x, age_of_vehicle, accident_severity))

###Data Cleaning - Keeping only unique rows.
vehicle_data_with_accident_severity <- distinct(vehicle_data_with_accident_severity)
nrow(vehicle_data_with_accident_severity[duplicated(vehicle_data_with_accident_severity), ])

###Data Transformation - Encoding categorical features using dummy encoding. 
encoded_vehicle_data_with_accident_severity <- dummy_cols(vehicle_data_with_accident_severity, select_columns = "generic_make_model.x", remove_first_dummy = TRUE)
encoded_vehicle_data_with_accident_severity <- subset(encoded_vehicle_data_with_accident_severity, select = -c(generic_make_model.x))

###Data Transformation - Encoding ordinal features using ordinal encoding. 
encoded_vehicle_data_with_accident_severity$accident_severity <- factor(encoded_vehicle_data_with_accident_severity$accident_severity,
                                 levels = c(1, 2, 3),
                                 labels = c("fatal", "severe", "slight"),
                                 ordered = TRUE)

str(encoded_vehicle_data_with_accident_severity)

#Model Fitting - Ordinal logistic regression model.
ordinal_model <- polr(accident_severity ~ vehicle_type + engine_capacity_cc + propulsion_code + age_of_vehicle + generic_make_model.x_BMW + generic_make_model.x_Ford +
                        generic_make_model.x_Honda + generic_make_model.x_Mercedes + generic_make_model.x_Nissan + generic_make_model.x_Peugeot +
                        generic_make_model.x_Toyota + generic_make_model.x_Vauxhall + generic_make_model.x_Volkswagen, data = encoded_vehicle_data_with_accident_severity, Hess = TRUE)

#Model Evaluation 
summary(ordinal_model)
