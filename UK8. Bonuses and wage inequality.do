*******************************************************************************
************************* Bonuses and wage inequality *************************
*******************************************************************************

local bonusjob "bonusjob"
local jobmatch "jobmatch"

//---------------------------------------------------------------------------//
//--------------------------- Grahpical evidence ----------------------------//
//---------------------------------------------------------------------------//

set more off
svyset [pweight = lrwght]
cd "/Users/pieterdevlieger/Desktop/plan B - wage inequality/BHPS"
*mkdir "wage inequality"
cd "/Users/pieterdevlieger/Desktop/plan B - wage inequality/BHPS/wage inequality"

// first a graph on the general trend of wage inequality
sort wave, stable
by wave: egen sdhly=sd(lnhly)

// We make the split, but without the MA-adjustment.

by wave: egen sdhlyb=sd(lnhly) if `bonusjob'==1
by wave: egen sdhlynb=sd(lnhly) if `bonusjob'==0

twoway (line sdhly sdhlyb sdhlynb wavey, lpattern(line dash dot)), ///
title("Wage inequality BHPS") ///
legend(lab(1 "All jobs") lab(2 "PP jobs") ///
lab(3 "Non-PP jobs")) scheme(s1mono)
graph save sd_hly, replace
cd "/Users/pieterdevlieger/Desktop/plan B - wage inequality/latex-documents"
graph export sd_hly_UK.png, replace
cd "/Users/pieterdevlieger/Desktop/plan B - wage inequality/BHPS/wage inequality"

// We weight the wages according to hours

egen mean_hrs=mean(hrswkd)
generate weight_occ=hrswkd/mean_hrs
generate hlyw = hly*weight_occ
generate lnhlyw = ln(hlyw)
drop mean_hrs weight_occ hlyw

sort wave, stable
by wave: egen sdhlyw=sd(lnhlyw)
by wave: egen sdhlywb=sd(lnhlyw) if `bonusjob'==1
by wave: egen sdhlywnb=sd(lnhlyw) if `bonusjob'==0

twoway (line sdhlyw sdhlywb sdhlywnb wavey, lpattern(line dash dot)), ///
title("Wage inequality BHPS") ///
legend(lab(1 "All jobs") lab(2 "PP jobs") ///
lab(3 "Non-PP jobs")) scheme(s1mono)
graph save sd_hlyw, replace
cd "/Users/pieterdevlieger/Desktop/plan B - wage inequality/latex-documents"
graph export sd_hlyw_UK.png, replace
cd "/Users/pieterdevlieger/Desktop/plan B - wage inequality/BHPS/wage inequality"

// Simple moving average model to get rid of some of the sampling noise

sort pid wave, stable
tsset pid wave
by pid: generate moveave1w=(F1.lnhlyw + lnhlyw + L1.lnhlyw) / 3
*by pid: generate moveave1w=(F2.lnhlyw + F1.lnhlyw + lnhlyw + L1.lnhlyw + L2.lnhlyw) / 5
*replace moveave1w=lnhlyw if moveave1==.
sort wave, stable
by wave: egen sdhly_ma1w=sd(moveave1w)
by wave: egen sdhly_b_ma1w=sd(moveave1w) if `bonusjob'==1
by wave: egen sdhly_nb_ma1w=sd(moveave1w) if `bonusjob'==0
twoway (line sdhly_ma1w sdhly_b_ma1w sdhly_nb_ma1w wavey, lpattern(line dash ///
dot)), title("Wage inequality BHPS - Moving average (panel)") ///
legend(lab(1 "All jobs") lab(2 "PP jobs") lab(3 "Non-PP jobs")) scheme(s1mono)
cd "/Users/pieterdevlieger/Desktop/plan B - wage inequality/latex-documents"
graph export sd_hlyw_ma_UK.png, replace
cd "/Users/pieterdevlieger/Desktop/plan B - wage inequality/BHPS/wage inequality"

// We set up a more extreme moving average model
//preserve
//sort wave, stable
//by wave: egen sdhly_m = mean(sdhly)
//by wave: egen sdhlyb_m = mean(sdhlyb)
//by wave: egen sdhlynb_m = mean(sdhlynb)
//by wave: keep if _n==1
//tsset wave
//generate moveave2=(F1.sdhly_m + sdhly_m + L1.sdhly_m)/3
//generate moveave2_b= (F1.sdhlyb_m + sdhlyb_m + L1.sdhlyb_m)/3
//generate moveave2_nb= (F1.sdhlynb_m + sdhlynb_m + L1.sdhlyb_m)/3
//twoway (line moveave2 moveave2_b wavey moveave2_nb wavey, lpattern(line ///
//dash dot)), title("Wage inequality BHPS - Moving average (wave)") ///
//legend(lab(1 "All jobs") lab(2 "PP jobs") ///
//lab(3 "Non-PP jobs")) scheme(s1mono)
//graph save sd_hly_ma2, replace
//cd "/Users/pieterdevlieger/Desktop/plan B - wage inequality/latex-documents"
//graph export sd_hly_ma2_UK.png, replace
//cd "/Users/pieterdevlieger/Desktop/plan B - wage inequality/BHPS/wage inequality"

//restore
//sort pid wave, stable

kdensity lnhly if `bonusjob'==1 & ME==1, plot(kdensity lnhly if ///
bonusjob1==1 & ME==6) legend(label(1 "PP jobs 1991-1993") ///
label(2 "PP jobs 2005-2008")) ///
title("Change in distribution (PP jobs)") scheme(s1mono)
graph save kdensitylnhly, replace
cd "/Users/pieterdevlieger/Desktop/plan B - wage inequality/latex-documents"
graph export kernel_pp_change_UK.png, replace
cd "/Users/pieterdevlieger/Desktop/plan B - wage inequality/BHPS/wage inequality"

kdensity lnhly if `bonusjob'==0 & ME==1, plot(kdensity lnhly if ///
`bonusjob'==0 & ME==6) legend(label(1 "Non-PP jobs 1991-1993") ///
label(2 "Non-PP jobs 2005-2008")) ///
title("Change in distribution (Non-PP jobs)") scheme(s1mono)
graph save kdensitylnhly, replace
cd "/Users/pieterdevlieger/Desktop/plan B - wage inequality/latex-documents"
graph export kernel_npp_change_UK.png, replace
cd "/Users/pieterdevlieger/Desktop/plan B - wage inequality/BHPS/wage inequality"

//---------------------------------------------------------------------------//
//------------------------- Decomposition results ---------------------------//
//---------------------------------------------------------------------------//

cd "/Users/pieterdevlieger/Desktop/plan B - wage inequality/BHPS/wage inequality"

generate Q12xexp=Q12*exp1
generate Q3xexp=Q3*exp1
generate Q4xexp=Q4*exp1
generate Q5xexp=Q5*exp1
generate Q6xexp=Q6*exp1
generate Q7xexp=Q7*exp1
generate Q12xnw=Q12*nonwhite
generate Q3xnw=Q3*nonwhite
generate Q4xnw=Q4*nonwhite
generate Q5xnw=Q5*nonwhite
generate Q6xnw=Q6*nonwhite
generate Q7xnw=Q7*nonwhite
generate expxnw=exp1*nonwhite

use BHPS, clear
sum lnhly if bonusjob==0, detail
generate xstep=(r(max)-r(min))/1000
gen kwage=r(min)+[_n-1]*xstep if _n<=1000
kdensity lnhly [aweight=hrswkd] if bonusjob==0 & ME==1, at(kwage) gauss ///
width(0.065) nograph generate(nw1 nfd1) 
kdensity lnhly [aweight=hrswkd] if bonusjob==1  & ME==1, at(kwage) gauss ///
width(0.065) nograph generate(w1 fd1) 
kdensity lnhly [aweight=hrswkd] if bonusjob==0 & ME==5, at(kwage) gauss ///
width(0.065) nograph generate(nw5 nfd5) 
kdensity lnhly [aweight=hrswkd] if bonusjob==1  & ME==5, at(kwage) gauss ///
width(0.065) nograph generate(w5 fd5) 
kdensity lnhly [aweight=hrswkd] if bonusjob==0 & ME==6, at(kwage) gauss ///
width(0.065) nograph generate(nw6 nfd6) 
kdensity lnhly [aweight=hrswkd] if bonusjob==1  & ME==6, at(kwage) gauss ///
width(0.065) nograph generate(w6 fd6) 
graph twoway (connected fd1 kwage, msymbol(i) clwidth(medium)  ) ///
      (connected nfd1 kwage, msymbol(i) lpattern(dash) clwidth(medium) ), ///
      scheme(sj)
graph twoway (connected fd5 kwage, msymbol(i) clwidth(medium)  ) ///
      (connected nfd5 kwage, msymbol(i) lpattern(dash) clwidth(medium) ), ///
      scheme(sj)
graph twoway (connected fd6 kwage, msymbol(i) clwidth(medium)  ) ///
      (connected nfd6 kwage, msymbol(i) lpattern(dash) clwidth(medium) ), ///
      scheme(sj)
drop xstep kwage

save BHPS, replace
use BHPS, clear
keep if ME==6
save BHPS_6, replace
use BHPS, clear
keep if ME==1
save BHPS_1, replace
use BHPS, clear
keep if ME==5
save BHPS_5, replace
use BHPS, clear
keep if wave==7 | wave==6 | wave==5
save BHPS_1adj, replace
use BHPS, clear
keep if wave==13 | wave==14 | wave==15
save BHPS_6adj, replace

use BHPS_1, clear
set more off
sum lnhly if bonusjob==0, detail
generate xstep=(r(max)-r(min))/200
gen kwage=r(min)+[_n-1]*xstep if _n<=200

gen hweight=hrswkd
kdensity lnhly [aweight=hrswkd] if bonusjob==0 , at(kwage) gauss ///
width(0.065) nograph generate(w88 fd88) 
kdensity lnhly [aweight=hrswkd] if bonusjob==1 , at(kwage) gauss ///
width(0.065) nograph generate(w79 fd79) 
graph twoway (connected fd88 kwage if kwage>=0 & kwage<=4, msymbol(i) clwidth(medium)  ) ///
      (connected fd79 kwage if kwage>=0 & kwage<=4, msymbol(i) lpattern(dash) clwidth(medium) ), ///
      scheme(sj) saving(dflfig4a,replace)


//***************************************************************************//
local xlist1 "Q12 Q3 Q4 Q5 Q6 exp1 exp12 nonwhite married cba union tenure tenure2 sic1 sic2 sic3 sic4 sic5 sic6 sic7 sic8 sic9 soc2 soc3 soc4 soc5 soc6 soc7 soc8 soc9 i.wave i.region"
local xlist4 "Q12xexp Q3xexp Q4xexp Q5xexp Q6xexp Q7xexp Q12xnw Q3xnw Q4xnw Q5xnw Q6xnw Q7xnw expxnw"

probit bonusjob `xlist1' `xlist4', vce(cluster jobmatch)
predict prob_pp, p
sum prob_pp, detail
estat classification
replace prob_pp=0.01 if prob_pp<0.01
egen p_bonusjob = mean(bonusjob)
sum p_bonusjob
gen weight = (p_bonusjob/(1-prob_pp)) if bonusjob==0
generate weight2=weight
replace weight2=1 if bonusjob==1
replace weight=weight*hweight
replace weight2=weight2*hrswkd
generate weight3=1/weight2
//***************************************************************************//

kdensity lnhly [aweight=hweight], at(kwage) ///
	generate(xly kdly) nograph
kdensity lnhly [aweight=weight] if bonusjob==0, at(kwage) ///
	generate(xlyw kdlyw) nograph width(0.100)
graph twoway (connected kdly xly, msymbol(i) clwidth(medium) ) ///
      (connected kdlyw xlyw, msymbol(i) lpattern(dash) clwidth(medium) ), ///
      scheme(sj) saving(dflfig4a,replace)
 
	
//kdensity lnhly [aweight=weight] if bonusjob==0, lpattern(dash) plot(kdensity lnhly [aweight=hweight])
//sum lnhly [aweight=weight] if bonusjob==0, detail
//sum lnhly [aweight=hweight], detail
quietly {
integ kdly xly, generate(cint)
integ kdlyw xlyw, generate(cintw)
}

gen nw_smooth_junk=.
foreach x in 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 ///
25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 ///
50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 65 66 67 68 69 70 71 72 73 74 ///
75 76 77 78 79 80 81 82 83 84 85 86 87 88 89 90 91 92 93 94 95 96 97 98 99 {
	gen cent`x'=xly if cint>=0.`x' & cint[_n-1]<0.`x' & cint!=.
	quietly sum cent`x'
	replace nw_smooth_junk=r(mean) if _n==`x'
	drop cent`x'
}
generate nw_smooth = (nw_smooth_junk[_n-2] + nw_smooth_junk[_n-1] + ///
nw_smooth_junk + nw_smooth_junk[_n+1] + nw_smooth_junk[_n+2])/5
replace nw_smooth = (nw_smooth_junk[_n-2] + nw_smooth_junk[_n-1] + ///
nw_smooth_junk + nw_smooth_junk[_n+1])/4 if _n==98
replace nw_smooth = (nw_smooth_junk[_n-2] + nw_smooth_junk[_n-1] + ///
nw_smooth_junk)/3 if _n==99

gen w_smooth_junk=.
foreach x in 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 ///
25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 ///
50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 65 66 67 68 69 70 71 72 73 74 ///
75 76 77 78 79 80 81 82 83 84 85 86 87 88 89 90 91 92 93 94 95 96 97 98 99 {
	gen cent`x'=xly if cintw>=0.`x' & cintw[_n-1]<0.`x' & cintw!=.
	quietly sum cent`x'
	replace w_smooth_junk=r(mean) if _n==`x'
	drop cent`x'
}
generate w_smooth = (w_smooth_junk[_n-2] + w_smooth_junk[_n-1] + ///
w_smooth_junk + w_smooth_junk[_n+1] + w_smooth_junk[_n+2])/5
replace w_smooth = (w_smooth_junk[_n-2] + w_smooth_junk[_n-1] + ///
w_smooth_junk + w_smooth_junk[_n+1])/4 if _n==98
replace w_smooth = (w_smooth_junk[_n-2] + w_smooth_junk[_n-1] + ///
w_smooth_junk)/3 if _n==99

quietly{
foreach x in 10 50 75 90 99 {
quietly sum nw_smooth, detail
gen nw_`x'= r(p`x')
quietly sum w_smooth, detail
gen w_`x'= r(p`x')
gen diff_`x'= w_`x'-nw_`x'
}
sum nw_smooth, detail
gen nw_var = r(Var)
sum w_smooth, detail
gen w_var = r(Var)
}
kdensity nw_smooth_junk, plot(kdensity w_smooth_junk)

display "unadjusted 10     " nw_10 
display "adjusted 10     " w_10
display "diff 10     " diff_10
display "unadjusted 50     " nw_50 
display "adjusted 50     " w_50
display "diff 50     " diff_50
display "unadjusted 75     " nw_75
display "adjusted 75     " w_75
display "diff 75     " diff_75
display "unadjusted 90     " nw_90 
display "adjusted 90     " w_90
display "diff 90     " diff_90
display "unadjusted 99     " nw_99 
display "adjusted 99     " w_99
display "diff 99     " diff_99
display "unadjusted var     " nw_var
display "adjusted var     " w_var

generate diff_1 = nw_smooth - w_smooth
generate diff_2 = kdlyw - kdly

graph twoway (connected diff_1 kwage, symbol(i) clwidth(medium)), scheme(sj)
graph save effect_period1_UK, replace
cd "/Users/pieterdevlieger/Desktop/plan B - wage inequality/latex-documents"
graph export effect_period1_UK.png, replace
cd "/Users/pieterdevlieger/Desktop/plan B - wage inequality/BHPS/wage inequality"
graph twoway (connected diff_2 kwage, symbol(i) clwidth(medium)), scheme(sj)

save BHPS_1, replace

use BHPS_6, clear
set more off
sum lnhly if bonusjob==0, detail
generate xstep=(r(max)-r(min))/200
gen kwage=r(min)+[_n-1]*xstep if _n<=200

gen hweight=hrswkd
kdensity lnhly [aweight=hrswkd] if bonusjob==0 , at(kwage) gauss ///
width(0.065) nograph generate(w88 fd88) 
kdensity lnhly [aweight=hrswkd] if bonusjob==1 , at(kwage) gauss ///
width(0.065) nograph generate(w79 fd79) 
graph twoway (connected fd88 kwage if kwage>=0 & kwage<=4, msymbol(i) clwidth(medium)  ) ///
      (connected fd79 kwage if kwage>=0 & kwage<=4, msymbol(i) lpattern(dash) clwidth(medium) ), ///
      scheme(sj) saving(dflfig4a,replace)


//***************************************************************************//
local xlist1 "Q12 Q3 Q4 Q5 Q6 exp1 exp12 nonwhite married cba union tenure tenure2 sic1 sic2 sic3 sic4 sic5 sic6 sic7 sic8 sic9 soc2 soc3 soc4 soc5 soc6 soc7 soc8 soc9 i.wave i.region"
local xlist4 "Q12xexp Q3xexp Q4xexp Q5xexp Q6xexp Q7xexp Q12xnw Q3xnw Q4xnw Q5xnw Q6xnw Q7xnw expxnw"

probit bonusjob `xlist1' `xlist4', vce(cluster jobmatch)
predict prob_pp, p
sum prob_pp, detail
estat classification
replace prob_pp=0.01 if prob_pp<0.01
egen p_bonusjob = mean(bonusjob)
sum p_bonusjob
gen weight = (p_bonusjob/(1-prob_pp)) if bonusjob==0
generate weight2=weight
replace weight2=1 if bonusjob==1
replace weight=weight*hweight
replace weight2=weight2*hrswkd
generate weight3=1/weight2
//***************************************************************************//

kdensity lnhly [aweight=hweight], at(kwage) ///
	generate(xly kdly) nograph
kdensity lnhly [aweight=weight] if bonusjob==0, at(kwage) ///
	generate(xlyw kdlyw) nograph
graph twoway (connected kdly xly, msymbol(i) clwidth(medium) ) ///
      (connected kdlyw xlyw, msymbol(i) lpattern(dash) clwidth(medium) ), ///
      scheme(sj) saving(dflfig4a,replace)
 
	
//kdensity lnhly [aweight=weight] if bonusjob==0, lpattern(dash) plot(kdensity lnhly [aweight=hweight])
//sum lnhly [aweight=weight] if bonusjob==0, detail
//sum lnhly [aweight=hweight], detail
quietly {
integ kdly xly, generate(cint)
integ kdlyw xlyw, generate(cintw)
}

gen nw_smooth_junk=.
foreach x in 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 ///
25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 ///
50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 65 66 67 68 69 70 71 72 73 74 ///
75 76 77 78 79 80 81 82 83 84 85 86 87 88 89 90 91 92 93 94 95 96 97 98 99 {
	gen cent`x'=xly if cint>=0.`x' & cint[_n-1]<0.`x' & cint!=.
	quietly sum cent`x'
	replace nw_smooth_junk=r(mean) if _n==`x'
	drop cent`x'
}
generate nw_smooth = (nw_smooth_junk[_n-2] + nw_smooth_junk[_n-1] + ///
nw_smooth_junk + nw_smooth_junk[_n+1] + nw_smooth_junk[_n+2])/5
replace nw_smooth = (nw_smooth_junk[_n-2] + nw_smooth_junk[_n-1] + ///
nw_smooth_junk + nw_smooth_junk[_n+1])/4 if _n==98
replace nw_smooth = (nw_smooth_junk[_n-2] + nw_smooth_junk[_n-1] + ///
nw_smooth_junk)/3 if _n==99

gen w_smooth_junk=.
foreach x in 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 ///
25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 ///
50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 65 66 67 68 69 70 71 72 73 74 ///
75 76 77 78 79 80 81 82 83 84 85 86 87 88 89 90 91 92 93 94 95 96 97 98 99 {
	gen cent`x'=xly if cintw>=0.`x' & cintw[_n-1]<0.`x' & cintw!=.
	quietly sum cent`x'
	replace w_smooth_junk=r(mean) if _n==`x'
	drop cent`x'
}
generate w_smooth = (w_smooth_junk[_n-2] + w_smooth_junk[_n-1] + ///
w_smooth_junk + w_smooth_junk[_n+1] + w_smooth_junk[_n+2])/5
replace w_smooth = (w_smooth_junk[_n-2] + w_smooth_junk[_n-1] + ///
w_smooth_junk + w_smooth_junk[_n+1])/4 if _n==98
replace w_smooth = (w_smooth_junk[_n-2] + w_smooth_junk[_n-1] + ///
w_smooth_junk)/3 if _n==99

quietly{
foreach x in 10 50 75 90 99 {
quietly sum nw_smooth_junk, detail
gen nw_`x'= r(p`x')
quietly sum w_smooth_junk, detail
gen w_`x'= r(p`x')
gen diff_`x'= w_`x'-nw_`x'
}
sum nw_smooth_junk, detail
gen nw_var = r(Var)
sum w_smooth_junk, detail
gen w_var = r(Var)
}
kdensity nw_smooth_junk, plot(kdensity w_smooth_junk)

display "unadjusted 10     " nw_10 
display "adjusted 10     " w_10
display "diff 10     " diff_10
display "unadjusted 50     " nw_50 
display "adjusted 50     " w_50
display "diff 50     " diff_50
display "unadjusted 75     " nw_75
display "adjusted 75     " w_75
display "diff 75     " diff_75
display "unadjusted 90     " nw_90 
display "adjusted 90     " w_90
display "diff 90     " diff_90
display "unadjusted 99     " nw_99 
display "adjusted 99     " w_99
display "diff 99     " diff_99
display "unadjusted var     " nw_var
display "adjusted var     " w_var


generate diff_1 = nw_smooth - w_smooth
generate diff_2 = kdlyw - kdly

graph twoway (connected diff_1 kwage, symbol(i) clwidth(medium)), scheme(sj)
graph twoway (connected diff_2 kwage, symbol(i) clwidth(medium)), scheme(sj)
save BHPS_6, replace

//---------------------------------------------------------------------------//
//-------------------------- Decomposition results --------------------------//
//----------------------------------- IRF -----------------------------------//
//---------------------------------------------------------------------------//

//foreach x in 10 50 75 90 99 {
//	gen rif_`x'=.
//	rifreg lnhly jobmatch persnr if bonusjob==0 [aweight=weight2], q(0.`x') re(rif_`x'm)
//	replace rif_`x'=rif_`x'm if bonusjob==0
//	rifreg lnhly jobmatch persnr if bonusjob==1 [aweight=hrs_annual], q(0.`x') re(rif_`x'f)
//	replace rif_`x'=rif_`x'f if bonusjob==1
//	oaxaca rif_`x' jobmatch persnr, by(bonusjob) weight(1) detail
//	drop rif_10 rif_10f rif_10m
//}

foreach x in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 {
	generate wave`x'=wave==`x'
}
foreach x in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 {
	generate region`x'=region==`x'
}

//--------------------------------- Period 1 ---------------------------------//

use BHPS_1, clear
local xlist1 "Q12 Q3 Q4 Q5 Q6 exp1 exp12 nonwhite cba union married tenure tenure2 sic1 sic2 sic3 sic4 sic5 sic6 sic7 sic8 sic9 soc1 soc2 soc3 soc4 soc5 soc6 soc7 soc8 soc9"
local xlist4 "Q12xexp Q3xexp Q4xexp Q5xexp Q6xexp Q7xexp Q12xnw Q3xnw Q4xnw Q5xnw Q6xnw Q7xnw expxnw"
foreach x in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 {
	generate region`x'=region==`x'
}
generate wave2=wave==2
generate wave3=wave==3

gen rif_var=.
rifreg lnhly `xlist1' `xlist4' wave2 wave3 region2 region3 region4 region5 ///
region6 region7 region8 region9 region10 region11 region12 region13 region14 ///
region15 region16 if bonusjob==0 [aweight=hrswkd], variance re(rif_varnb)
replace rif_var=rif_varnb if bonusjob==0
rifreg lnhly `xlist1' `xlist4' wave2 wave3 region2 region3 region4 region5 ///
region6 region7 region8 region9 region10 region11 region12 region13 region14 ///
region15 region16 if bonusjob==1 [aweight=hrswkd], variance re(rif_varb)
replace rif_var=rif_varb if bonusjob==1
oaxaca rif_var `xlist1' `xlist4' wave2 wave3 region2 region3 region4 region5 ///
region6 region7 region8 region9 region10 region11 region12 region13 region14 ///
region15 region16, by(bonusjob) weight(1) swap

save BHPS_1, replace
keep if bonusjob==0
replace bonusjob=2
save temp1, replace
use BHPS_1, clear
append using temp1
gen wgt = weight if bonusjob==2
replace wgt = hrswkd if bonusjob==1 | bonusjob==0
local xlist1 "Q12 Q3 Q4 Q5 Q6 exp1 exp12 nonwhite cba union married tenure tenure2 sic1 sic2 sic3 sic4 sic5 sic6 sic7 sic8 sic9 soc1 soc2 soc3 soc4 soc5 soc6 soc7 soc8 soc9"
local xlist4 "Q12xexp Q3xexp Q4xexp Q5xexp Q6xexp Q7xexp Q12xnw Q3xnw Q4xnw Q5xnw Q6xnw Q7xnw expxnw"

oaxaca rif_var `xlist1' `xlist4' wave2 wave3 region2 region3 region4 ///
region5 region6 region7 region8 region9 region10 region11 region12 region13 ///
region14 region15 region16 [aweight=wgt] if bonusjob==0 | bonusjob==2, ///
by(bonusjob) weight(1) swap detail

oaxaca rif_var `xlist1' `xlist4' wave2 wave3 region2 region3 region4 ///
region5 region6 region7 region8 region9 region10 region11 region12 region13 ///
region14 region15 region16 [aweight=wgt] if bonusjob==1 | bonusjob==2, ///
by(bonusjob) weight(0) detail

save BHPS_1, replace

//--------------------------------- Period 6 ---------------------------------//

use BHPS_6, clear
local xlist1 "Q12 Q3 Q4 Q5 Q6 exp1 exp12 nonwhite cba union married tenure tenure2 sic1 sic2 sic3 sic4 sic5 sic6 sic7 sic8 sic9 soc1 soc2 soc3 soc4 soc5 soc6 soc7 soc8 soc9"
local xlist4 "Q12xexp Q3xexp Q4xexp Q5xexp Q6xexp Q7xexp Q12xnw Q3xnw Q4xnw Q5xnw Q6xnw Q7xnw expxnw"
foreach x in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 {
	generate region`x'=region==`x'
}
generate wave18=wave==18
generate wave17=wave==17

gen rif_var=.
rifreg lnhly `xlist1' `xlist4' wave17 wave18 region2 region3 region4 region5 ///
region6 region7 region8 region9 region10 region11 region12 region13 region14 ///
region15 region16 if bonusjob==0 [aweight=hrswkd], variance re(rif_varnb)
replace rif_var=rif_varnb if bonusjob==0
rifreg lnhly `xlist1' `xlist4' wave17 wave18 region2 region3 region4 region5 ///
region6 region7 region8 region9 region10 region11 region12 region13 region14 ///
region15 region16 if bonusjob==1 [aweight=hrswkd], variance re(rif_varb)
replace rif_var=rif_varb if bonusjob==1
oaxaca rif_var `xlist1' `xlist4' wave18 wave17 region2 region3 region4 ///
region5 region6 region7 region8 region9 region10 region11 region12 region13 ///
region14 region15 region16, by(bonusjob) weight(1) swap

save BHPS_6, replace
keep if bonusjob==0
replace bonusjob=2
save temp6, replace
use BHPS_6, clear
append using temp6
gen wgt = weight if bonusjob==2
replace wgt = hrswkd if bonusjob==1 | bonusjob==0
local xlist1 "Q12 Q3 Q4 Q5 Q6 exp1 exp12 nonwhite cba union married tenure tenure2 sic1 sic2 sic3 sic4 sic5 sic6 sic7 sic8 sic9 soc1 soc2 soc3 soc4 soc5 soc6 soc7 soc8 soc9"
local xlist4 "Q12xexp Q3xexp Q4xexp Q5xexp Q6xexp Q7xexp Q12xnw Q3xnw Q4xnw Q5xnw Q6xnw Q7xnw expxnw"

oaxaca rif_var `xlist1' `xlist4' wave18 wave17 region2 region3 region4 ///
region5 region6 region7 region8 region9 region10 region11 region12 region13 ///
region14 region15 region16 [aweight=wgt] if bonusjob==0 | bonusjob==2, ///
by(bonusjob) weight(1) swap


oaxaca rif_var `xlist1' `xlist4' wave18 wave17 region2 region3 region4 ///
region5 region6 region7 region8 region9 region10 region11 region12 region13 ///
region14 region15 region16 [aweight=wgt] if bonusjob==1 | bonusjob==2, ///
by(bonusjob) weight(0)

save BHPS_6, replace





* probit for bonusjobeffect


keep if ME==1
save SOEP_1, replace
keep if bonusjob==0
replace bonusjob=2
save SOEP_temp, replace
use SOEP_1, clear
append using SOEP_temp


set more off
local xlist1 "university technical vocational exp exp2 exp3 exp4 exp5 eu married tenure tenure2 tenure3 tenure4 tenure5 sic1 sic2 sic3 sic4 sic5 sic6 sic7 sic8 sic9 soc1 soc2 soc3 soc4 soc5 soc6 soc7 soc8 soc9 i.wave i.region"
local xlist4 "unixexp techxexp vocxexp unixeu techxeu vocxeu expxeu"
local xlist11 "yeq exp exp2 exp3 exp4 exp5 eu married tenure tenure2 tenure3 tenure4 tenure5 sic1 sic2 sic3 sic4 sic5 sic6 sic7 sic8 sic9 soc1 soc2 soc3 soc4 soc5 soc6 soc7 soc8 soc9 i.wave i.region"
local xlist41 "yeqxexp yeqxeu expxeu"

logit bonusjob `xlist1' `xlist4' if (bonusjob==0 | bonusjob==1), ///
vce(cluster jobmatch)
predict prob_pp, p

*replace prob_pp=0.99 if prob_pp>0.99 & bonusjob!=0

























*******************************************************************************
*******************************************************************************



