*******************************************************************************
************************* Bonuses and wage inequality *************************
*******************************************************************************

//---------------------------------------------------------------------------//
//--------------------------- Grahpical evidence ----------------------------//
//---------------------------------------------------------------------------//

set more off
cd "/Users/pieterdevlieger/Desktop/plan B - wage inequality/G-SOEP"
*mkdir "wage inequality"
cd "/Users/pieterdevlieger/Desktop/plan B - wage inequality/G-SOEP/wage inequality"

// first a graph on the general trend of wage inequality

sort wave, stable
by wave: egen sdhly=sd(lnhly)
// We make the split, but without the MA-adjustment.

by wave: egen sdhlyb=sd(lnhly) if bonusjob==1
by wave: egen sdhlynb=sd(lnhly) if bonusjob==0

twoway (line sdhly sdhlyb sdhlynb wavey, lpattern(line dash dot)), ///
title("Wage inequality SOEP") ///
legend(lab(1 "All jobs") ///
lab(2 "PP jobs") ///
lab(3 "Non-PP jobs")) scheme(s1mono)
graph save sd_hly, replace
cd "/Users/pieterdevlieger/Desktop/plan B - wage inequality/latex-documents"
graph export sd_hly_GE.png, replace
cd "/Users/pieterdevlieger/Desktop/plan B - wage inequality/G-SOEP/wage inequality"

// We weight the wages according to hours

egen mean_hrs=mean(hrs_annual)
generate weight_occ=hrs_annual/mean_hrs
generate hlyw = hly*weight_occ
generate lnhlyw = ln(hlyw)
drop mean_hrs weight_occ hlyw

sort wave, stable
by wave: egen sdhlyw=sd(lnhlyw)
by wave: egen sdhlywb=sd(lnhlyw) if bonusjob==1
by wave: egen sdhlywnb=sd(lnhlyw) if bonusjob==0

twoway (line sdhlyw sdhlywb sdhlywnb wavey, lpattern(line dash dot)), ///
title("Wage inequality SOEP (weighted for annual hours)") ///
legend(lab(1 "All jobs") lab(2 "PP jobs") ///
lab(3 "Non-PP jobs")) scheme(s1mono)
graph save sd_hlyw, replace
cd "/Users/pieterdevlieger/Desktop/plan B - wage inequality/latex-documents"
graph export sd_hlyw_GE.png, replace
cd "/Users/pieterdevlieger/Desktop/plan B - wage inequality/G-SOEP/wage inequality"


// We set up a simple moving average model to get rid of some of the sampling
// noise
preserve
sort persnr wave, stable
tsset persnr wave
by persnr: generate moveave1w=(F2.lnhlyw + F1.lnhlyw + lnhlyw + L1.lnhlyw + L2.lnhlyw)/5
sort wave, stable
by wave: egen sdhlyw_ma1=sd(moveave1w)
by wave: egen sdhlyw_b_ma1=sd(moveave1w) if bonusjob==1
by wave: egen sdhlyw_nb_ma1=sd(moveave1w) if bonusjob==0
twoway (line sdhlyw_ma1 sdhlyw_b_ma1 sdhlyw_nb_ma1 wavey, lpattern(line dash ///
dot)), title("Wage inequality SOEP - Moving average (panel)") ///
legend(lab(1 "All jobs") lab(2 "PP jobs") ///
lab(3 "Non-PP jobs")) scheme(s1mono)
graph save sd_hly_ma1, replace
cd "/Users/pieterdevlieger/Desktop/plan B - wage inequality/latex-documents"
graph export sd_hlyw_ma1_GE.png, replace
cd "/Users/pieterdevlieger/Desktop/plan B - wage inequality/G-SOEP/wage inequality"
restore
// We set up a more extreme moving average model

preserve
sort wave, stable
by wave: egen sdhly_m = mean(sdhly)
by wave: egen sdhlyb_m = mean(sdhlyb)
by wave: egen sdhlynb_m = mean(sdhlynb)
by wave: keep if _n==1
tsset wave
generate moveave2=(F1.sdhly_m + sdhly_m + L1.sdhly_m)/3
generate moveave2_b= (F1.sdhlyb_m + sdhlyb_m + L1.sdhlyb_m)/3
generate moveave2_nb= (F1.sdhlynb_m + sdhlynb_m + L1.sdhlyb_m)/3
twoway (line moveave2 moveave2_b wavey moveave2_nb wavey, lpattern(line ///
dash dot)), title("Wage inequality SOEP - Moving average (wave)") ///
legend(lab(1 "All jobs") lab(2 "PP jobs") ///
lab(3 "Non-PP jobs")) scheme(s1mono)
graph save sd_hly_ma2, replace
cd "/Users/pieterdevlieger/Desktop/plan B - wage inequality/latex-documents"
graph export sd_hly_ma2_GE.png, replace
cd "/Users/pieterdevlieger/Desktop/plan B - wage inequality/G-SOEP/wage inequality"

restore
sort persnr wave, stable
save SOEP, replace

//---------------------------------------------------------------------------//
//-------------------------- Decomposition results --------------------------//
//------------------------------- Reweighting -------------------------------//
//---------------------------------------------------------------------------//

cd "/Users/pieterdevlieger/Desktop/plan B - wage inequality/G-SOEP/wage inequality"


generate unixexp=university*exp
generate techxexp=technical*exp
generate vocxexp=vocational*exp
generate yeqxexp=yeq*exp
generate unixeu=university*eu
generate techxeu=technical*eu
generate vocxeu=vocational*eu
generate yeqxeu=yeq*eu
generate expxeu=exp*eu
save SOEP, replace
use SOEP, clear
sum lnhly if bonusjob==0, detail
generate xstep=(r(max)-r(min))/200
gen kwage=r(min)+[_n-1]*xstep if _n<=200
kdensity lnhly [aweight=hrs_annual] if bonusjob==0 & ME==1, at(kwage) gauss ///
width(0.065) nograph generate(nw1 nfd1) 
kdensity lnhly [aweight=hrs_annual] if bonusjob==1  & ME==1, at(kwage) gauss ///
width(0.065) nograph generate(w1 fd1) 
kdensity lnhly [aweight=hrs_annual] if bonusjob==0 & ME==7, at(kwage) gauss ///
width(0.065) nograph generate(nw7 nfd7) 
kdensity lnhly [aweight=hrs_annual] if bonusjob==1  & ME==7, at(kwage) gauss ///
width(0.065) nograph generate(w7 fd7) 
kdensity lnhly [aweight=hrs_annual] if bonusjob==0 & ME==8, at(kwage) gauss ///
width(0.065) nograph generate(nw8 nfd8) 
kdensity lnhly [aweight=hrs_annual] if bonusjob==1  & ME==8, at(kwage) gauss ///
width(0.065) nograph generate(w8 fd8) 
graph twoway (connected fd1 kwage, msymbol(i) clwidth(medium)  ) ///
      (connected nfd1 kwage, msymbol(i) lpattern(dash) clwidth(medium) ), ///
      scheme(sj)
graph twoway (connected fd7 kwage, msymbol(i) clwidth(medium)  ) ///
      (connected nfd7 kwage, msymbol(i) lpattern(dash) clwidth(medium) ), ///
      scheme(sj)
graph twoway (connected fd8 kwage, msymbol(i) clwidth(medium)  ) ///
      (connected nfd8 kwage, msymbol(i) lpattern(dash) clwidth(medium) ), ///
      scheme(sj)
drop xstep kwage

save SOEP, replace
use SOEP, clear
keep if ME==8
save SOEP_8, replace
use SOEP, clear
keep if ME==1
save SOEP_1, replace
use SOEP, clear
keep if ME==7
save SOEP_7, replace
use SOEP, clear
keep if ME==6
save SOEP_6, replace
use SOEP, clear
keep if ME==5
save SOEP_5, replace
use SOEP, clear
keep if wave==22 | wave==24 | wave==23
save SOEP_8adj, replace
use SOEP, clear
keep if wave==21
save SOEP_test, replace



use SOEP_1, clear
set more off
sum lnhly if bonusjob==0, detail
generate xstep=(r(max)-r(min))/200
gen kwage=r(min)+[_n-1]*xstep if _n<=200

gen hweight=hrs_annual
kdensity lnhly [aweight=hrs_annual] if bonusjob==0 , at(kwage) gauss ///
width(0.065) nograph generate(w88 fd88) 
kdensity lnhly [aweight=hrs_annual] if bonusjob==1 , at(kwage) gauss ///
width(0.065) nograph generate(w79 fd79) 
graph twoway (connected fd88 kwage, msymbol(i) clwidth(medium)  ) ///
      (connected fd79 kwage, msymbol(i) lpattern(dash) clwidth(medium) ), ///
      scheme(sj) saving(dflfig4a,replace)


//***************************************************************************//
local xlist1 "university technical vocational exp exp2 exp3 exp4 exp5 eu married tenure tenure2 tenure3 tenure4 tenure5 i.sic i.soc i.wave i.region"
local xlist4 "unixexp techxexp vocxexp unixeu techxeu vocxeu expxeu"

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
replace weight=weight*hrs_annual
replace weight2=weight2*hrs_annual
generate weight3=1/weight2
//***************************************************************************//

kdensity lnhly [aweight=hrs_annual], at(kwage) ///
	generate(xly kdly) nograph
kdensity lnhly [aweight=weight], ///
	generate(xlyw kdlyw) nograph at(kwage)
graph twoway (connected kdly xly, msymbol(i) clwidth(medium) ) ///
      (connected kdlyw xlyw, msymbol(i) lpattern(dash) clwidth(medium) ), ///
      scheme(sj) saving(dflfig4a,replace) 

quietly {
integ kdly xly, generate(cint)
integ kdlyw xlyw, generate(cintw)
}

local xlist1 "university technical vocational exp exp2 exp3 exp4 exp5 eu married tenure tenure2 tenure3 tenure4 tenure5 i.sic i.soc i.wave i.region"
local xlist4 "unixexp techxexp vocxexp unixeu techxeu vocxeu expxeu"

reg lnhly `xlist1' `xlist4' if bonusjob==1, vce(cluster jobmatch)
predict var1_pp
gen var1_ppr = lnhly-var1_pp

xtmixed lnhly `xlist1' `xlist4' if bonusjob==1 & wave<4, variance mle
xtmixed lnhly if bonusjob==1 & wave<4 || var1_pp:, variance mle

xtmixed lnhly `xlist1' `xlist4' if bonusjob==0 & wave<4, variance mle


reg lnhly `xlist1' `xlist4' if bonusjob==1, vce(cluster jobmatch)
predict var1_pp
gen var1_ppr = lnhly-var1_pp
reg lnhly `xlist1' `xlist4' if bonusjob==0, vce(cluster jobmatch)
predict var1_npp
gen var1_nppr = lnhly-var1_npp





gen nw_smooth_junk=.
foreach x in 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20 21 ///
22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 ///
47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 65 66 67 68 69 70 71 ///
72 73 74 75 76 77 78 79 80 81 82 83 84 85 86 87 88 89 90 91 92 93 94 95 96 ///
97 98 99 {
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
foreach x in 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20 21 ///
22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 ///
47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 65 66 67 68 69 70 71 ///
72 73 74 75 76 77 78 79 80 81 82 83 84 85 86 87 88 89 90 91 92 93 94 95 96 ///
97 98 99 {
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
gen w_97_junk = w_smooth if _n==97
gen nw_97_junk = nw_smooth if _n==97
egen w_97 = mean(w_97_junk)
egen nw_97 = mean(nw_97_junk)
gen w_999_junk = w_smooth_junk if _n==999
gen nw_999_junk = nw_smooth_junk if _n==999
egen w_999 = mean(w_999_junk)
egen nw_999 = mean(nw_999_junk)


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
display "unadjusted 97     " nw_97
display "adjusted 97     " w_97
display "unadjusted 999     " nw_999
display "adjusted 999     " w_999
display "unadjusted var     " nw_var
display "adjusted var     " w_var

generate diff_1 = nw_smooth - w_smooth
generate diff_2 = kdlyw - kdly

graph twoway (connected diff_1 kwage, symbol(i) clwidth(medium)), scheme(sj)
graph save effect_period1_GE, replace
cd "/Users/pieterdevlieger/Desktop/plan B - wage inequality/latex-documents"
graph export effect_period1_GE.png, replace
cd "/Users/pieterdevlieger/Desktop/plan B - wage inequality/G-SOEP/wage inequality"
graph twoway (connected diff_2 kwage, symbol(i) clwidth(medium)), scheme(sj)

save SOEP_1, replace

use SOEP_8adj, clear
set more off
sum lnhly if bonusjob==0, detail
generate xstep=(r(max)-r(min))/200
gen kwage=r(min)+[_n-1]*xstep if _n<=200

gen hweight=hrs_annual
kdensity lnhly [aweight=hrs_annual] if bonusjob==0 , at(kwage) gauss ///
width(0.065) nograph generate(w88 fd88) 
kdensity lnhly [aweight=hrs_annual] if bonusjob==1 , at(kwage) gauss ///
width(0.065) nograph generate(w79 fd79) 
graph twoway (connected fd88 kwage, msymbol(i) clwidth(medium)  ) ///
      (connected fd79 kwage, msymbol(i) lpattern(dash) clwidth(medium) ), ///
      scheme(sj) saving(dflfig4a,replace)


//***************************************************************************//
local xlist1 "university technical vocational exp exp2 exp3 exp4 exp5 eu married tenure tenure2 tenure3 tenure4 tenure5 i.sic i.soc i.wave i.region"
local xlist4 "unixexp techxexp vocxexp unixeu techxeu vocxeu expxeu"

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
replace weight=weight*hrs_annual
replace weight2=weight2*hrs_annual
generate weight3=1/weight2
//***************************************************************************//

kdensity lnhly [aweight=hrs_annual], at(kwage) ///
	generate(xly kdly) nograph
kdensity lnhly [aweight=weight], ///
	generate(xlyw kdlyw) nograph at(kwage)
graph twoway (connected kdly xly, msymbol(i) clwidth(medium) ) ///
      (connected kdlyw xlyw, msymbol(i) lpattern(dash) clwidth(medium) ), ///
      scheme(sj) saving(dflfig4a,replace) 

quietly {
integ kdly xly, generate(cint)
integ kdlyw xlyw, generate(cintw)
}

gen nw_smooth_junk=.
foreach x in 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20 21 ///
22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 ///
47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 65 66 67 68 69 70 71 ///
72 73 74 75 76 77 78 79 80 81 82 83 84 85 86 87 88 89 90 91 92 93 94 95 96 ///
97 98 99 999 {
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
foreach x in 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20 21 ///
22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 ///
47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 65 66 67 68 69 70 71 ///
72 73 74 75 76 77 78 79 80 81 82 83 84 85 86 87 88 89 90 91 92 93 94 95 96 ///
97 98 99 999 {
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
gen w_97_junk = w_smooth if _n==97
gen nw_97_junk = nw_smooth if _n==97
egen w_97 = mean(w_97_junk)
egen nw_97 = mean(nw_97_junk)
gen w_999_junk = w_smooth_junk if _n==999
gen nw_999_junk = nw_smooth_junk if _n==999
egen w_999 = mean(w_999_junk)
egen nw_999 = mean(nw_999_junk)


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
display "unadjusted 97     " nw_97
display "adjusted 97     " w_97
display "unadjusted 999     " nw_999
display "adjusted 999     " w_999
display "unadjusted var     " nw_var
display "adjusted var     " w_var

generate diff_1 = nw_smooth - w_smooth
generate diff_2 = kdlyw - kdly

graph twoway (connected diff_1 kwage, symbol(i) clwidth(medium)), scheme(sj)
graph save effect_period8_GE, replace
cd "/Users/pieterdevlieger/Desktop/plan B - wage inequality/latex-documents"
graph export effect_period8_GE.png, replace
cd "/Users/pieterdevlieger/Desktop/plan B - wage inequality/G-SOEP/wage inequality"
graph twoway (connected diff_2 kwage, symbol(i) clwidth(medium)), scheme(sj)

save SOEP_8adj, replace

//---------------------------------------------------------------------------//
//-------------------------- Decomposition results --------------------------//
//----------------------------------- IRF -----------------------------------//
//---------------------------------------------------------------------------//

foreach x in 10 50 75 90 99 {
	gen rif_`x'=.
	rifreg lnhly jobmatch persnr if bonusjob==0 [aweight=weight2], q(0.`x') re(rif_`x'm)
	replace rif_`x'=rif_`x'm if bonusjob==0
	rifreg lnhly jobmatch persnr if bonusjob==1 [aweight=hrs_annual], q(0.`x') re(rif_`x'f)
	replace rif_`x'=rif_`x'f if bonusjob==1
	oaxaca rif_`x' jobmatch persnr, by(bonusjob) weight(1) detail
*	drop rif_10 rif_10f rif_10m
}

foreach x in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 {
	generate wave`x'=wave==`x'
}
foreach x in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 {
	generate region`x'=region==`x'
}

local xlist1 "university technical vocational exp exp2 eu married tenure tenure2 i.sic i.soc"
local xlist4 "unixexp techxexp vocxexp unixeu techxeu vocxeu expxeu"
local xlist5 "wave24 wave25 wave26 region2 region3 region4 region5 region6 region7 region8 region9 region10 region11 region12 region13 region14 region15 region16"




use SOEP_1, clear
keep if bonusjob==0
replace bonusjob=2
save temp_1, replace
use SOEP_1, clear
append using temp_1
codebook bonusjob
gen phix = (p_bonusjob/(1-prob_pp)) if bonusjob==2
replace phix=1 if bonusjob==0


foreach x in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 {
	generate region`x'=region==`x'
}
generate wave2=wave==2
generate wave3=wave==3
generate rif_var=.

use SOEP_8adj, clear

quietly{
foreach x in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 {
	generate region`x'=region==`x'
}

generate wave24=wave==24
generate wave23=wave==23
generate rif_var=.

rifreg lnhly university technical vocational exp exp2 eu married tenure ///
tenure2 wave23 wave24 region2 region3 region4 region5 region6 region7 region8 ///
region9 region10 region11 region12 region13 region14 region15 region16 sic1 ///
sic2 sic3 sic4 sic5 sic6 sic7 sic8 sic9 sic10 sic11 sic12 sic13 sic14 sic15 ///
sic16 soc1 soc2 soc3 soc4 soc5 soc6 soc7 soc8 soc9 if bonusjob==0 ////
[aweight=hrs_annual], variance re(rif_varnb)

rifreg lnhly university technical vocational exp exp2 eu married tenure ///
tenure2 wave23 wave24 region2 region3 region4 region5 region6 region7 region8 ///
region9 region10 region11 region12 region13 region14 region15 region16 sic1 ///
sic2 sic3 sic4 sic5 sic6 sic7 sic8 sic9 sic10 sic11 sic12 sic13 sic14 sic15 ///
sic16 soc1 soc2 soc3 soc4 soc5 soc6 soc7 soc8 soc9 if bonusjob==1 ////
[aweight=hrs_annual], variance re(rif_varb)

replace rif_var = rif_varnb if bonusjob==0
replace rif_var = rif_varb if bonusjob==1

}

oaxaca rif_var university technical vocational exp exp2 eu married tenure ///
tenure2 wave23 wave24 region2 region3 region4 region5 region6 region7 region8 ///
region9 region10 region11 region12 region13 region14 region15 region16 sic1 ///
sic2 sic3 sic4 sic5 sic6 sic7 sic8 sic9 sic10 sic11 sic12 sic13 sic14 sic15 ///
sic16 soc1 soc2 soc3 soc4 soc5 soc6 soc7 soc8 soc9, by(bonusjob) weight(1) swap









oaxaca rif_var university technical vocational exp exp2 eu married tenure ///
tenure2 wave2 wave3 region2 region3 region4 region5 region6 region7 region8 ///
region9 region10 region11 region12 region13 region14 region15 region16 sic1 ///
sic2 sic3 sic4 sic5 sic6 sic7 sic8 sic9 sic10 sic11 sic12 sic13 sic14 sic15 ///
sic16 soc1 soc2 soc3 soc4 soc5 soc6 soc7 soc8 soc9 [aweight=phix] if ///
bonusjob==0 | bonusjob==2, by(bonusjob) weight(1) detail(groupemp: ///
university technical vocational exp exp2 eu married tenure tenure2, ///
groupjob: region2 region3 region4 region5 region6 region7 region8 region9 ///
region10 region11 region12 region13 region14 region15 region16 sic1 sic2 ///
sic3 sic4 sic5 sic6 sic7 sic8 sic9 sic10 sic11 sic12 sic13 sic14 sic15 ///
sic16 soc1 soc2 soc3 soc4 soc5 soc6 soc7 soc8 soc9, grouptime: wave2 wave3) ///
swap


oaxaca rif_var university technical vocational exp exp2 eu married tenure ///
tenure2 wave2 wave3 region2 region3 region4 region5 region6 region7 region8 ///
region9 region10 region11 region12 region13 region14 region15 region16 sic1 ///
sic2 sic3 sic4 sic5 sic6 sic7 sic8 sic9 sic10 sic11 sic12 sic13 sic14 sic15 ///
sic16 soc1 soc2 soc3 soc4 soc5 soc6 soc7 soc8 soc9, by(bonusjob) weight(0) ///
detail(groupemp: university technical vocational exp exp2 eu married tenure ///
tenure2, groupjob: region2 region3 region4 region5 region6 region7 region8 ///
region9 region10 region11 region12 region13 region14 region15 region16 sic1 ///
sic2 sic3 sic4 sic5 sic6 sic7 sic8 sic9 sic10 sic11 sic12 sic13 sic14 sic15 ///
sic16 soc1 soc2 soc3 soc4 soc5 soc6 soc7 soc8 soc9, grouptime: wave2 wave3) swap

quietly{
generate rif_varw=.
rifreg lnhly university technical vocational exp exp2 eu married tenure ///
tenure2 wave2 wave3 region2 region3 region4 region5 region6 region7 region8 ///
region9 region10 region11 region12 region13 region14 region15 region16 sic1 ///
sic2 sic3 sic4 sic5 sic6 sic7 sic8 sic9 sic10 sic11 sic12 sic13 sic14 sic15 ///
sic16 soc1 soc2 soc3 soc4 soc5 soc6 soc7 soc8 soc9 if bonusjob==0 ////
[aweight=hrs_annual], variance re(rif_varwnb)
rifreg lnhly university technical vocational exp exp2 eu married tenure ///
tenure2 wave2 wave3 region2 region3 region4 region5 region6 region7 region8 ///
region9 region10 region11 region12 region13 region14 region15 region16 sic1 ///
sic2 sic3 sic4 sic5 sic6 sic7 sic8 sic9 sic10 sic11 sic12 sic13 sic14 sic15 ///
sic16 soc1 soc2 soc3 soc4 soc5 soc6 soc7 soc8 soc9 if bonusjob==1 ////
[aweight=hrs_annual], variance re(rif_varwb)
replace rif_varw=rif_varwb if bonusjob==1
replace rif_varw=rif_varwnb if bonusjob==0
}

oaxaca rif_varw university technical vocational exp exp2 eu married tenure ///
tenure2 wave2 wave3 region2 region3 region4 region5 region6 region7 region8 ///
region9 region10 region11 region12 region13 region14 region15 region16 sic1 ///
sic2 sic3 sic4 sic5 sic6 sic7 sic8 sic9 sic10 sic11 sic12 sic13 sic14 sic15 ///
sic16 soc1 soc2 soc3 soc4 soc5 soc6 soc7 soc8 soc9, by(bonusjob) weight(0) ///
detail(groupemp: university technical vocational exp exp2 eu married tenure ///
tenure2, groupjob: region2 region3 region4 region5 region6 region7 region8 ///
region9 region10 region11 region12 region13 region14 region15 region16 sic1 ///
sic2 sic3 sic4 sic5 sic6 sic7 sic8 sic9 sic10 sic11 sic12 sic13 sic14 sic15 ///
sic16 soc1 soc2 soc3 soc4 soc5 soc6 soc7 soc8 soc9, grouptime: wave2 wave3)swap
















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
quietly sum bonusjob if bonusjob<2
gen p_bonusjob = r(mean)

gen weight = (prob_pp)/(1-prob_pp)*((1-p_bonusjob)/p_bonusjob) if ///
bonusjob==2

kdensity lnhly if bonusjob==0, plot(kdensity lnhly if bonusjob==1, n(200) || ///
kdensity lnhly if bonusjob==2 [aweight=weight], n(200))

quietly sum lnhly if bonusjob==0, detail
gen p99n = r(p99)
gen p90n = r(p90)
gen p75n = r(p75)
gen p50n = r(p50)
gen p10n = r(p10)
gen pmeann = r(mean)
gen pvarn = r(Var)
quietly sum lnhly if bonusjob==1, detail
gen p99b = r(p99)
gen p90b = r(p90)
gen p75b = r(p75)
gen p50b = r(p50)
gen p10b = r(p10)
gen pmeanb = r(mean)
gen pvarb = r(Var)
quietly sum lnhly if bonusjob==2 [aweight=weight], detail
gen p99nb = r(p99)
gen p90nb = r(p90)
gen p75nb = r(p75)
gen p50nb = r(p50)
gen p10nb = r(p10)
gen pmeannb = r(mean)
gen pvarnb = r(Var)

foreach stat in var mean 10 50 75 90 99 {
	gen delta = p`stat'n - p`stat'nb
	di "The unadjusted `stat'" " = " p`stat'n
	di "The adjusted `stat'" " = " p`stat'nb
	di "The difference" "=" delta
	drop delta
}

save SOEP_1, replace
use SOEP
keep if ME==8
save SOEP_8, replace
keep if bonusjob==0
replace bonusjob=2
save SOEP_temp, replace
use SOEP_8, clear
append using SOEP_temp

generate unixexp=university*exp
generate techxexp=technical*exp
generate vocxexp=vocational*exp
generate yeqxexp=yeq*exp
generate unixeu=university*eu
generate techxeu=technical*eu
generate vocxeu=vocational*eu
generate yeqxeu=yeq*eu
generate expxeu=exp*eu

set more off
local xlist1 "university technical vocational exp exp2 exp3 exp4 exp5 eu married tenure tenure2 tenure3 tenure4 tenure5 sic1 sic2 sic3 sic4 sic5 sic6 sic7 sic8 sic9 soc1 soc2 soc3 soc4 soc5 soc6 soc7 soc8 soc9 i.wave i.region"
local xlist4 "unixexp techxexp vocxexp unixeu techxeu vocxeu expxeu"
local xlist11 "yeq exp exp2 exp3 exp4 exp5 eu married tenure tenure2 tenure3 tenure4 tenure5 sic1 sic2 sic3 sic4 sic5 sic6 sic7 sic8 sic9 soc1 soc2 soc3 soc4 soc5 soc6 soc7 soc8 soc9 i.wave i.region"
local xlist41 "yeqxexp yeqxeu expxeu"

logit bonusjob `xlist1' `xlist4' if (bonusjob==0 | bonusjob==1), ///
vce(cluster jobmatch)
predict prob_pp, p

*replace prob_pp=0.99 if prob_pp>0.99 & bonusjob!=0
quietly sum bonusjob if bonusjob<2
gen p_bonusjob = r(mean)

gen weight = (prob_pp)/(1-prob_pp)*((1-p_bonusjob)/p_bonusjob) if ///
bonusjob==2

kdensity lnhly if bonusjob==0, plot(kdensity lnhly if bonusjob==1, n(200) || ///
kdensity lnhly if bonusjob==2 [aweight=weight], n(200))

quietly sum lnhly if bonusjob==0, detail
gen p99n = r(p99)
gen p90n = r(p90)
gen p75n = r(p75)
gen p50n = r(p50)
gen p10n = r(p10)
gen pmeann = r(mean)
gen pvarn = r(Var)
quietly sum lnhly if bonusjob==1, detail
gen p99b = r(p99)
gen p90b = r(p90)
gen p75b = r(p75)
gen p50b = r(p50)
gen p10b = r(p10)
gen pmeanb = r(mean)
gen pvarb = r(Var)
quietly sum lnhly if bonusjob==2 [aweight=weight], detail
gen p99nb = r(p99)
gen p90nb = r(p90)
gen p75nb = r(p75)
gen p50nb = r(p50)
gen p10nb = r(p10)
gen pmeannb = r(mean)
gen pvarnb = r(Var)

foreach stat in var mean 10 50 75 90 99 {
	gen delta = p`stat'n - p`stat'nb
	di "The unadjusted `stat'" " = " p`stat'n
	di "The adjusted `stat'" " = " p`stat'nb
	di "The difference" "=" delta
	drop delta
}




































local xlist1 "yeq Q12 Q3 Q4 Q5 Q6 exp1 exp12 exp13 exp14 exp15 nonwhite married cba union tenure tenure2 tenure3 tenure4 tenure5 sic1 sic2 sic3 sic4 sic5 sic6 sic7 sic8 sic9 soc1 soc2 soc3 soc4 soc5 soc6 soc7 soc8 soc9 i.wave i.region"
local xlist4 "Q12xexp Q3xexp Q4xexp Q5xexp Q6xexp Q7xexp Q12xnw Q3xnw Q4xnw Q5xnw Q6xnw Q7xnw expxnw"
local xlist11 "yeq exp exp2 exp3 exp4 exp5 eu married tenure tenure2 tenure3 tenure4 tenure5 sic1 sic2 sic3 sic4 sic5 sic6 sic7 sic8 sic9 soc1 soc2 soc3 soc4 soc5 soc6 soc7 soc8 soc9 i.wave i.region"
local xlist41 "yeqxexp yeqxeu expxeu"
local bonusjob "bonusjob"
local jobmatch "jobmatch"
set more off
preserve
keep if ME==6

logit `bonusjob' `xlist1' `xlist4' if (`bonusjob'==0 | `bonusjob'==1), ///
vce(cluster `jobmatch')
estat classification
predict prob_pp, p

replace prob_pp=0.99 if prob_pp>0.99 & bonusjob!=0
quietly sum bonusjob if bonusjob<2
gen p_bonusjob = r(mean)

gen weight = (prob_pp)/(1-prob_pp)*((1-p_bonusjob)/bonusjob) if ///
bonusjob==2

kdensity lnhly if bonusjob==0, plot(kdensity lnhly if bonusjob==1 || ///
kdensity lnhly if bonusjob==2 [aweight=weight])

quietly sum lnhly if bonusjob==0, detail
gen p99n = r(p99)
gen p90n = r(p90)
gen p75n = r(p75)
gen p50n = r(p50)
gen p10n = r(p10)
gen pmeann = r(mean)
gen pvarn = r(Var)
quietly sum lnhly if bonusjob==1, detail
gen p99b = r(p99)
gen p90b = r(p90)
gen p75b = r(p75)
gen p50b = r(p50)
gen p10b = r(p10)
gen pmeanb = r(mean)
gen pvarb = r(Var)
quietly sum lnhly if bonusjob==2 [aweight=weight], detail
gen p99nb = r(p99)
gen p90nb = r(p90)
gen p75nb = r(p75)
gen p50nb = r(p50)
gen p10nb = r(p10)
gen pmeannb = r(mean)
gen pvarnb = r(Var)

foreach stat in var mean 10 50 75 90 99 {
	gen delta = p`stat'n - p`stat'nb
	di "The unadjusted `stat'" " = " p`stat'n
	di "The adjusted `stat'" " = " p`stat'nb
	di "The difference" "=" delta
	drop delta
}

restore




foreach x in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 ///
25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 ///
50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 65 66 67 68 69 70 71 72 73 74 ///
75 76 77 78 79 80 81 82 83 84 85 86 87 88 89 90 91 92 93 94 95 96 97 98 99 {
 replace lnhy_ws=r(r`x') if _n==`x'
}




















































quietly{
probit bonusjob `xlist1' `xlist4' if ME==1, vce(cluster jobmatch)
predict prob_pp_1 if ME==1
egen mean_pp_1=mean(bonusjob) if ME==1

generate weight_cfl_1= (prob_pp_1)*(1-mean_pp_1)/((1-prob_pp_1)*(mean_pp_1)) ///
if bonusjob==0 & ME==1

*generate weight_cfl_1= (1-mean_pp_1)/(1-prob_pp_1) if bonusjob==0 & ME==1
}
sum lnhly if bonusjob==0 & ME==1, detail
sum lnhly if bonusjob==0 & ME==1 [aweight=weight_cfl_1], detail

quietly{
logit bonusjob `xlist1' `xlist4' if ME==8, vce(cluster jobmatch)
predict prob_pp_8 if ME==8
egen mean_pp_8=mean(bonusjob) if ME==8

generate weight_cfl_8= (prob_pp_8)*(1-mean_pp_8)/((1-prob_pp_8)*(mean_pp_8)) ///
if bonusjob==0 & ME==8

*generate weight_cfl_8= (1-mean_pp_8)/(1-prob_pp_8) if bonusjob==0 & ME==8
}
sum lnhly if bonusjob==0 & ME==8, detail
sum lnhly if bonusjob==0 & ME==8 [aweight=weight_cfl_8], detail

drop prob_pp_1 mean_pp_1 weight_cfl_1 prob_pp_8 mean_pp_8 weight_cfl_8




kdensity lnhly [aweight=weight_cfl_8] if ME==8, plot(kdensity lnhly if ME==8)



quietly{
//generate mu_prelim=weight_cfl*lnhly if bonusjob==0
//generate bonusjob_owr=1 if bonusjob==0
//egen mu_prelim_sum=total(mu_prelim)
//egen denom = total(bonusjob_owr)
//generate mu = mu_prelim_sum/denom
//generate wsecondm = weight_cfl*(lnhly-mu)*(lnhly-mu) if bonusjob==0
//egen sum_wsecondm = sum(wsecondm)
//egen total_wsecondm = total(wsecondm)
//generate var_cfl= total_wsecondm/denom

//sum var_cfl
//sum lnhly, detail

//drop mu_prelim bonusjob_owr mu_prelim_sum wsecondm sum_wsecondm total_wsecondm








//kdensity lnhly [aweight=weight_cfl], plot(kdensity lnhly) ///
//generate(points2 prob_kernel2) n(100)


//drop mean_pp prob_pp

//sum prob_kernel, detail
//sum prob, detail
}
*******************************************************************************
*******************************************************************************
