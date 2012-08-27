*******************************************************************************
*********************** Dealing with endpoint problems ************************
*******************************************************************************

local bonusjob "bonusjob"
local duration "duration"
local perfjob "perfjob"
local bonusjobfifth "bonusjobfifth"
local bonusjobhalf "bonusjobhalf"


set more off 

cd "/Users/pieterdevlieger/Desktop/plan B - wage inequality/BHPS"
*mkdir endpoint
cd "/Users/pieterdevlieger/Desktop/plan B - wage inequality/BHPS/endpoint"

kdensity `duration', plot(kdensity `duration' if wave>5 & wave<15) ///
	legend(label(1 "Non-adjusted distribution") ///
	label(2 "Adjusted distribution")) scheme(s1mono)
graph save kernel_endpoint_test, replace
cd "/Users/pieterdevlieger/Desktop/plan B - wage inequality/latex-documents"
graph export durationdiff_endpoint_UK.png, replace
cd "/Users/pieterdevlieger/Desktop/plan B - wage inequality/BHPS/endpoint"

// ksmirnov separately

egen mean_post_1 = mean(`duration') if wave>5 & wave<15
egen mean_post = mean(mean_post_1)
drop mean_post_1

quietly reg `bonusjob' `duration' i.wave
predict prob_job
generate adjusted = prob_job - _b[`duration']*`duration' ///
+ _b[`duration']*mean_post
label var adjusted "PP incidence (adjusted for endpoint problems)"
drop prob_job mean_post

sort wave, stable
by wave: egen adjustedmean=mean(adjusted)
by wave: egen bonusjobmean=mean(`bonusjob')

twoway (line bonusjobmean adjustedmean wavey, lpattern(line dash)), ///
title("Adjustment for endpoints") legend(lab(1 "Unadjusted PP incidence") ///
lab(2 "Adjusted PP jobs incidence")) ylabel(0(0.2)0.8) scheme(s1mono)
graph save adjusted_endpoint, replace

cd "/Users/pieterdevlieger/Desktop/plan B - wage inequality/latex-documents"
graph export adjusted_endpoint_UK.png, replace
cd "/Users/pieterdevlieger/Desktop/plan B - wage inequality/BHPS/endpoint"

*******************************************************************************
*******************************************************************************


*******************************************************************************
********************* Graphs by different characteristics *********************
*******************************************************************************

//---------------------------------------------------------------------------//
//--------------------------------- Overall ---------------------------------//
//---------------------------------------------------------------------------//

cd "/Users/pieterdevlieger/Desktop/plan B - wage inequality/BHPS"
*mkdir graphmean
cd "/Users/pieterdevlieger/Desktop/plan B - wage inequality/BHPS/graphmean"

by wave: egen bonusmean=mean(bonus)
by wave: egen perfmean=mean(performance)
by wave: egen perfjobmean=mean(`perfjob')
by wave: egen bonammean=mean(bonam)
by wave: egen bonsharemean=mean(bonsharel)
by wave: egen nonwhitemean=mean(nonwhite)
by wave: egen cbamean=mean(cba)
by wave: egen unionmean=mean(union)

twoway (line bonusmean wavey) (line bonusjobmean wavey) ///
(line bonsharemean wavey) (line nonwhitemean wavey) ///
(line unionmean wavey), title("Overall trend PP jobs") nodraw 
graph save graphbonmean, replace

twoway (line bonusmean bonusjobmean adjustedmean wavey, lpattern(line line ///
dash)), title("Overall trend performance-pay jobs") ///
legend(lab(1 "PP incidence") lab(2 "PP jobs incidence")) ylabel(0(0.2)0.8) ///
scheme(s1mono)
cd "/Users/pieterdevlieger/Desktop/plan B - wage inequality/latex-documents"
graph export graphbonmean_UK.png, replace
cd "/Users/pieterdevlieger/Desktop/plan B - wage inequality/BHPS/graphmean"

//---------------------------------------------------------------------------//
//-------------------------------- Industry ---------------------------------//
//---------------------------------------------------------------------------//

cd "/Users/pieterdevlieger/Desktop/plan B - wage inequality/BHPS"
*mkdir graphsic
cd "/Users/pieterdevlieger/Desktop/plan B - wage inequality/BHPS/graphsic"
sort wave, stable
foreach x in 0 1 2 3 4 5 6 7 8 9 {

	egen mean_pre_sic`x' = mean(`duration') if sic`x'==1
	egen mean_post_1sic`x' = mean(`duration') if wave>5 & wave<15 & sic`x'==1
	egen mean_post_sic`x' = mean(mean_post_1)
	drop mean_post_1sic`x'

	quietly reg `bonusjob' `duration' i.wave if sic`x'==1
	predict prob_job_sic`x'
	generate adjusted_sic`x' = prob_job_sic`x' - _b[`duration']*`duration' + ///
	_b[`duration']*mean_post_sic`x'
	label var adjusted_sic`x' "PP incidence SIC`x' (endpoint corrected)"
	drop prob_job_sic`x' mean_post_sic`x' mean_pre_sic`x'

	by wave: egen bonussic`x'=mean(bonus) if sic`x'==1
	by wave: egen bonusjobsic`x'=mean(`bonusjob') if sic`x'==1
	by wave: egen perfsic`x'=mean(performance) if sic`x'==1
	by wave: egen perfjobsic`x'=mean(`perfjob') if sic`x'==1
	by wave: egen bonamsic`x'=mean(bonam) if sic`x'==1
	by wave: egen bonsharesic`x'=mean(bonsharel) if sic`x'==1
	by wave: egen nonwhitesic`x'=mean(nonwhite) if sic`x'==1
	by wave: egen cbasic`x'=mean(cba) if sic`x'==1
	by wave: egen unionsic`x'=mean(union) if sic`x'==1
	by wave: egen adjustedsic`x'=mean(adjusted_sic`x') if sic`x'==1
	
	twoway (line bonussic`x' wavey) (line bonusjobsic`x' wavey) ///
	(line bonsharesic`x' wavey) (line nonwhitesic`x' wavey) ///
	(line unionsic`x' wavey), title("Sic`x' trends bonus jobs") nodraw 
	graph save graphbonsic`x', replace

	twoway (line perfsic`x' wavey) (line perfjobsic`x' wavey) ///
	(line bonsharesic`x' wavey) (line nonwhitesic`x' wavey) ///
	(line unionsic`x' wavey), title("Sic`x' trends performance jobs") nodraw 
	graph save graphperfsic`x', replace
	
	twoway (line bonamsic`x' wavey), ///
	title("Sic`x' trends bonus amounts") nodraw 
	graph save bonamgraphsic`x', replace	
	
	twoway (line bonussic`x' bonusjobsic`x' adjustedsic`x' wavey, ///
	lpattern(line line dash)), title("Sic`x' trend performance-pay jobs") ///
	legend(lab(1 "PP incidence") lab(2 "PP jobs incidence") ///
	lab(3 "PP endpoint corrected")) ylabel(0(0.2)0.8) scheme(s1mono)
	cd "/Users/pieterdevlieger/Desktop/plan B - wage inequality/latex-documents"
	graph export graphbonsic`x'_UK.png, replace
	cd "/Users/pieterdevlieger/Desktop/plan B - wage inequality/BHPS/graphsoc"

	drop bonussic`x' bonusjobsic`x' perfsic`x' perfjobsic`x' bonamsic`x' ///
	bonsharesic`x' nonwhitesic`x' cbasic`x' unionsic`x' adjustedsic`x'
}

//---------------------------------------------------------------------------//
//------------------------------- Occupation --------------------------------//
//---------------------------------------------------------------------------//

cd "/Users/pieterdevlieger/Desktop/plan B - wage inequality/BHPS"
*mkdir graphsoc
cd "/Users/pieterdevlieger/Desktop/plan B - wage inequality/BHPS/graphsoc"

foreach x in 1 2 3 4 5 6 7 8 9 {
	egen mean_pre_soc`x' = mean(`duration') if soc`x'==1
	egen mean_post_1soc`x' = mean(`duration') if wave>5 & wave<15 & soc`x'==1
	egen mean_post_soc`x' = mean(mean_post_1)
	drop mean_post_1soc`x'

	quietly reg `bonusjob' `duration' i.wave if soc`x'==1
	predict prob_job_soc`x'
	generate adjusted_soc`x' = prob_job_soc`x' - _b[`duration']*`duration' ///
	+ _b[`duration']*mean_post_soc`x'
	label var adjusted_soc`x' "PP incidence SOC`x' (endpoint corrected)"
	drop prob_job_soc`x' mean_post_soc`x' mean_pre_soc`x'

	by wave: egen bonussoc`x'=mean(bonus) if soc`x'==1
	by wave: egen bonusjobsoc`x'=mean(`bonusjob') if soc`x'==1
	by wave: egen perfsoc`x'=mean(performance) if soc`x'==1
	by wave: egen perfjobsoc`x'=mean(`perfjob') if soc`x'==1
	by wave: egen bonamsoc`x'=mean(bonam) if soc`x'==1
	by wave: egen bonsharesoc`x'=mean(bonsharel) if soc`x'==1
	by wave: egen nonwhitesoc`x'=mean(nonwhite) if soc`x'==1
	by wave: egen cbasoc`x'=mean(cba) if soc`x'==1
	by wave: egen unionsoc`x'=mean(union) if soc`x'==1
	by wave: egen adjustedsoc`x'=mean(adjusted_soc`x') if soc`x'==1
	
	twoway (line bonussoc`x' wavey) (line bonusjobsoc`x' wavey) ///
	(line bonsharesoc`x' wavey) (line nonwhitesoc`x' wavey) ///
	(line unionsoc`x' wavey), title("Soc`x' trends bonus jobs") nodraw 
	graph save graphbonsoc`x', replace

	twoway (line perfsoc`x' wavey) (line perfjobsoc`x' wavey) ///
	(line bonsharesoc`x' wavey) (line nonwhitesoc`x' wavey) ///
	(line unionsoc`x' wavey), title("Sc`x' trends performance jobs") nodraw 
	graph save graphperfsoc`x', replace
	
	twoway (line bonamsoc`x' wavey), ///
	title("Soc`x' trends bonus amounts") nodraw 
	graph save bonamgraphsoc`x', replace
	
	twoway (line bonussoc`x' bonusjobsoc`x' adjustedsoc`x' wavey, ///
	lpattern(line line dash)), title("Soc`x' trend performance-pay jobs") ///
	legend(lab(1 "PP incidence") lab(2 "PP jobs incidence") ///
	lab(3 "PP endpoint corrected")) ylabel(0(0.2)0.8) scheme(s1mono)
	cd "/Users/pieterdevlieger/Desktop/plan B - wage inequality/latex-documents"
	graph export graphbonsoc`x'_UK.png, replace
	cd "/Users/pieterdevlieger/Desktop/plan B - wage inequality/BHPS/graphsoc"

	drop bonussoc`x' bonusjobsoc`x' perfsoc`x' perfjobsoc`x' bonamsoc`x' ///
	bonsharesoc`x' nonwhitesoc`x' cbasoc`x' unionsoc`x' adjustedsoc`x'
}

//---------------------------------------------------------------------------//
//----------------------------- Worker contract -----------------------------//
//---------------------------------------------------------------------------//

cd "/Users/pieterdevlieger/Desktop/plan B - wage inequality/BHPS"
*mkdir graphcontract
cd "/Users/pieterdevlieger/Desktop/plan B - wage inequality/BHPS/graphcontract"

// Permanent contract

by wave: egen bonusperm=mean(bonus) if permanent==1
by wave: egen bonusjobperm=mean(`bonusjob') if permanent==1
by wave: egen perfperm=mean(performance) if permanent==1
by wave: egen perfjobperm=mean(`perfjob') if permanent==1
by wave: egen bonamperm=mean(bonam) if permanent==1
by wave: egen bonshareperm=mean(bonsharel) if permanent==1
by wave: egen nonwhiteperm=mean(nonwhite) if permanent==1
by wave: egen cbaperm=mean(cba) if permanent==1
by wave: egen unionperm=mean(union) if permanent==1

twoway (line bonusperm wavey) (line bonusjobperm wavey) ///
(line bonshareperm wavey) (line nonwhiteperm wavey) ///
(line unionperm wavey), title("Permament contract: trends bonus jobs") nodraw 
graph save graphbonperm, replace

twoway (line perfperm wavey) (line perfjobperm wavey) ///
(line bonshareperm wavey) (line nonwhiteperm wavey) (line unionperm wavey), ///
title("Permament contract: trends permanent jobs") nodraw 
graph save graphperfperm, replace

twoway (line bonamperm wavey), ///
title("Permament contract: trends bonus amounts") nodraw 
graph save bonamperm, replace

drop bonusperm bonusjobperm perfperm perfjobperm ///
bonamperm bonshareperm nonwhiteperm cbaperm unionperm

// Temporary contract

by wave: egen bonusterm=mean(bonus) if permanent==0
by wave: egen bonusjobterm=mean(`bonusjob') if permanent==0
by wave: egen perfterm=mean(performance) if permanent==0
by wave: egen perfjobterm=mean(`perfjob') if permanent==0
by wave: egen bonamterm=mean(bonam) if permanent==0
by wave: egen bonshareterm=mean(bonsharel) if permanent==0
by wave: egen nonwhiteterm=mean(nonwhite) if permanent==0
by wave: egen cbaterm=mean(cba) if permanent==0
by wave: egen unionterm=mean(union) if permanent==0

twoway (line bonusterm wavey) (line bonusjobterm wavey) ///
(line bonshareterm wavey) (line nonwhiteterm wavey) (line unionterm wavey), ///
title("Temporary contract: trends bonus jobs") nodraw 
graph save graphbonterm, replace

twoway (line perfterm wavey) (line perfjobterm wavey) ///
(line bonshareterm wavey) (line nonwhiteterm wavey) (line unionterm wavey), ///
title("Temporary contract: trends performance jobs") nodraw 
graph save graphperfterm, replace

twoway (line bonamterm wavey), ///
title("Temporary contract: trends bonus amounts") nodraw 
graph save bonamterm, replace

drop bonusterm bonusjobterm perfterm perfjobterm bonamterm bonshareterm ///
nonwhiteterm cbaterm unionterm

//---------------------------------------------------------------------------//
//--------------------------------- Gender ----------------------------------//
//---------------------------------------------------------------------------//

cd "/Users/pieterdevlieger/Desktop/plan B - wage inequality/BHPS"
*mkdir graphgender
cd "/Users/pieterdevlieger/Desktop/plan B - wage inequality/BHPS/graphgender"

// work this out? need to redefine our database for this. preserve/restore!!!

//---------------------------------------------------------------------------//
//----------------------------- Kernel density ------------------------------//
//---------------------------------------------------------------------------//

// overall.

cd "/Users/pieterdevlieger/Desktop/plan B - wage inequality/BHPS"
*mkdir graphkernel
cd "/Users/pieterdevlieger/Desktop/plan B - wage inequality/BHPS/graphkernel"
*mkdir overall
cd "/Users/pieterdevlieger/Desktop/plan B - wage inequality/BHPS/graphkernel/overall"

kdensity lnhly if `bonusjob'==1, plot(kdensity lnhly if `bonusjob'==0) ///
legend(label(1 "Performance pay jobs") label(2 "Non-performance-pay jobs")) ///
title("Kernel density (by performance-pay jobs)") scheme(s1mono)
graph save kdensitylnhly, replace

cd "/Users/pieterdevlieger/Desktop/plan B - wage inequality/latex-documents"
graph export kdensitylnhly_UK.png, replace


*kdensity lnhybonus if bonusjob1==1, plot(kdensity lnhybonus if ///
*bonusjob1==0) legend(label(1 "Bonus jobs") label(2 "Non-bonus jobs")) ///
*title("Kernel density (by bonus jobs type 1)") nodraw
*graph save kdensitylnhybonus, replace

*kdensity lnhlybonus if bonusjob1==1, plot(kdensity lnhlybonus if ///
*bonusjob1==0) legend(label(1 "Bonus jobs") label(2 "Non-bonus jobs")) ///
*title("Kernel density (by bonus jobs type 1)") nodraw
*graph save kdensitylnhlybonus, replace

// getting rid of some outliers - trimming.

cd "/Users/pieterdevlieger/Desktop/plan B - wage inequality/BHPS/graphkernel"
*mkdir trimming
cd "/Users/pieterdevlieger/Desktop/plan B - wage inequality/BHPS/graphkernel/trimming"

*hy

preserve

drop if (hy<1 | hy>70)

kdensity lnhy if `bonusjob'==1, plot(kdensity lnhy if `bonusjob'==0) ///
legend(label(1 "Performance-pay jobs") label(2 "Non-performance-pay jobs")) ///
title("Kernel density (by performance-pay jobs, trimmed)") scheme(s1mono)
graph save kdensitylnhytrim, replace

cd "/Users/pieterdevlieger/Desktop/plan B - wage inequality/latex-documents"
graph export kdensitylnhlytrim_UK.png, replace
cd "/Users/pieterdevlieger/Desktop/plan B - wage inequality/BHPS/graphkernel/trimming"

restore

*hybonus

*preserve

*drop if (hybonus<1 | hybonus>70)

*kdensity lnhybonus if bonusjob1==1, ///
*plot(kdensity lnhybonus if bonusjob1==0) ///
*legend(label(1 "Bonus jobs") label(2 "Non-bonus jobs")) ///
*title("Kernel density (by bonus jobs type 1, trimmed)") nodraw
*graph save kdensitylnhybonustrim, replace

*restore

*hly

preserve

*drop if (hly<1 | hly>70)

kdensity lnhly if `bonusjob'==1, plot(kdensity lnhly if `bonusjob'==0) ///
legend(label(1 "Bonus jobs") label(2 "Non-bonus jobs")) ///
title("Kernel density (by bonus jobs type 1, trimmed)") nodraw scheme(s1mono)
graph save kdensitylnhlytrim, replace

restore

*hlybonus

*preserve
*
*drop if (hlybonus<1 | hlybonus>70)

*kdensity lnhlybonus if bonusjob1==1, ///
*plot(kdensity lnhlybonus if bonusjob1==0) ///
*legend(label(1 "Bonus jobs") label(2 "Non-bonus jobs")) ///
*title("Kernel density (by bonus jobs type 1, trimmed)") nodraw
*graph save kdensitylnhlybonustrim, replace

*restore

// getting rid of some outliers - winsorizing.

cd "/Users/pieterdevlieger/Desktop/plan B - wage inequality/BHPS/graphkernel"
*mkdir winsorizing
cd "/Users/pieterdevlieger/Desktop/plan B - wage inequality/BHPS/graphkernel/winsorizing"

*hy

winsor hy, gen(W1) p(0.01)
generate lnW1=ln(W1)
	label var W1 "Hourly earnings"

kdensity lnW1 if `bonusjob'==1, plot(kdensity lnW1 if `bonusjob'==0) ///
legend(label(1 "Performance-pay jobs") label(2 "Non-performance-pay jobs")) ///
title("Kernel density (by performance-pay jobs, winsorized)") ///
nodraw scheme(s1mono)
graph save kdensitylnhywinsor, replace

drop W1 lnW1

*hybonus

*winsor hybonus, gen(W2) p(0.01)
*generate lnW2=ln(W2)
*	label var W2 "Hourly earnings (including bonus)"

*kdensity lnW2 if bonusjob1==1, plot(kdensity lnW2 if bonusjob1==0) ///
*legend(label(1 "Bonus jobs") label(2 "Non-bonus jobs")) ///
*title("Kernel density (by bonus jobs type 1, winsorized)") nodraw
*graph save kdensitylnhybonuswinsor, replace

*drop W2 lnW2

*hly

winsor hly, gen(W3) p(0.01)
generate lnW3=ln(W3)
	label var W3 "Hourly labour earnings"

kdensity lnW3 if `bonusjob'==1, plot(kdensity lnW3 if `bonusjob'==0) ///
legend(label(1 "Bonus jobs") label(2 "Non-bonus jobs")) ///
title("Kernel density (by bonus jobs type 1, winsorized)") scheme(s1mono)
graph save kdensitylnhlywinsor, replace

cd "/Users/pieterdevlieger/Desktop/plan B - wage inequality/latex-documents"
graph export kdensitylnhlywinsor_UK.png, replace

drop W3 lnW3

*hlybonus

*winsor hlybonus, gen(W4) p(0.01)
*generate lnW4=ln(W4)
*	label var W4 "Hourly labour earnings (including bonus)"

*kdensity lnW4 if bonusjob1==1, plot(kdensity lnW4 if bonusjob1==0) ///
*legend(label(1 "Bonus jobs") label(2 "Non-bonus jobs")) ///
*title("Kernel density (by bonus jobs type 1, winsorized)") nodraw
*graph save kdensitylnhlybonuswinsor, replace

*drop W4 lnW4

*******************************************************************************
*******************************************************************************

*******************************************************************************
************************** Different specifications ***************************
*******************************************************************************

cd "/Users/pieterdevlieger/Desktop/plan B - wage inequality/BHPS/graphmean"
sort wave, stable
by wave: egen fifth=mean(`bonusjobfifth')
by wave: egen half=mean(`bonusjobhalf')

twoway (line bonusjobmean wavey) (line fifth wavey) (line half wavey), ///
title("different specifications") legend(lab(1 "Ever paid performance-pay") ///
lab(2 "At least 20% performance-pay") lab(3 "At least 50% performance-pay")) ///
ylabel(0(0.2)0.8) scheme(s1mono)
graph save diffspecs, replace
cd "/Users/pieterdevlieger/Desktop/plan B - wage inequality/latex-documents"
graph export diffspecs_UK.png, replace
cd "/Users/pieterdevlieger/Desktop/plan B - wage inequality/G-SOEP/endpoint"

sort pid wave, stable

*******************************************************************************
*******************************************************************************

//---------------------------------------------------------------------------//
//---------------------------- Change directory -----------------------------//
//---------------------------------------------------------------------------//

// Change directory to the original directory to avoid problems later on.

cd "/Users/pieterdevlieger/Desktop/plan B - wage inequality/BHPS"
