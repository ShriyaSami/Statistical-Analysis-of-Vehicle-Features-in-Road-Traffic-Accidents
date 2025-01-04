# Statistical Analysis of Vehicle Features in Road Traffic Accidents

This statistical analysis aims to lay the foundation of understanding of vehicle features in relation to road traffic accidents. Through a collaborative approach, the findings of this analysis have the potential to reduce the number of vehicle-related road traffic accidents. 

# Datasets
The ‘Road Safety Data’ by the Department for Transport will be used, (Department for Transport, 2024b). From the dataset, the ‘Road Safety - Collisions last 5 years’ (86.4 MB) and ‘Road Safety - Vehicles last 5 years’ (120.4 MB) files are used. 

# Data Pre-processing
## Overall Data Cleaning
The dataset’s supporting documentation states that unknown/missing data has been categorised using the value of ‘-1’. As the dataset is extremely large, records containing ‘-1’ have been dropped, effectively removing unknown/missing data.

## Data Cleaning for Regression Model Only
To fit a regression model, the dataset had to be pre-processed further.
This included: data integration, data transformation (feature selection, dummy encoding and ordinal encoding) and data cleaning.

# Statistical Analysis
To perform statistical analysis, the following research questions were answered.

## 1. Do the observed frequencies of road traffic accidents for different vehicle types differ significantly from the expected frequencies?

## 2. Is there a statistically significant relationship between a vehicle’s engine capacity and its frequency of being involved in a road traffic accident?

## 3. Do the observed frequencies of road traffic accidents for different vehicle propulsion types differ significantly from the expected frequencies?

## 4. Is there a statistically significant relationship between a vehicle’s age and its frequency of being involved in a road traffic accident?

## 5. Among the UK's top ten vehicle makes identified by the DVLA, do the observed frequencies of road traffic accidents for different vehicle makes differ significantly from the expected frequencies?

## 6. Are certain vehicle makes, among the UK’s top ten makes identified by the DVLA, associated with more severe road traffic accidents?



# References
Department for Transport (2024b) ‘Road Safety Data’. Available at: https://www.data.gov.uk/dataset/cb7ae6f0-4be6-4935-9277-47e5ce24a11f/road-safety-data (Accessed: 10 November 2024).
