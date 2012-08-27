STATA-files
===========

STATA files that I have used for my dissertation.

For my master dissertation, the BHPS is analyzed to see if performance pay (or bonuses) have been an important channel for increasing wage inequalities. The do files can be more or 
less summed up in three key parts. 

## For the UK
UK1, UK2 and UK3 set up the database and variables; UK4, UK5, UK6 and UK7 set up different regressions and graphical evidence to test an empirical model from economic
literature; UK8 more specifically performans a variance decomposition on the wage distribution to see what would have happened to the wage distribution absent of performance pay. 

"UK1. data_extract.do" is a do-file that extracts data from the different BHPS master data files.

"UK2. conversion SIC and deflate.do" is a do-file that ensures compatibility across the different industry (SIC) codes and deflates monetary values.

"UK3. VARs_and_MVs.do" is a do-file that declares missing values and variables.

"UK4. graphs and endpoint.do" sets up different graphs that I use for descriptives.

"UK5. Exploring changes.do", "UK6. Simple regressions.do" and "UK7. Variance decomposition.do" set up regressions frameworks.

"UK8. Bonuses and wage inequality.do" sets up a variance decomposition specification to see how the change of performance pay has changed the wage distribution over the last couple of years in the UK.

## For Germany
GE1 sets up the database and variables; GE set up different regressions and graphical evidence to test an empirical model from economic
literature; UK8 more specifically performans a variance decomposition on the wage distribution to see what would have happened to the wage distribution absent of performance pay. 


"GE1. data_extract_and_variables.do" is a do-file that extracts from the different SOEP master data files, deflates and declares variables.

"GE2. graphs and endpoint.do" sets up different graphs that I use for descriptives.

"GE3. Exploring changes", "GE4. Simple Regressions", "GE5. Variance decomposition.do" set up regressions frameworks.

"GE6. Bonuses and wage inequality.do" sets up a variance decomposition specification to see how the change of performance pay has changed the wage distribution over the last couple of years in Germany.