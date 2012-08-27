*******************************************************************************
**************************** Regression framework *****************************
*******************************************************************************

set more off
xtset persnr wave

// Set of controls: education, experience (cubic), race, marital status, union,
// tenure (quadratic), industry, occupation, (calendar) year.
local xlist1 "university technical vocational exp exp2 eu married tenure tenure2 i.sic i.soc i.wave i.region"
local xlist11 "yeq exp exp2 exp3 exp4 exp5 eu married tenure tenure2 tenure3 tenure4 tenure5 sic1 sic2 sic3 sic4 sic5 sic6 sic7 sic8 sic9 soc1 soc2 soc3 soc4 soc5 soc6 soc7 soc8 soc9 i.wave i.region"
* tenure2 tenure3 tenure4 tenure5
//---------------------------------------------------------------------------//
//---------------------- Simple regression framework ------------------------//
//---------------------------------------------------------------------------//

// OLS and no controls.--------------------------------------------------------

*reg lnhly bonusjob `xlist1' if wave<25, vce(cluster jobmatch)
*xtreg lnhly bonusjob `xlist1' if wave<25, fe vce(cluster jobmatch) nonest

// OLS with controls.----------------------------------------------------------

reg lnhly bonusjob `xlist1' if wave<25, vce(cluster jobmatch)

reg lnhly bonusjob bonus `xlist1' if wave<25, vce(cluster jobmatch)

*reg lnhly bonusjob `xlist11' if wave<25, vce(cluster jobmatch)

*reg lnhly bonusjob bonus `xlist11' if wave<25, vce(cluster jobmatch)

// FE model - worker fixed effects.--------------------------------------------

*type 1

xtreg lnhly bonusjob `xlist1' if wave<25, fe vce(cluster jobmatch) nonest

*xtreg lnhly bonusjob `xlist11' if wave<25, fe vce(cluster jobmatch) nonest

xtreg lnhly bonusjob bonus `xlist1' if wave<25, fe vce(cluster jobmatch) nonest

*xtreg lnhly bonusjob bonus `xlist11' if wave<25, fe vce(cluster jobmatch) nonest

// FE model - worker and jobmatch fixed effects.-------------------------------

*type 1

egen FE=group(persnr jobmatch)

xtreg lnhly bonusjob bonus `xlist1' if wave<25, i(FE) fe vce(cluster jobmatch) nonest

*xtreg lnhly bonusjob bonus `xlist11' if wave<25, i(FE) fe vce(cluster jobmatch) nonest

//---------------------------------------------------------------------------//
//----------------------- Return to Skill regressions -----------------------//
//---------------------------------------------------------------------------//

// Split sample.---------------------------------------------------------------
set more off
xtset persnr wave


local xlist1 "university technical vocational exp exp2 eu married tenure tenure2 i.sic i.soc i.wave i.region"
local xlist11 "yeq exp exp2 exp3 exp4 exp5 eu married tenure tenure2 tenure3 tenure4 tenure5 sic1 sic2 sic3 sic4 sic5 sic6 sic7 sic8 sic9 soc1 soc2 soc3 soc4 soc5 soc6 soc7 soc8 soc9 i.wave i.region"

reg lnhly `xlist1' if bonusjob==0 & wave<25, vce(cluster jobmatch) 
predict outcomenpp
predict outcomenpp_r, residuals

reg lnhly `xlist1' if bonusjob==1 & wave<25, vce(cluster jobmatch)
predict outcomepp
predict outcomepp_r, residuals


reg lnhly `xlist1' if bonusjob==0 & wave<25
estimates store modelno
reg lnhly `xlist1' if bonusjob==1 & wave<25
estimates store modelyes

suest modelno modelyes, vce(cluster jobmatch)
test [modelno_mean]_b[university] + [modelno_mean]_b[technical] + ///
[modelno_mean]_b[vocational] = [modelyes_mean]_b[university] + ///
[modelyes_mean]_b[technical] + [modelyes_mean]_b[vocational]
test [modelno_mean]_b[university] + [modelno_mean]_b[technical] = ///
[modelyes_mean]_b[university] + [modelyes_mean]_b[technical]

// testing SIC
*foreach x in 1 2 3 4 5 6 7 8 9 {
*	test [modelno_mean]_b[sic`x']=[modelyes_mean]_b[sic`x'] 
*}
*test [modelno_mean]_b[sic1] + [modelno_mean]_b[sic2] + ///
*[modelno_mean]_b[sic3] + [modelno_mean]_b[sic4] + [modelno_mean]_b[sic5] + ///
*[modelno_mean]_b[sic6] + [modelno_mean]_b[sic7] + [modelno_mean]_b[sic8] + ///
*[modelno_mean]_b[sic9] = [modelyes_mean]_b[sic1] + [modelyes_mean]_b[sic2] ///
*+ [modelyes_mean]_b[sic3] + [modelyes_mean]_b[sic4] + ///
*[modelyes_mean]_b[sic5] + [modelyes_mean]_b[sic6] + [modelyes_mean]_b[sic7] ///
*+ [modelyes_mean]_b[sic8] + [modelyes_mean]_b[sic9]
// testing SOC
*foreach x in 2 3 4 5 6 7 8 9 {
*	test [modelno_mean]_b[soc`x']=[modelyes_mean]_b[soc`x'] 
*}
*test [modelno_mean]_b[soc2] + [modelno_mean]_b[soc3] + ///
*[modelno_mean]_b[soc4] + [modelno_mean]_b[soc5] + [modelno_mean]_b[soc6] + ///
*[modelno_mean]_b[soc7] + [modelno_mean]_b[soc8] + [modelno_mean]_b[soc9] = ///
*[modelyes_mean]_b[soc2] + [modelyes_mean]_b[soc3] + [modelyes_mean]_b[soc4] ///
*+ [modelyes_mean]_b[soc5] + [modelyes_mean]_b[soc6] + ///
*[modelyes_mean]_b[soc7] + [modelyes_mean]_b[soc8] + [modelyes_mean]_b[soc9]
*restore



// Interaction variables with performance pay only.----------------------------

* create the interaction variables
quietly{
generate unixbonus = university*bonusjob
generate techxbonus = technical*bonusjob
generate vocxbonus = vocational*bonusjob
generate yeqxbonus = yeq*bonusjob
generate expxbonus = exp*bonusjob
generate exp2xbonus = exp2*bonusjob
generate exp3xbonus = exp3*bonusjob
generate exp4xbonus = exp4*bonusjob
generate exp5xbonus = exp5*bonusjob
generate tenurexbonus = tenure*bonusjob
generate tenure2xbonus = tenure2*bonusjob
generate tenure3xbonus = tenure3*bonusjob
generate tenure4xbonus = tenure4*bonusjob
generate tenure5xbonus = tenure5*bonusjob

}

* run regressions

xtset persnr wave
set more off

local xlist1 "university technical vocational exp exp2 eu married tenure tenure2 i.sic i.soc i.wave i.region"
local xlist11 "yeq exp exp2 exp3 exp4 exp5 eu married tenure tenure2 tenure3 tenure4 tenure5 sic1 sic2 sic3 sic4 sic5 sic6 sic7 sic8 sic9 soc1 soc2 soc3 soc4 soc5 soc6 soc7 soc8 soc9 i.wave i.region"
local xlist2 "unixbonus techxbonus vocxbonus expxbonus exp2xbonus tenurexbonus tenure2xbonus"
local xlist21 "yeqxbonus  expxbonus exp2xbonus exp3xbonus exp4xbonus exp5xbonus tenurexbonus tenure2xbonus tenure3xbonus tenure4xbonus tenure5xbonus"

reg lnhly bonusjob sex `xlist1' `xlist2' if wave<25, vce(cluster jobmatch)
*reg lnhly bonusjob sex `xlist11' `xlist21' if wave<25, vce(cluster jobmatch)

xtreg lnhly bonusjob sex `xlist1' `xlist2' if wave<25, fe vce(cluster jobmatch) nonest
*xtreg lnhly bonusjob sex `xlist11' `xlist21' if wave<25, fe vce(cluster jobmatch) nonest

// Interaction variables with performance pay and periods.---------------------

* Create the interaction variables

quietly {
generate unixME1 = university*ME1
generate unixME2 = university*ME2
generate unixME3 = university*ME3
generate unixME4 = university*ME4
generate unixME5 = university*ME5
generate unixME6 = university*ME6
generate unixME7 = university*ME7
generate unixME8 = university*ME8
generate techxME1 = technical*ME1
generate techxME2 = technical*ME2
generate techxME3 = technical*ME3
generate techxME4 = technical*ME4
generate techxME5 = technical*ME5
generate techxME6 = technical*ME6
generate techxME7 = technical*ME7
generate techxME8 = technical*ME8
generate vocxME1 = vocational*ME1
generate vocxME2 = vocational*ME2
generate vocxME3 = vocational*ME3
generate vocxME4 = vocational*ME4
generate vocxME5 = vocational*ME5
generate vocxME6 = vocational*ME6
generate vocxME7 = vocational*ME7
generate vocxME8 = vocational*ME8
generate yeqxME1 = yeq*ME1
generate yeqxME2 = yeq*ME2
generate yeqxME3 = yeq*ME3
generate yeqxME4 = yeq*ME4
generate yeqxME5 = yeq*ME5
generate yeqxME6 = yeq*ME6
generate yeqxME7 = yeq*ME7
generate yeqxME8 = yeq*ME8

generate unixME1xb = university*ME1*bonusjob
generate unixME2xb = university*ME2*bonusjob
generate unixME3xb = university*ME3*bonusjob
generate unixME4xb = university*ME4*bonusjob
generate unixME5xb = university*ME5*bonusjob
generate unixME6xb = university*ME6*bonusjob
generate unixME7xb = university*ME7*bonusjob
generate unixME8xb = university*ME8*bonusjob
generate techxME1xb = technical*ME1*bonusjob
generate techxME2xb = technical*ME2*bonusjob
generate techxME3xb = technical*ME3*bonusjob
generate techxME4xb = technical*ME4*bonusjob
generate techxME5xb = technical*ME5*bonusjob
generate techxME6xb = technical*ME6*bonusjob
generate techxME7xb = technical*ME7*bonusjob
generate techxME8xb = technical*ME8*bonusjob
generate vocxME1xb = vocational*ME1*bonusjob
generate vocxME2xb = vocational*ME2*bonusjob
generate vocxME3xb = vocational*ME3*bonusjob
generate vocxME4xb = vocational*ME4*bonusjob
generate vocxME5xb = vocational*ME5*bonusjob
generate vocxME6xb = vocational*ME6*bonusjob
generate vocxME7xb = vocational*ME7*bonusjob
generate vocxME8xb = vocational*ME8*bonusjob
generate yeqxME1xb = yeq*ME1*bonusjob
generate yeqxME2xb = yeq*ME2*bonusjob
generate yeqxME3xb = yeq*ME3*bonusjob
generate yeqxME4xb = yeq*ME4*bonusjob
generate yeqxME5xb = yeq*ME5*bonusjob
generate yeqxME6xb = yeq*ME6*bonusjob
generate yeqxME7xb = yeq*ME7*bonusjob
generate yeqxME8xb = yeq*ME8*bonusjob

}

local xlist3 "unixME2 unixME3 unixME4 unixME5 unixME6 unixME7 unixME8 techxME2 techxME3 techxME4 techxME5 techxME6 techxME7 techxME8 vocxME2 vocxME3 vocxME4 vocxME5 vocxME6 vocxME7 vocxME8 unixME2xb unixME3xb unixME4xb unixME5xb unixME6xb unixME7xb unixME8xb techxME2xb techxME3xb techxME4xb techxME5xb techxME6xb techxME7xb techxME8xb vocxME2xb vocxME3xb vocxME4xb vocxME5xb vocxME6xb vocxME7xb vocxME8xb"
local xlist31 "yeqxME2 yeqxME3 yeqxME4 yeqxME5 yeqxME6 yeqxME7 yeqxME8 yeqxME9 yeqxME2xb yeqxME3xb yeqxME4xb yeqxME5xb yeqxME6xb yeqxME7xb yeqxME8xb yeqxME9xb"

reg lnhly bonusjob `xlist1' `xlist2' `xlist3' if wave<25, vce(cluster jobmatch)

xtreg lnhly bonusjob `xlist1' `xlist2' `xlist3'  if wave<25, fe vce(cluster jobmatch) nonest

//---------------------------------------------------------------------------//
//------------------- Returns to industry and occupation --------------------//
//---------------------------------------------------------------------------//

set more off

local bonusjob "bonusjob"
local bonus "bonus"
local jobmatch "jobmatch"
local soc "soc1"
local sic "sic0"

quietly{
gen sicother = sic11 + sic12 + sic13 + sic14 + sic15 + sic16 + sic17
gen sicbanking = sic8 + sic9 + sic10
generate unixb = university*`bonusjob'
generate techxb = technical*`bonusjob'
generate vocxb = vocational*`bonusjob'
generate expxb = exp*`bonusjob'
generate exp2xb = exp2*`bonusjob'
generate exp3xb = exp3*`bonusjob'
generate exp4xb = exp4*`bonusjob'
generate exp5xb = exp5*`bonusjob'
generate tenurexb = tenure*`bonusjob'
generate tenure2xb = tenure2*`bonusjob'
generate tenure3xb = tenure3*`bonusjob'
generate tenure4xb = tenure4*`bonusjob'
generate tenure5xb = tenure5*`bonusjob'
generate unixbxm = university*`bonusjob'*`soc'
generate techxbxm = technical*`bonusjob'*`soc'
generate vocxbxm = vocational*`bonusjob'*`soc'
generate i0xb = sic0*`bonus'
generate i1xb = sic1*`bonus'
generate i2xb = sic2*`bonus'
generate i3xb = sic3*`bonus'
generate i4xb = sic4*`bonus'
generate i5xb = sic5*`bonus'
generate i6xb = sic6*`bonus'
generate i7xb = sic7*`bonus'
generate i8xb = sic8*`bonus'
generate i9xb = sic9*`bonus'
generate i10xb = sic10*`bonus'
generate i11xb = sic11*`bonus'
generate i12xb = sic12*`bonus'
generate i13xb = sic13*`bonus'
generate i14xb = sic14*`bonus'
generate i15xb = sic15*`bonus'
generate i16xb = sic16*`bonus'
generate i17xb = sic17*`bonus'
generate iotherxb = sicother*`bonus'
generate ibankxb = sicbank*`bonus'
generate o0xb = soc0*`bonus'
generate o1xb = soc1*`bonus'
generate o2xb = soc2*`bonus'
generate o3xb = soc3*`bonus'
generate o4xb = soc4*`bonus'
generate o5xb = soc5*`bonus'
generate o6xb = soc6*`bonus'
generate o7xb = soc7*`bonus'
generate o8xb = soc8*`bonus'
generate o9xb = soc9*`bonus'
}

local bonusjob "bonusjob"
local bonus "bonus"
local jobmatch "jobmatch"

local xlist1 "university technical vocational exp exp2 eu married tenure tenure2 i.sic i.soc i.wave i.region"
local xlist2 "unixb techxb vocxb expxb exp2xb tenurexb tenure2xb"
local xlisto "o0xb o1xb o2xb o3xb o4xb o5xb o6xb o7xb o8xb o9xb"
local xlisti "i0xb i1xb i2xb i3xb i4xb i5xb i6xb i7xb ibankxb iotherxb"

reg lnhly `bonusjob' `xlist1' `xlist2' `xlisto' if wave<25, ///
vce(cluster `jobmatch')
xtreg lnhly `bonusjob' `xlist1' `xlist2' `xlisto' if wave<25, ///
fe vce(cluster `jobmatch') nonest
reg lnhly `bonusjob' `xlist1' `xlist2' `xlisti' if wave<25, ///
vce(cluster `jobmatch')
xtreg lnhly `bonusjob' `xlist1' `xlist2' `xlisti' if wave<25, ///
fe vce(cluster `jobmatch') nonest

quietly{
drop unix* techx* vocx*
drop expx* exp2x* exp3x* exp4x* exp5x*
drop tenurex* tenure2x* tenure3x* tenure4x* tenure5x*
drop i0x
foreach x in 1 2 3 4 5 6 7 8 9 {
 drop i`x'* 
 drop o`x'*
}
foreach x in 10 11 12 13 14 15 16 17 {
 drop i`x'* 
}
drop iotherxb
}

//	soc1:	Managers & administrators						
			// OLS yes, FE no // education: OLS no, FE yes
//	soc2:	Professional occupators							
			// OLS no, FE no // education: OLS a bit, FE yes
//	soc3:	Associate professional & technical occupations	
			// OLS yes, FE no // education: OLS yes, FE yes
//	soc4:	Clerical & secretarial occupations				
			// OLS no, FE no // education: OLS yes, FE yes 
//	soc5:	Craft & related occupations						
			// OLS no, FE no // education: OLS yes, FE yes
//	soc6:	Personal & protective service occupations		
			// OLS yes, FE no // education: OLS yes, FE yes
//	soc7:	Sales occupations								
			// OLS no, FE no // education: OLS yes, FE yes
//	soc8:	Plant & machine operatives						
			// OLS no, FE yes // education: OLS yes, FE yes
//	soc9:	Other occupations						
			// OLS no, FE no // education: OLS yes, FE yes
	
//	sic0:	Agriculture, forestry & fishing					
			// OLS no, FE no // education: OLS yes, FE no
//	sic1:	Mining					
			// OLS no, FE no // education: OLS yes, FE no
//	sic2:	Manufacturing 
			// OLS no, FE no // education: OLS yes, FE no
//	sic3:	Energy and water supply	
			// OLS no, FE no // education: OLS yes, FE no
//	sic4:	Construction					
			// OLS yes, FE yes // education: OLS yes, FE no
//	sic5:	Trading									
			// OLS no, FE no // education: OLS yes, FE no
//	sic6:	Hotel and restaurant industry		
			// OLS yes, FE no // education: OLS yes, FE no
//	sic7:	Traffic and transport						
			// OLS yes, FE no // education: OLS yes, FE bit
//	sic8:	Banking and insurance	
			// OLS yes, FE yes // education: OLS yes, FE yes
//	sic9:	Real estate
			// OLS no, FE no // education: OLS yes, FE no
//	sic10:	Services for enterprises							
			// OLS no, FE no // education: OLS yes, FE no			
//	sic11:	Public sector						
			// OLS no, FE no // education: OLS yes, FE no
//	sic12:	Education							
			// OLS no, FE no // education: OLS yes, FE no
//	sic13:	Health and social							
			// OLS no, FE no // education: OLS yes, FE no
//	sic14:	Private households							
			// OLS no, FE no // education: OLS yes, FE no
//	sic15:	Religion							
			// OLS no, FE no // education: OLS yes, FE no
//	sic16:	Culture and sports							
			// OLS no, FE no // education: OLS yes, FE no
//	sic17:	Other sports						
			// OLS no, FE no // education: OLS yes, FE no

*******************************************************************************
*******************************************************************************
