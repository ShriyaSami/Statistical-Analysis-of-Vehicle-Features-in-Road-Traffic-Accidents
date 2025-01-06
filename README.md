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
**Statistical test used:** Chi-square goodness of fit test.

**Findings:** 
- As p-value < 0.05, there is sufficient evidence to reject the null hypothesis in favour of the alternative hypothesis, indicating a statistically significant difference in accident counts across vehicle types. This suggests potential under or overrepresentation of certain vehicle types in road traffic accident data.
- The standardised residuals were visualised, as shown below:
- ![Standardised Residuals by Vehicle Types](https://github.com/ShriyaSami/Statistical-Analysis-of-Vehicle-Features-in-Road-Traffic-Accidents/blob/main/question%201%20standardised%20residuals.png)
- In the bar plot, the height of each bar represents the difference between observed and expected values. The direction of the bar, positive or negative, indicates whether observed frequencies were higher or lower. The car category’s largely positive residual suggests disproportional involvement in road traffic accidents compared to their road presence. The van category’s largely negative residual suggests lower involvement in road traffic accidents compared to their road presence. 

## 2. Is there a statistically significant relationship between a vehicle’s engine capacity and its frequency of being involved in a road traffic accident?
**Statistical test used:** Pearson’s correlation.

**Findings:** 
- The negative test statistic and correlation coefficient signify a weak negative correlation between a vehicle’s engine capacity and road traffic accident frequency. Although marginal, this suggests that vehicles with larger engine capacities are involved in fewer road traffic accidents. 
- As p-value < 0.05, there is sufficient evidence to reject the null hypothesis in favour of the alternative hypothesis. This confirms a statistically significant relationship between a vehicle’s engine capacity and road traffic accident frequency.
- However, the weak correlation limits the practical significance of this finding alone.

## 3. Do the observed frequencies of road traffic accidents for different vehicle propulsion types differ significantly from the expected frequencies?
**Statistical test used:** Chi-square goodness of fit test.

**Findings:** 
- As p-value < 0.05, there is sufficient evidence to reject the null hypothesis in favour of the alternative hypothesis, indicating a statistically significant difference in accident counts for various propulsion types. However, underlying propulsion type trends may contribute to these results.
- The extremely small p-value suggests this difference is not due to chance.
- Upon visualising standardised residuals, it was found that more electric vehicles are involved in road traffic accidents despite their 2% proportion across the UK.
- Conversely, for the hybrid category, frequencies were observed than expected. This shows that from the 6% of hybrid vehicles in the UK, even fewer are involved in road traffic accidents.

## 4. Is there a statistically significant relationship between a vehicle’s age and its frequency of being involved in a road traffic accident?
**Statistical test used:** Spearman’s correlation.

**Findings:** 
- The large test statistic and correlation coefficient represent a strong negative monotonic correlation. This suggests that as a vehicle’s age increases, it’s road traffic accident frequency decreases.
- As p-value < 0.05, there is sufficient evidence to reject the null hypothesis in favour of the alternative hypothesis. Further signifying the statistically significant relationship between a vehicle’s age and its frequency of being involved in a road traffic accident.
- Therefore it is unlikely that the strong monotonic correlation exists due to chance.

## 5. Among the UK's top ten vehicle makes identified by the DVLA, do the observed frequencies of road traffic accidents for different vehicle makes differ significantly from the expected frequencies?
**Statistical test used:** Chi-square goodness of fit test.

**Findings:** 
- As p-value < 0.05, there is sufficient evidence to reject the null hypothesis in favour of the alternative hypothesis. This indicates a statistically significant difference in accident counts for vehicles of different makes. This was expected due to some vehicle makes being significantly overrepresented in the dataset.
- Upon visualising standardised residuals, it was found that despite Honda having a 3% proportion amongst the UK’s top ten vehicle makes, Hondas are involved in more road traffic accidents. This is similar for Toyota which has a 4% proportion but had higher observed values.
- Ford had the highest count of accidents, however, from the standardised residuals it is evident that the observed counts for Ford were lower. This indicates that despite Ford vehicles’ greater presence on UK roads, Ford vehicles are underrepresented in road traffic accidents. There are many possible reasons for this, including driving behaviours of Ford vehicle drivers, and Ford vehicle uses. This is the same for Vauxhall, which had the second highest count of accidents.

## 6. Are certain vehicle makes, among the UK’s top ten makes identified by the DVLA, associated with more severe road traffic accidents?
**Statistical test used:** Chi-square test of independence.

**Findings:** 
- As p-value < 0.05, there is sufficient evidence to reject the null hypothesis in favour of the alternative hypothesis. This indicates a statistically significant association between vehicle make and road traffic accident severity, suggesting that certain vehicles are more likely to be involved in road traffic accidents at various severity levels.
- A mosaic plot was plotted that showed that most observed road traffic accidents belong to category 3 (slight), regardless of make.
- Ford is the most observed make, but this does not convey that Ford vehicles are associated with more severe road traffic accidents. This is indicated by the colour coded standardised residuals. The standardised residual of Ford in severity category 3 (-2.0) is significantly less than its standardised residual in severity category 2 (2.4).
- Toyota has a significantly higher standardised residual for severity category 3 (>4), compared to other categories, suggesting that most Toyota vehicle accidents are of slight severity. Toyota vehicles are desired for their fuel efficiency and low operating costs, making them a top choice for taxi drivers. Despite their increased presence on the road, taxi drivers can avert road traffic accidents, (Wu, 2012). This clarifies why Toyota accidents are mainly of slight severity.
- The observed  value for Honda vehicles in severity category 2 (serious) is significantly higher than expected. This shows that despite Honda having a 3% proportion amongst the UK’s top ten vehicle makes, it is severely overrepresented in severity category 2.
- Similarly, BMW and Mercedes have significant differences in observed and expected values for severity category 1 (fatal). For both, significantly higher values were observed. This can be linked to driver behaviours. Both makes are considered luxury cars, but various research has shown for drivers of expensive cars ‘more likely to break traffic regulations’, (Lönnqvist, Ilmarinen and Leikas, 2020).
![Mosaic Plot](https://github.com/ShriyaSami/Statistical-Analysis-of-Vehicle-Features-in-Road-Traffic-Accidents/blob/main/mosaic%20plot%20of%20accident%20severity%20by%20vehicle%20make.png)  

## Ordinal Logistic Regression Model
Overall, the model identified statistically significant features and log odds of categories when all predictor features are zero. It indicated whether a one-unit increase, per feature, would lead to increased odds of higher accident severity levels. This provides an insight into which features, when increased, could lead to increased accident severity levels. 

# References
Department for Transport (2024b) ‘Road Safety Data’. Available at: https://www.data.gov.uk/dataset/cb7ae6f0-4be6-4935-9277-47e5ce24a11f/road-safety-data (Accessed: 10 November 2024).

Lönnqvist, J.E., Ilmarinen, V. and Leikas, S. (2020) ‘Not only assholes drive Mercedes. Besides disagreeable men, also conscientious people drive high‐status cars’, International Journal of Psychology, 55(4), pp. 572–576. Available at: https://doi.org/10.1002/ijop.12642.

Wu, J. (2012) Analysis of taxi drivers’ driving behavior based on a driving simulator experiment . Available at: https://core.ac.uk/download/pdf/236297546.pdf (Accessed: 19 December 2024).
