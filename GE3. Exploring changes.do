*******************************************************************************
***************************** Setting up Table 2 ******************************
*******************************************************************************

quietly {
set more off

// Calculate averages per group.

sort ME, stable

by ME: egen incidence=mean(bonusjob)
by ME: egen incidencefifth1=mean(bonusjobfifth)
by ME: egen incidencehalf1=mean(bonusjobhalf)

egen meandur1_ = mean(duration) if ME==1
egen meandur1 = mean(meandur1_)
egen meanexp11_ = mean(exp) if ME==1
egen meanexp11 = mean(meanexp11_)
egen meanexp21_ = mean(exp2) if ME==1
egen meanexp21 = mean(meanexp21_)
egen meanexp31_ = mean(exp3) if ME==1
egen meanexp31 = mean(meanexp31_)
egen meanexp41_ = mean(exp4) if ME==1
egen meanexp41 = mean(meanexp41_)
egen meanexp51_ = mean(exp5) if ME==1
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
egen meaneu1_ = mean(eu) if ME==1
egen meaneu1 = mean(meaneu1_)
egen meanmarried1_ = mean(married) if ME==1
egen meanmarried1 = mean(meanmarried1_)
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
egen meansoc01_ = mean(soc0) if ME==1
egen meansoc01 = mean(meansoc01_)

egen meandur8_ = mean(duration) if ME==8
egen meandur8 = mean(meandur8_)
egen meanexp18_ = mean(exp) if ME==8
egen meanexp18 = mean(meanexp18_)
egen meanexp28_ = mean(exp2) if ME==8
egen meanexp28 = mean(meanexp28_)
egen meanexp38_ = mean(exp3) if ME==8
egen meanexp38 = mean(meanexp38_)
egen meanexp48_ = mean(exp4) if ME==8
egen meanexp48 = mean(meanexp48_)
egen meanexp58_ = mean(exp5) if ME==8
egen meanexp58 = mean(meanexp58_)
egen meanten18_ = mean(tenure) if ME==8
egen meanten18 = mean(meanten18_)
egen meanten28_ = mean(tenure2) if ME==8
egen meanten28 = mean(meanten28_)
egen meanten38_ = mean(tenure3) if ME==8
egen meanten38 = mean(meanten38_)
egen meanten48_ = mean(tenure4) if ME==8
egen meanten48 = mean(meanten48_)
egen meanten58_ = mean(tenure5) if ME==8
egen meanten58 = mean(meanten58_)
egen meaneu8_ = mean(eu) if ME==8
egen meaneu8 = mean(meaneu8_)
egen meanmarried8_ = mean(married) if ME==8
egen meanmarried8 = mean(meanmarried8_)
egen meansic18_ = mean(sic1) if ME==8
egen meansic18 = mean(meansic18_)
egen meansic28_ = mean(sic2) if ME==8
egen meansic28 = mean(meansic28_)
egen meansic38_ = mean(sic3) if ME==8
egen meansic38 = mean(meansic38_)
egen meansic48_ = mean(sic4) if ME==8
egen meansic48 = mean(meansic48_)
egen meansic58_ = mean(sic5) if ME==8
egen meansic58 = mean(meansic58_)
egen meansic68_ = mean(sic6) if ME==8
egen meansic68 = mean(meansic68_)
egen meansic78_ = mean(sic7) if ME==8
egen meansic78 = mean(meansic78_)
egen meansic88_ = mean(sic8) if ME==8
egen meansic88 = mean(meansic88_)
egen meansic98_ = mean(sic9) if ME==8
egen meansic98 = mean(meansic98_)
egen meansic08_ = mean(sic0) if ME==8
egen meansic08 = mean(meansic08_)
egen meansoc18_ = mean(soc1) if ME==8
egen meansoc18 = mean(meansoc18_)
egen meansoc28_ = mean(soc2) if ME==8
egen meansoc28 = mean(meansoc28_)
egen meansoc38_ = mean(soc3) if ME==8
egen meansoc38 = mean(meansoc38_)
egen meansoc48_ = mean(soc4) if ME==8
egen meansoc48 = mean(meansoc48_)
egen meansoc58_ = mean(soc5) if ME==8
egen meansoc58 = mean(meansoc58_)
egen meansoc68_ = mean(soc6) if ME==8
egen meansoc68 = mean(meansoc68_)
egen meansoc78_ = mean(soc7) if ME==8
egen meansoc78 = mean(meansoc78_)
egen meansoc88_ = mean(soc8) if ME==8
egen meansoc88 = mean(meansoc88_)
egen meansoc98_ = mean(soc9) if ME==8
egen meansoc98 = mean(meansoc98_)
egen meansoc08_ = mean(soc0) if ME==8
egen meansoc08 = mean(meansoc08_)

local xlist "duration exp exp2 exp3 exp4 exp5 tenure tenure2 tenure3 tenure4 tenure5 eu married sic1 sic2 sic3 sic4 sic5 sic6 sic7 sic8 sic9 soc1 soc2 soc3 soc4 soc5 soc6 soc7 soc8 soc9 ME2 ME3 ME4 ME5 ME6 ME7 ME8"

//---------------------------------------------------------------------------//
//----------------------------------- LPM -----------------------------------//
//---------------------------------------------------------------------------//

reg bonusjob `xlist'

generate coeffb = _b[_cons]
generate coeffdur = _b[duration]
generate coeffexp1 = _b[exp]
generate coeffexp2 = _b[exp2]
generate coeffexp3 = _b[exp3]
generate coeffexp4 = _b[exp4]
generate coeffexp5 = _b[exp5]
generate coefftenure1 = _b[tenure]
generate coefftenure2 = _b[tenure2]
generate coefftenure3 = _b[tenure3]
generate coefftenure4 = _b[tenure4]
generate coefftenure5 = _b[tenure5]
generate coeffmarried = _b[married]
generate coeffeu = _b[eu]
generate coeffsic1 = _b[sic1]
generate coeffsic2 = _b[sic2]
generate coeffsic3 = _b[sic3]
generate coeffsic4 = _b[sic4]
generate coeffsic5 = _b[sic5]
generate coeffsic6 = _b[sic6]
generate coeffsic7 = _b[sic7]
generate coeffsic8 = _b[sic8]
generate coeffsic9 = _b[sic9]
generate coeffsoc1 = _b[soc1]
generate coeffsoc2 = _b[soc2]
generate coeffsoc3 = _b[soc3]
generate coeffsoc4 = _b[soc4]
generate coeffsoc5 = _b[soc5]
generate coeffsoc6 = _b[soc6]
generate coeffsoc7 = _b[soc7]
generate coeffsoc8 = _b[soc8]
generate coeffsoc9 = _b[soc9]

generate result_1_all = coeffb + coeffdur*meandur1 + coeffexp1*meanexp11 + ///
coeffexp2*meanexp21 + coeffexp3*meanexp31 + coeffexp4*meanexp41 + ///
coeffexp5*meanexp51 + coefftenure1*meanten11 + coefftenure2*meanten21 + ///
coefftenure3*meanten31 + coefftenure4*meanten41 + coefftenure5*meanten51 + ///
coeffmarried*meanmarried1 + coeffeu*meaneu1 + coeffsic1*meansic11 + ///
coeffsic2*meansic21 + coeffsic3*meansic31 + coeffsic4*meansic41 + ///
coeffsic5*meansic51 + coeffsic6*meansic61 + coeffsic7*meansic71 + ///
coeffsic8*meansic81 + coeffsic9*meansic91 + coeffsoc1*meansoc11 + ///
coeffsoc2*meansoc21 + coeffsoc3*meansoc31 + coeffsoc4*meansoc41 + ///
coeffsoc5*meansoc51 + coeffsoc6*meansoc61 + coeffsoc7*meansoc71 + ///
coeffsoc8*meansoc81 + coeffsoc9*meansoc91

// => this is the LPM-predicted incidence in period 1!

generate result_8_all = coeffb + coeffdur*meandur8 + coeffexp1*meanexp18 + ///
coeffexp2*meanexp28 + coeffexp3*meanexp38 + coeffexp4*meanexp48 + ///
coeffexp5*meanexp58 + coefftenure1*meanten18 + coefftenure2*meanten28 + ///
coefftenure3*meanten38 + coefftenure4*meanten48 + coefftenure5*meanten58 + ///
coeffmarried*meanmarried8 + coeffeu*meaneu8 + coeffsic1*meansic18 + ///
coeffsic2*meansic28 + coeffsic3*meansic38 + coeffsic4*meansic48 + ///
coeffsic5*meansic58 + coeffsic6*meansic68 + coeffsic7*meansic78 + ///
coeffsic8*meansic88 + coeffsic9*meansic98 + coeffsoc1*meansoc18 + ///
coeffsoc2*meansoc28 + coeffsoc3*meansoc38 + coeffsoc4*meansoc48 + ///
coeffsoc5*meansoc58 + coeffsoc6*meansoc68 + coeffsoc7*meansoc78 + ///
coeffsoc8*meansoc88 + coeffsoc9*meansoc98

// => this is the LPM-predicted incidence in period 8!

display _b[ME8]
// => this is the adjusted change between periods (significant)!

generate change_dur_all = coeffdur*(meandur8-meandur1)

generate change_sic_all = coeffsic1*(meansic18-meansic11) + ///
coeffsic2*(meansic28-meansic21) + coeffsic3*(meansic38-meansic31) + ///
coeffsic4*(meansic48-meansic41) + coeffsic5*(meansic58-meansic51) + ///
coeffsic6*(meansic68-meansic61) + coeffsic7*(meansic78-meansic71) + ///
coeffsic8*(meansic88-meansic81) + coeffsic9*(meansic98-meansic91)        
         
generate change_soc_all = coeffsoc1*(meansoc18-meansoc11) + ///
coeffsic2*(meansoc28-meansoc21) + coeffsoc3*(meansoc38-meansoc31) + ///
coeffsic4*(meansoc48-meansoc41) + coeffsoc5*(meansoc58-meansoc51) + ///
coeffsic6*(meansoc68-meansoc61) + coeffsoc7*(meansoc78-meansoc71) + ///
coeffsic8*(meansoc88-meansoc81) + coeffsoc9*(meansoc98-meansoc91)
}

sum result_1_all result_8_all change_dur_all change_sic_all change_soc_all

// => Sum other factors to get change.

//---------------------------------------------------------------------------//
//------------------------------ LPM (a fifth) ------------------------------//
//---------------------------------------------------------------------------//

quietly {
drop coeff*
reg bonusjobfifth `xlist'

generate coeffb = _b[_cons]
generate coeffdur = _b[duration]
generate coeffexp1 = _b[exp]
generate coeffexp2 = _b[exp2]
generate coeffexp3 = _b[exp3]
generate coeffexp4 = _b[exp4]
generate coeffexp5 = _b[exp5]
generate coefftenure1 = _b[tenure]
generate coefftenure2 = _b[tenure2]
generate coefftenure3 = _b[tenure3]
generate coefftenure4 = _b[tenure4]
generate coefftenure5 = _b[tenure5]
generate coeffmarried = _b[married]
generate coeffeu = _b[eu]
generate coeffsic1 = _b[sic1]
generate coeffsic2 = _b[sic2]
generate coeffsic3 = _b[sic3]
generate coeffsic4 = _b[sic4]
generate coeffsic5 = _b[sic5]
generate coeffsic6 = _b[sic6]
generate coeffsic7 = _b[sic7]
generate coeffsic8 = _b[sic8]
generate coeffsic9 = _b[sic9]
generate coeffsoc1 = _b[soc1]
generate coeffsoc2 = _b[soc2]
generate coeffsoc3 = _b[soc3]
generate coeffsoc4 = _b[soc4]
generate coeffsoc5 = _b[soc5]
generate coeffsoc6 = _b[soc6]
generate coeffsoc7 = _b[soc7]
generate coeffsoc8 = _b[soc8]
generate coeffsoc9 = _b[soc9]

generate result_1_fifth = coeffb + coeffdur*meandur1 + coeffexp1*meanexp11 + ///
coeffexp2*meanexp21 + coeffexp3*meanexp31 + coeffexp4*meanexp41 + ///
coeffexp5*meanexp51 + coefftenure1*meanten11 + coefftenure2*meanten21 + ///
coefftenure3*meanten31 + coefftenure4*meanten41 + coefftenure5*meanten51 + ///
coeffmarried*meanmarried1 + coeffeu*meaneu1 + coeffsic1*meansic11 + ///
coeffsic2*meansic21 + coeffsic3*meansic31 + coeffsic4*meansic41 + ///
coeffsic5*meansic51 + coeffsic6*meansic61 + coeffsic7*meansic71 + ///
coeffsic8*meansic81 + coeffsic9*meansic91 + coeffsoc1*meansoc11 + ///
coeffsoc2*meansoc21 + coeffsoc3*meansoc31 + coeffsoc4*meansoc41 + ///
coeffsoc5*meansoc51 + coeffsoc6*meansoc61 + coeffsoc7*meansoc71 + ///
coeffsoc8*meansoc81 + coeffsoc9*meansoc91

// => this is the LPM-predicted incidence in period 1!

generate result_8_fifth = coeffb + coeffdur*meandur8 + coeffexp1*meanexp18 + ///
coeffexp2*meanexp28 + coeffexp3*meanexp38 + coeffexp4*meanexp48 + ///
coeffexp5*meanexp58 + coefftenure1*meanten18 + coefftenure2*meanten28 + ///
coefftenure3*meanten38 + coefftenure4*meanten48 + coefftenure5*meanten58 + ///
coeffmarried*meanmarried8 + coeffeu*meaneu8 + coeffsic1*meansic18 + ///
coeffsic2*meansic28 + coeffsic3*meansic38 + coeffsic4*meansic48 + ///
coeffsic5*meansic58 + coeffsic6*meansic68 + coeffsic7*meansic78 + ///
coeffsic8*meansic88 + coeffsic9*meansic98 + coeffsoc1*meansoc18 + ///
coeffsoc2*meansoc28 + coeffsoc3*meansoc38 + coeffsoc4*meansoc48 + ///
coeffsoc5*meansoc58 + coeffsoc6*meansoc68 + coeffsoc7*meansoc78 + ///
coeffsoc8*meansoc88 + coeffsoc9*meansoc98

// => this is the LPM-predicted incidence in period 8!

display _b[ME8]
// => this is the adjusted change between periods (significant)!

generate change_dur_fifth = coeffdur*(meandur8-meandur1)

generate change_sic_fifth = coeffsic1*(meansic18-meansic11) + ///
coeffsic2*(meansic28-meansic21) + coeffsic3*(meansic38-meansic31) + ///
coeffsic4*(meansic48-meansic41) + coeffsic5*(meansic58-meansic51) + ///
coeffsic6*(meansic68-meansic61) + coeffsic7*(meansic78-meansic71) + ///
coeffsic8*(meansic88-meansic81) + coeffsic9*(meansic98-meansic91)        
         
generate change_soc_fifth = coeffsoc1*(meansoc18-meansoc11) + ///
coeffsic2*(meansoc28-meansoc21) + coeffsoc3*(meansoc38-meansoc31) + ///
coeffsic4*(meansoc48-meansoc41) + coeffsoc5*(meansoc58-meansoc51) + ///
coeffsic6*(meansoc68-meansoc61) + coeffsoc7*(meansoc78-meansoc71) + ///
coeffsic8*(meansoc88-meansoc81) + coeffsoc9*(meansoc98-meansoc91)
}

sum result_1_fifth result_8_fifth change_dur_fifth change_sic_fifth ///
change_soc_fifth

// => Sum other factors to get change.

//---------------------------------------------------------------------------//
//-------------------- LPM (type 1 bonus job - a half) ----------------------//
//---------------------------------------------------------------------------//

quietly {
drop coeff*
reg bonusjobhalf `xlist'

generate coeffb = _b[_cons]
generate coeffdur = _b[duration]
generate coeffexp1 = _b[exp]
generate coeffexp2 = _b[exp2]
generate coeffexp3 = _b[exp3]
generate coeffexp4 = _b[exp4]
generate coeffexp5 = _b[exp5]
generate coefftenure1 = _b[tenure]
generate coefftenure2 = _b[tenure2]
generate coefftenure3 = _b[tenure3]
generate coefftenure4 = _b[tenure4]
generate coefftenure5 = _b[tenure5]
generate coeffmarried = _b[married]
generate coeffeu = _b[eu]
generate coeffsic1 = _b[sic1]
generate coeffsic2 = _b[sic2]
generate coeffsic3 = _b[sic3]
generate coeffsic4 = _b[sic4]
generate coeffsic5 = _b[sic5]
generate coeffsic6 = _b[sic6]
generate coeffsic7 = _b[sic7]
generate coeffsic8 = _b[sic8]
generate coeffsic9 = _b[sic9]
generate coeffsoc1 = _b[soc1]
generate coeffsoc2 = _b[soc2]
generate coeffsoc3 = _b[soc3]
generate coeffsoc4 = _b[soc4]
generate coeffsoc5 = _b[soc5]
generate coeffsoc6 = _b[soc6]
generate coeffsoc7 = _b[soc7]
generate coeffsoc8 = _b[soc8]
generate coeffsoc9 = _b[soc9]

generate result_1_half = coeffb + coeffdur*meandur1 + coeffexp1*meanexp11 + ///
coeffexp2*meanexp21 + coeffexp3*meanexp31 + coeffexp4*meanexp41 + ///
coeffexp5*meanexp51 + coefftenure1*meanten11 + coefftenure2*meanten21 + ///
coefftenure3*meanten31 + coefftenure4*meanten41 + coefftenure5*meanten51 + ///
coeffmarried*meanmarried1 + coeffeu*meaneu1 + coeffsic1*meansic11 + ///
coeffsic2*meansic21 + coeffsic3*meansic31 + coeffsic4*meansic41 + ///
coeffsic5*meansic51 + coeffsic6*meansic61 + coeffsic7*meansic71 + ///
coeffsic8*meansic81 + coeffsic9*meansic91 + coeffsoc1*meansoc11 + ///
coeffsoc2*meansoc21 + coeffsoc3*meansoc31 + coeffsoc4*meansoc41 + ///
coeffsoc5*meansoc51 + coeffsoc6*meansoc61 + coeffsoc7*meansoc71 + ///
coeffsoc8*meansoc81 + coeffsoc9*meansoc91

// => this is the LPM-predicted incidence in period 1!

generate result_8_half = coeffb + coeffdur*meandur8 + coeffexp1*meanexp18 + ///
coeffexp2*meanexp28 + coeffexp3*meanexp38 + coeffexp4*meanexp48 + ///
coeffexp5*meanexp58 + coefftenure1*meanten18 + coefftenure2*meanten28 + ///
coefftenure3*meanten38 + coefftenure4*meanten48 + coefftenure5*meanten58 + ///
coeffmarried*meanmarried8 + coeffeu*meaneu8 + coeffsic1*meansic18 + ///
coeffsic2*meansic28 + coeffsic3*meansic38 + coeffsic4*meansic48 + ///
coeffsic5*meansic58 + coeffsic6*meansic68 + coeffsic7*meansic78 + ///
coeffsic8*meansic88 + coeffsic9*meansic98 + coeffsoc1*meansoc18 + ///
coeffsoc2*meansoc28 + coeffsoc3*meansoc38 + coeffsoc4*meansoc48 + ///
coeffsoc5*meansoc58 + coeffsoc6*meansoc68 + coeffsoc7*meansoc78 + ///
coeffsoc8*meansoc88 + coeffsoc9*meansoc98

// => this is the LPM-predicted incidence in period 8!

display _b[ME8]
// => this is the adjusted change between periods (significant)!

generate change_dur_half = coeffdur*(meandur8-meandur1)

generate change_sic_half = coeffsic1*(meansic18-meansic11) + ///
coeffsic2*(meansic28-meansic21) + coeffsic3*(meansic38-meansic31) + ///
coeffsic4*(meansic48-meansic41) + coeffsic5*(meansic58-meansic51) + ///
coeffsic6*(meansic68-meansic61) + coeffsic7*(meansic78-meansic71) + ///
coeffsic8*(meansic88-meansic81) + coeffsic9*(meansic98-meansic91)        
         
generate change_soc_half = coeffsoc1*(meansoc18-meansoc11) + ///
coeffsic2*(meansoc28-meansoc21) + coeffsoc3*(meansoc38-meansoc31) + ///
coeffsic4*(meansoc48-meansoc41) + coeffsoc5*(meansoc58-meansoc51) + ///
coeffsic6*(meansoc68-meansoc61) + coeffsoc7*(meansoc78-meansoc71) + ///
coeffsic8*(meansoc88-meansoc81) + coeffsoc9*(meansoc98-meansoc91)
}

sum result_1_half result_8_half change_dur_half change_sic_half change_soc_half

// => Sum other factors to get change.

//---------------------------------------------------------------------------//
//-------------- LPM (type 1 bonus job - endpoint adjusted) -----------------//
//---------------------------------------------------------------------------//

preserve
drop if ME==1 | ME==8

quietly {
drop coeff*

reg bonusjob `xlist'

generate coeffb = _b[_cons]
generate coeffdur = _b[duration]
generate coeffexp1 = _b[exp]
generate coeffexp2 = _b[exp2]
generate coeffexp3 = _b[exp3]
generate coeffexp4 = _b[exp4]
generate coeffexp5 = _b[exp5]
generate coefftenure1 = _b[tenure]
generate coefftenure2 = _b[tenure2]
generate coefftenure3 = _b[tenure3]
generate coefftenure4 = _b[tenure4]
generate coefftenure5 = _b[tenure5]
generate coeffmarried = _b[married]
generate coeffeu = _b[eu]
generate coeffsic1 = _b[sic1]
generate coeffsic2 = _b[sic2]
generate coeffsic3 = _b[sic3]
generate coeffsic4 = _b[sic4]
generate coeffsic5 = _b[sic5]
generate coeffsic6 = _b[sic6]
generate coeffsic7 = _b[sic7]
generate coeffsic8 = _b[sic8]
generate coeffsic9 = _b[sic9]
generate coeffsoc1 = _b[soc1]
generate coeffsoc2 = _b[soc2]
generate coeffsoc3 = _b[soc3]
generate coeffsoc4 = _b[soc4]
generate coeffsoc5 = _b[soc5]
generate coeffsoc6 = _b[soc6]
generate coeffsoc7 = _b[soc7]
generate coeffsoc8 = _b[soc8]
generate coeffsoc9 = _b[soc9]

generate result_1_ep = coeffb + coeffdur*meandur1 + coeffexp1*meanexp11 + ///
coeffexp2*meanexp21 + coeffexp3*meanexp31 + coeffexp4*meanexp41 + ///
coeffexp5*meanexp51 + coefftenure1*meanten11 + coefftenure2*meanten21 + ///
coefftenure3*meanten31 + coefftenure4*meanten41 + coefftenure5*meanten51 + ///
coeffmarried*meanmarried1 + coeffeu*meaneu1 + coeffsic1*meansic11 + ///
coeffsic2*meansic21 + coeffsic3*meansic31 + coeffsic4*meansic41 + ///
coeffsic5*meansic51 + coeffsic6*meansic61 + coeffsic7*meansic71 + ///
coeffsic8*meansic81 + coeffsic9*meansic91 + coeffsoc1*meansoc11 + ///
coeffsoc2*meansoc21 + coeffsoc3*meansoc31 + coeffsoc4*meansoc41 + ///
coeffsoc5*meansoc51 + coeffsoc6*meansoc61 + coeffsoc7*meansoc71 + ///
coeffsoc8*meansoc81 + coeffsoc9*meansoc91

// => this is the LPM-predicted incidence in period 1!

generate result_8_ep = coeffb + coeffdur*meandur8 + coeffexp1*meanexp18 + ///
coeffexp2*meanexp28 + coeffexp3*meanexp38 + coeffexp4*meanexp48 + ///
coeffexp5*meanexp58 + coefftenure1*meanten18 + coefftenure2*meanten28 + ///
coefftenure3*meanten38 + coefftenure4*meanten48 + coefftenure5*meanten58 + ///
coeffmarried*meanmarried8 + coeffeu*meaneu8 + coeffsic1*meansic18 + ///
coeffsic2*meansic28 + coeffsic3*meansic38 + coeffsic4*meansic48 + ///
coeffsic5*meansic58 + coeffsic6*meansic68 + coeffsic7*meansic78 + ///
coeffsic8*meansic88 + coeffsic9*meansic98 + coeffsoc1*meansoc18 + ///
coeffsoc2*meansoc28 + coeffsoc3*meansoc38 + coeffsoc4*meansoc48 + ///
coeffsoc5*meansoc58 + coeffsoc6*meansoc68 + coeffsoc7*meansoc78 + ///
coeffsoc8*meansoc88 + coeffsoc9*meansoc98

// => this is the LPM-predicted incidence in period 8!

display _b[ME8]
// => this is the adjusted change between periods (significant)!

generate change_dur_ep = coeffdur*(meandur8-meandur1)

generate change_sic_ep = coeffsic1*(meansic18-meansic11) + ///
coeffsic2*(meansic28-meansic21) + coeffsic3*(meansic38-meansic31) + ///
coeffsic4*(meansic48-meansic41) + coeffsic5*(meansic58-meansic51) + ///
coeffsic6*(meansic68-meansic61) + coeffsic7*(meansic78-meansic71) + ///
coeffsic8*(meansic88-meansic81) + coeffsic9*(meansic98-meansic91)        
         
generate change_soc_ep = coeffsoc1*(meansoc18-meansoc11) + ///
coeffsic2*(meansoc28-meansoc21) + coeffsoc3*(meansoc38-meansoc31) + ///
coeffsic4*(meansoc48-meansoc41) + coeffsoc5*(meansoc58-meansoc51) + ///
coeffsic6*(meansoc68-meansoc61) + coeffsoc7*(meansoc78-meansoc71) + ///
coeffsic8*(meansoc88-meansoc81) + coeffsoc9*(meansoc98-meansoc91)

}

sum result_1_ep result_8_ep change_dur_ep change_sic_ep change_soc_ep

// => Sum other factors to get change.

restore
drop meandur* meanexp* meanten* meanmarried* meaneu* meansic* meansoc* coeff*
drop result_1_* result_8_* change_dur_* change_sic_* change_soc_*


*******************************************************************************
*******************************************************************************
