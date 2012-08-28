STATA-files
===========

STATA files that I have used for my dissertation.

For my master dissertation, the BHPS is analyzed to see if performance pay (or bonuses) have been an important channel for increasing wage inequalities. The do files can be more or 
less summed up in three key parts. 

## For the UK
UK1, UK2 and UK3 set up the database and variables; UK4, UK5, UK6 and UK7 set up different regressions and graphical evidence to test an empirical model from economic
literature; UK8 more specifically performans a variance decomposition on the wage distribution to see what would have happened to the wage distribution absent of performance pay. 

_UK1. data extract.do_ is a do-file that extracts data from the different BHPS master data files.

_UK2. conversion SIC and deflate.do_ is a do-file that ensures compatibility across the different industry (SIC) codes and deflates monetary values.

_UK3. VARs and MVs.do_ is a do-file that declares missing values and variables.

_UK4. graphs and endpoint.do_ sets up different graphs that I use for descriptives.

_UK5. Exploring changes.do_, _UK6. Simple regressions.do_ and _UK7. Variance decomposition.do_ set up regressions frameworks.

_UK8. Bonuses and wage inequality.do_ sets up a variance decomposition specification to see how the change of performance pay has changed the wage distribution over the last couple of years in the UK.

## For Germany
GE1 sets up the database and variables; GE2, GE3, GE4 and GE5 set up different regressions and graphical evidence to test an empirical model from economic
literature; UK8 more specifically performans a variance decomposition on the wage distribution to see what would have happened to the wage distribution absent of performance pay. 


_GE1. data extract and variables.do_ is a do-file that extracts from the different SOEP master data files, deflates and declares variables.

_GE2. graphs and endpoint.do_ sets up different graphs that I use for descriptives.

_GE3. Exploring changes_, _GE4. Simple Regressions_, _GE5. Variance decomposition.do_ set up regressions frameworks.

_GE6. Bonuses and wage inequality.do_ sets up a variance decomposition specification to see how the change of performance pay has changed the wage distribution over the last couple of years in Germany.