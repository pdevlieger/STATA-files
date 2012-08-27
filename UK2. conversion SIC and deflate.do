********************************bhps***********************************************
******* Converting the SIC(1992) classification table to the SIC(1980) ********
**************************** classification table *****************************
*******************************************************************************

set more off

generate sic_junk=.
replace sic_junk=100	if jbsic92==111

*******************************************************************************
*******************************************************************************

*******************************************************************************
*************************** Deflating the variables ***************************
*******************************************************************************

// Source: http://ons.gov.uk/ons/datasets-and-tables/data-selector.html?cdid=D7BT&dataset=mm23&table-id=1.1
// site: http://ons.gov.uk

// OECD is exactly the same

generate deflator=0
label var deflator "deflator"
replace deflator=0.768 if wave==1
replace deflator=0.801 if wave==2
replace deflator=0.821 if wave==3
replace deflator=0.838 if wave==4
replace deflator=0.86 if wave==5
replace deflator=0.881 if wave==6
replace deflator=0.897 if wave==7
replace deflator=0.911 if wave==8
replace deflator=0.923 if wave==9
replace deflator=0.931 if wave==10
replace deflator=0.942 if wave==11
replace deflator=0.954 if wave==12
replace deflator=0.967 if wave==13
replace deflator=0.98 if wave==14
replace deflator=1.00 if wave==15
replace deflator=1.023 if wave==16
replace deflator=1.047 if wave==17
replace deflator=1.085 if wave==18

save BHPS, replace

*******************************************************************************