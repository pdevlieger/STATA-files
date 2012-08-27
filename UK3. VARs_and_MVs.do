*******************************************************************************
************************* Dealing with missing values *************************
*******************************************************************************

quietly{
set more off

// Selection of employees (not self-employed). Public and females are not 
// yet selected as they will be used for robustness checks.
// Variables pid, hid, hoh, jbsemp, jbsect, age and sex have no missing values.

drop if jbsemp!=1    		// employee or self-employed
drop if sex !=1				// only males
//drop if hoh !=1			// NOT STRICTLY NECESSARY IN THE ANALYSIS!!!!!!!!!
drop if age<20 				// age restriction
drop if age>65				// age restriction
drop if jbsect !=1			// only private company workers
drop if jbstat!=2			// Only people in paid employ

// Now we have a sample strictly consisting of males aged 16-65 in private
// paid employ (not self-employed). What about the other variables?

// For missing values, the following variables need to be dealt with:

//	race:	-9, -8, -7, -2, -1, 1/9		//	tujbpl:	-9, -8, -7, -2, -1
//	racel:	-9, -8, -7, -2, -1, 1-5/18	//	tuin1:	-9, -8, -7, -2, -1
//	scend:	-9, -8						//	mastat:	-9, -8, 0, 1/7
//	doid:	-9, -7						//	qfachi:	-9, -8, -7, 1/7
//	doim:	-9, -8, -7					//	njbwks:	-9, -8, -7
//	doiy4:	-9, -7						//	njuwks:	-9, -8, -7
//	jbstat:	-9, -8, -7, -2, -1, 1/10	//	njiwks:	-9, -8, -7
//	jbsoc:	-9, -8						//	fiyrl:	-9, -8, -7
//	jbsic92:-9, -8, -2, -1				//	fiyr:	-9, -8, -7
//	jbhrs:	-9, -8, -2, -1				//	jbbgd:	-9, -8, -7, -2, -1
//	jbot:	-9, -8, -2, -1				//	jbbgm:	-9, -8, -7, -2, -1
//	jbonus: -9, -8, -7, -2, -1			//	jbbgy4:	-9, -8, -7, -2, -1
//	jbonam:	-9, -8, -7, -2, -1			//	jbsic:	-9, -8, -2, -1
//	jbrise:	-9, -8, -7, -2, -1			//	jbbgly:	-9, -8, -7, -2, -1
//	feend:	not used					//	jbperfp:-9, -8, -7, -2, -1
//	mrjsic:	-9, -8, -7, -3, -2, -1		// 	jbterm:	-9, -8, -7, -1
//  cjsten: -9, -7

foreach var of varlist race racel scend doid doim doiy4 jbstat jbsoc ///
jbsic92 jbhrs jbot jbonus jbonam jbrise tujbpl tuin1 mastat qfachi njbwks ///
njuwks njiwks fiyrl fiyr jbbgd jbbgm jbbgy4 jbsic jbbgly feend jbperfp ///
mrjsic jbterm region {
	recode `var' -9/-1 = .
}

// Now, we delete some observations where key variables are missing or smaller
// than zero (we delete them, as they may confound our summary stats)

//drop if fiyrl==.
//drop if fiyrl<=0
//drop if fiyr==.
//drop if fiyr<=0
//drop if jbonus==.
//drop if jbperfp==. & wave>=8
//drop if jbbgly==.
//drop if jbsect==.
//drop if hoh==.

// What about proxy values? About 5% in jbot, jbonus, jbonam, jbrise, tujbpl,
// tuin1, njiwks; and 7% in  qfachi, njbwks, njuwks, fiyr, fiyrl, jbbgm, 
// jbbgy4. How to solve this?
}
*******************************************************************************
*******************************************************************************

*******************************************************************************
*************************** Defining the variables ****************************
*******************************************************************************

//---------------------------------------------------------------------------//
//---------------------------- Bonus information ----------------------------//
//---------------------------------------------------------------------------//

// Generate bonus amount. Do we set up logarhithms here? Look at eventual 
// distribution. ISSUE! 2179 missing values after wave 7 (not corrected yet)!

generate bonam=jbonam/deflator
replace bonam=0 if (jbonus==2 & wave>=7)
replace bonam=. if (jbonus==. & wave>=7)
	label var bonam "Bonus amount"

// Generate bonus share.
generate bonshare = bonam/(fiyr)
	label var bonshare "Bonus share (annual income)"
generate bonsharel = bonam/(fiyrl)
	label var bonsharel "Bonus share (annual labour income)"

//---------------------------------------------------------------------------//
//-------------------------- (Log) Hourly earnings --------------------------//
//---------------------------------------------------------------------------//

// We will need to compare wages of different people on a comparable basis. 
// Therefore, we need to obtain the hourly wages. As wages are recorded on an
// annual basis and work hours on a weekly basis, we need to adjust for this.
// We calculate weeks worked over the year and multiply this by the hours
// worked in a standard week. We then can compare wages on an hourly basis.

//generate wksem=min(max(0,njbwks),53)
//	label var wksem "Weeks employed during the year"
//generate wksin=min(max(0,njiwks),53)
//	label var wksin "Weeks ianctive during the year"
//generate wksun=min(max(0,njuwks),53)
//	label var wksun "Weeks unemployed during the year"
//generate wks=max(0,wksem-wksin-wksun)
//	label var wks "Weeks worked during the year"
generate hrs=jbhrs*njbwks
	label var hrs "Hours worked during the year (excluding overtime)"
	drop if hrs==.
generate hrswkd=(jbhrs+jbot)*njbwks
	label var hrswkd "Hours worked during the year (including overtime)"
	drop if hrswkd==.
generate lnly = ln(fiyrl/deflator)
	label var lnly "Log of annual labour income"
	drop if lnly==.
generate lny = ln(fiyr/deflator)
	label var lny "Log of annual income"
	drop if lny==.
	
generate hy = (fiyr)/hrswkd/deflator
	label var hy "Hourly income"
	drop if hy==.
//generate hybonus = (fiyr+bonam)/hrswkd/deflator 
//replace hybonus = . if wave<7
//	label var hybonus "Hourly income (including bonus)"
//	drop if (hybonus==. & wave >=7)
generate hly = (fiyrl)/hrswkd/deflator
	label var hly "Hourly labour income"
	drop if hly==.
//generate hlybonus = (fiyrl+bonam)/hrswkd/deflator 
//replace hlybonus=. if wave<7
//	label var hlybonus "Hourly labour income (including bonus)"
//	drop if (hlybonus==. & wave >=7)
generate lnhy = ln(hy)
	label var lnhy "Log of hourly income"
	drop if lnhy==.
//generate lnhybonus = ln(hybonus)
//replace lnhybonus=. if wave<7
//	label var lnhybonus "Log of hourly income (including bonus)"
//	drop if (lnhybonus==. & wave >=7)
generate lnhly = ln(hly)
	label var lnhly "Log of hourly labour income"
	drop if lnhly==.
//generate lnhlybonus = ln(hlybonus)
//replace lnhlybonus=. if wave<7
//	label var lnhlybonus "Log of hourly labour income (including bonus)"
//	drop if (lnhlybonus==. & wave >=7)
	
//---------------------------------------------------------------------------//
//-------------------------------- Job tenure -------------------------------//
//---------------------------------------------------------------------------//

replace cjsten=cjsten/365
generate tenure=cjsten
drop if cjsten==.
by pid: replace tenure=wave - wave[_n-1] +tenure[_n-1] if jc2==0 & ///
tenure<tenure[_n-1] & _n!=1
replace tenure=max(0, tenure)

generate bonus=jbonus==1
	label var bonus "receives bonus"
generate performance=jbperfp==1
	label var performance "receives pay for performance"

generate jobchange=0
by pid: replace jobchange=1 if (tenure<tenure[_n-1] & _n!=1)
by pid: replace jobchange=1 if (cjsten<1 & _n==1)

by pid: generate jobs=sum(jobchange)
egen jobmatch=group(pid jobs)
	label var jobchange "Change of jobs"
	label var jobmatch "Jobmatch"
by pid: generate jobstot=1+jobs[_N] if jobchange[1]==0
by pid: replace jobstot=jobs[_N] if jobchange[1]==1
	label var jobstot ///
	"Total amount of jobs held by this person (not adjusted for promotion)"

*by pid: generate jobs4=sum(jobchange4)
*egen jobmatch4=group(pid jobs4)
*	label var jobchange4 "Change of jobs (adjusted for promotion)"
*	label var jobmatch4 "Jobmatch (adjusted for promotion)"
*by pid: generate jobstot4=1+jobs4[_N] if jobchange4[1]==0
*by pid: replace jobstot4=jobs4[_N] if jobchange4[1]==1
*	label var jobstot4 ///
*	"Total amount of jobs held by this person (adjusted for promotion)"

sort jobmatch, stable
by jobmatch: generate duration=_N
by jobmatch: egen bonusjob_junk1=total(bonus)
by jobmatch: generate bonusjob_junk2=bonusjob_junk/(_N)
by jobmatch: egen perfjob_junk=total(performance)

by jobmatch: generate bonusjob=1 if bonusjob_junk1!=0
by jobmatch: replace bonusjob=0 if bonusjob_junk1==0
	label var bonusjob "Bonusjob"
	
by jobmatch: generate perfjob=1 if perfjob_junk!=0
by jobmatch: replace perfjob=0 if perfjob_junk==0
	label var perfjob "Performance-pay job"
	
by jobmatch: generate bonusjobfifth=1 if bonusjob_junk2>=0.2
by jobmatch: replace bonusjobfifth=0 if bonusjob_junk2<0.2
	label var bonusjobfifth "At least 20% bonusjob"

by jobmatch: generate bonusjobhalf=1 if bonusjob_junk2>=0.5
by jobmatch: replace bonusjobhalf=0 if bonusjob_junk2<0.5
	label var bonusjobfifth "At least 50% bonusjob"
	
drop bonusjob_junk1 bonusjob_junk2

sum tenure if bonusjob==1
sum tenure if bonusjob==0
sum tenure if perfjob==1
sum tenure if perfjob==0
	
generate tenure1=max(wavey-jbbgy4,0)
replace tenure1=. if jbbgy4==.
	label var tenure1 "Job tenure (promotions counted as change)"
	drop if tenure1==.	
	
*sort jobmatch2, stable
*by jobmatch2: generate jbbgy4_junk=jbbgy4[1]
*generate tenure2=max(wavey-jbbgy4_junk,0)
*replace tenure2=. if jbbgy4==.
*	label var tenure2 "Job tenure (promotions not counted as change)"
*	drop if tenure2==.
*	drop jbbgy4_junk
*sort pid wave, stable

sort pid wave

//---------------------------------------------------------------------------//
//-------------------------- Performance pay dummy --------------------------//
//---------------------------------------------------------------------------//

// We now need to define jobmatches, job changes and determine whether or not
// the person was rewarded with performance pay while on the different jobs.

// => Variable (a): pp1 (does not consider promotion)
// Step 1: compare job change (month and year) to interview date.
// Step 2a: stop here

generate jobchange1=jbbgly==2
replace jobchange1=. if jbbgly==.
by pid: generate jobs1=sum(jobchange1)
egen jobmatch1=group(pid jobs1)
by pid: generate jobstot1=1
by pid: replace jobstot1=1+jobs1[_N] if jobchange1[1]==0
by pid: replace jobstot1=jobs1[_N] if jobchange1[1]==1
	drop jobs1
	label var jobchange1 "change of jobs (type 1)"
	label var jobmatch1 "jobmatch (type 1)"
	label var jobstot1 "total amount of jobs (type 1)"
generate index=_n
sort jobmatch1, stable
by jobmatch1: generate duration1=_N
by jobmatch1: egen bj_junk1_=total(bonus)
by jobmatch1: generate bj_junk1=bj_junk1_/(_N)
by jobmatch1: generate bonusjob1=1 if bj_junk1!=0
by jobmatch1: replace bonusjob1=0 if bj_junk1==0
by jobmatch1: generate bonusjob1fifth=1 if bj_junk1>=0.2
by jobmatch1: replace bonusjob1fifth=0 if bj_junk1<0.2
by jobmatch1: generate bonusjob1half=1 if bj_junk1>=0.5
by jobmatch1: replace bonusjob1half=0 if bj_junk1<0.5
by jobmatch1: egen pj_junk1=total(performance)
by jobmatch1: generate perfjob1=1 if pj_junk1!=0
by jobmatch1: replace perfjob1=0 if pj_junk1==0
drop bj_junk1 bj_junk1_ pj_junk1
	label var bonusjob1 "Bonus job indicator (type 1)"
	label var perfjob1 "Performance Pay job indicator (type 1)"
	label var duration1 "Amount of times job match observed (type 1)"
sort index
drop index
sort pid wave, stable

// => Variable (b): pp2 (considers promotion)
// Step 1: compare job change (month and year) to interview date.
// Step 2a: check if the change was a promotion or not.

replace jc2=0 if jc2==.
replace jc3=0 if jc3==.
generate jobchange2=0 
replace jobchange2=1 if (jbbgly==2 & jc2==1)
// We define a jobchange when the respondent reports a new position, but no 
// promotion.
replace jobchange2=. if jbbgly==.
by pid: generate jobs2=sum(jobchange2)
egen jobmatch2=group(pid jobs2)
by pid: generate jobstot2=1
by pid: replace jobstot2=1+jobs2[_N] if jobchange1[1]==0
by pid: replace jobstot2=jobs2[_N] if jobchange1[1]==1
	drop jobs2
	label var jobchange2 "change of jobs (type 2)"
	label var jobmatch2 "jobmatch (type 2)"
	label var jobstot2 "total amount of jobs (type 2)"
generate index=_n
sort jobmatch2, stable
by jobmatch2: generate duration2=_N
by jobmatch2: egen bj_junk2_=total(bonus)
by jobmatch2: generate bj_junk2=bj_junk2_/(_N)
by jobmatch2: generate bonusjob2=1 if bj_junk2!=0
by jobmatch2: replace bonusjob2=0 if bj_junk2==0
by jobmatch2: generate bonusjob2fifth=1 if bj_junk2>=0.2
by jobmatch2: replace bonusjob2fifth=0 if bj_junk2<0.2
by jobmatch2: generate bonusjob2half=1 if bj_junk2>=0.5
by jobmatch2: replace bonusjob2half=0 if bj_junk2<0.5
by jobmatch2: egen pj_junk2=total(performance)
by jobmatch2: generate perfjob2=1 if pj_junk2!=0
by jobmatch2: replace perfjob2=0 if pj_junk2==0
drop bj_junk2 pj_junk2
	label var bonusjob2 "Bonus job indicator (type 2)"
	label var perfjob2 "Performance Pay job indicator (type 2)"
	label var duration2 "Amount of times job match observed (type 2)"
sort index
drop index
sort pid wave, stable

//---------------------------------------------------------------------------//
//---------------------------- job match dummies ----------------------------//
//---------------------------------------------------------------------------//

// set up dummy variables for the amount of job matches a individual has.

foreach x in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18{
	generate type1matches`x'=jobstot1==`x'
	replace type1matches`x'=. if jobchange1==.
}

foreach x in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18{
	generate type2matches`x'=jobstot2==`x'
	replace type2matches`x'=. if jobchange2==.
}

//---------------------------------------------------------------------------//
//-------------------------------- Education --------------------------------//
//---------------------------------------------------------------------------//

generate Q12=0
replace Q12=1 if qfachi==1 | qfachi==2
replace Q12=. if qfachi==.
	label var Q12 "Higher or first degree qualification"

generate Q1=0
replace Q1=1 if qfachi==1
replace Q1=. if qfachi==.
	label var Q1 "Higher degree qualification"

generate Q2=0
replace Q2=1 if qfachi==2
replace Q2=. if qfachi==.
	label var Q2 "First degree qualification"

generate Q3=0
replace Q3=1 if qfachi==3
replace Q3=. if qfachi==.
	label var Q3 "HND, HNC, teaching qualification"

generate Q4=0
replace Q4=1 if qfachi==4
replace Q4=. if qfachi==.
	label var Q4 "A level qualification"

generate Q5=0 
replace Q5=1 if qfachi==5
replace Q5=. if qfachi==.
	label var Q5 "O level qualification"

generate Q6=0 
replace Q6=1 if qfachi==6
replace Q6=. if qfachi==.
	label var Q6 "CSE qualification"
	
generate Q7=0 
replace Q7=1 if qfachi==7
replace Q7=. if qfachi==.
	label var Q7 "None of these"

drop if qfachi==.

generate university=Q12==1
generate diploma=Q3==1
generate Alevel=Q4==1

//---------------------------------------------------------------------------//
//--------------------------- Potential experience --------------------------//
//---------------------------------------------------------------------------//

// We have scend (1240 missing values for this), but people that are student at
// the beginning of the panel and get jobs later on do not get at scend marker. 
// I code a simple command that sets the school leaving age to that age where 
// the person left school.

generate ftstud=jbstat==7
by pid: generate leftschool=age[_n-1] if (jbstat[_n-1]==7 & scend[_n-1]==. ///
& jbstat[_n]!=7)
by pid: egen sla_junk=total(leftschool)
generate sla=scend
replace sla=sla_junk if scend==.
replace sla=. if (scend==. & sla_junk==0)
	drop ftstud leftschool sla_junk

// Now cross school leaving age with further education attended.
// 1: Higher degree				5: O level
// 2: 1st degree				6: CSE
// 3: HND, HNC, teaching		7: None
// 4: A level
generate yeq=0
replace yeq=1 if qfachi==1
replace yeq=3 if qfachi==2
replace yeq=2 if qfachi==3
replace yeq=2 if qfachi==4
replace yeq=0 if qfachi==5
replace yeq=0 if qfachi==6
replace yeq=0 if qfachi==7
replace yeq=. if qfachi==.
// Assumption made on year-equivalents: look up online?
// http://courses.essex.ac.uk/ec/ec831/lecture_notes/Paul.Fisher.Lecture.Notes.pdf
// 4 years + 18 years (higher degree) / 17 years (first degree) / 14 years (a level)
// 12 years (GCSE/o-level/none of these)
generate exp1=max(age-sla-yeq,0)
	drop yeq sla
	label var exp1 "Total potential experience (type 1)"
generate yeq=18 if qfachi==1
replace yeq=17 if qfachi==2
replace yeq=15 if qfachi==3
replace yeq=14 if qfachi==4
replace yeq=12 if qfachi==5 | qfachi==6 | qfachi==7
generate exp2=age-yeq
	label var yeq "Year equivalent schooling"
	label var exp2 "Total potential experience (type 2)"


//---------------------------------------------------------------------------//
//-------------------------------- Ethnicity --------------------------------//
//---------------------------------------------------------------------------//

generate nonwhite=1
replace nonwhite=0 if race==1 | racel==1 | racel==2 | racel==3 | racel==4 ///
| racel==5
replace nonwhite=. if (race==. & racel==.)
	label var nonwhite "nonwhite dummy (ethnicity)"
	drop race racel
	drop if nonwhite==.


//---------------------------------------------------------------------------//
//------------------------------ Marital status -----------------------------//
//---------------------------------------------------------------------------//

generate married=mastat==1
replace married=1 if mastat==7
replace married=. if mastat==.
	label var married "Marital status (dummy)"
	drop if married==.
	
//---------------------------------------------------------------------------//
//-------------------------- Rising wage agreement --------------------------//
//---------------------------------------------------------------------------//

generate rising=jbrise==1
replace rising=. if jbrise==.
	label var rising "Rising wage agreement (dummy)"
	drop if rising==.

//---------------------------------------------------------------------------//
//------------------------------ Contract type-------------------------------//
//---------------------------------------------------------------------------//

generate permanent=jbterm==1
replace permanent=1 if jbterm1==1
replace permanent=. if jbterm==. & jbterm1==.
	label var permanent "Permanent job (dummy)"
	drop if permanent==.

//---------------------------------------------------------------------------//
//------------------------------ Union status -------------------------------//
//---------------------------------------------------------------------------//

generate cba=tujbpl==1
replace cba=. if tujbpl==.
	label var cba "Union at workplace (dummy)"
	drop if cba==.

generate union=0
replace union=1 if tuin1==1 & tujbpl==1
replace union=. if tujbpl==.
	label var union "Union member (dummy)"
	drop if union==.

//---------------------------------------------------------------------------//
//--------------------------- SIC and SOC dummies ---------------------------//
//---------------------------------------------------------------------------//

// First, we need to deal with the fact that we have jbsic, jbsic92 and mrjsic.
// Since jbsic and mrjsic are always equal to each, we give priority to mrjsic.
// As sic1992 is not a clear mapping of sic1980, we need to use a conversion
// table (source: http://www.list-logic.co.uk/downloads/free-products/free-standard-industrial-classification-codes-list.html,
// website: http://www.list-logic.co.uk/). Another available conversion table
// was available at LSE RLAB; however, this conversion converted 5 digit 1992 
// SIC codes to 4 digit 1980 SIC codes. Converted jbsic92 numbers are available
// under the variable sic_junk. We now convert these three available codes to
// one variable (sic_dummy) and set up dummies.

//  According to sic1980, we have the following industries
//	sic0:	Agriculture, forestry & fishing
//	sic1:	Energy & water supplies
//	sic2:	Extraction of minerals & ores other than fuels; manufacture of
//			metals, mineral products & chemicals
//	sic3:	Metal goods, engineering & vehicles industries
//	sic4:	Other manufacturing industries
//	sic5:	Construction
//	sic6:	Distribution, hotels & catering (repairs)
//	sic7:	Transport & communication
//	sic8:	Banking, finance, insurance, business services & leasing
//	sic9:	Other services

replace mrjsic=mrjsic[_n-1] if (jbsic92==jbsic92[_n-1] & mrjsic==.)
generate sic_dummy=jbsic
replace sic_dummy=mrjsic if (jbsic==. & mrjsic!=.)
replace sic_dummy=mrj
replace sic_dummy=sic_junk if (jbsic==. & mrjsic==.)
replace sic_dummy=. if (jbsic==. & mrjsic==. & sic_junk==.)

generate sic0=0
replace sic0=1 if sic_dummy>=000 & sic_dummy<=999

generate sic1=0
replace sic1=1 if sic_dummy>=1000 & sic_dummy<=1999

generate sic2=0
replace sic2=1 if sic_dummy>=2000 & sic_dummy<=2999

generate sic3=0
replace sic3=1 if sic_dummy>=3000 & sic_dummy<=3999

generate sic4=0
replace sic4=1 if sic_dummy>=4000 & sic_dummy<=4999

generate sic5=0
replace sic5=1 if sic_dummy>=5000 & sic_dummy<=5999

generate sic6=0
replace sic6=1 if sic_dummy>=6000 & sic_dummy<=6999

generate sic7=0
replace sic7=1 if sic_dummy>=7000 & sic_dummy<=7999

generate sic8=0
replace sic8=1 if sic_dummy>=8000 & sic_dummy<=8999

generate sic9=0
replace sic9=1 if sic_dummy>=9000 & sic_dummy<=9999

foreach x in 0 1 2 3 4 5 6 7 8 9 {
	replace sic`x'=. if sic_dummy==.
	label var sic`x' "SIC industry `x' (dummy)"
}

drop if sic_dummy==.
drop sic_junk sic_dummy

//  According to SOC, we have the following occupations
//	soc1:	Managers & administrators
//	soc2:	Professional occupators
//	soc3:	Associate professional & technical occupations
//	soc4:	Clerical & secretarial occupations
//	soc5:	Craft & related occupations
//	soc6:	Personal & protective service occupations
//	soc7:	Sales occupations
//	soc8:	Plant & machine operatives
//	soc9:	Other occupations

generate soc1=0
replace soc1=1 if jbsoc>=100 & jbsoc<=199

generate soc2=0
replace soc2=1 if jbsoc>=200 & jbsoc<=299

generate soc3=0
replace soc3=1 if jbsoc>=300 & jbsoc<=399

generate soc4=0
replace soc4=1 if jbsoc>=400 & jbsoc<=499

generate soc5=0
replace soc5=1 if jbsoc>=500 & jbsoc<=599

generate soc6=0
replace soc6=1 if jbsoc>=600 & jbsoc<=699

generate soc7=0
replace soc7=1 if jbsoc>=700 & jbsoc<=799

generate soc8=0
replace soc8=1 if jbsoc>=800 & jbsoc<=899

generate soc9=0
replace soc9=1 if jbsoc>=900 & jbsoc<=999

foreach x in 1 2 3 4 5 6 7 8 9 {
	replace soc`x'=. if jbsoc==.
	label var soc`x' "SOC occupation `x' (dummy)"
}

drop if jbsoc==.

//---------------------------------------------------------------------------//
//----------------------- dummies for calendar years ------------------------//
//---------------------------------------------------------------------------//

foreach x in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18{
	generate cyear`x'=wave==`x'
	label var cyear`x' "calendar year `x'"
}

//---------------------------------------------------------------------------//
//--------- Old code with a lot of tricks that may come in helpful ----------//
//---------------------------------------------------------------------------//
//drop if jbbgy4==.
//by pid: generate multip=wave[1]!=wave[_N]
//generate job=1
//by pid: replace job=job[_n-1]+multip if (jbbgy4!=jbbgy4[_n-1] & ///
//jbbgy4[_n-1]!=.)
//by pid: replace job=job[_n-1] if (jbbgy4==jbbgy4[_n-1] & jbbgy4[_n-1]!=.)
//by pid: replace job=job[_n-1]+multip if (jbbgy4!=jbbgy4[_n-1] & ///
//jbbgy4[_n-1]!=.)
//replace job=. if jbbgy4==.
//	label var job "jobs observed per person (running sum)"
//order pid multip job jbbgy4
//drop multip
//generate bon=jbonus==1
//replace bon=. if jbonus==.
//	label var bon "Bonus receipt this year"
//egen jobmatchid=group(pid job)
//generate index=_n
//bysort jobmatchid: egen ppp=total(bon)
//replace ppp=. if jobmatchid==.
//by jobmatchid: generate pp=0
//by jobmatchid: replace pp=1 if ppp!=0
//by jobmatchid: replace pp=. if jobmatchid==.
//drop ppp
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

*******************************************************************************
*******************************************************************************

*******************************************************************************
********************************* Cleaning up *********************************
*******************************************************************************

drop if fiyrl==.
drop if fiyrl<=0
drop if fiyr==.
drop if fiyr<=0
drop if jbonus==.
drop if jbperfp==. & wave>=8
drop if jbbgly==.
drop if jbsect==.
drop if hoh==.
drop if region==.
drop if hly<1
drop if hly>100
drop if hrswkd<1000
drop if hrswkd>4500

generate exp12=exp1*exp1
generate exp13=exp1*exp1*exp1
generate exp14=exp1*exp1*exp1*exp1
generate exp15=exp1*exp1*exp1*exp1*exp1
generate tenure2=tenure*tenure
generate tenure3=tenure*tenure*tenure
generate tenure4=tenure*tenure*tenure*tenure
generate tenure5=tenure*tenure*tenure*tenure*tenure

foreach x in 1 2 3 4 5 6 {
	generate ME`x'=0
}

replace ME1=1 if wave==1 | wave==2 | wave==3
replace ME2=1 if wave==4 | wave==5 | wave==6
replace ME3=1 if wave==7 | wave==8 | wave==9
replace ME4=1 if wave==10 | wave==11 | wave==12
replace ME5=1 if wave==13 | wave==14 | wave==15
replace ME6=1 if wave==16 | wave==17 | wave==18
generate ME = 1*ME1 + 2*ME2 + 3*ME3 + 4*ME4 + 5*ME5 + 6*ME6

save BHPS, replace

//drop jhstpy jc2 jc3 scend feend doid doim doiy4 jbsoc jbsic jbsic92 jbsemp ///
//jbhrs jbot jbperfp jbonus jbonam jbrise tujbpl tuin1 mastat qfachi njbwks ///
//njuwks njiwks fiyrl fiyr mrjsic jbbgd jbbgm jbbgy4 jc1 jbbgly jbterm ///
//jbterm1 jbsect jbstat sex deflator 

*******************************************************************************
*******************************************************************************

*******************************************************************************
******************************** Summary Stats ********************************
*******************************************************************************

sum hly exp1 exp2 age tenure1 tenure married nonwhite union yeq hrswkd ///
if bonusjob==1
sum hly exp1 exp2 age tenure1 tenure married nonwhite union yeq hrswkd ///
if bonusjob==0
sum university diploma Alevel if bonusjob==1
sum Q1 Q2 Q3 Q4 Q5 Q6 Q7 if bonusjob==1
sum university diploma Alevel if bonusjob==0
sum Q1 Q2 Q3 Q4 Q5 Q6 Q7 if bonusjob==0

********************************************************************************
********************************************************************************
