*******************************************************************************
*************************** Variance decomposition ****************************
*******************************************************************************
set more off
*preserve
local xlist1 "university technical vocational exp exp2 exp3 exp4 exp5 eu married tenure tenure2 tenure3 tenure4 tenure5 i.sic i.soc i.wave i.region"
local xlist11 "yeq exp exp2 exp3 exp4 exp5 eu married tenure tenure2 tenure3 tenure4 tenure5 sic1 sic2 sic3 sic4 sic5 sic6 sic7 sic8 sic9 soc1 soc2 soc3 soc4 soc5 soc6 soc7 soc8 soc9 i.wave i.region"

*xtmixed lnhly `xlist1' if bonusjob==1 || persnr:, variance nolog

*xtmixed lnhly `xlist1' if bonusjob==0 || persnr:, variance nolog

*xtmixed lnhly `xlist1' if bonusjob==1 || persnr: || jobmatch:, variance nolog

*xtmixed lnhly `xlist1' if bonusjob==0 || persnr: || jobmatch:, variance nolog

*set more off

xtmixed outcomepp_r if bonusjob==1 & wave<25 || persnr:, variance nolog mle

xtmixed outcomenpp_r if bonusjob==0  & wave<25 || persnr:, variance nolog mle

xtmixed outcomepp_r if bonusjob==1  & wave<25 ///
|| persnr: || jobmatch:, variance nolog mle

xtmixed outcomenpp_r if bonusjob==0  & wave<25 ///
|| persnr: || jobmatch:, variance nolog mle

generate JM1 = jobmatch*ME1
generate JM2 = jobmatch*ME2
generate JM3 = jobmatch*ME3
generate JM4 = jobmatch*ME4
generate JM5 = jobmatch*ME5
generate JM6 = jobmatch*ME6
generate JM7 = jobmatch*ME7
generate JM8 = jobmatch*ME8

*xtmixed outcomepp_r if bonusjob==1 || persnr: || jobmatch: || JM*:, variance nolog mle

*xtmixed outcomenpp_r if bonusjob==0 || persnr: || jobmatch: || JM*, variance nolog mle



// What for people that have been in both jobs?

by persnr: egen bonustotal=total(bonusjob)
by persnr: generate split=1
by persnr: replace split=0 if bonustotal==0
by persnr: replace split=0 if _N==bonustotal

xtmixed outcomepp_r if (bonusjob==1 & split==1  & wave<25 ) ///
|| persnr:, variance nolog mle 

xtmixed outcomenpp_r if (bonusjob==0 & split==1  & wave<25 ) ///
|| persnr:, variance nolog mle

xtmixed outcomepp_r if (bonusjob==1 & split==1  & wave<25 ) ///
|| persnr: || jobmatch:, ///
variance nolog mle

xtmixed outcomenpp_r if (bonusjob==0 & split==1  & wave<25 ) ///
|| persnr: || jobmatch:, ///
variance nolog mle


*******************************************************************************
*******************************************************************************
