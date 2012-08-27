*******************************************************************************
***************************** Setting up Table 2 ******************************
*******************************************************************************

quietly{
set more off
svyset [pweight = lrwght]

// Calculate averages per group.

sort ME, stable

by ME: egen incidence1=mean(bonusjob1)
by ME: egen incidence2=mean(bonusjob2)
by ME: egen incidencefifth1=mean(bonusjob1fifth)
by ME: egen incidencefifth2=mean(bonusjob2fifth)
by ME: egen incidencehalf1=mean(bonusjob1half)
by ME: egen incidencehalf2=mean(bonusjob2half)

egen meandur1_ = mean(duration1) if ME==1
egen meandur1 = mean(meandur1_)
egen meanexp11_ = mean(exp1) if ME==1
egen meanexp11 = mean(meanexp11_)
egen meanexp21_ = mean(exp12) if ME==1
egen meanexp21 = mean(meanexp21_)
egen meanexp31_ = mean(exp13) if ME==1
egen meanexp31 = mean(meanexp31_)
egen meanexp41_ = mean(exp14) if ME==1
egen meanexp41 = mean(meanexp41_)
egen meanexp51_ = mean(exp15) if ME==1
egen meanexp51 = mean(meanexp51_)
egen meanten11_ = mean(tenure) if ME==1
egen meanten11 = mean(meanten11_)
egen meanten21_ = mean(tenure2) if ME==1
egen meanten21 = mean(meanten21_)
egen meanten31_ = mean(tenure3) if ME==1
egen meanten31 = mean(meanten31_)
egen meanten41_ = mean(tenure4) if ME==1
egen meanten41 = mean(meanten41_)
egen meanten51_ = mean(tenure5) if ME==1
egen meanten51 = mean(meanten51_)
egen meannonwhite1_ = mean(nonwhite) if ME==1
egen meannonwhite1 = mean(meannonwhite1_)
egen meanmarried1_ = mean(married) if ME==1
egen meanmarried1 = mean(meanmarried1_)
egen meancba1_ = mean(cba) if ME==1
egen meancba1 = mean(meancba1_)
egen meanunion1_ = mean(union) if ME==1
egen meanunion1 = mean(meanunion1_)
egen meansic11_ = mean(sic1) if ME==1
egen meansic11 = mean(meansic11_)
egen meansic21_ = mean(sic2) if ME==1
egen meansic21 = mean(meansic21_)
egen meansic31_ = mean(sic3) if ME==1
egen meansic31 = mean(meansic31_)
egen meansic41_ = mean(sic4) if ME==1
egen meansic41 = mean(meansic41_)
egen meansic51_ = mean(sic5) if ME==1
egen meansic51 = mean(meansic51_)
egen meansic61_ = mean(sic6) if ME==1
egen meansic61 = mean(meansic61_)
egen meansic71_ = mean(sic7) if ME==1
egen meansic71 = mean(meansic71_)
egen meansic81_ = mean(sic8) if ME==1
egen meansic81 = mean(meansic81_)
egen meansic91_ = mean(sic9) if ME==1
egen meansic91 = mean(meansic91_)
egen meansic01_ = mean(sic0) if ME==1
egen meansic01 = mean(meansic01_)
egen meansoc11_ = mean(soc1) if ME==1
egen meansoc11 = mean(meansoc11_)
egen meansoc21_ = mean(soc2) if ME==1
egen meansoc21 = mean(meansoc21_)
egen meansoc31_ = mean(soc3) if ME==1
egen meansoc31 = mean(meansoc31_)
egen meansoc41_ = mean(soc4) if ME==1
egen meansoc41 = mean(meansoc41_)
egen meansoc51_ = mean(soc5) if ME==1
egen meansoc51 = mean(meansoc51_)
egen meansoc61_ = mean(soc6) if ME==1
egen meansoc61 = mean(meansoc61_)
egen meansoc71_ = mean(soc7) if ME==1
egen meansoc71 = mean(meansoc71_)
egen meansoc81_ = mean(soc8) if ME==1
egen meansoc81 = mean(meansoc81_)
egen meansoc91_ = mean(soc9) if ME==1
egen meansoc91 = mean(meansoc91_)

egen meandur8_ = mean(duration1) if ME==6
egen meandur8 = mean(meandur8_)
egen meanexp18_ = mean(exp1) if ME==6
egen meanexp18 = mean(meanexp18_)
egen meanexp28_ = mean(exp12) if ME==6
egen meanexp28 = mean(meanexp28_)
egen meanexp38_ = mean(exp13) if ME==6
egen meanexp38 = mean(meanexp38_)
egen meanexp48_ = mean(exp14) if ME==6
egen meanexp48 = mean(meanexp48_)
egen meanexp58_ = mean(exp15) if ME==6
egen meanexp58 = mean(meanexp58_)
egen meanten18_ = mean(tenure) if ME==6
egen meanten18 = mean(meanten18_)
egen meanten28_ = mean(tenure2) if ME==6
egen meanten28 = mean(meanten28_)
egen meanten38_ = mean(tenure3) if ME==6
egen meanten38 = mean(meanten38_)
egen meanten48_ = mean(tenure4) if ME==6
egen meanten48 = mean(meanten48_)
egen meanten58_ = mean(tenure5) if ME==6
egen meanten58 = mean(meanten58_)
egen meannonwhite8_ = mean(nonwhite) if ME==6
egen meannonwhite8 = mean(meannonwhite8_)
egen meanmarried8_ = mean(married) if ME==6
egen meanmarried8 = mean(meanmarried8_)
egen meancba8_ = mean(cba) if ME==6
egen meancba8 = mean(meancba8_)
egen meanunion8_ = mean(union) if ME==6
egen meanunion8 = mean(meanunion8_)
egen meansic18_ = mean(sic1) if ME==6
egen meansic18 = mean(meansic18_)
egen meansic28_ = mean(sic2) if ME==6
egen meansic28 = mean(meansic28_)
egen meansic38_ = mean(sic3) if ME==6
egen meansic38 = mean(meansic38_)
egen meansic48_ = mean(sic4) if ME==6
egen meansic48 = mean(meansic48_)
egen meansic58_ = mean(sic5) if ME==6
egen meansic58 = mean(meansic58_)
egen meansic68_ = mean(sic6) if ME==6
egen meansic68 = mean(meansic68_)
egen meansic78_ = mean(sic7) if ME==6
egen meansic78 = mean(meansic78_)
egen meansic88_ = mean(sic8) if ME==6
egen meansic88 = mean(meansic88_)
egen meansic98_ = mean(sic9) if ME==6
egen meansic98 = mean(meansic98_)
egen meansic08_ = mean(sic0) if ME==6
egen meansic08 = mean(meansic08_)
egen meansoc18_ = mean(soc1) if ME==6
egen meansoc18 = mean(meansoc18_)
egen meansoc28_ = mean(soc2) if ME==6
egen meansoc28 = mean(meansoc28_)
egen meansoc38_ = mean(soc3) if ME==6
egen meansoc38 = mean(meansoc38_)
egen meansoc48_ = mean(soc4) if ME==6
egen meansoc48 = mean(meansoc48_)
egen meansoc58_ = mean(soc5) if ME==6
egen meansoc58 = mean(meansoc58_)
egen meansoc68_ = mean(soc6) if ME==6
egen meansoc68 = mean(meansoc68_)
egen meansoc78_ = mean(soc7) if ME==6
egen meansoc78 = mean(meansoc78_)
egen meansoc88_ = mean(soc8) if ME==6
egen meansoc88 = mean(meansoc88_)
egen meansoc98_ = mean(soc9) if ME==6
egen meansoc98 = mean(meansoc98_)

local xlist "exp1 exp12 nonwhite married cba union tenure tenure2 sic1 sic2 sic3 sic4 sic5 sic6 sic7 sic8 sic9 soc2 soc3 soc4 soc5 soc6 soc7 soc8 soc9 ME2 ME3 ME4 ME5 ME6"
local bonusjob "bonusjob"
local jobmatch "jobmatch"

//---------------------------------------------------------------------------//
//------------------------- LPM (type 1 bonus job) --------------------------//
//---------------------------------------------------------------------------//

reg `bonusjob' duration1 `xlist', vce(cluster `jobmatch')

generate coeffb = _b[_cons]
generate coeffdur = _b[duration1]
generate coeffexp1 = _b[exp1]
generate coeffexp2 = _b[exp12]
*generate coeffexp3 = _b[exp13]
*generate coeffexp4 = _b[exp14]
*generate coeffexp5 = _b[exp15]
generate coefftenure1 = _b[tenure]
generate coefftenure2 = _b[tenure2]
*generate coefftenure3 = _b[tenure3]
*generate coefftenure4 = _b[tenure4]
*generate coefftenure5 = _b[tenure5]
generate coeffmarried = _b[married]
generate coeffnw = _b[nonwhite]
generate coeffcba = _b[cba]
generate coeffunion = _b[union]
generate coeffsic1 = _b[sic1]
generate coeffsic2 = _b[sic2]
generate coeffsic3 = _b[sic3]
generate coeffsic4 = _b[sic4]
generate coeffsic5 = _b[sic5]
generate coeffsic6 = _b[sic6]
generate coeffsic7 = _b[sic7]
generate coeffsic8 = _b[sic8]
generate coeffsic9 = _b[sic9]
generate coeffsoc2 = _b[soc2]
generate coeffsoc3 = _b[soc3]
generate coeffsoc4 = _b[soc4]
generate coeffsoc5 = _b[soc5]
generate coeffsoc6 = _b[soc6]
generate coeffsoc7 = _b[soc7]
generate coeffsoc8 = _b[soc8]
generate coeffsoc9 = _b[soc9]

generate result_1_all = coeffb + coeffdur*meandur1 + coeffexp1*meanexp11 + ///
coeffexp2*meanexp21 + coefftenure1*meanten11 + coefftenure2*meanten21 + ///
coeffmarried*meanmarried1 + coeffnw*meannonwhite1 + coeffcba*meancba1 + ///
coeffunion*meanunion1 + coeffsic1*meansic11 + coeffsic2*meansic21 + ///
coeffsic3*meansic31 + coeffsic4*meansic41 + coeffsic5*meansic51 + ///
coeffsic6*meansic61 + coeffsic7*meansic71 + coeffsic8*meansic81 + ///
coeffsic9*meansic91 + coeffsoc2*meansoc21 + coeffsoc3*meansoc31 + ///
coeffsoc4*meansoc41 + coeffsoc5*meansoc51 + coeffsoc6*meansoc61 + ///
coeffsoc7*meansoc71 + coeffsoc8*meansoc81 + coeffsoc9*meansoc91

// => this is the LPM-predicted incidence in period 1!

generate result_6_all = coeffb + coeffdur*meandur8 + coeffexp1*meanexp18 + ///
coeffexp2*meanexp28 + coefftenure1*meanten18 + coefftenure2*meanten28 + ///
coeffmarried*meanmarried8 + coeffnw*meannonwhite8 + coeffcba*meancba8 + ///
coeffunion*meanunion8 + coeffsic1*meansic18 + coeffsic2*meansic28 + ///
coeffsic3*meansic38 + coeffsic4*meansic48 + coeffsic5*meansic58 + ///
coeffsic6*meansic68 + coeffsic7*meansic78 + coeffsic8*meansic88 + ///
coeffsic9*meansic98 + coeffsoc2*meansoc28 + coeffsoc3*meansoc38 + ///
coeffsoc4*meansoc48 + coeffsoc5*meansoc58 + coeffsoc6*meansoc68 + ///
coeffsoc7*meansoc78 + coeffsoc8*meansoc88 + coeffsoc9*meansoc98

// => this is the LPM-predicted incidence in period 8!

display _b[ME6]
// => this is the adjusted change between periods (significant)!

generate change_dur_all = coeffdur*(meandur8-meandur1)

generate change_sic_all = coeffsic1*(meansic18-meansic11) + ///
coeffsic2*(meansic28-meansic21) + coeffsic3*(meansic38-meansic31) + ///
coeffsic4*(meansic48-meansic41) + coeffsic5*(meansic58-meansic51) + ///
coeffsic6*(meansic68-meansic61) + coeffsic7*(meansic78-meansic71) + ///
coeffsic8*(meansic88-meansic81) + coeffsic9*(meansic98-meansic91)        
         
generate change_soc_all =  ///
coeffsic2*(meansoc28-meansoc21) + coeffsoc3*(meansoc38-meansoc31) + ///
coeffsic4*(meansoc48-meansoc41) + coeffsoc5*(meansoc58-meansoc51) + ///
coeffsic6*(meansoc68-meansoc61) + coeffsoc7*(meansoc78-meansoc71) + ///
coeffsic8*(meansoc88-meansoc81) + coeffsoc9*(meansoc98-meansoc91)

}

sum result_1_all result_6_all change_dur_all change_sic_all change_soc_all

drop meandur* meanexp* meanten* meanmarried* 
drop meannonwhite* meansic* meansoc* coeff*
drop result_1_* result_6_* change_dur_* change_sic_* change_soc_*
drop meanunion* meancba*

//---------------------------------------------------------------------------//
//-------------- LPM (type 1 bonus job - endpoint adjusted) -----------------//
//---------------------------------------------------------------------------//

preserve

drop if ME==1

reg bonusjob1 duration1 `xlist'

sum duration1 married nonwhite union cba exp1 tenure1 sic* soc* if ME==2

display _b[_cons] + _b[duration1]*5.133658 + _b[married]*.5729823 + ///
_b[nonwhite]*.0300515 + _b[union]*.2384087 + _b[cba]*.3586148 + ///
_b[exp1]*18.85633 + _b[exp12]*18.85633*18.85633 + ///
_b[exp13]*18.85633*18.85633*18.85633 + _b[tenure1]*4.159702 + ///
_b[tenure12]*4.159702*4.159702 + _b[sic1]*.0380653 + _b[sic2]*.066972 + ///
_b[sic3]*.1923297 + _b[sic4]*.1579851 + _b[sic5]*.0492272 + _b[sic6]*.1949056 ///
+ _b[sic7]*.079565 + _b[sic8]*.1657127 + _b[sic9]*.0383515 + ///
_b[soc2]*.0818546 + _b[soc3]*.0901546 + _b[soc4]*.0941614 + ///
_b[soc5]*.2103606 + _b[soc6]*.0329136 + _b[soc7]*.0609616 + ///
_b[soc8]*.1823125 + _b[soc9]*.0506583 
// => this is the LPM-predicted incidence in period 1!

display _b[_cons] + _b[duration1]*5.140264 + _b[married]*.5572057 + ///
_b[nonwhite]*.0249358 + _b[union]*.2004034 + _b[cba]*.3601027 + ///
_b[exp1]*21.93033 + _b[exp12]*21.93033*21.93033 + ///
_b[exp13]*21.93033*21.93033*21.93033 + _b[tenure1]*5.274111 + ///
_b[tenure12]*5.274111*5.274111 + _b[sic1]*.0491382 + _b[sic2]*.0489549 + ///
_b[sic3]*.1409974 + _b[sic4]*.1142281 + _b[sic5]*.1030436 + ///
_b[sic6]*.2024202 + _b[sic7]*.1015768 + _b[sic8]*.1642831 + ///
_b[sic9]*.063623 + _b[soc2]*.0702237 + _b[soc3]*.1056106 + ///
_b[soc4]*.0740741  + _b[soc5]*.2071874 + _b[soc6]*.0341034 + ///
_b[soc7]*.0522552 + _b[soc8]*.1505317 + _b[soc9]*.0663733 
// => this is the LPM-predicted incidence in period 2!

display _b[ME6]
// => this is the adjusted change between periods (significant)!

sum duration1 married nonwhite union cba exp1 tenure1 sic* soc* if ME==6 
display _b[duration1]*(5.140264-5.133658)
display _b[cba]*(.3601027-.3586148)
display _b[union]*(.2004034-.2384087)

display _b[sic1]*(.0491382-.0380653) + _b[sic2]*(.0489549-.066972) ///
+ _b[sic3]*(.1409974-.1923297) + _b[sic4]*(.1142281-.1579851) + ///
_b[sic5]*(.1030436-.0492272) + _b[sic6]*(.2024202-.1949056) + ///
_b[sic7]*(.1015768-.079565) + _b[sic8]*(.1642831-.1657127) + ///
_b[sic9]*(.063623-.0383515)                 

display _b[soc2]*(.0702237-.0818546) + _b[soc3]*(.1056106-.0901546) ///
+ _b[soc4]*(.0740741-.0941614) + _b[soc5]*(.2071874-.2103606) + ///
_b[soc6]*(.0341034-.0329136) + _b[soc7]*(.0522552-.0609616) + ///
_b[soc8]*(.1505317-.1823125) + _b[soc9]*(.0663733-.0506583)
// => Sum other factors to get change.

restore

// Also performed logit on this, but results were a bit crazy. Does that mean 
// something about my sample?

//---------------------------------------------------------------------------//
//------------------------- LPM (type 2 bonus job) --------------------------//
//---------------------------------------------------------------------------//

// Note that the descriptive stats do not change, except duration2!!!

preserve

drop if ME==1

reg bonusjob2 duration2 `xlist'

sum duration2 if ME==2

display _b[_cons] + _b[duration2]*6.489124 + _b[married]*.5729823 + ///
_b[nonwhite]*.0300515 + _b[union]*.2384087 + _b[cba]*.3586148 + ///
_b[exp1]*18.85633 + _b[exp12]*18.85633*18.85633 + ///
_b[exp13]*18.85633*18.85633*18.85633 + _b[tenure1]*4.159702 + ///
_b[tenure12]*4.159702*4.159702 + _b[sic1]*.0380653 + _b[sic2]*.066972 + ///
_b[sic3]*.1923297 + _b[sic4]*.1579851 + _b[sic5]*.0492272 + _b[sic6]*.1949056 ///
+ _b[sic7]*.079565 + _b[sic8]*.1657127 + _b[sic9]*.0383515 + ///
_b[soc2]*.0818546 + _b[soc3]*.0901546 + _b[soc4]*.0941614 + ///
_b[soc5]*.2103606 + _b[soc6]*.0329136 + _b[soc7]*.0609616 + ///
_b[soc8]*.1823125 + _b[soc9]*.0506583 
// => this is the LPM-predicted incidence in period 1!

display _b[_cons] + _b[duration2]*6.06619 + _b[married]*.5572057 + ///
_b[nonwhite]*.0249358 + _b[union]*.2004034 + _b[cba]*.3601027 + ///
_b[exp1]*21.93033 + _b[exp12]*21.93033*21.93033 + ///
_b[exp13]*21.93033*21.93033*21.93033 + _b[tenure1]*5.274111 + ///
_b[tenure12]*5.274111*5.274111 + _b[sic1]*.0491382 + _b[sic2]*.0489549 + ///
_b[sic3]*.1409974 + _b[sic4]*.1142281 + _b[sic5]*.1030436 + ///
_b[sic6]*.2024202 + _b[sic7]*.1015768 + _b[sic8]*.1642831 + ///
_b[sic9]*.063623 + _b[soc2]*.0702237 + _b[soc3]*.1056106 + ///
_b[soc4]*.0740741  + _b[soc5]*.2071874 + _b[soc6]*.0341034 + ///
_b[soc7]*.0522552 + _b[soc8]*.1505317 + _b[soc9]*.0663733 
// => this is the LPM-predicted incidence in period 2!

display _b[ME6]
// => this is the adjusted change between periods (insignificant)!

display _b[duration2]*(6.06619-6.489124)
display _b[cba]*(.3601027-.3586148)
display _b[union]*(.2004034-.2384087)

display _b[sic1]*(.0491382-.0380653) + _b[sic2]*(.0489549-.066972) ///
+ _b[sic3]*(.1409974-.1923297) + _b[sic4]*(.1142281-.1579851) + ///
_b[sic5]*(.1030436-.0492272) + _b[sic6]*(.2024202-.1949056) + ///
_b[sic7]*(.1015768-.079565) + _b[sic8]*(.1642831-.1657127) + ///
_b[sic9]*(.063623-.0383515)                 // => -.00391079

display _b[soc2]*(.0702237-.0818546) + _b[soc3]*(.1056106-.0901546) ///
+ _b[soc4]*(.0740741-.0941614) + _b[soc5]*(.2071874-.2103606) + ///
_b[soc6]*(.0341034-.0329136) + _b[soc7]*(.0522552-.0609616) + ///
_b[soc8]*(.1505317-.1823125) + _b[soc9]*(.0663733-.0506583)
// => Sum other factors to get change.

restore

sort pid wave, stable

*******************************************************************************
*******************************************************************************
