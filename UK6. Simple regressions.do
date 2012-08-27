*******************************************************************************
**************************** Regression framework *****************************
*******************************************************************************

set more off
*svyset [pweight = lrwght]
xtset pid wave

// Set of controls: education, experience (cubic), race, marital status, union,
// tenure (quadratic), industry, occupation, (calendar) year.
local xlist1 "Q12 Q3 Q4 Q5 Q6 exp1 exp12 nonwhite married cba union tenure tenure2 sic1 sic2 sic3 sic4 sic5 sic6 sic7 sic8 sic9 soc2 soc3 soc4 soc5 soc6 soc7 soc8 soc9 i.wave i.region"
local xlist11 "Q12 Q3 Q4 exp1 exp12 nonwhite married cba union tenure1 tenure12 sic1 sic2 sic3 sic4 sic5 sic6 sic7 sic8 sic9 soc2 soc3 soc4 soc5 soc6 soc7 soc8 soc9 i.wave i.region"
local xlist12 "yeq exp1 exp12 exp14 exp15 exp13 nonwhite married cba union tenure1 tenure12 tenure13 tenure14 tenure15 sic1 sic2 sic3 sic4 sic5 sic6 sic7 sic8 sic9 soc2 soc3 soc4 soc5 soc6 soc7 soc8 soc9 i.wave i.region"
local bonusjob "bonusjobfifth"
local bonus "bonus"
local jobmatch "jobmatch"

// for robustness checks, i can just set bonusjob to anything available and run 
// all necessary regressions. Just make sure both bonusjob and jobmatch are
// consistent.

//---------------------------------------------------------------------------//
//---------------------- Simple regression framework ------------------------//
//---------------------------------------------------------------------------//

// OLS with controls.----------------------------------------------------------

*reg lnhly `bonusjob' `xlist1', vce(cluster `jobmatch')

*reg lnhly `bonusjob' `bonus' `xlist1', vce(cluster `jobmatch')

// FE model - worker fixed effects.--------------------------------------------

*type 1

*xtreg lnhly `bonusjob' `xlist1', fe vce(cluster `jobmatch') nonest

*xtreg lnhly `bonusjob' `bonus' `xlist1', fe vce(cluster `jobmatch') nonest

// FE model - worker and jobmatch fixed effects.-------------------------------

*egen FE=group(pid `jobmatch')

*xtreg lnhly `bonusjob' `bonus' `xlist1', i(FE) fe vce(cluster `jobmatch') ///
*nonest

xtset pid wave

//---------------------------------------------------------------------------//
//----------------------- Return to Skill regressions -----------------------//
//---------------------------------------------------------------------------//

// Split sample.---------------------------------------------------------------

local xlist1 "Q12 Q3 Q4 Q5 Q6 exp1 exp12 nonwhite married cba union tenure tenure2 sic1 sic2 sic3 sic4 sic5 sic6 sic7 sic8 sic9 soc2 soc3 soc4 soc5 soc6 soc7 soc8 soc9 i.wave i.region"
local xlist11 "Q12 Q3 Q4 exp1 exp12 nonwhite married cba union tenure1 tenure12 sic1 sic2 sic3 sic4 sic5 sic6 sic7 sic8 sic9 soc2 soc3 soc4 soc5 soc6 soc7 soc8 soc9 i.wave i.region"
local xlist12 "yeq exp1 exp12 exp14 exp15 exp13 nonwhite married cba union tenure1 tenure12 tenure13 tenure14 tenure15 sic1 sic2 sic3 sic4 sic5 sic6 sic7 sic8 sic9 soc2 soc3 soc4 soc5 soc6 soc7 soc8 soc9 i.wave i.region"

reg lnhly `xlist1' if `bonusjob'==0, vce(cluster `jobmatch')
*predict outcomenpp
*predict outcomenpp_r, residuals

reg lnhly `xlist1' if `bonusjob'==1, vce(cluster `jobmatch')
*predict outcomepp
*predict outcomepp_r, residuals

quietly{
reg lnhly `xlist1' if `bonusjob'==0
est store modelno
reg lnhly `xlist1' if `bonusjob'==1
est store modelyes
suest modelno modelyes, vce(cluster `jobmatch')
}
test [modelno_mean]_b[Q12] + [modelno_mean]_b[Q3] + ///
[modelno_mean]_b[Q4] = [modelyes_mean]_b[Q12] + ///
[modelyes_mean]_b[Q3] + [modelyes_mean]_b[Q4]
test [modelno_mean]_b[Q12] + [modelno_mean]_b[Q3] = ///
[modelyes_mean]_b[Q12] + [modelyes_mean]_b[Q3]

// Interaction variables with performance pay only.----------------------------

* create the interaction variables

local bonusjob "bonusjobfifth"
local bonus "bonus"
local jobmatch "jobmatch"

quietly{
set more off
generate Q1xb = Q1*`bonusjob'
generate Q2xb = Q2*`bonusjob'
generate Q12xb = Q12*`bonusjob'
generate Q3xb = Q3*`bonusjob'
generate Q4xb = Q4*`bonusjob'
generate Q5xb = Q5*`bonusjob'
generate Q6xb = Q6*`bonusjob'
generate Q7xb = Q7*`bonusjob'
generate expxb = exp1*`bonusjob'
generate exp2xb = exp12*`bonusjob'
generate exp3xb = exp13*`bonusjob'
generate exp4xb = exp14*`bonusjob'
generate exp5xb = exp15*`bonusjob'
generate tenurexb = tenure*`bonusjob'
generate tenure2xb = tenure2*`bonusjob'
generate tenure3xb = tenure3*`bonusjob'
generate tenure4xb = tenure4*`bonusjob'
generate tenure5xb = tenure5*`bonusjob'
generate yeqxb1 = yeq*`bonusjob'
generate Q12xbxm = Q12*`bonusjob'*soc1
generate Q3xbxm = Q3*`bonusjob'*soc1
generate Q4xbxm = Q4*`bonusjob'*soc1
generate Q5xbxm = Q5*`bonusjob'*soc1
generate Q6xbxm = Q6*`bonusjob'*soc1
generate Q7xbxm = Q7*`bonusjob'*soc1
generate Q12xbxf = Q12*`bonusjob'*sic8
generate Q3xbxf = Q3*`bonusjob'*sic8
generate Q4xbxf = Q4*`bonusjob'*sic8
generate Q5xbxf = Q5*`bonusjob'*sic8
generate Q6xbxf = Q6*`bonusjob'*sic8
generate Q7xbxf = Q7*`bonusjob'*sic8

local xlist1 "Q12 Q3 Q4 Q5 Q6 exp1 exp12 nonwhite married cba union tenure tenure2 sic1 sic2 sic3 sic4 sic5 sic6 sic7 sic8 sic9 soc2 soc3 soc4 soc5 soc6 soc7 soc8 soc9 i.wave i.region"
local xlist2 "Q12xb Q3xb Q4xb Q5xb Q6xb expxb exp2xb tenurexb tenure2xb"
local xlist21 "Q12xb Q3xb Q4xb expxb exp2xb exp3xb tenurexb tenure2xb"
local xlist22 "yeqxb expxb exp2xb tenurexb tenure2xb"
}

reg lnhly `bonusjob' `xlist1' `xlist2', vce(cluster `jobmatch')
xtreg lnhly `bonusjob' `xlist1' `xlist2', fe vce(cluster `jobmatch') nonest


// Interaction variables with performance pay and periods.---------------------

* create the interaction variables
quietly{
generate Q1xp1 = Q1*ME1
generate Q1xp2 = Q1*ME2
generate Q1xp3 = Q1*ME3
generate Q1xp4 = Q1*ME4
generate Q1xp5 = Q1*ME5
generate Q1xp6 = Q1*ME6

generate Q12xp1 = Q12*ME1
generate Q12xp2 = Q12*ME2
generate Q12xp3 = Q12*ME3
generate Q12xp4 = Q12*ME4
generate Q12xp5 = Q12*ME5
generate Q12xp6 = Q12*ME6

generate Q2xp1 = Q2*ME1
generate Q2xp2 = Q2*ME2
generate Q2xp3 = Q2*ME3
generate Q2xp4 = Q2*ME4
generate Q2xp5 = Q2*ME5
generate Q2xp6 = Q2*ME6

generate Q3xp1 = Q3*ME1
generate Q3xp2 = Q3*ME2
generate Q3xp3 = Q3*ME3
generate Q3xp4 = Q3*ME4
generate Q3xp5 = Q3*ME5
generate Q3xp6 = Q3*ME6

generate Q4xp1 = Q4*ME1
generate Q4xp2 = Q4*ME2
generate Q4xp3 = Q4*ME3
generate Q4xp4 = Q4*ME4
generate Q4xp5 = Q4*ME5
generate Q4xp6 = Q4*ME6

generate Q5xp1 = Q5*ME1
generate Q5xp2 = Q5*ME2
generate Q5xp3 = Q5*ME3
generate Q5xp4 = Q5*ME4
generate Q5xp5 = Q5*ME5
generate Q5xp6 = Q5*ME6

generate Q6xp1 = Q6*ME1
generate Q6xp2 = Q6*ME2
generate Q6xp3 = Q6*ME3
generate Q6xp4 = Q6*ME4
generate Q6xp5 = Q6*ME5
generate Q6xp6 = Q6*ME6

generate Q7xp1 = Q7*ME1
generate Q7xp2 = Q7*ME2
generate Q7xp3 = Q7*ME3
generate Q7xp4 = Q7*ME4
generate Q7xp5 = Q7*ME5
generate Q7xp6 = Q7*ME6

generate Q1xbxp1 = Q1*ME1*`bonusjob'
generate Q1xbxp2 = Q1*ME2*`bonusjob'
generate Q1xbxp3 = Q1*ME3*`bonusjob'
generate Q1xbxp4 = Q1*ME4*`bonusjob'
generate Q1xbxp5 = Q1*ME5*`bonusjob'
generate Q1xbxp6 = Q1*ME6*`bonusjob'

generate Q12xbxp1 = Q12*ME1*`bonusjob'
generate Q12xbxp2 = Q12*ME2*`bonusjob'
generate Q12xbxp3 = Q12*ME3*`bonusjob'
generate Q12xbxp4 = Q12*ME4*`bonusjob'
generate Q12xbxp5 = Q12*ME5*`bonusjob'
generate Q12xbxp6 = Q12*ME6*`bonusjob'

generate Q2xbxp1 = Q2*ME1*`bonusjob'
generate Q2xbxp2 = Q2*ME2*`bonusjob'
generate Q2xbxp3 = Q2*ME3*`bonusjob'
generate Q2xbxp4 = Q2*ME4*`bonusjob'
generate Q2xbxp5 = Q2*ME5*`bonusjob'
generate Q2xbxp6 = Q2*ME6*`bonusjob'

generate Q3xbxp1 = Q3*ME1*`bonusjob'
generate Q3xbxp2 = Q3*ME2*`bonusjob'
generate Q3xbxp3 = Q3*ME3*`bonusjob'
generate Q3xbxp4 = Q3*ME4*`bonusjob'
generate Q3xbxp5 = Q3*ME5*`bonusjob'
generate Q3xbxp6 = Q3*ME6*`bonusjob'

generate Q4xbxp1 = Q4*ME1*`bonusjob'
generate Q4xbxp2 = Q4*ME2*`bonusjob'
generate Q4xbxp3 = Q4*ME3*`bonusjob'
generate Q4xbxp4 = Q4*ME4*`bonusjob'
generate Q4xbxp5 = Q4*ME5*`bonusjob'
generate Q4xbxp6 = Q4*ME6*`bonusjob'

generate Q5xbxp1 = Q5*ME1*`bonusjob'
generate Q5xbxp2 = Q5*ME2*`bonusjob'
generate Q5xbxp3 = Q5*ME3*`bonusjob'
generate Q5xbxp4 = Q5*ME4*`bonusjob'
generate Q5xbxp5 = Q5*ME5*`bonusjob'
generate Q5xbxp6 = Q5*ME6*`bonusjob'

generate Q6xbxp1 = Q6*ME1*`bonusjob'
generate Q6xbxp2 = Q6*ME2*`bonusjob'
generate Q6xbxp3 = Q6*ME3*`bonusjob'
generate Q6xbxp4 = Q6*ME4*`bonusjob'
generate Q6xbxp5 = Q6*ME5*`bonusjob'
generate Q6xbxp6 = Q6*ME6*`bonusjob'

generate Q7xbxp1 = Q7*ME1*`bonusjob'
generate Q7xbxp2 = Q7*ME2*`bonusjob'
generate Q7xbxp3 = Q7*ME3*`bonusjob'
generate Q7xbxp4 = Q7*ME4*`bonusjob'
generate Q7xbxp5 = Q7*ME5*`bonusjob'
generate Q7xbxp6 = Q7*ME6*`bonusjob'

generate yeqxp1 = yeq*ME1
generate yeqxp2 = yeq*ME2
generate yeqxp3 = yeq*ME3
generate yeqxp4 = yeq*ME4
generate yeqxp5 = yeq*ME5
generate yeqxp6 = yeq*ME6

generate yeqxbxp1 = yeq*ME1*`bonusjob'
generate yeqxbxp2 = yeq*ME2*`bonusjob'
generate yeqxbxp3 = yeq*ME3*`bonusjob'
generate yeqxbxp4 = yeq*ME4*`bonusjob'
generate yeqxbxp5 = yeq*ME5*`bonusjob'
generate yeqxbxp6 = yeq*ME6*`bonusjob'

local xlist3 "Q12xp2 Q12xp3 Q12xp4 Q12xp5 Q12xp6 Q3xp2 Q3xp3 Q3xp4 Q3xp5 Q3xp6 Q4xp2 Q4xp3 Q4xp4 Q4xp5 Q4xp6 Q5xp2 Q5xp3 Q5xp4 Q5xp5 Q5xp6 Q6xp2 Q6xp3 Q6xp4 Q6xp5 Q6xp6 Q12xbxp2 Q12xbxp3 Q12xbxp4 Q12xbxp5 Q12xbxp6 Q3xbxp2 Q3xbxp3 Q3xbxp4 Q3xbxp5 Q3xbxp6 Q4xbxp2 Q4xbxp3 Q4xbxp4 Q4xbxp5 Q4xbxp6 Q5xbxp2 Q5xbxp3 Q5xbxp4 Q5xbxp5 Q5xbxp6 Q6xbxp2 Q6xbxp3 Q6xbxp4 Q6xbxp5 Q6xbxp6"
local xlist31 "Q12xp2 Q12xp3 Q12xp4 Q12xp5 Q12xp6 Q3xp2 Q3xp3 Q3xp4 Q3xp5 Q3xp6 Q4xp2 Q4xp3 Q4xp4 Q4xp5 Q4xp6 Q5xp2 Q5xp3 Q5xp4 Q5xp5 Q5xp6 Q6xp2 Q6xp3 Q6xp4 Q6xp5 Q6xp6 Q7xp2 Q7xp3 Q7xp4 Q7xp5 Q7xp6 Q12xbxp2 Q12xbxp3 Q12xbxp4 Q12xbxp5 Q12xbxp6 Q3xbxp2 Q3xbxp3 Q3xbxp4 Q3xbxp5 Q3xbxp6 Q4xbxp2 Q4xbxp3 Q4xbxp4 Q4xbxp5 Q4xbxp6 Q5xbxp2 Q5xbxp3 Q5xbxp4 Q5xbxp5 Q5xbxp6 Q6xbxp2 Q6xbxp3 Q6xbxp4 Q6xbxp5 Q6xbxp6 Q7xbxp2 Q7xbxp3 Q7xbxp4 Q7xbxp5 Q7xbxp6"
local xlist32 "yeqxp2 yeqxp3 yeqxp4 yeqxp5 yeqxp6 yeqxbxp2 yeqxbxp3 yeqxbxp4 yeqxbxp5 yeqxbxp6"
}

reg lnhly `bonusjob' `xlist1' `xlist2' `xlist3', vce(cluster `jobmatch')
xtreg lnhly `bonusjob' `xlist1' `xlist2' `xlist3', fe vce(cluster `jobmatch') nonest

quietly{
drop Q1x* Q12x* Q2x* Q3x* Q4x* Q5x* Q6x* Q7x*
drop expx* exp2x* exp3x* exp4x* exp5x*
drop tenurex* tenure2x* tenure3x* tenure4x* tenure5x*
drop yeqx*
}

//---------------------------------------------------------------------------//
//------------------- Returns to industry and occupation --------------------//
//---------------------------------------------------------------------------//

set more off

xtset pid wave


local bonusjob "bonusjob"
local bonus "bonus"
local jobmatch "jobmatch"
local soc "soc1"
local sic "sic0"

quietly{
generate Q1xb = Q1*`bonusjob'
generate Q2xb = Q2*`bonusjob'
generate Q12xb = Q12*`bonusjob'
generate Q3xb = Q3*`bonusjob'
generate Q4xb = Q4*`bonusjob'
generate Q5xb = Q5*`bonusjob'
generate Q6xb = Q6*`bonusjob'
generate Q7xb = Q7*`bonusjob'
generate expxb = exp1*`bonusjob'
generate exp2xb = exp12*`bonusjob'
generate exp3xb = exp13*`bonusjob'
generate exp4xb = exp14*`bonusjob'
generate exp5xb = exp15*`bonusjob'
generate tenurexb = tenure*`bonusjob'
generate tenure2xb = tenure2*`bonusjob'
generate tenure3xb = tenure3*`bonusjob'
generate tenure4xb = tenure4*`bonusjob'
generate tenure5xb = tenure5*`bonusjob'
generate yeqxm = yeq*soc1
generate Q12xm = Q12*soc1
generate Q3xm = Q3*soc1
generate Q4xm = Q4*soc1
generate Q5xm = Q5*soc1
generate Q6xm = Q6*soc1
generate Q7xm = Q7*soc1
generate Q12xf = Q12*sic8
generate Q3xf = Q3*sic8
generate Q4xf = Q4*sic8
generate Q5xf = Q5*sic8
generate Q6xf = Q6*sic8
generate Q7xf = Q7*sic8
generate Q12xbxm = Q12*`bonusjob'*`soc'
generate Q3xbxm = Q3*`bonusjob'*`soc'
generate Q4xbxm = Q4*`bonusjob'*`soc'
generate Q5xbxm = Q5*`bonusjob'*`soc'
generate Q6xbxm = Q6*`bonusjob'*`soc'
generate Q7xbxm = Q7*`bonusjob'*`soc'
generate Q12xbxf = Q12*`bonusjob'*`sic'
generate Q3xbxf = Q3*`bonusjob'*`sic'
generate Q4xbxf = Q4*`bonusjob'*`sic'
generate Q5xbxf = Q5*`bonusjob'*`sic'
generate Q6xbxf = Q6*`bonusjob'*`sic'
generate Q7xbxf = Q7*`bonusjob'*`sic'
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

local xlist1 "Q12 Q3 Q4 Q5 Q6 exp1 exp12 nonwhite married cba union tenure tenure2 sic1 sic2 sic3 sic4 sic5 sic6 sic7 sic8 sic9 soc2 soc3 soc4 soc5 soc6 soc7 soc8 soc9 i.wave i.region"
local xlist2 "Q12xb Q3xb Q4xb Q5xb Q6xb expxb exp2xb tenurexb tenure2xb"
local xlistx "Q12xm Q3xm Q4xm Q5xm Q6xm Q12xbxm Q3xbxm Q4xbxm Q5xbxm Q6xbxm"
local xlisty "Q12xf Q3xf Q4xf Q5xf Q6xf Q12xbxf Q3xbxf Q4xbxf Q5xbxf Q6xbxf"
local xlisto "o1xb o2xb o3xb o4xb o5xb o6xb o7xb o8xb o9xb"
local xlisti "i0xb i1xb i2xb i3xb i4xb i5xb i6xb i7xb i8xb i9xb"

reg lnhly `bonusjob' `xlist1' `xlist2' `xlisti', vce(cluster `jobmatch')
xtreg lnhly `bonusjob' `xlist1' `xlist2' `xlisti', fe vce(cluster `jobmatch') nonest
reg lnhly `bonusjob' `xlist1' `xlist2' `xlisto', vce(cluster `jobmatch')
xtreg lnhly `bonusjob' `xlist1' `xlist2' `xlisto', fe vce(cluster `jobmatch') nonest

quietly{
drop Q1x* Q12x* Q2x* Q3x* Q4x* Q5x* Q6x* Q7x*
drop expx* exp2x* exp3x* exp4x* exp5x*
drop tenurex* tenure2x* tenure3x* tenure4x* tenure5x*
drop yeqx*
drop i0x
foreach x in 1 2 3 4 5 6 7 8 9 {
 drop i`x'* 
 drop o`x'*
}
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
//	sic1:	Energy & water supplies							
			// OLS no, FE no // education: OLS yes, FE no
//	sic2:	Extraction of minerals & ores other than fuels; 
//			manufacture of metals, mineral products & chemicals
			// OLS no, FE no // education: OLS yes, FE no
//	sic3:	Metal goods, engineering & vehicles industries	
			// OLS no, FE no // education: OLS yes, FE no
//	sic4:	Other manufacturing industries					
			// OLS yes, FE yes // education: OLS yes, FE no
//	sic5:	Construction									
			// OLS no, FE no // education: OLS yes, FE no
//	sic6:	Distribution, hotels & catering (repairs)		
			// OLS yes, FE no // education: OLS yes, FE no
//	sic7:	Transport & communication						
			// OLS yes, FE no // education: OLS yes, FE bit
//	sic8:	Banking, finance, insurance, business services & leasing	
			// OLS yes, FE yes // education: OLS yes, FE yes
//	sic9:	Other services
			// OLS no, FE no // education: OLS yes, FE no

*******************************************************************************
*******************************************************************************
