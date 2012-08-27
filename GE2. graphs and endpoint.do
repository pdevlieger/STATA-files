*******************************************************************************
*********************** Dealing with endpoint problems ************************
*******************************************************************************

set more off

cd "/Users/pieterdevlieger/Desktop/plan B - wage inequality/G-SOEP"
*mkdir endpoint
cd "/Users/pieterdevlieger/Desktop/plan B - wage inequality/G-SOEP/endpoint"

kdensity duration, plot(kdensity duration if wave>10 & wave<20) ///
	legend(label(1 "Non-adjusted distribution") ///
	label(2 "Adjusted distribution")) scheme(s1mono)
graph save kernel_endpoint_test, replace
cd "/Users/pieterdevlieger/Desktop/plan B - wage inequality/latex-documents"
graph export durationdiff_endpoint_GE.png, replace
cd "/Users/pieterdevlieger/Desktop/plan B - wage inequality/G-SOEP/endpoint"

// ksmirnov separately => you can test equality: is rejected!

egen mean_post_1 = mean(duration) if wave>4 & wave<23
egen mean_post = mean(mean_post_1)
drop mean_post_1

quietly reg bonusjob duration i.wave
predict prob_job
generate adjusted = prob_job - _b[duration]*duration + _b[duration]*mean_post
label var adjusted "PP incidence (adjusted for endpoint problems)"
drop prob_job mean_post

sort wave, stable
by wave: egen adjustedmean=mean(adjusted)
by wave: egen bonusjobmean=mean(bonusjob)

twoway (line bonusjobmean adjustedmean wavey, lpattern(line dash)), ///
title("Adjustment for endpoints") legend(lab(1 "Unadjusted PP incidence") ///
lab(2 "Adjusted PP jobs incidence")) ylabel(0(0.2)0.8) scheme(s1mono)
graph save adjusted_endpoint, replace
cd "/Users/pieterdevlieger/Desktop/plan B - wage inequality/latex-documents"
graph export adjusted_endpoint_GE.png, replace
cd "/Users/pieterdevlieger/Desktop/plan B - wage inequality/G-SOEP/endpoint"

*******************************************************************************
*******************************************************************************


*******************************************************************************
********************* Graphs by different characteristics *********************
*******************************************************************************

//---------------------------------------------------------------------------//
//--------------------------------- Overall ---------------------------------//
//---------------------------------------------------------------------------//

cd "/Users/pieterdevlieger/Desktop/plan B - wage inequality/G-SOEP"
*mkdir graphmean
cd "/Users/pieterdevlieger/Desktop/plan B - wage inequality/G-SOEP/graphmean"

by wave: egen bonusmean=mean(bonus)
by wave: egen bonammean=mean(bonam)
by wave: egen bonsharemean=mean(bonusshare)
by wave: egen eumean=mean(eu)
by wave: egen bonussharemean=mean(bonusshare)

twoway (line bonusmean wavey) (line bonusjobmean wavey) ///
(line adjustedmean wavey, lpattern(dash)), ///
title("Overall trend performance-pay jobs") ///
legend(lab(1 "PP incidence") ///
lab(2 "PP jobs incidence") ///
lab(3 "PP endpoint corrected")) ylabel(0(0.2)0.8) scheme(s1mono)
graph save graphbonmean, replace
cd "/Users/pieterdevlieger/Desktop/plan B - wage inequality/latex-documents"
graph export graphbonmean_GE.png, replace
cd "/Users/pieterdevlieger/Desktop/plan B - wage inequality/G-SOEP/graphmean"

twoway (line bonammean wavey), title("Overall trend PP amount") ///
legend(lab(1 "PP amount")) scheme(s1mono)
graph save graphbonammean, replace
cd "/Users/pieterdevlieger/Desktop/plan B - wage inequality/latex-documents"
graph export bonusam_GE.png, replace
cd "/Users/pieterdevlieger/Desktop/plan B - wage inequality/G-SOEP/graphmean"

twoway (line bonussharemean wavey), title("Overall trend PP share") ///
legend(lab(1 "PP share")) scheme(s1mono)
graph save graphbonussharemean, replace
cd "/Users/pieterdevlieger/Desktop/plan B - wage inequality/latex-documents"
graph export bonusshare_GE.png, replace
cd "/Users/pieterdevlieger/Desktop/plan B - wage inequality/G-SOEP"


//---------------------------------------------------------------------------//
//-------------------------------- Industry ---------------------------------//
//---------------------------------------------------------------------------//

cd "/Users/pieterdevlieger/Desktop/plan B - wage inequality/G-SOEP"
*mkdir graphsic
cd "/Users/pieterdevlieger/Desktop/plan B - wage inequality/G-SOEP/graphsic"

foreach x in 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 {

	egen mean_pre_sic`x' = mean(duration) if sic`x'==1
	egen mean_post_1sic`x' = mean(duration) if wave>4 & wave<23 & sic`x'==1
	egen mean_post_sic`x' = mean(mean_post_1)
	drop mean_post_1sic`x'

	quietly reg bonusjob duration i.wave if sic`x'==1
	predict prob_job_sic`x'
	generate adjusted_sic`x' = prob_job_sic`x' - _b[duration]*duration + ///
	_b[duration]*mean_post_sic`x'
	label var adjusted_sic`x' "Bonus incidence SIC`x' (endpoint corrected)"
	drop prob_job_sic`x' mean_post_sic`x' mean_pre_sic`x'

	by wave: egen bonussic`x'=mean(bonus) if sic`x'==1
	by wave: egen bonusjobsic`x'=mean(bonusjob) if sic`x'==1
	by wave: egen bonamsic`x'=mean(bonam) if sic`x'==1
	by wave: egen bonsharesic`x'=mean(bonusshare) if sic`x'==1
	by wave: egen eusic`x'=mean(eu) if sic`x'==1
	by wave: egen adjustedsic`x'=mean(adjusted_sic`x') if sic`x'==1
	
	twoway (line bonussic`x' bonusjobsic`x' bonsharesic`x' eusic`x' wavey), ///
	title("Sic`x' trends bonus jobs") nodraw 
	graph save graphbonsic`x', replace

	twoway (line bonamsic`x' wavey), ///
	title("Sic`x' trends bonus amounts") nodraw 
	graph save bonamgraphsic`x', replace	
	
	twoway (line bonussic`x' bonusjobsic`x' adjustedsic`x' wavey, ///
	lpattern(line line dash)), title("Sic`x' trend performance-pay jobs") ///
	legend(lab(1 "PP incidence") lab(2 "PP jobs incidence") ///
	lab(3 "PP endpoint corrected")) ylabel(0(0.2)0.8) scheme(s1mono)
	cd "/Users/pieterdevlieger/Desktop/plan B - wage inequality/latex-documents"
	graph export graphbonsic`x'_GE.png, replace
	cd "/Users/pieterdevlieger/Desktop/plan B - wage inequality/G-SOEP/graphsic"

	drop bonussic`x' bonusjobsic`x' bonamsic`x' bonsharesic`x' eusic`x' ///
	adjustedsic`x'
}

//---------------------------------------------------------------------------//
//------------------------------- Occupation --------------------------------//
//---------------------------------------------------------------------------//

cd "/Users/pieterdevlieger/Desktop/plan B - wage inequality/G-SOEP"
*mkdir graphsoc
cd "/Users/pieterdevlieger/Desktop/plan B - wage inequality/G-SOEP/graphsoc"

foreach x in 0 1 2 3 4 5 6 7 8 9 {
	egen mean_pre_soc`x' = mean(duration) if soc`x'==1
	egen mean_post_1soc`x' = mean(duration) if wave>4 & wave<23 & soc`x'==1
	egen mean_post_soc`x' = mean(mean_post_1)
	drop mean_post_1soc`x'

	quietly reg bonusjob duration i.wave if soc`x'==1
	predict prob_job_soc`x'
	generate adjusted_soc`x' = prob_job_soc`x' - _b[duration]*duration + ///
	_b[duration]*mean_post_soc`x'
	label var adjusted_soc`x' "Bonus incidence SOC`x' (endpoint corrected)"
	drop prob_job_soc`x' mean_post_soc`x' mean_pre_soc`x'

	by wave: egen bonussoc`x'=mean(bonus) if soc`x'==1
	by wave: egen bonusjobsoc`x'=mean(bonusjob) if soc`x'==1
	by wave: egen bonamsoc`x'=mean(bonam) if soc`x'==1
	by wave: egen bonsharesoc`x'=mean(bonusshare) if soc`x'==1
	by wave: egen eusoc`x'=mean(eu) if soc`x'==1
	by wave: egen adjustedsoc`x'=mean(adjusted_soc`x') if soc`x'==1
	
	twoway (line bonussoc`x' wavey) (line bonusjobsoc`x' wavey) ///
	(line bonsharesoc`x' wavey) (line eusoc`x' wavey), ///
	title("Sic`x' trends bonus jobs") nodraw 
	graph save graphbonsoc`x', replace

	twoway (line bonamsoc`x' wavey), ///
	title("Soc`x' trends bonus amounts") nodraw 
	graph save bonamgraphsoc`x', replace	
	
	twoway (line bonussoc`x' bonusjobsoc`x' adjustedsoc`x' wavey, ///
	lpattern(line line dash)), title("Soc`x' trend performance-pay jobs") ///
	legend(lab(1 "PP incidence") lab(2 "PP jobs incidence") ///
	lab(3 "PP endpoint corrected")) ylabel(0(0.2)0.8) scheme(s1mono)
	cd "/Users/pieterdevlieger/Desktop/plan B - wage inequality/latex-documents"
	graph export graphbonsoc`x'_GE.png, replace
	cd "/Users/pieterdevlieger/Desktop/plan B - wage inequality/G-SOEP/graphsoc"

	drop bonussoc`x' bonusjobsoc`x' bonamsoc`x' bonsharesoc`x' eusoc`x' ///
	adjustedsoc`x'
}

//---------------------------------------------------------------------------//
//----------------------------- Worker contract -----------------------------//
//---------------------------------------------------------------------------//

cd "/Users/pieterdevlieger/Desktop/plan B - wage inequality/G-SOEP"
*mkdir graphcontract
cd "/Users/pieterdevlieger/Desktop/plan B - wage inequality/G-SOEP/graphcontract"

// Permanent contract

by wave: egen bonusperm=mean(bonus) if temp==0
by wave: egen bonusjobperm=mean(bonusjob) if temp==0
by wave: egen bonamperm=mean(bonam) if temp==0
by wave: egen bonshareperm=mean(bonusshare) if temp==0
by wave: egen euperm=mean(eu) if temp==0

twoway (line bonusperm wavey) (line bonusjobperm wavey) ///
(line bonshareperm wavey) (line euperm wavey), ///
title("Permament contract: trends bonus jobs") nodraw 
graph save graphbonperm, replace

twoway (line bonamperm wavey), ///
title("Permament contract: trends bonus amounts") nodraw 
graph save bonamperm, replace

drop bonusperm bonusjobperm bonamperm bonshareperm euperm

// Temporary contract

by wave: egen bonustemp=mean(bonus) if temp==1
by wave: egen bonusjobtemp=mean(bonusjob) if temp==1
by wave: egen bonamtemp=mean(bonam) if temp==1
by wave: egen bonsharetemp=mean(bonusshare) if temp==1
by wave: egen eutemp=mean(eu) if temp==1

twoway (line bonustemp wavey) (line bonusjobtemp wavey) ///
(line bonsharetemp wavey) (line eutemp wavey), ///
title("Temporary contract: trends bonus jobs") nodraw 
graph save graphbontemp, replace

twoway (line bonamtemp wavey), ///
title("Temporary contract: trends bonus amounts") nodraw 
graph save bonamtemp, replace

drop bonustemp bonusjobtemp bonamtemp bonsharetemp eutemp

//---------------------------------------------------------------------------//
//--------------------------------- Gender ----------------------------------//
//---------------------------------------------------------------------------//

*cd "/Users/pieterdevlieger/Desktop/plan B - wage inequality/BHPS"
*mkdir graphgender
*cd "/Users/pieterdevlieger/Desktop/plan B - wage inequality/BHPS/graphgender"

// work this out? need to redefine our database for this. preserve/restore!!!

//---------------------------------------------------------------------------//
//----------------------------- Kernel density ------------------------------//
//---------------------------------------------------------------------------//

// overall.

cd "/Users/pieterdevlieger/Desktop/plan B - wage inequality/G-SOEP"
*mkdir graphkernel
cd "/Users/pieterdevlieger/Desktop/plan B - wage inequality/G-SOEP/graphkernel"
*mkdir overall
cd "/Users/pieterdevlieger/Desktop/plan B - wage inequality/G-SOEP/graphkernel/overall"

kdensity lnhly if bonusjob==1, plot(kdensity lnhly if bonusjob==0) ///
legend(label(1 "Performance-pay jobs") ///
label(2 "Non-performance-pay jobs")) ///
title("Kernel density (by performance-pay jobs)") scheme(s1mono)
graph save kdensitylnhly, replace

cd "/Users/pieterdevlieger/Desktop/plan B - wage inequality/latex-documents"
graph export kdensitylnhly_GE.png, replace

cd "/Users/pieterdevlieger/Desktop/plan B - wage inequality/G-SOEP"

// getting rid of some outliers - trimming.

cd "/Users/pieterdevlieger/Desktop/plan B - wage inequality/G-SOEP/graphkernel"
*mkdir trimming
cd "/Users/pieterdevlieger/Desktop/plan B - wage inequality/G-SOEP/graphkernel/trimming"

preserve

drop if (hly<3 | hly>40)

kdensity lnhly if bonusjob==1, plot(kdensity lnhly if bonusjob==0) ///
legend(label(1 "Performance-pay jobs") label(2 "Non-performance-pay jobs")) ///
title("Kernel density (by performance-pay jobs, trimmed)") scheme(s1mono)
graph save kdensitylnhlytrim, replace

cd "/Users/pieterdevlieger/Desktop/plan B - wage inequality/latex-documents"
graph export kdensitylnhlytrim_GE.png, replace

restore

// getting rid of some outliers - winsorizing.

cd "/Users/pieterdevlieger/Desktop/plan B - wage inequality/G-SOEP/graphkernel"
*mkdir winsorizing
cd "/Users/pieterdevlieger/Desktop/plan B - wage inequality/G-SOEP/graphkernel/winsorizing"

winsor hly, gen(W1) p(0.01)
generate lnW1=ln(W1)
	label var W1 "Hourly earnings (winsorized)"

kdensity lnW1 if bonusjob==1, plot(kdensity lnW1 if bonusjob==0) ///
legend(label(1 "Performance-pay jobs") label(2 "Non-performance-pay jobs")) ///
title("Kernel density (by performance-pay jobs, winsorized)") scheme(s1mono)
graph save kdensitylnhlywinsor, replace

cd "/Users/pieterdevlieger/Desktop/plan B - wage inequality/latex-documents"
graph export kdensitylnhlywinsor_GE.png, replace

drop W1 lnW1

*******************************************************************************
*******************************************************************************

*******************************************************************************
************************** Different specifications ***************************
*******************************************************************************

cd "/Users/pieterdevlieger/Desktop/plan B - wage inequality/G-SOEP/graphmean"

sort wave, stable
by wave: egen fifth=mean(bonusjobfifth)
by wave: egen half=mean(bonusjobhalf)

twoway (line bonusjobmean wavey) (line fifth wavey) (line half wavey) ///
, title("different specifications") ///
legend(lab(1 "Ever paid performance-pay") ///
lab(2 "At least 20% performance-pay") ///
lab(3 "At least 50% performance-pay")) ylabel(0(0.2)0.8) scheme(s1mono)
graph save diffspecs, replace
cd "/Users/pieterdevlieger/Desktop/plan B - wage inequality/latex-documents"
graph export diffspecs_GE.png, replace
cd "/Users/pieterdevlieger/Desktop/plan B - wage inequality/G-SOEP/endpoint"

sort persnr wave, stable

*******************************************************************************
*******************************************************************************

//---------------------------------------------------------------------------//
//---------------------------- Change directory -----------------------------//
//---------------------------------------------------------------------------//

// Change directory to the original directory to avoid problems later on.

cd "/Users/pieterdevlieger/Desktop/plan B - wage inequality/G-SOEP"


