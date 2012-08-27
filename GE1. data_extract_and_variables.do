clear all
set more off
cd "/Users/pieterdevlieger/Desktop/plan B - wage inequality/G-SOEP"
global dir bilingual_stata

*******************************************************************************
************************** Setting up the long panel **************************
*******************************************************************************

// we need to do this wave by wave for the SOEP as variables sometimes change 
// names. So no loop possible here. We only use the waves starting in 1985,
// as this is the first year there is a specific question for performance
// related pay.

//---------------------------------------------------------------------------//
//---------------------------------- 1985 -----------------------------------//
//---------------------------------------------------------------------------//

use persnr hhnr bp5909 bp5910 bp4401 bp4402 bpmonin bptagin bp3802 bp09 ///
bp81 bp21g bp23g01 bp23g02 bp22g01 bp22g02 bp45 bp42 bp4002 ///
using $dir/bp, clear

rename bp5909 bonus
rename bp5910 bonam
rename bp4401 jbbgy
rename bp4402 jbbgm
rename bpmonin doim
rename bptagin doid
rename bp3802 self_employed
rename bp09 unemployed
rename bp81 yob
rename bp21g jbbgly
rename bp23g01 jbbgly_2
rename bp23g02 jbbgly_3
rename bp22g01 jobchange_within1
rename bp22g02 jobchange_within2
rename bp45 perm_1
rename bp42 rules_ot
rename bp4002 hours_flex

generate wave=1
generate wavey=1985

save wave1_junk_1, replace

use hhnr nuts185 using $dir/bhgen, clear
sort hhnr, stable
quietly by hhnr: gen dup=cond(_N==1,0,_n)
drop if dup>1
drop dup

rename nuts185 region

merge 1:m  hhnr using wave1_junk_1
keep if _merge==3
drop _merge
save wave1_junk_2, replace

use persnr e1110185 d11102ll d1110985 e1110385 using $dir/bpequiv, clear

rename e1110185 hrs_annual
rename d11102ll sex
rename d1110985 yeq
rename e1110385 perm_2

merge 1:1 persnr using wave1_junk_2
keep if _merge==3
drop _merge
save wave1_junk_3, replace

use persnr nation85 bfamstd oeffd85 labgro85 btatzeit bvebzeit lfs85 is8885 ///
nace85 bpsbil expft85 exppt85 berwzeit bpbbil01 bpbbil02 bpbbil03 ///
using $dir/bpgen, clear

rename nation85 eu
rename bfamstd married
rename oeffd85 public_sector
rename labgro85 ly
rename btatzeit hrs_week
rename bvebzeit hrs_agreed
rename lfs85 job_stat
rename is8885 soc
rename nace85 sic
rename bpsbil degree
rename expft85 exp_ft
rename exppt85 exp_pt
rename berwzeit tenure
rename bpbbil01 vocational
rename bpbbil02 further
rename bpbbil03 no_voc

merge 1:1 persnr using wave1_junk_3
keep if _merge==3
drop _merge

recode bonus bonam jbbgy jbbgm doim doid yob perm_1 rules_ot hours_flex ///
region hrs_annual yeq perm_2 ly hrs_week hrs_agreed degree exp_ft exp_pt ///
tenure further (-3 -2 -1 = .)
recode self_employed vocational no_voc (-3 -2 -1 = .) (1/6 = 1)
recode unemployed jbbgly public_sector sex (-3 -2 -1 = .) (1 = 1) (2 = 0)
recode jbbgly_* jobchange_within* (-3 -2 -1 =.) (1/12 = 1)
recode eu		(-3 -2 -1 = .) ///
				(1 4 5 6 10 11 12 13 14 15 16 17 18 19 28 41 =0) ///
				(2 3 20/27 29/40 40/1000 = 1)
recode married (-3 -2 -1 = .) (1 2 6 = 1) (3 4 5 = 0)
recode job_stat (-3 -2 -1 = .) (1/10 = 0) (11 12 = 1)
recode soc 	(-3 -2 -1 = .)    	///
			(0/999 = 0)    		///
			(1000/1999 = 1)    	///
			(2000/2999 = 2)    	///
			(3000/3999 = 3)    	///
			(4000/4999 = 4)    	///
			(5000/5999 = 5)    	///
			(6000/6999 = 6)    	///
			(7000/7999 = 7)    	///
			(8000/8999 = 8)    	///
			(9000/9999 = 9)
recode sic 	(-3 -2 -1 = .) 		///
			(0/9 = 0)  			///
			(10/14 = 1)  		///
			(15/39 = 2)  		///
			(40/41 = 3)  		///
			(42/49 = 4)  		///
			(50/54 = 5)  		///
			(55/59 = 6)   		///
			(60/64 = 7)  		///
			(65/69 = 8)   		///
			(70/71 = 9)			///
			(72/74 = 10)		///
			(75/79 = 11)		///
			(80/84 = 12)	   	///
			(85/89 = 13)		///
			(90 = 14)			///
			(91/92 = 15)	   	///
			(95 = 16)			///
			(96/100 = 17)

** perm_1 could still have self-employed (3)!!!! check!!!
** perm_2 could still have unemployed (3)!!!! check!!!

save wave1, replace

//---------------------------------------------------------------------------//
//---------------------------------- 1986 -----------------------------------//
//---------------------------------------------------------------------------//

use persnr hhnr cp5909 cp5910 cp3501 cp3502 cpmonin cptagin cp4602 cp05 ///
cp8802 cp21g cp23g01 cp23g02 cp22g01 cp22g02 cp36 cp50 cp4702 ///
using $dir/cp, clear

rename cp5909 bonus
rename cp5910 bonam
rename cp3501 jbbgy
rename cp3502 jbbgm
rename cpmonin doim
rename cptagin doid
rename cp4602 self_employed
rename cp05 unemployed
rename cp8802 yob
rename cp21g jbbgly
rename cp23g01 jbbgly_2 
rename cp23g02 jbbgly_3
rename cp22g01 jobchange_within1
rename cp22g02 jobchange_within2
rename cp36 perm_1
rename cp50 rules_ot
rename cp4702 hours_flex

generate wave=2
generate wavey=1986

save wave2_junk_1, replace

use hhnr nuts186 using $dir/chgen, clear
sort hhnr, stable
quietly by hhnr: gen dup=cond(_N==1,0,_n)
drop if dup>1
drop dup

rename nuts186 region

merge 1:m  hhnr using wave2_junk_1
keep if _merge==3
drop _merge
save wave2_junk_2, replace

use persnr e1110186 d11102ll d1110986 e1110386 using $dir/cpequiv, clear

rename e1110186 hrs_annual
rename d11102ll sex
rename d1110986 yeq
rename e1110386 perm_2

merge 1:1 persnr using wave2_junk_2
keep if _merge==3
drop _merge
save wave2_junk_3, replace

use persnr nation86 cfamstd oeffd86 labgro86 ctatzeit cvebzeit lfs86 is8886 ///
nace86 cpsbil expft86 exppt86 cerwzeit cpbbil01 cpbbil02 cpbbil03 ///
using $dir/cpgen, clear

rename nation86 eu
rename cfamstd married
rename oeffd86 public_sector
rename labgro86 ly
rename ctatzeit hrs_week
rename cvebzeit hrs_agreed
rename lfs86 job_stat
rename is8886 soc
rename nace86 sic
rename cpsbil degree
rename expft86 exp_ft
rename exppt86 exp_pt
rename cerwzeit tenure
rename cpbbil01 vocational
rename cpbbil02 further
rename cpbbil03 no_voc

merge 1:1 persnr using wave2_junk_3
keep if _merge==3
drop _merge

recode bonus bonam jbbgy jbbgm doim doid yob perm_1 rules_ot hours_flex ///
region hrs_annual yeq perm_2 ly hrs_week hrs_agreed degree exp_ft exp_pt ///
tenure further (-3 -2 -1 = .)
recode self_employed vocational no_voc (-3 -2 -1 = .) (1/6 = 1)
recode unemployed jbbgly public_sector sex (-3 -2 -1 = .) (1 = 1) (2 = 0)
recode jbbgly_* jobchange_within* (-3 -2 -1 =.) (1/12 = 1)
recode eu		(-3 -2 -1 = .) ///
				(1 4 5 6 10 11 12 13 14 15 16 17 18 19 28 41 =0) ///
				(2 3 20/27 29/40 40/1000 = 1)
recode married (-3 -2 -1 = .) (1 2 6 = 1) (3 4 5 = 0)
recode job_stat (-3 -2 -1 = .) (1/10 = 0) (11 12 = 1)
recode soc 	(-3 -2 -1 = .)    	///
			(0/999 = 0)    		///
			(1000/1999 = 1)    	///
			(2000/2999 = 2)    	///
			(3000/3999 = 3)    	///
			(4000/4999 = 4)    	///
			(5000/5999 = 5)    	///
			(6000/6999 = 6)    	///
			(7000/7999 = 7)    	///
			(8000/8999 = 8)    	///
			(9000/9999 = 9)
recode sic 	(-3 -2 -1 = .) 		///
			(0/9 = 0)  			///
			(10/14 = 1)  		///
			(15/39 = 2)  		///
			(40/41 = 3)  		///
			(42/49 = 4)  		///
			(50/54 = 5)  		///
			(55/59 = 6)   		///
			(60/64 = 7)  		///
			(65/69 = 8)   		///
			(70/71 = 9)			///
			(72/74 = 10)		///
			(75/79 = 11)		///
			(80/84 = 12)	   	///
			(85/89 = 13)		///
			(90 = 14)			///
			(91/92 = 15)	   	///
			(95 = 16)			///
			(96/100 = 17)

** perm_1 could still have self-employed (3)!!!! check!!!
** perm_2 could still have unemployed (3)!!!! check!!!

save wave2, replace

//---------------------------------------------------------------------------//
//---------------------------------- 1987 -----------------------------------//
//---------------------------------------------------------------------------//

use persnr hhnr dp5909 dp5910 dp3301 dp3302 dpmonin dptagin dp3802 dp05 ///
dp9002 dp19g dp21g01 dp21g02 dp20g01 dp20g02 dp34 dp4002 ///
using $dir/dp, clear

rename dp5909 bonus
rename dp5910 bonam
rename dp3301 jbbgy
rename dp3302 jbbgm
rename dpmonin doim
rename dptagin doid
rename dp3802 self_employed
rename dp05 unemployed
rename dp9002 yob
rename dp19g jbbgly
rename dp21g01 jbbgly_2
rename dp21g02 jbbgly_3
rename dp20g01 jobchange_within1
rename dp20g02 jobchange_within2
rename dp34 perm_1
generate rules_ot=.
rename dp4002 hours_flex

generate wave=3
generate wavey=1987

save wave3_junk_1, replace

use hhnr nuts187 using $dir/dhgen, clear
sort hhnr, stable
quietly by hhnr: gen dup=cond(_N==1,0,_n)
drop if dup>1
drop dup

rename nuts187 region

merge 1:m  hhnr using wave3_junk_1
keep if _merge==3
drop _merge
save wave3_junk_2, replace

use persnr e1110187 d11102ll d1110987 e1110387 using $dir/dpequiv, clear

rename e1110187 hrs_annual
rename d11102ll sex
rename d1110987 yeq
rename e1110387 perm_2

merge 1:1 persnr using wave3_junk_2
keep if _merge==3
drop _merge
save wave3_junk_3, replace

use persnr nation87 dfamstd oeffd87 labgro87 dtatzeit dvebzeit lfs87 is8887 ///
nace87 dpsbil expft87 exppt87 derwzeit dpbbil01 dpbbil02 dpbbil03 ///
using $dir/dpgen, clear

rename nation87 eu
rename dfamstd married
rename oeffd87 public_sector
rename labgro87 ly
rename dtatzeit hrs_week
rename dvebzeit hrs_agreed
rename lfs87 job_stat
rename is8887 soc
rename nace87 sic
rename dpsbil degree
rename expft87 exp_ft
rename exppt87 exp_pt
rename derwzeit tenure
rename dpbbil01 vocational
rename dpbbil02 further
rename dpbbil03 no_voc

merge 1:1 persnr using wave3_junk_3
keep if _merge==3
drop _merge

recode bonus bonam jbbgy jbbgm doim doid yob perm_1 rules_ot hours_flex ///
region hrs_annual yeq perm_2 ly hrs_week hrs_agreed degree exp_ft exp_pt ///
tenure further (-3 -2 -1 = .)
recode self_employed vocational no_voc (-3 -2 -1 = .) (1/6 = 1)
recode unemployed jbbgly public_sector sex (-3 -2 -1 = .) (1 = 1) (2 = 0)
recode jbbgly_* jobchange_within* (-3 -2 -1 =.) (1/12 = 1)
recode eu		(-3 -2 -1 = .) ///
				(1 4 5 6 10 11 12 13 14 15 16 17 18 19 28 41 =0) ///
				(2 3 20/27 29/40 40/1000 = 1)
recode married (-3 -2 -1 = .) (1 2 6 = 1) (3 4 5 = 0)
recode job_stat (-3 -2 -1 = .) (1/10 = 0) (11 12 = 1)
recode soc 	(-3 -2 -1 = .)    	///
			(0/999 = 0)    		///
			(1000/1999 = 1)    	///
			(2000/2999 = 2)    	///
			(3000/3999 = 3)    	///
			(4000/4999 = 4)    	///
			(5000/5999 = 5)    	///
			(6000/6999 = 6)    	///
			(7000/7999 = 7)    	///
			(8000/8999 = 8)    	///
			(9000/9999 = 9)
recode sic 	(-3 -2 -1 = .) 		///
			(0/9 = 0)  			///
			(10/14 = 1)  		///
			(15/39 = 2)  		///
			(40/41 = 3)  		///
			(42/49 = 4)  		///
			(50/54 = 5)  		///
			(55/59 = 6)   		///
			(60/64 = 7)  		///
			(65/69 = 8)   		///
			(70/71 = 9)			///
			(72/74 = 10)		///
			(75/79 = 11)		///
			(80/84 = 12)	   	///
			(85/89 = 13)		///
			(90 = 14)			///
			(91/92 = 15)	   	///
			(95 = 16)			///
			(96/100 = 17)

** perm_1 could still have self-employed (3)!!!! check!!!
** perm_2 could still have unemployed (3)!!!! check!!!

save wave3, replace

//---------------------------------------------------------------------------//
//---------------------------------- 1988 -----------------------------------//
//---------------------------------------------------------------------------//

use persnr hhnr ep5409 ep5410 ep3301 ep3302 epmonin eptagin ep3802 ep05 ///
ep8102 ep19g ep21g01 ep21g02 ep20g09 ep20g10 ep34 ep42 ep3902 ///
using $dir/ep, clear

rename ep5409 bonus
rename ep5410 bonam
rename ep3301 jbbgy
rename ep3302 jbbgm
rename epmonin doim
rename eptagin doid
rename ep3802 self_employed
rename ep05 unemployed
rename ep8102 yob
rename ep19g jbbgly
rename ep21g01 jbbgly_2
rename ep21g02 jbbgly_3
rename ep20g09 jobchange_within1
rename ep20g10 jobchange_within2
rename ep34 perm_1
rename ep42 rules_ot
rename ep3902 hours_flex

generate wave=4
generate wavey=1988

save wave4_junk_1, replace

use hhnr nuts188 using $dir/ehgen, clear
sort hhnr, stable
quietly by hhnr: gen dup=cond(_N==1,0,_n)
drop if dup>1
drop dup

rename nuts188 region

merge 1:m  hhnr using wave4_junk_1
keep if _merge==3
drop _merge
save wave4_junk_2, replace

use persnr e1110188 d11102ll d1110988 e1110388 using $dir/epequiv, clear

rename e1110188 hrs_annual
rename d11102ll sex
rename d1110988 yeq
rename e1110388 perm_2

merge 1:1 persnr using wave4_junk_2
keep if _merge==3
drop _merge
save wave4_junk_3, replace

use persnr nation88 efamstd oeffd88 labgro88 etatzeit evebzeit lfs88 is8888 ///
nace88 epsbil expft88 exppt88 eerwzeit epbbil01 epbbil02 epbbil03 ///
using $dir/epgen, clear

rename nation88 eu
rename efamstd married
rename oeffd88 public_sector
rename labgro88 ly
rename etatzeit hrs_week
rename evebzeit hrs_agreed
rename lfs88 job_stat
rename is8888 soc
rename nace88 sic
rename epsbil degree
rename expft88 exp_ft
rename exppt88 exp_pt
rename eerwzeit tenure
rename epbbil01 vocational
rename epbbil02 further
rename epbbil03 no_voc

merge 1:1 persnr using wave4_junk_3
keep if _merge==3
drop _merge

recode bonus bonam jbbgy jbbgm doim doid yob perm_1 rules_ot hours_flex ///
region hrs_annual yeq perm_2 ly hrs_week hrs_agreed degree exp_ft exp_pt ///
tenure further (-3 -2 -1 = .)
recode self_employed vocational no_voc (-3 -2 -1 = .) (1/6 = 1)
recode unemployed jbbgly public_sector sex (-3 -2 -1 = .) (1 = 1) (2 = 0)
recode jbbgly_* jobchange_within* (-3 -2 -1 =.) (1/12 = 1)
recode eu		(-3 -2 -1 = .) ///
				(1 4 5 6 10 11 12 13 14 15 16 17 18 19 28 41 =0) ///
				(2 3 20/27 29/40 40/1000 = 1)
recode married (-3 -2 -1 = .) (1 2 6 = 1) (3 4 5 = 0)
recode job_stat (-3 -2 -1 = .) (1/10 = 0) (11 12 = 1)
recode soc 	(-3 -2 -1 = .)    	///
			(0/999 = 0)    		///
			(1000/1999 = 1)    	///
			(2000/2999 = 2)    	///
			(3000/3999 = 3)    	///
			(4000/4999 = 4)    	///
			(5000/5999 = 5)    	///
			(6000/6999 = 6)    	///
			(7000/7999 = 7)    	///
			(8000/8999 = 8)    	///
			(9000/9999 = 9)
recode sic 	(-3 -2 -1 = .) 		///
			(0/9 = 0)  			///
			(10/14 = 1)  		///
			(15/39 = 2)  		///
			(40/41 = 3)  		///
			(42/49 = 4)  		///
			(50/54 = 5)  		///
			(55/59 = 6)   		///
			(60/64 = 7)  		///
			(65/69 = 8)   		///
			(70/71 = 9)			///
			(72/74 = 10)		///
			(75/79 = 11)		///
			(80/84 = 12)	   	///
			(85/89 = 13)		///
			(90 = 14)			///
			(91/92 = 15)	   	///
			(95 = 16)			///
			(96/100 = 17)

** perm_1 could still have self-employed (3)!!!! check!!!
** perm_2 could still have unemployed (3)!!!! check!!!

save wave4, replace

//---------------------------------------------------------------------------//
//---------------------------------- 1989 -----------------------------------//
//---------------------------------------------------------------------------//

use persnr hhnr fp7209 fp7210 fpmonin fptagin fp3802 fp06 fp10002 fp17g ///
fp19g01 fp19g02 fp18g09 fp18g10 fp27g fp44 fp4002 using $dir/fp, clear

rename fp7209 bonus
rename fp7210 bonam
generate jbbgy=.
generate jbbgm=.
rename fpmonin doim
rename fptagin doid
rename fp3802 self_employed
rename fp06 unemployed
rename fp10002 yob
rename fp17g jbbgly
rename fp19g01 jbbgly_2
rename fp19g02 jbbgly_3
rename fp18g09 jobchange_within1
rename fp18g10 jobchange_within2
rename fp27g perm_1
rename fp44 rules_ot
rename fp4002 hours_flex

generate wave=5
generate wavey=1989

save wave5_junk_1, replace

use hhnr nuts189 using $dir/fhgen, clear
sort hhnr, stable
quietly by hhnr: gen dup=cond(_N==1,0,_n)
drop if dup>1
drop dup

rename nuts189 region

merge 1:m  hhnr using wave5_junk_1
keep if _merge==3
drop _merge
save wave5_junk_2, replace

use persnr e1110189 d11102ll d1110989 e1110389 using $dir/fpequiv, clear

rename e1110189 hrs_annual
rename d11102ll sex
rename d1110989 yeq
rename e1110389 perm_2

merge 1:1 persnr using wave5_junk_2
keep if _merge==3
drop _merge
save wave5_junk_3, replace

use persnr nation89 ffamstd oeffd89 labgro89 ftatzeit fvebzeit lfs89 is8889 ///
nace89 fpsbil expft89 exppt89 ferwzeit fpbbil01 fpbbil02 fpbbil03 ///
using $dir/fpgen, clear

rename nation89 eu
rename ffamstd married
rename oeffd89 public_sector
rename labgro89 ly
rename ftatzeit hrs_week
rename fvebzeit hrs_agreed
rename lfs89 job_stat
rename is8889 soc
rename nace89 sic
rename fpsbil degree
rename expft89 exp_ft
rename exppt89 exp_pt
rename ferwzeit tenure
rename fpbbil01 vocational
rename fpbbil02 further
rename fpbbil03 no_voc

merge 1:1 persnr using wave5_junk_3
keep if _merge==3
drop _merge

recode bonus bonam jbbgy jbbgm doim doid yob perm_1 rules_ot hours_flex ///
region hrs_annual yeq perm_2 ly hrs_week hrs_agreed degree exp_ft exp_pt ///
tenure further (-3 -2 -1 = .)
recode self_employed vocational no_voc (-3 -2 -1 = .) (1/6 = 1)
recode unemployed jbbgly public_sector sex (-3 -2 -1 = .) (1 = 1) (2 = 0)
recode jbbgly_* jobchange_within* (-3 -2 -1 =.) (1/12 = 1)
recode eu		(-3 -2 -1 = .) ///
				(1 4 5 6 10 11 12 13 14 15 16 17 18 19 28 41 =0) ///
				(2 3 20/27 29/40 40/1000 = 1)
recode married (-3 -2 -1 = .) (1 2 6 = 1) (3 4 5 = 0)
recode job_stat (-3 -2 -1 = .) (1/10 = 0) (11 12 = 1)
recode soc 	(-3 -2 -1 = .)    	///
			(0/999 = 0)    		///
			(1000/1999 = 1)    	///
			(2000/2999 = 2)    	///
			(3000/3999 = 3)    	///
			(4000/4999 = 4)    	///
			(5000/5999 = 5)    	///
			(6000/6999 = 6)    	///
			(7000/7999 = 7)    	///
			(8000/8999 = 8)    	///
			(9000/9999 = 9)
recode sic 	(-3 -2 -1 = .) 		///
			(0/9 = 0)  			///
			(10/14 = 1)  		///
			(15/39 = 2)  		///
			(40/41 = 3)  		///
			(42/49 = 4)  		///
			(50/54 = 5)  		///
			(55/59 = 6)   		///
			(60/64 = 7)  		///
			(65/69 = 8)   		///
			(70/71 = 9)			///
			(72/74 = 10)		///
			(75/79 = 11)		///
			(80/84 = 12)	   	///
			(85/89 = 13)		///
			(90 = 14)			///
			(91/92 = 15)	   	///
			(95 = 16)			///
			(96/100 = 17)

** perm_1 could still have self-employed (3)!!!! check!!!
** perm_2 could still have unemployed (3)!!!! check!!!

save wave5, replace

//---------------------------------------------------------------------------//
//---------------------------------- 1990 -----------------------------------//
//---------------------------------------------------------------------------//

use persnr hhnr gp7209 gp7210 gp36g01 gp36g02 gpmonin gptagin gp3702 gp09 ///
gp10002 gp20g gp22g01 gp22g02 gp21g09 gp21g10 gp30g gp42 gp3802 ///
using $dir/gp, clear

rename gp7209 bonus
rename gp7210 bonam
rename gp36g01 jbbgy
rename gp36g02 jbbgm
rename gpmonin doim
rename gptagin doid
rename gp3702 self_employed
rename gp09 unemployed
rename gp10002 yob
rename gp20g jbbgly
rename gp22g01 jbbgly_2
rename gp22g02 jbbgly_3
rename gp21g09 jobchange_within1
rename gp21g10 jobchange_within2
rename gp30g perm_1
rename gp42 rules_ot
rename gp3802 hours_flex

generate wave=6
generate wavey=1990

save wave6_junk_1, replace

use hhnr nuts190 using $dir/ghgen, clear
sort hhnr, stable
quietly by hhnr: gen dup=cond(_N==1,0,_n)
drop if dup>1
drop dup

rename nuts190 region

merge 1:m  hhnr using wave6_junk_1
keep if _merge==3
drop _merge
save wave6_junk_2, replace

use persnr e1110190 d11102ll d1110990 e1110390 using $dir/gpequiv, clear

rename e1110190 hrs_annual
rename d11102ll sex
rename d1110990 yeq
rename e1110390 perm_2

merge 1:1 persnr using wave6_junk_2
keep if _merge==3
drop _merge
save wave6_junk_3, replace

use persnr nation90 gfamstd oeffd90 labgro90 gtatzeit gvebzeit lfs90 is8890 ///
nace90 gpsbil expft90 exppt90 gerwzeit gpbbil01 gpbbil02 gpbbil03 ///
using $dir/gpgen, clear

rename nation90 eu
rename gfamstd married
rename oeffd90 public_sector
rename labgro90 ly
rename gtatzeit hrs_week
rename gvebzeit hrs_agreed
rename lfs90 job_stat
rename is8890 soc
rename nace90 sic
rename gpsbil degree
rename expft90 exp_ft
rename exppt90 exp_pt
rename gerwzeit tenure
rename gpbbil01 vocational
rename gpbbil02 further
rename gpbbil03 no_voc

merge 1:1 persnr using wave6_junk_3
keep if _merge==3
drop _merge

recode bonus bonam jbbgy jbbgm doim doid yob perm_1 rules_ot hours_flex ///
region hrs_annual yeq perm_2 ly hrs_week hrs_agreed degree exp_ft exp_pt ///
tenure further (-3 -2 -1 = .)
recode self_employed vocational no_voc (-3 -2 -1 = .) (1/6 = 1)
recode unemployed jbbgly public_sector sex (-3 -2 -1 = .) (1 = 1) (2 = 0)
recode jbbgly_* jobchange_within* (-3 -2 -1 =.) (1/12 = 1)
recode eu		(-3 -2 -1 = .) ///
				(1 4 5 6 10 11 12 13 14 15 16 17 18 19 28 41 =0) ///
				(2 3 20/27 29/40 40/1000 = 1)
recode married (-3 -2 -1 = .) (1 2 6 = 1) (3 4 5 = 0)
recode job_stat (-3 -2 -1 = .) (1/10 = 0) (11 12 = 1)
recode soc 	(-3 -2 -1 = .)    	///
			(0/999 = 0)    		///
			(1000/1999 = 1)    	///
			(2000/2999 = 2)    	///
			(3000/3999 = 3)    	///
			(4000/4999 = 4)    	///
			(5000/5999 = 5)    	///
			(6000/6999 = 6)    	///
			(7000/7999 = 7)    	///
			(8000/8999 = 8)    	///
			(9000/9999 = 9)
recode sic 	(-3 -2 -1 = .) 		///
			(0/9 = 0)  			///
			(10/14 = 1)  		///
			(15/39 = 2)  		///
			(40/41 = 3)  		///
			(42/49 = 4)  		///
			(50/54 = 5)  		///
			(55/59 = 6)   		///
			(60/64 = 7)  		///
			(65/69 = 8)   		///
			(70/71 = 9)			///
			(72/74 = 10)		///
			(75/79 = 11)		///
			(80/84 = 12)	   	///
			(85/89 = 13)		///
			(90 = 14)			///
			(91/92 = 15)	   	///
			(95 = 16)			///
			(96/100 = 17)

** perm_1 could still have self-employed (3)!!!! check!!!
** perm_2 could still have unemployed (3)!!!! check!!!

save wave6, replace

//---------------------------------------------------------------------------//
//---------------------------------- 1991 -----------------------------------//
//---------------------------------------------------------------------------//

use persnr hhnr hp6709 hp6710 hp4701 hp4702 hpmonin hptagin hp4802 hp07 ///
hp10002 hp22g hp24g01 hp24g02 hp23g11 hp23g12 hp32g hp53 hp4902 ///
using $dir/hp, clear

rename hp6709 bonus
rename hp6710 bonam
rename hp4701 jbbgy
rename hp4702 jbbgm
rename hpmonin doim
rename hptagin doid
rename hp4802 self_employed
rename hp07 unemployed
rename hp10002 yob
rename hp22g jbbgly
rename hp24g01 jbbgly_2
rename hp24g02 jbbgly_3
rename hp23g11 jobchange_within1
rename hp23g12 jobchange_within2
rename hp32g perm_1
rename hp53 rules_ot
rename hp4902 hours_flex

generate wave=7
generate wavey=1991

save wave7_junk_1, replace

use hhnr nuts191 using $dir/hhgen, clear
sort hhnr, stable
quietly by hhnr: gen dup=cond(_N==1,0,_n)
drop if dup>1
drop dup

rename nuts191 region

merge 1:m  hhnr using wave7_junk_1
keep if _merge==3
drop _merge
save wave7_junk_2, replace

use persnr e1110191 d11102ll d1110991 e1110391 using $dir/hpequiv, clear

rename e1110191 hrs_annual
rename d11102ll sex
rename d1110991 yeq
rename e1110391 perm_2

merge 1:1 persnr using wave7_junk_2
keep if _merge==3
drop _merge
save wave7_junk_3, replace

use persnr nation91 hfamstd oeffd91 labgro91 htatzeit hvebzeit lfs91 is8891 ///
nace91 hpsbil expft91 exppt91 herwzeit hpbbil01 hpbbil02 hpbbil03 ///
using $dir/hpgen, clear

rename nation91 eu
rename hfamstd married
rename oeffd91 public_sector
rename labgro91 ly
rename htatzeit hrs_week
rename hvebzeit hrs_agreed
rename lfs91 job_stat
rename is8891 soc
rename nace91 sic
rename hpsbil degree
rename expft91 exp_ft
rename exppt91 exp_pt
rename herwzeit tenure
rename hpbbil01 vocational
rename hpbbil02 further
rename hpbbil03 no_voc

merge 1:1 persnr using wave7_junk_3
keep if _merge==3
drop _merge

recode bonus bonam jbbgy jbbgm doim doid yob perm_1 rules_ot hours_flex ///
region hrs_annual yeq perm_2 ly hrs_week hrs_agreed degree exp_ft exp_pt ///
tenure further (-3 -2 -1 = .)
recode self_employed vocational no_voc (-3 -2 -1 = .) (1/6 = 1)
recode unemployed jbbgly public_sector sex (-3 -2 -1 = .) (1 = 1) (2 = 0)
recode jbbgly_* jobchange_within* (-3 -2 -1 =.) (1/12 = 1)
recode eu		(-3 -2 -1 = .) ///
				(1 4 5 6 10 11 12 13 14 15 16 17 18 19 28 41 =0) ///
				(2 3 20/27 29/40 40/1000 = 1)
recode married (-3 -2 -1 = .) (1 2 6 = 1) (3 4 5 = 0)
recode job_stat (-3 -2 -1 = .) (1/10 = 0) (11 12 = 1)
recode soc 	(-3 -2 -1 = .)    	///
			(0/999 = 0)    		///
			(1000/1999 = 1)    	///
			(2000/2999 = 2)    	///
			(3000/3999 = 3)    	///
			(4000/4999 = 4)    	///
			(5000/5999 = 5)    	///
			(6000/6999 = 6)    	///
			(7000/7999 = 7)    	///
			(8000/8999 = 8)    	///
			(9000/9999 = 9)
recode sic 	(-3 -2 -1 = .) 		///
			(0/9 = 0)  			///
			(10/14 = 1)  		///
			(15/39 = 2)  		///
			(40/41 = 3)  		///
			(42/49 = 4)  		///
			(50/54 = 5)  		///
			(55/59 = 6)   		///
			(60/64 = 7)  		///
			(65/69 = 8)   		///
			(70/71 = 9)			///
			(72/74 = 10)		///
			(75/79 = 11)		///
			(80/84 = 12)	   	///
			(85/89 = 13)		///
			(90 = 14)			///
			(91/92 = 15)	   	///
			(95 = 16)			///
			(96/100 = 17)

** perm_1 could still have self-employed (3)!!!! check!!!
** perm_2 could still have unemployed (3)!!!! check!!!

save wave7, replace

//---------------------------------------------------------------------------//
//---------------------------------- 1992 -----------------------------------//
//---------------------------------------------------------------------------//

use persnr hhnr ip6709 ip6710 ip4701 ip4702 ipmonin iptagin ip4802 ip09 ///
ip10002 ip22g ip24g01 ip24g02 ip23g11 ip23g12 ip32g ip53 ip4902 ///
using $dir/ip, clear

rename ip6709 bonus
rename ip6710 bonam
rename ip4701 jbbgy
rename ip4702 jbbgm
rename ipmonin doim
rename iptagin doid
rename ip4802 self_employed
rename ip09 unemployed
rename ip10002 yob
rename ip22g jbbgly
rename ip24g01 jbbgly_2
rename ip24g02 jbbgly_3
rename ip23g11 jobchange_within1
rename ip23g12 jobchange_within2
rename ip32g perm_1
rename ip53 rules_ot
rename ip4902 hours_flex

generate wave=8
generate wavey=1992

save wave8_junk_1, replace

use hhnr nuts192 using $dir/ihgen, clear
sort hhnr, stable
quietly by hhnr: gen dup=cond(_N==1,0,_n)
drop if dup>1
drop dup

rename nuts192 region

merge 1:m  hhnr using wave8_junk_1
keep if _merge==3
drop _merge
save wave8_junk_2, replace

use persnr e1110192 d11102ll d1110992 e1110392 using $dir/ipequiv, clear

rename e1110192 hrs_annual
rename d11102ll sex
rename d1110992 yeq
rename e1110392 perm_2

merge 1:1 persnr using wave8_junk_2
keep if _merge==3
drop _merge
save wave8_junk_3, replace

use persnr nation92 ifamstd oeffd92 labgro92 itatzeit ivebzeit lfs92 is8892 ///
nace92 ipsbil expft92 exppt92 ierwzeit ipbbil01 ipbbil02 ipbbil03 ///
using $dir/ipgen, clear

rename nation92 eu
rename ifamstd married
rename oeffd92 public_sector
rename labgro92 ly
rename itatzeit hrs_week
rename ivebzeit hrs_agreed
rename lfs92 job_stat
rename is8892 soc
rename nace92 sic
rename ipsbil degree
rename expft92 exp_ft
rename exppt92 exp_pt
rename ierwzeit tenure
rename ipbbil01 vocational
rename ipbbil02 further
rename ipbbil03 no_voc

merge 1:1 persnr using wave8_junk_3
keep if _merge==3
drop _merge

recode bonus bonam jbbgy jbbgm doim doid yob perm_1 rules_ot hours_flex ///
region hrs_annual yeq perm_2 ly hrs_week hrs_agreed degree exp_ft exp_pt ///
tenure further (-3 -2 -1 = .)
recode self_employed vocational no_voc (-3 -2 -1 = .) (1/6 = 1)
recode unemployed jbbgly public_sector sex (-3 -2 -1 = .) (1 = 1) (2 = 0)
recode jbbgly_* jobchange_within* (-3 -2 -1 =.) (1/12 = 1)
recode eu		(-3 -2 -1 = .) ///
				(1 4 5 6 10 11 12 13 14 15 16 17 18 19 28 41 =0) ///
				(2 3 20/27 29/40 40/1000 = 1)
recode married (-3 -2 -1 = .) (1 2 6 = 1) (3 4 5 = 0)
recode job_stat (-3 -2 -1 = .) (1/10 = 0) (11 12 = 1)
recode soc 	(-3 -2 -1 = .)    	///
			(0/999 = 0)    		///
			(1000/1999 = 1)    	///
			(2000/2999 = 2)    	///
			(3000/3999 = 3)    	///
			(4000/4999 = 4)    	///
			(5000/5999 = 5)    	///
			(6000/6999 = 6)    	///
			(7000/7999 = 7)    	///
			(8000/8999 = 8)    	///
			(9000/9999 = 9)
recode sic 	(-3 -2 -1 = .) 		///
			(0/9 = 0)  			///
			(10/14 = 1)  		///
			(15/39 = 2)  		///
			(40/41 = 3)  		///
			(42/49 = 4)  		///
			(50/54 = 5)  		///
			(55/59 = 6)   		///
			(60/64 = 7)  		///
			(65/69 = 8)   		///
			(70/71 = 9)			///
			(72/74 = 10)		///
			(75/79 = 11)		///
			(80/84 = 12)	   	///
			(85/89 = 13)		///
			(90 = 14)			///
			(91/92 = 15)	   	///
			(95 = 16)			///
			(96/100 = 17)

** perm_1 could still have self-employed (3)!!!! check!!!
** perm_2 could still have unemployed (3)!!!! check!!!

save wave8, replace

//---------------------------------------------------------------------------//
//---------------------------------- 1993 -----------------------------------//
//---------------------------------------------------------------------------//

use persnr hhnr jp7709 jp7710 jp4601 jp4602 jpmonin jptagin jp4802 jp09 ///
jp10002 jp22g jp24g01 jp24g02 jp23g11 jp23g12 jp32g jp53 jp4902 ///
using $dir/jp, clear

rename jp7709 bonus
rename jp7710 bonam
rename jp4601 jbbgy
rename jp4602 jbbgm
rename jpmonin doim
rename jptagin doid
rename jp4802 self_employed
rename jp09 unemployed
rename jp10002 yob
rename jp22g jbbgly
rename jp24g01 jbbgly_2
rename jp24g02 jbbgly_3
rename jp23g11 jobchange_within1
rename jp23g12 jobchange_within2
rename jp32g perm_1
rename jp53 rules_ot
rename jp4902 hours_flex

generate wave=9
generate wavey=1993

save wave9_junk_1, replace

use hhnr nuts193 using $dir/jhgen, clear
sort hhnr, stable
quietly by hhnr: gen dup=cond(_N==1,0,_n)
drop if dup>1
drop dup

rename nuts193 region

merge 1:m  hhnr using wave9_junk_1
keep if _merge==3
drop _merge
save wave9_junk_2, replace

use persnr e1110193 d11102ll d1110993 e1110393 using $dir/jpequiv, clear

rename e1110193 hrs_annual
rename d11102ll sex
rename d1110993 yeq
rename e1110393 perm_2

merge 1:1 persnr using wave9_junk_2
keep if _merge==3
drop _merge
save wave9_junk_3, replace

use persnr nation93 jfamstd oeffd93 labgro93 jtatzeit jvebzeit lfs93 is8893 ///
nace93 jpsbil expft93 exppt93 jerwzeit jpbbil01 jpbbil02 jpbbil03 ///
using $dir/jpgen, clear

rename nation93 eu
rename jfamstd married
rename oeffd93 public_sector
rename labgro93 ly
rename jtatzeit hrs_week
rename jvebzeit hrs_agreed
rename lfs93 job_stat
rename is8893 soc
rename nace93 sic
rename jpsbil degree
rename expft93 exp_ft
rename exppt93 exp_pt
rename jerwzeit tenure
rename jpbbil01 vocational
rename jpbbil02 further
rename jpbbil03 no_voc

merge 1:1 persnr using wave9_junk_3
keep if _merge==3
drop _merge

recode bonus bonam jbbgy jbbgm doim doid yob perm_1 rules_ot hours_flex ///
region hrs_annual yeq perm_2 ly hrs_week hrs_agreed degree exp_ft exp_pt ///
tenure further (-3 -2 -1 = .)
recode self_employed no_voc vocational (-3 -2 -1 = .) (1/6 = 1)
recode unemployed jbbgly public_sector sex (-3 -2 -1 = .) (1 = 1) (2 = 0)
recode jbbgly_* jobchange_within* (-3 -2 -1 =.) (1/12 = 1)
recode eu		(-3 -2 -1 = .) ///
				(1 4 5 6 10 11 12 13 14 15 16 17 18 19 28 41 =0) ///
				(2 3 20/27 29/40 40/1000 = 1)
recode married (-3 -2 -1 = .) (1 2 6 = 1) (3 4 5 = 0)
recode job_stat (-3 -2 -1 = .) (1/10 = 0) (11 12 = 1)
recode soc 	(-3 -2 -1 = .)    	///
			(0/999 = 0)    		///
			(1000/1999 = 1)    	///
			(2000/2999 = 2)    	///
			(3000/3999 = 3)    	///
			(4000/4999 = 4)    	///
			(5000/5999 = 5)    	///
			(6000/6999 = 6)    	///
			(7000/7999 = 7)    	///
			(8000/8999 = 8)    	///
			(9000/9999 = 9)
recode sic 	(-3 -2 -1 = .) 		///
			(0/9 = 0)  			///
			(10/14 = 1)  		///
			(15/39 = 2)  		///
			(40/41 = 3)  		///
			(42/49 = 4)  		///
			(50/54 = 5)  		///
			(55/59 = 6)   		///
			(60/64 = 7)  		///
			(65/69 = 8)   		///
			(70/71 = 9)			///
			(72/74 = 10)		///
			(75/79 = 11)		///
			(80/84 = 12)	   	///
			(85/89 = 13)		///
			(90 = 14)			///
			(91/92 = 15)	   	///
			(95 = 16)			///
			(96/100 = 17)

** perm_1 could still have self-employed (3)!!!! check!!!
** perm_2 could still have unemployed (3)!!!! check!!!

save wave9, replace

//---------------------------------------------------------------------------//
//---------------------------------- 1994 -----------------------------------//
//---------------------------------------------------------------------------//

use persnr hhnr kp7709 kp7710 kp50 kpmonin kptagin kp5102 kp16 kp10002 ///
kp20 kp2101 kp2102 kp39 kp44 kp63 kp5902 using $dir/kp, clear

rename kp7709 bonus
rename kp7710 bonam
rename kp50 jbbgy
generate jbbgm=.
rename kpmonin doim
rename kptagin doid
rename kp5102 self_employed
rename kp16 unemployed
rename kp10002 yob
rename kp20 jbbgly
rename kp2101 jbbgly_2
rename kp2102 jbbgly_3
rename kp39 jobchange_within
rename kp44 perm_1
rename kp63 rules_ot
rename kp5902 hours_flex

generate wave=10
generate wavey=1994

save wave10_junk_1, replace

use hhnr nuts194 using $dir/khgen, clear
sort hhnr, stable
quietly by hhnr: gen dup=cond(_N==1,0,_n)
drop if dup>1
drop dup

rename nuts194 region

merge 1:m  hhnr using wave10_junk_1
keep if _merge==3
drop _merge
save wave10_junk_2, replace

use persnr e1110194 d11102ll d1110994 e1110394 using $dir/kpequiv, clear

rename e1110194 hrs_annual
rename d11102ll sex
rename d1110994 yeq
rename e1110394 perm_2

merge 1:1 persnr using wave10_junk_2
keep if _merge==3
drop _merge
save wave10_junk_3, replace

use persnr nation94 kfamstd oeffd94 labgro94 ktatzeit kvebzeit lfs94 is8894 ///
nace94 kpsbil expft94 exppt94 kerwzeit kpbbil01 kpbbil02 kpbbil03 ///
using $dir/kpgen, clear

rename nation94 eu
rename kfamstd married
rename oeffd94 public_sector
rename labgro94 ly
rename ktatzeit hrs_week
rename kvebzeit hrs_agreed
rename lfs94 job_stat
rename is8894 soc
rename nace94 sic
rename kpsbil degree
rename expft94 exp_ft
rename exppt94 exp_pt
rename kerwzeit tenure
rename kpbbil01 vocational
rename kpbbil02 further
rename kpbbil03 no_voc

merge 1:1 persnr using wave10_junk_3
keep if _merge==3
drop _merge

recode bonus bonam jbbgy jbbgm doim doid yob perm_1 rules_ot hours_flex ///
region hrs_annual yeq perm_2 ly hrs_week hrs_agreed degree exp_ft exp_pt ///
tenure further (-3 -2 -1 = .)
recode self_employed vocational no_voc (-3 -2 -1 = .) (1/6 = 1)
recode unemployed jbbgly public_sector sex (-3 -2 -1 = .) (1 = 1) (2 = 0)
recode jbbgly_* (-3 -2 -1 =.) (1/12 = 1)
recode jobchange_within (-3 -2 -1 = .) (1/4 = 0) (5 6 = 1)
recode eu		(-3 -2 -1 = .) ///
				(1 4 5 6 10 11 12 13 14 15 16 17 18 19 28 41 =0) ///
				(2 3 20/27 29/40 40/1000 = 1)
recode married (-3 -2 -1 = .) (1 2 6 = 1) (3 4 5 = 0)
recode job_stat (-3 -2 -1 = .) (1/10 = 0) (11 12 = 1)
recode soc 	(-3 -2 -1 = .)    	///
			(0/999 = 0)    		///
			(1000/1999 = 1)    	///
			(2000/2999 = 2)    	///
			(3000/3999 = 3)    	///
			(4000/4999 = 4)    	///
			(5000/5999 = 5)    	///
			(6000/6999 = 6)    	///
			(7000/7999 = 7)    	///
			(8000/8999 = 8)    	///
			(9000/9999 = 9)
recode sic 	(-3 -2 -1 = .) 		///
			(0/9 = 0)  			///
			(10/14 = 1)  		///
			(15/39 = 2)  		///
			(40/41 = 3)  		///
			(42/49 = 4)  		///
			(50/54 = 5)  		///
			(55/59 = 6)   		///
			(60/64 = 7)  		///
			(65/69 = 8)   		///
			(70/71 = 9)			///
			(72/74 = 10)		///
			(75/79 = 11)		///
			(80/84 = 12)	   	///
			(85/89 = 13)		///
			(90 = 14)			///
			(91/92 = 15)	   	///
			(95 = 16)			///
			(96/100 = 17)

** perm_1 could still have self-employed (3)!!!! check!!!
** perm_2 could still have unemployed (3)!!!! check!!!

save wave10, replace

//---------------------------------------------------------------------------//
//---------------------------------- 1995 -----------------------------------//
//---------------------------------------------------------------------------//

use persnr hhnr lp8209 lp8210 lp41 lpmonin lptagin lp4302 lp13 lp10002 ///
lp16 lp1701 lp1702 lp31 lp42 lp52 lp4802 using $dir/lp, clear

rename lp8209 bonus
rename lp8210 bonam
rename lp41 jbbgy
generate jbbgm=.
rename lpmonin doim
rename lptagin doid
rename lp4302 self_employed
rename lp13 unemployed
rename lp10002 yob
rename lp16 jbbgly
rename lp1701 jbbgly_2
rename lp1702 jbbgly_3
rename lp31 jobchange_within
rename lp42 perm_1
rename lp52 rules_ot
rename lp4802 hours_flex

generate wave=11
generate wavey=1995

save wave11_junk_1, replace

use hhnr nuts195 using $dir/lhgen, clear
sort hhnr, stable
quietly by hhnr: gen dup=cond(_N==1,0,_n)
drop if dup>1
drop dup

rename nuts195 region

merge 1:m  hhnr using wave11_junk_1
keep if _merge==3
drop _merge
save wave11_junk_2, replace

use persnr e1110195 d11102ll d1110995 e1110395 using $dir/lpequiv, clear

rename e1110195 hrs_annual
rename d11102ll sex
rename d1110995 yeq
rename e1110395 perm_2

merge 1:1 persnr using wave11_junk_2
keep if _merge==3
drop _merge
save wave11_junk_3, replace

use persnr nation95 lfamstd oeffd95 labgro95 ltatzeit lvebzeit lfs95 is8895 ///
nace95 lpsbil expft95 exppt95 lerwzeit lpbbil01 lpbbil02 lpbbil03 ///
using $dir/lpgen, clear

rename nation95 eu
rename lfamstd married
rename oeffd95 public_sector
rename labgro95 ly
rename ltatzeit hrs_week
rename lvebzeit hrs_agreed
rename lfs95 job_stat
rename is8895 soc
rename nace95 sic
rename lpsbil degree
rename expft95 exp_ft
rename exppt95 exp_pt
rename lerwzeit tenure
rename lpbbil01 vocational
rename lpbbil02 further
rename lpbbil03 no_voc

merge 1:1 persnr using wave11_junk_3
keep if _merge==3
drop _merge

recode bonus bonam jbbgy jbbgm doim doid yob perm_1 rules_ot hours_flex ///
region hrs_annual yeq perm_2 ly hrs_week hrs_agreed degree exp_ft exp_pt ///
tenure further (-3 -2 -1 = .)
recode self_employed vocational no_voc (-3 -2 -1 = .) (1/6 = 1)
recode unemployed jbbgly public_sector sex (-3 -2 -1 = .) (1 = 1) (2 = 0)
recode jbbgly_* (-3 -2 -1 =.) (1/12 = 1)
recode jobchange_within (-3 -2 -1 = .) (1/4 = 0) (5 6 = 1)
recode eu		(-3 -2 -1 = .) ///
				(1 4 5 6 10 11 12 13 14 15 16 17 18 19 28 41 =0) ///
				(2 3 20/27 29/40 40/1000 = 1)
recode married (-3 -2 -1 = .) (1 2 6 = 1) (3 4 5 = 0)
recode job_stat (-3 -2 -1 = .) (1/10 = 0) (11 12 = 1)
recode soc 	(-3 -2 -1 = .)    	///
			(0/999 = 0)    		///
			(1000/1999 = 1)    	///
			(2000/2999 = 2)    	///
			(3000/3999 = 3)    	///
			(4000/4999 = 4)    	///
			(5000/5999 = 5)    	///
			(6000/6999 = 6)    	///
			(7000/7999 = 7)    	///
			(8000/8999 = 8)    	///
			(9000/9999 = 9)
recode sic 	(-3 -2 -1 = .) 		///
			(0/9 = 0)  			///
			(10/14 = 1)  		///
			(15/39 = 2)  		///
			(40/41 = 3)  		///
			(42/49 = 4)  		///
			(50/54 = 5)  		///
			(55/59 = 6)   		///
			(60/64 = 7)  		///
			(65/69 = 8)   		///
			(70/71 = 9)			///
			(72/74 = 10)		///
			(75/79 = 11)		///
			(80/84 = 12)	   	///
			(85/89 = 13)		///
			(90 = 14)			///
			(91/92 = 15)	   	///
			(95 = 16)			///
			(96/100 = 17)

** perm_1 could still have self-employed (3)!!!! check!!!
** perm_2 could still have unemployed (3)!!!! check!!!

save wave11, replace

//---------------------------------------------------------------------------//
//---------------------------------- 1996 -----------------------------------//
//---------------------------------------------------------------------------//

use persnr hhnr mp6809 mp6810 mp3901 mp3902 mpmonin mptagin mp4102 mp12 ///
mp10502 mp61 mp6201 mp6202 mp29 mp40 mp46 mp4202 using $dir/mp, clear

rename mp6809 bonus
rename mp6810 bonam
rename mp3901 jbbgy
rename mp3902 jbbgm
rename mpmonin doim
rename mptagin doid
rename mp4102 self_employed
rename mp12 unemployed
rename mp10502 yob
rename mp61 jbbgly
rename mp6201 jbbgly_2
rename mp6202 jbbgly_3
rename mp29 jobchange_within
rename mp40 perm_1
rename mp46 rules_ot
rename mp4202 hours_flex

generate wave=12
generate wavey=1996

save wave12_junk_1, replace

use hhnr nuts196 using $dir/mhgen, clear
sort hhnr, stable
quietly by hhnr: gen dup=cond(_N==1,0,_n)
drop if dup>1
drop dup

rename nuts196 region

merge 1:m  hhnr using wave12_junk_1
keep if _merge==3
drop _merge
save wave12_junk_2, replace

use persnr e1110196 d11102ll d1110996 e1110396 using $dir/mpequiv, clear

rename e1110196 hrs_annual
rename d11102ll sex
rename d1110996 yeq
rename e1110396 perm_2

merge 1:1 persnr using wave12_junk_2
keep if _merge==3
drop _merge
save wave12_junk_3, replace

use persnr nation96 mfamstd oeffd96 labgro96 mtatzeit mvebzeit lfs96 is8896 ///
nace96 mpsbil expft96 exppt96 merwzeit mpbbil01 mpbbil02 mpbbil03 ///
using $dir/mpgen, clear

rename nation96 eu
rename mfamstd married
rename oeffd96 public_sector
rename labgro96 ly
rename mtatzeit hrs_week
rename mvebzeit hrs_agreed
rename lfs96 job_stat
rename is8896 soc
rename nace96 sic
rename mpsbil degree
rename expft96 exp_ft
rename exppt96 exp_pt
rename merwzeit tenure
rename mpbbil01 vocational
rename mpbbil02 further
rename mpbbil03 no_voc

merge 1:1 persnr using wave12_junk_3
keep if _merge==3
drop _merge

recode bonus bonam jbbgy jbbgm doim doid yob perm_1 rules_ot hours_flex ///
region hrs_annual yeq perm_2 ly hrs_week hrs_agreed degree exp_ft exp_pt ///
tenure further (-3 -2 -1 = .)
recode self_employed vocational no_voc (-3 -2 -1 = .) (1/6 = 1)
recode unemployed jbbgly public_sector sex (-3 -2 -1 = .) (1 = 1) (2 = 0)
recode jbbgly_* (-3 -2 -1 =.) (1/12 = 1)
recode jobchange_within (-3 -2 -1 = .) (1/4 = 0) (5 6 = 1)
recode eu		(-3 -2 -1 = .) ///
				(1 4 5 6 10 11 12 13 14 15 16 17 18 19 28 41 =0) ///
				(2 3 20/27 29/40 40/1000 = 1)
recode married (-3 -2 -1 = .) (1 2 6 = 1) (3 4 5 = 0)
recode job_stat (-3 -2 -1 = .) (1/10 = 0) (11 12 = 1)
recode soc 	(-3 -2 -1 = .)    	///
			(0/999 = 0)    		///
			(1000/1999 = 1)    	///
			(2000/2999 = 2)    	///
			(3000/3999 = 3)    	///
			(4000/4999 = 4)    	///
			(5000/5999 = 5)    	///
			(6000/6999 = 6)    	///
			(7000/7999 = 7)    	///
			(8000/8999 = 8)    	///
			(9000/9999 = 9)
recode sic 	(-3 -2 -1 = .) 		///
			(0/9 = 0)  			///
			(10/14 = 1)  		///
			(15/39 = 2)  		///
			(40/41 = 3)  		///
			(42/49 = 4)  		///
			(50/54 = 5)  		///
			(55/59 = 6)   		///
			(60/64 = 7)  		///
			(65/69 = 8)   		///
			(70/71 = 9)			///
			(72/74 = 10)		///
			(75/79 = 11)		///
			(80/84 = 12)	   	///
			(85/89 = 13)		///
			(90 = 14)			///
			(91/92 = 15)	   	///
			(95 = 16)			///
			(96/100 = 17)

** perm_1 could still have self-employed (3)!!!! check!!!
** perm_2 could still have unemployed (3)!!!! check!!!

save wave12, replace

//---------------------------------------------------------------------------//
//---------------------------------- 1997 -----------------------------------//
//---------------------------------------------------------------------------//

use persnr hhnr np6809 np6810 np3301 np3302 npmonin nptagin np3502 np08 ///
np11202 np61 np6201 np6202 np23 np3401 np5201 np4602 using $dir/np, clear

rename np6809 bonus
rename np6810 bonam
rename np3301 jbbgy
rename np3302 jbbgm
rename npmonin doim
rename nptagin doid
rename np3502 self_employed
rename np08 unemployed
rename np11202 yob
rename np61 jbbgly
rename np6201 jbbgly_2
rename np6202 jbbgly_3
rename np23 jobchange_within
rename np3401 perm_1
rename np5201 rules_ot
rename np4602 hours_flex

generate wave=13
generate wavey=1997

save wave13_junk_1, replace

use hhnr nuts197 using $dir/nhgen, clear
sort hhnr, stable
quietly by hhnr: gen dup=cond(_N==1,0,_n)
drop if dup>1
drop dup

rename nuts197 region

merge 1:m  hhnr using wave13_junk_1
keep if _merge==3
drop _merge
save wave13_junk_2, replace

use persnr e1110197 d11102ll d1110997 e1110397 using $dir/npequiv, clear

rename e1110197 hrs_annual
rename d11102ll sex
rename d1110997 yeq
rename e1110397 perm_2

merge 1:1 persnr using wave13_junk_2
keep if _merge==3
drop _merge
save wave13_junk_3, replace

use persnr nation97 nfamstd oeffd97 labgro97 ntatzeit nvebzeit lfs97 is8897 ///
nace97 npsbil expft97 exppt97 nerwzeit npbbil01 npbbil02 npbbil03 ///
using $dir/npgen, clear

rename nation97 eu
rename nfamstd married
rename oeffd97 public_sector
rename labgro97 ly
rename ntatzeit hrs_week
rename nvebzeit hrs_agreed
rename lfs97 job_stat
rename is8897 soc
rename nace97 sic
rename npsbil degree
rename expft97 exp_ft
rename exppt97 exp_pt
rename nerwzeit tenure
rename npbbil01 vocational
rename npbbil02 further
rename npbbil03 no_voc

merge 1:1 persnr using wave13_junk_3
keep if _merge==3
drop _merge

recode bonus bonam jbbgy jbbgm doim doid yob perm_1 rules_ot hours_flex ///
region hrs_annual yeq perm_2 ly hrs_week hrs_agreed degree exp_ft exp_pt ///
tenure further (-3 -2 -1 = .)
recode self_employed vocational no_voc (-3 -2 -1 = .) (1/6 = 1)
recode unemployed jbbgly public_sector sex (-3 -2 -1 = .) (1 = 1) (2 = 0)
recode jbbgly_* (-3 -2 -1 =.) (1/12 = 1)
recode jobchange_within (-3 -2 -1 = .) (1/4 = 0) (5 6 = 1)
recode eu		(-3 -2 -1 = .) ///
				(1 4 5 6 10 11 12 13 14 15 16 17 18 19 28 41 =0) ///
				(2 3 20/27 29/40 40/1000 = 1)
recode married (-3 -2 -1 = .) (1 2 6 = 1) (3 4 5 = 0)
recode job_stat (-3 -2 -1 = .) (1/10 = 0) (11 12 = 1)
recode soc 	(-3 -2 -1 = .)    	///
			(0/999 = 0)    		///
			(1000/1999 = 1)    	///
			(2000/2999 = 2)    	///
			(3000/3999 = 3)    	///
			(4000/4999 = 4)    	///
			(5000/5999 = 5)    	///
			(6000/6999 = 6)    	///
			(7000/7999 = 7)    	///
			(8000/8999 = 8)    	///
			(9000/9999 = 9)
recode sic 	(-3 -2 -1 = .) 		///
			(0/9 = 0)  			///
			(10/14 = 1)  		///
			(15/39 = 2)  		///
			(40/41 = 3)  		///
			(42/49 = 4)  		///
			(50/54 = 5)  		///
			(55/59 = 6)   		///
			(60/64 = 7)  		///
			(65/69 = 8)   		///
			(70/71 = 9)			///
			(72/74 = 10)		///
			(75/79 = 11)		///
			(80/84 = 12)	   	///
			(85/89 = 13)		///
			(90 = 14)			///
			(91/92 = 15)	   	///
			(95 = 16)			///
			(96/100 = 17)

** perm_1 could still have self-employed (3)!!!! check!!!
** perm_2 could still have unemployed (3)!!!! check!!!

save wave13, replace

//---------------------------------------------------------------------------//
//---------------------------------- 1998 -----------------------------------//
//---------------------------------------------------------------------------//

use persnr hhnr op5909 op5910 op3301 op3302 opmonin optagin op3502 op04 ///
op11802 op52 op5301 op5302 op23 op3401 op4301 op3902 using $dir/op, clear

rename op5909 bonus
rename op5910 bonam
rename op3301 jbbgy
rename op3302 jbbgm
rename opmonin doim
rename optagin doid
rename op3502 self_employed
rename op04 unemployed
rename op11802 yob
rename op52 jbbgly
rename op5301 jbbgly_2
rename op5302 jbbgly_3
rename op23 jobchange_within
rename op3401 perm_1
rename op4301 rules_ot
rename op3902 hours_flex

generate wave=14
generate wavey=1998

save wave14_junk_1, replace

use hhnr nuts198 using $dir/ohgen, clear
sort hhnr, stable
quietly by hhnr: gen dup=cond(_N==1,0,_n)
drop if dup>1
drop dup

rename nuts198 region

merge 1:m  hhnr using wave14_junk_1
keep if _merge==3
drop _merge
save wave14_junk_2, replace

use persnr e1110198 d11102ll d1110998 e1110398 using $dir/opequiv, clear

rename e1110198 hrs_annual
rename d11102ll sex
rename d1110998 yeq
rename e1110398 perm_2

merge 1:1 persnr using wave14_junk_2
keep if _merge==3
drop _merge
save wave14_junk_3, replace

use persnr nation98 ofamstd oeffd98 labgro98 otatzeit ovebzeit lfs98 is8898 ///
nace98 opsbil expft98 exppt98 oerwzeit opbbil01 opbbil02 opbbil03 ///
using $dir/opgen, clear

rename nation98 eu
rename ofamstd married
rename oeffd98 public_sector
rename labgro98 ly
rename otatzeit hrs_week
rename ovebzeit hrs_agreed
rename lfs98 job_stat
rename is8898 soc
rename nace98 sic
rename opsbil degree
rename expft98 exp_ft
rename exppt98 exp_pt
rename oerwzeit tenure
rename opbbil01 vocational
rename opbbil02 further
rename opbbil03 no_voc

merge 1:1 persnr using wave14_junk_3
keep if _merge==3
drop _merge

recode bonus bonam jbbgy jbbgm doim doid yob perm_1 rules_ot hours_flex ///
region hrs_annual yeq perm_2 ly hrs_week hrs_agreed degree exp_ft exp_pt ///
tenure further (-3 -2 -1 = .)
recode self_employed vocational no_voc (-3 -2 -1 = .) (1/6 = 1)
recode unemployed jbbgly public_sector sex (-3 -2 -1 = .) (1 = 1) (2 = 0)
recode jbbgly_* (-3 -2 -1 =.) (1/12 = 1)
recode jobchange_within (-3 -2 -1 = .) (1/4 = 0) (5 6 = 1)
recode eu		(-3 -2 -1 = .) ///
				(1 4 5 6 10 11 12 13 14 15 16 17 18 19 28 41 =0) ///
				(2 3 20/27 29/40 40/1000 = 1)
recode married (-3 -2 -1 = .) (1 2 6 = 1) (3 4 5 = 0)
recode job_stat (-3 -2 -1 = .) (1/10 = 0) (11 12 = 1)
recode soc 	(-3 -2 -1 = .)    	///
			(0/999 = 0)    		///
			(1000/1999 = 1)    	///
			(2000/2999 = 2)    	///
			(3000/3999 = 3)    	///
			(4000/4999 = 4)    	///
			(5000/5999 = 5)    	///
			(6000/6999 = 6)    	///
			(7000/7999 = 7)    	///
			(8000/8999 = 8)    	///
			(9000/9999 = 9)
recode sic 	(-3 -2 -1 = .) 		///
			(0/9 = 0)  			///
			(10/14 = 1)  		///
			(15/39 = 2)  		///
			(40/41 = 3)  		///
			(42/49 = 4)  		///
			(50/54 = 5)  		///
			(55/59 = 6)   		///
			(60/64 = 7)  		///
			(65/69 = 8)   		///
			(70/71 = 9)			///
			(72/74 = 10)		///
			(75/79 = 11)		///
			(80/84 = 12)	   	///
			(85/89 = 13)		///
			(90 = 14)			///
			(91/92 = 15)	   	///
			(95 = 16)			///
			(96/100 = 17)

** perm_1 could still have self-employed (3)!!!! check!!!
** perm_2 could still have unemployed (3)!!!! check!!!

save wave14, replace

//---------------------------------------------------------------------------//
//---------------------------------- 1999 -----------------------------------//
//---------------------------------------------------------------------------//

use persnr hhnr pp7709 pp7710 pp3602 pp3601 ppmonin pptagin pp3802 pp05 ///
pp13002 pp69 pp7001 pp7002 pp23 pp3701 pp5801 pp5102 using $dir/pp, clear

rename pp7709 bonus
rename pp7710 bonam
rename pp3602 jbbgy
rename pp3601 jbbgm
rename ppmonin doim
rename pptagin doid
rename pp3802 self_employed
rename pp05 unemployed
rename pp13002 yob
rename pp69 jbbgly
rename pp7001 jbbgly_2
rename pp7002 jbbgly_3
rename pp23 jobchange_within
rename pp3701 perm_1
rename pp5801 rules_ot
rename pp5102 hours_flex

generate wave=15
generate wavey=1999

save wave15_junk_1, replace

use hhnr nuts199 using $dir/phgen, clear
sort hhnr, stable
quietly by hhnr: gen dup=cond(_N==1,0,_n)
drop if dup>1
drop dup

rename nuts199 region

merge 1:m  hhnr using wave15_junk_1
keep if _merge==3
drop _merge
save wave15_junk_2, replace

use persnr e1110199 d11102ll d1110999 e1110399 using $dir/ppequiv, clear

rename e1110199 hrs_annual
rename d11102ll sex
rename d1110999 yeq
rename e1110399 perm_2

merge 1:1 persnr using wave15_junk_2
keep if _merge==3
drop _merge
save wave15_junk_3, replace

use persnr nation99 pfamstd oeffd99 labgro99 ptatzeit pvebzeit lfs99 is8899 ///
nace99 ppsbil expft99 exppt99 perwzeit ppbbil01 ppbbil02 ppbbil03 ///
using $dir/ppgen, clear

rename nation99 eu
rename pfamstd married
rename oeffd99 public_sector
rename labgro99 ly
rename ptatzeit hrs_week
rename pvebzeit hrs_agreed
rename lfs99 job_stat
rename is8899 soc
rename nace99 sic
rename ppsbil degree
rename expft99 exp_ft
rename exppt99 exp_pt
rename perwzeit tenure
rename ppbbil01 vocational
rename ppbbil02 further
rename ppbbil03 no_voc

merge 1:1 persnr using wave15_junk_3
keep if _merge==3
drop _merge

recode bonus bonam jbbgy jbbgm doim doid yob perm_1 rules_ot hours_flex ///
region hrs_annual yeq perm_2 ly hrs_week hrs_agreed degree exp_ft exp_pt ///
tenure further(-3 -2 -1 = .)
recode self_employed vocational no_voc (-3 -2 -1 = .) (1/6 = 1)
recode unemployed jbbgly public_sector sex (-3 -2 -1 = .) (1 = 1) (2 = 0)
recode jbbgly_* (-3 -2 -1 =.) (1/12 = 1)
recode jobchange_within (-3 -2 -1 = .) (1/4 = 0) (5 6 = 1)
recode eu		(-3 -2 -1 = .) ///
				(1 4 5 6 10 11 12 13 14 15 16 17 18 19 28 41 =0) ///
				(2 3 20/27 29/40 40/1000 = 1)
recode married (-3 -2 -1 = .) (1 2 6 = 1) (3 4 5 = 0)
recode job_stat (-3 -2 -1 = .) (1/10 = 0) (11 12 = 1)
recode soc 	(-3 -2 -1 = .)    	///
			(0/999 = 0)    		///
			(1000/1999 = 1)    	///
			(2000/2999 = 2)    	///
			(3000/3999 = 3)    	///
			(4000/4999 = 4)    	///
			(5000/5999 = 5)    	///
			(6000/6999 = 6)    	///
			(7000/7999 = 7)    	///
			(8000/8999 = 8)    	///
			(9000/9999 = 9)
recode sic 	(-3 -2 -1 = .) 		///
			(0/9 = 0)  			///
			(10/14 = 1)  		///
			(15/39 = 2)  		///
			(40/41 = 3)  		///
			(42/49 = 4)  		///
			(50/54 = 5)  		///
			(55/59 = 6)   		///
			(60/64 = 7)  		///
			(65/69 = 8)   		///
			(70/71 = 9)			///
			(72/74 = 10)		///
			(75/79 = 11)		///
			(80/84 = 12)	   	///
			(85/89 = 13)		///
			(90 = 14)			///
			(91/92 = 15)	   	///
			(95 = 16)			///
			(96/100 = 17)

** perm_1 could still have self-employed (3)!!!! check!!!
** perm_2 could still have unemployed (3)!!!! check!!!

save wave15, replace

//---------------------------------------------------------------------------//
//---------------------------------- 2000 -----------------------------------//
//---------------------------------------------------------------------------//

use persnr hhnr qp7709 qp7710 qp3402 qp3401 qpmonin qptagin qp3602 qp04 ///
qp13902 qp69 qp7001 qp7002 qp22 qp3501 qp5401 qp4902 using $dir/qp, clear

rename qp7709 bonus
rename qp7710 bonam
rename qp3402 jbbgy
rename qp3401 jbbgm
rename qpmonin doim
rename qptagin doid
rename qp3602 self_employed
rename qp04 unemployed
rename qp13902 yob
rename qp69 jbbgly
rename qp7001 jbbgly_2
rename qp7002 jbbgly_3
rename qp22 jobchange_within
rename qp3501 perm_1
rename qp5401 rules_ot
rename qp4902 hours_flex

generate wave=16
generate wavey=2000

save wave16_junk_1, replace

use hhnr nuts100 using $dir/qhgen, clear
sort hhnr, stable
quietly by hhnr: gen dup=cond(_N==1,0,_n)
drop if dup>1
drop dup

rename nuts100 region

merge 1:m  hhnr using wave16_junk_1
keep if _merge==3
drop _merge
save wave16_junk_2, replace

use persnr e1110100 d11102ll d1110900 e1110300 using $dir/qpequiv, clear

rename e1110100 hrs_annual
rename d11102ll sex
rename d1110900 yeq
rename e1110300 perm_2

merge 1:1 persnr using wave16_junk_2
keep if _merge==3
drop _merge
save wave16_junk_3, replace

use persnr nation00 qfamstd oeffd00 labgro00 qtatzeit qvebzeit lfs00 is8800 ///
nace00 qpsbil expft00 exppt00 qerwzeit qpbbil01 qpbbil02 qpbbil03 ///
using $dir/qpgen, clear

rename nation00 eu
rename qfamstd married
rename oeffd00 public_sector
rename labgro00 ly
rename qtatzeit hrs_week
rename qvebzeit hrs_agreed
rename lfs00 job_stat
rename is8800 soc
rename nace00 sic
rename qpsbil degree
rename expft00 exp_ft
rename exppt00 exp_pt
rename qerwzeit tenure
rename qpbbil01 vocational
rename qpbbil02 further
rename qpbbil03 no_voc

merge 1:1 persnr using wave16_junk_3
keep if _merge==3
drop _merge

recode bonus bonam jbbgy jbbgm doim doid yob perm_1 rules_ot hours_flex ///
region hrs_annual yeq perm_2 ly hrs_week hrs_agreed degree exp_ft exp_pt ///
tenure further (-3 -2 -1 = .)
recode self_employed vocational no_voc (-3 -2 -1 = .) (1/6 = 1)
recode unemployed jbbgly public_sector sex (-3 -2 -1 = .) (1 = 1) (2 = 0)
recode jbbgly_* (-3 -2 -1 =.) (1/12 = 1)
recode jobchange_within (-3 -2 -1 = .) (1/4 = 0) (5 6 = 1)
recode eu		(-3 -2 -1 = .) ///
				(1 4 5 6 10 11 12 13 14 15 16 17 18 19 28 41 =0) ///
				(2 3 20/27 29/40 40/1000 = 1)
recode married (-3 -2 -1 = .) (1 2 6 = 1) (3 4 5 = 0)
recode job_stat (-3 -2 -1 = .) (1/10 = 0) (11 12 = 1)
recode soc 	(-3 -2 -1 = .)    	///
			(0/999 = 0)    		///
			(1000/1999 = 1)    	///
			(2000/2999 = 2)    	///
			(3000/3999 = 3)    	///
			(4000/4999 = 4)    	///
			(5000/5999 = 5)    	///
			(6000/6999 = 6)    	///
			(7000/7999 = 7)    	///
			(8000/8999 = 8)    	///
			(9000/9999 = 9)
recode sic 	(-3 -2 -1 = .) 		///
			(0/9 = 0)  			///
			(10/14 = 1)  		///
			(15/39 = 2)  		///
			(40/41 = 3)  		///
			(42/49 = 4)  		///
			(50/54 = 5)  		///
			(55/59 = 6)   		///
			(60/64 = 7)  		///
			(65/69 = 8)   		///
			(70/71 = 9)			///
			(72/74 = 10)		///
			(75/79 = 11)		///
			(80/84 = 12)	   	///
			(85/89 = 13)		///
			(90 = 14)			///
			(91/92 = 15)	   	///
			(95 = 16)			///
			(96/100 = 17)

** perm_1 could still have self-employed (3)!!!! check!!!
** perm_2 could still have unemployed (3)!!!! check!!!

save wave16, replace

//---------------------------------------------------------------------------//
//---------------------------------- 2001 -----------------------------------//
//---------------------------------------------------------------------------//

use persnr hhnr rp7709 rp7710 rp3702 rp3701 rpmonin rptagin rp4002 rp09 ///
rp13002 rp69 rp7001 rp7002 rp25 rp3901 rp5501 rp4902 using $dir/rp, clear

rename rp7709 bonus
rename rp7710 bonam
rename rp3702 jbbgy
rename rp3701 jbbgm
rename rpmonin doim
rename rptagin doid
rename rp4002 self_employed
rename rp09 unemployed
rename rp13002 yob
rename rp69 jbbgly
rename rp7001 jbbgly_2
rename rp7002 jbbgly_3
rename rp25 jobchange_within
rename rp3901 perm_1
rename rp5501 rules_ot
rename rp4902 hours_flex

generate wave=17
generate wavey=2001

save wave17_junk_1, replace

use hhnr nuts101 using $dir/rhgen, clear
sort hhnr, stable
quietly by hhnr: gen dup=cond(_N==1,0,_n)
drop if dup>1
drop dup

rename nuts101 region

merge 1:m  hhnr using wave17_junk_1
keep if _merge==3
drop _merge
save wave17_junk_2, replace

use persnr e1110101 d11102ll d1110901 e1110301 using $dir/rpequiv, clear

rename e1110101 hrs_annual
rename d11102ll sex
rename d1110901 yeq
rename e1110301 perm_2

merge 1:1 persnr using wave17_junk_2
keep if _merge==3
drop _merge
save wave17_junk_3, replace

use persnr nation01 rfamstd oeffd01 labgro01 rtatzeit rvebzeit lfs01 is8801 ///
nace01 rpsbil expft01 exppt01 rerwzeit rpbbil01 rpbbil02 rpbbil03 ///
using $dir/rpgen, clear

rename nation01 eu
rename rfamstd married
rename oeffd01 public_sector
rename labgro01 ly
rename rtatzeit hrs_week
rename rvebzeit hrs_agreed
rename lfs01 job_stat
rename is8801 soc
rename nace01 sic
rename rpsbil degree
rename expft01 exp_ft
rename exppt01 exp_pt
rename rerwzeit tenure
rename rpbbil01 vocational
rename rpbbil02 further
rename rpbbil03 no_voc

merge 1:1 persnr using wave17_junk_3
keep if _merge==3
drop _merge

recode bonus bonam jbbgy jbbgm doim doid yob perm_1 rules_ot hours_flex ///
region hrs_annual yeq perm_2 ly hrs_week hrs_agreed degree exp_ft exp_pt ///
tenure further (-3 -2 -1 = .)
recode self_employed vocational no_voc (-3 -2 -1 = .) (1/6 = 1)
recode unemployed jbbgly public_sector sex (-3 -2 -1 = .) (1 = 1) (2 = 0)
recode jbbgly_* (-3 -2 -1 =.) (1/12 = 1)
recode jobchange_within (-3 -2 -1 = .) (1/4 = 0) (5 6 = 1)
recode eu		(-3 -2 -1 = .) ///
				(1 4 5 6 10 11 12 13 14 15 16 17 18 19 28 41 =0) ///
				(2 3 20/27 29/40 40/1000 = 1)
recode married (-3 -2 -1 = .) (1 2 6 = 1) (3 4 5 = 0)
recode job_stat (-3 -2 -1 = .) (1/10 = 0) (11 12 = 1)
recode soc 	(-3 -2 -1 = .)    	///
			(0/999 = 0)    		///
			(1000/1999 = 1)    	///
			(2000/2999 = 2)    	///
			(3000/3999 = 3)    	///
			(4000/4999 = 4)    	///
			(5000/5999 = 5)    	///
			(6000/6999 = 6)    	///
			(7000/7999 = 7)    	///
			(8000/8999 = 8)    	///
			(9000/9999 = 9)
recode sic 	(-3 -2 -1 = .) 		///
			(0/9 = 0)  			///
			(10/14 = 1)  		///
			(15/39 = 2)  		///
			(40/41 = 3)  		///
			(42/49 = 4)  		///
			(50/54 = 5)  		///
			(55/59 = 6)   		///
			(60/64 = 7)  		///
			(65/69 = 8)   		///
			(70/71 = 9)			///
			(72/74 = 10)		///
			(75/79 = 11)		///
			(80/84 = 12)	   	///
			(85/89 = 13)		///
			(90 = 14)			///
			(91/92 = 15)	   	///
			(95 = 16)			///
			(96/100 = 17)

** perm_1 could still have self-employed (3)!!!! check!!!
** perm_2 could still have unemployed (3)!!!! check!!!

save wave17, replace

//---------------------------------------------------------------------------//
//---------------------------------- 2002 -----------------------------------//
//---------------------------------------------------------------------------//

use persnr hhnr sp7709 sp7710 sp3702 sp3701 spmonin sptagin sp4002 sp10 ///
sp13002 sp69 sp7001 sp7002 sp25 sp3901 sp56 sp5102 using $dir/sp, clear

rename sp7709 bonus
rename sp7710 bonam
rename sp3702 jbbgy
rename sp3701 jbbgm
rename spmonin doim
rename sptagin doid
rename sp4002 self_employed
rename sp10 unemployed
rename sp13002 yob
rename sp69 jbbgly
rename sp7001 jbbgly_2
rename sp7002 jbbgly_3
rename sp25 jobchange_within
rename sp3901 perm_1
rename sp56 rules_ot
rename sp5102 hours_flex

generate wave=18
generate wavey=2002

save wave18_junk_1, replace

use hhnr nuts102 using $dir/shgen, clear
sort hhnr, stable
quietly by hhnr: gen dup=cond(_N==1,0,_n)
drop if dup>1
drop dup

rename nuts102 region

merge 1:m  hhnr using wave18_junk_1
keep if _merge==3
drop _merge
save wave18_junk_2, replace

use persnr e1110102 d11102ll d1110902 e1110302 using $dir/spequiv, clear

rename e1110102 hrs_annual
rename d11102ll sex
rename d1110902 yeq
rename e1110302 perm_2

merge 1:1 persnr using wave18_junk_2
keep if _merge==3
drop _merge
save wave18_junk_3, replace

use persnr nation02 sfamstd oeffd02 labgro02 statzeit svebzeit lfs02 is8802 ///
nace02 spsbil expft02 exppt02 serwzeit spbbil01 spbbil02 spbbil03 ///
using $dir/spgen, clear

rename nation02 eu
rename sfamstd married
rename oeffd02 public_sector
rename labgro02 ly
rename statzeit hrs_week
rename svebzeit hrs_agreed
rename lfs02 job_stat
rename is8802 soc
rename nace02 sic
rename spsbil degree
rename expft02 exp_ft
rename exppt02 exp_pt
rename serwzeit tenure
rename spbbil01 vocational
rename spbbil02 further
rename spbbil03 no_voc

merge 1:1 persnr using wave18_junk_3
keep if _merge==3
drop _merge

recode bonus bonam jbbgy jbbgm doim doid yob perm_1 rules_ot hours_flex ///
region hrs_annual yeq perm_2 ly hrs_week hrs_agreed degree exp_ft exp_pt ///
tenure further (-3 -2 -1 = .)
recode self_employed vocational no_voc (-3 -2 -1 = .) (1/6 = 1)
recode unemployed jbbgly public_sector sex (-3 -2 -1 = .) (1 = 1) (2 = 0)
recode jbbgly_* (-3 -2 -1 =.) (1/12 = 1)
recode jobchange_within (-3 -2 -1 = .) (1/4 = 0) (5 6 = 1)
recode eu		(-3 -2 -1 = .) ///
				(1 4 5 6 10 11 12 13 14 15 16 17 18 19 28 41 =0) ///
				(2 3 20/27 29/40 40/1000 = 1)
recode married (-3 -2 -1 = .) (1 2 6 = 1) (3 4 5 = 0)
recode job_stat (-3 -2 -1 = .) (1/10 = 0) (11 12 = 1)
recode soc 	(-3 -2 -1 = .)    	///
			(0/999 = 0)    		///
			(1000/1999 = 1)    	///
			(2000/2999 = 2)    	///
			(3000/3999 = 3)    	///
			(4000/4999 = 4)    	///
			(5000/5999 = 5)    	///
			(6000/6999 = 6)    	///
			(7000/7999 = 7)    	///
			(8000/8999 = 8)    	///
			(9000/9999 = 9)
recode sic 	(-3 -2 -1 = .) 		///
			(0/9 = 0)  			///
			(10/14 = 1)  		///
			(15/39 = 2)  		///
			(40/41 = 3)  		///
			(42/49 = 4)  		///
			(50/54 = 5)  		///
			(55/59 = 6)   		///
			(60/64 = 7)  		///
			(65/69 = 8)   		///
			(70/71 = 9)			///
			(72/74 = 10)		///
			(75/79 = 11)		///
			(80/84 = 12)	   	///
			(85/89 = 13)		///
			(90 = 14)			///
			(91/92 = 15)	   	///
			(95 = 16)			///
			(96/100 = 17)

** perm_1 could still have self-employed (3)!!!! check!!!
** perm_2 could still have unemployed (3)!!!! check!!!

save wave18, replace

//---------------------------------------------------------------------------//
//---------------------------------- 2003 -----------------------------------//
//---------------------------------------------------------------------------//

use persnr hhnr tp9509 tp9510 tp6302 tp6301 tpmonin tptagin tp6602 tp13 ///
tp13602 tp87 tp8801 tp8802 tp50 tp6501 tp74 tp7002 using $dir/tp, clear

rename tp9509 bonus
rename tp9510 bonam
rename tp6302 jbbgy
rename tp6301 jbbgm
rename tpmonin doim
rename tptagin doid
rename tp6602 self_employed
rename tp13 unemployed
rename tp13602 yob
rename tp87 jbbgly
rename tp8801 jbbgly_2
rename tp8802 jbbgly_3
rename tp50 jobchange_within
rename tp6501 perm_1
rename tp74 rules_ot
rename tp7002 hours_flex

generate wave=19
generate wavey=2003

save wave19_junk_1, replace

use hhnr nuts103 using $dir/thgen, clear
sort hhnr, stable
quietly by hhnr: gen dup=cond(_N==1,0,_n)
drop if dup>1
drop dup

rename nuts103 region

merge 1:m  hhnr using wave19_junk_1
keep if _merge==3
drop _merge
save wave19_junk_2, replace

use persnr e1110103 d11102ll d1110903 e1110303 using $dir/tpequiv, clear

rename e1110103 hrs_annual
rename d11102ll sex
rename d1110903 yeq
rename e1110303 perm_2

merge 1:1 persnr using wave19_junk_2
keep if _merge==3
drop _merge
save wave19_junk_3, replace

use persnr nation03 tfamstd oeffd03 labgro03 ttatzeit tvebzeit lfs03 is8803 ///
nace03 tpsbil expft03 exppt03 terwzeit tpbbil01 tpbbil02 tpbbil03 ///
using $dir/tpgen, clear

rename nation03 eu
rename tfamstd married
rename oeffd03 public_sector
rename labgro03 ly
rename ttatzeit hrs_week
rename tvebzeit hrs_agreed
rename lfs03 job_stat
rename is8803 soc
rename nace03 sic
rename tpsbil degree
rename expft03 exp_ft
rename exppt03 exp_pt
rename terwzeit tenure
rename tpbbil01 vocational
rename tpbbil02 further
rename tpbbil03 no_voc

merge 1:1 persnr using wave19_junk_3
keep if _merge==3
drop _merge

recode bonus bonam jbbgy jbbgm doim doid yob perm_1 rules_ot hours_flex ///
region hrs_annual yeq perm_2 ly hrs_week hrs_agreed degree exp_ft exp_pt ///
tenure further (-3 -2 -1 = .)
recode self_employed vocational no_voc (-3 -2 -1 = .) (1/6 = 1)
recode unemployed jbbgly public_sector sex (-3 -2 -1 = .) (1 = 1) (2 = 0)
recode jbbgly_* (-3 -2 -1 =.) (1/12 = 1)
recode jobchange_within (-3 -2 -1 = .) (1/4 = 0) (5 6 = 1)
recode eu		(-3 -2 -1 = .) ///
				(1 4 5 6 10 11 12 13 14 15 16 17 18 19 28 41 =0) ///
				(2 3 20/27 29/40 40/1000 = 1)
recode married (-3 -2 -1 = .) (1 2 6 = 1) (3 4 5 = 0)
recode job_stat (-3 -2 -1 = .) (1/10 = 0) (11 12 = 1)
recode soc 	(-3 -2 -1 = .)    	///
			(0/999 = 0)    		///
			(1000/1999 = 1)    	///
			(2000/2999 = 2)    	///
			(3000/3999 = 3)    	///
			(4000/4999 = 4)    	///
			(5000/5999 = 5)    	///
			(6000/6999 = 6)    	///
			(7000/7999 = 7)    	///
			(8000/8999 = 8)    	///
			(9000/9999 = 9)
recode sic 	(-3 -2 -1 = .) 		///
			(0/9 = 0)  			///
			(10/14 = 1)  		///
			(15/39 = 2)  		///
			(40/41 = 3)  		///
			(42/49 = 4)  		///
			(50/54 = 5)  		///
			(55/59 = 6)   		///
			(60/64 = 7)  		///
			(65/69 = 8)   		///
			(70/71 = 9)			///
			(72/74 = 10)		///
			(75/79 = 11)		///
			(80/84 = 12)	   	///
			(85/89 = 13)		///
			(90 = 14)			///
			(91/92 = 15)	   	///
			(95 = 16)			///
			(96/100 = 17)

** perm_1 could still have self-employed (3)!!!! check!!!
** perm_2 could still have unemployed (3)!!!! check!!!

save wave19, replace

//---------------------------------------------------------------------------//
//---------------------------------- 2004 -----------------------------------//
//---------------------------------------------------------------------------//

use persnr hhnr up8009 up8010 up3402 up3401 upmonin uptagin up3702 up05 ///
up13902 up72 up7301 up7302 up21 up3601 up57 up4902 using $dir/up, clear

rename up8009 bonus
rename up8010 bonam
rename up3402 jbbgy
rename up3401 jbbgm
rename upmonin doim
rename uptagin doid
rename up3702 self_employed
rename up05 unemployed
rename up13902 yob
rename up72 jbbgly
rename up7301 jbbgly_2
rename up7302 jbbgly_3
rename up21 jobchange_within
rename up3601 perm_1
rename up57 rules_ot
rename up4902 hours_flex

generate wave=20
generate wavey=2004

save wave20_junk_1, replace

use hhnr nuts104 using $dir/uhgen, clear
sort hhnr, stable
quietly by hhnr: gen dup=cond(_N==1,0,_n)
drop if dup>1
drop dup

rename nuts104 region

merge 1:m  hhnr using wave20_junk_1
keep if _merge==3
drop _merge
save wave20_junk_2, replace

use persnr e1110104 d11102ll d1110904 e1110304 using $dir/upequiv, clear

rename e1110104 hrs_annual
rename d11102ll sex
rename d1110904 yeq
rename e1110304 perm_2

merge 1:1 persnr using wave20_junk_2
keep if _merge==3
drop _merge
save wave20_junk_3, replace

use persnr nation04 ufamstd oeffd04 labgro04 utatzeit uvebzeit lfs04 is8804 ///
nace04 upsbil expft04 exppt04 uerwzeit upbbil01 upbbil02 upbbil03 ///
using $dir/upgen, clear

rename nation04 eu
rename ufamstd married
rename oeffd04 public_sector
rename labgro04 ly
rename utatzeit hrs_week
rename uvebzeit hrs_agreed
rename lfs04 job_stat
rename is8804 soc
rename nace04 sic
rename upsbil degree
rename expft04 exp_ft
rename exppt04 exp_pt
rename uerwzeit tenure
rename upbbil01 vocational
rename upbbil02 further
rename upbbil03 no_voc

merge 1:1 persnr using wave20_junk_3
keep if _merge==3
drop _merge

recode bonus bonam jbbgy jbbgm doim doid yob perm_1 rules_ot hours_flex ///
region hrs_annual yeq perm_2 ly hrs_week hrs_agreed degree exp_ft exp_pt ///
tenure further (-3 -2 -1 = .)
recode self_employed vocational no_voc (-3 -2 -1 = .) (1/6 = 1)
recode unemployed jbbgly public_sector sex (-3 -2 -1 = .) (1 = 1) (2 = 0)
recode jbbgly_* (-3 -2 -1 =.) (1/12 = 1)
recode jobchange_within (-3 -2 -1 = .) (1/4 = 0) (5 6 = 1)
recode eu		(-3 -2 -1 = .) ///
				(1 4 5 6 10 11 12 13 14 15 16 17 18 19 28 41 =0) ///
				(2 3 20/27 29/40 40/1000 = 1)
recode married (-3 -2 -1 = .) (1 2 6 = 1) (3 4 5 = 0)
recode job_stat (-3 -2 -1 = .) (1/10 = 0) (11 12 = 1)
recode soc 	(-3 -2 -1 = .)    	///
			(0/999 = 0)    		///
			(1000/1999 = 1)    	///
			(2000/2999 = 2)    	///
			(3000/3999 = 3)    	///
			(4000/4999 = 4)    	///
			(5000/5999 = 5)    	///
			(6000/6999 = 6)    	///
			(7000/7999 = 7)    	///
			(8000/8999 = 8)    	///
			(9000/9999 = 9)
recode sic 	(-3 -2 -1 = .) 		///
			(0/9 = 0)  			///
			(10/14 = 1)  		///
			(15/39 = 2)  		///
			(40/41 = 3)  		///
			(42/49 = 4)  		///
			(50/54 = 5)  		///
			(55/59 = 6)   		///
			(60/64 = 7)  		///
			(65/69 = 8)   		///
			(70/71 = 9)			///
			(72/74 = 10)		///
			(75/79 = 11)		///
			(80/84 = 12)	   	///
			(85/89 = 13)		///
			(90 = 14)			///
			(91/92 = 15)	   	///
			(95 = 16)			///
			(96/100 = 17)

** perm_1 could still have self-employed (3)!!!! check!!!
** perm_2 could still have unemployed (3)!!!! check!!!

save wave20, replace

//---------------------------------------------------------------------------//
//---------------------------------- 2005 -----------------------------------//
//---------------------------------------------------------------------------//
use persnr hhnr vp10109 vp10110 vp3902 vp3901 vpmonin vptagin vp4302 vp07 ///
vp14702 vp93 vp9401 vp9402 vp2601 vp41 vp69 vp6102 using $dir/vp, clear

rename vp10109 bonus
rename vp10110 bonam
rename vp3902 jbbgy
rename vp3901 jbbgm
rename vpmonin doim
rename vptagin doid
rename vp4302 self_employed
rename vp07 unemployed
rename vp14702 yob
rename vp93 jbbgly
rename vp9401 jbbgly_2
rename vp9402 jbbgly_3
rename vp2601 jobchange_within
rename vp41 perm_1
rename vp69 rules_ot
rename vp6102 hours_flex

generate wave=21
generate wavey=2005

save wave21_junk_1, replace

use hhnr nuts105 using $dir/vhgen, clear
sort hhnr, stable
quietly by hhnr: gen dup=cond(_N==1,0,_n)
drop if dup>1
drop dup

rename nuts105 region

merge 1:m  hhnr using wave21_junk_1
keep if _merge==3
drop _merge
save wave21_junk_2, replace

use persnr e1110105 d11102ll d1110905 e1110305 using $dir/vpequiv, clear

rename e1110105 hrs_annual
rename d11102ll sex
rename d1110905 yeq
rename e1110305 perm_2

merge 1:1 persnr using wave21_junk_2
keep if _merge==3
drop _merge
save wave21_junk_3, replace

use persnr nation05 vfamstd oeffd05 labgro05 vtatzeit vvebzeit lfs05 is8805 ///
nace05 vpsbil expft05 exppt05 verwzeit vpbbil01 vpbbil02 vpbbil03 ///
using $dir/vpgen, clear

rename nation05 eu
rename vfamstd married
rename oeffd05 public_sector
rename labgro05 ly
rename vtatzeit hrs_week
rename vvebzeit hrs_agreed
rename lfs05 job_stat
rename is8805 soc
rename nace05 sic
rename vpsbil degree
rename expft05 exp_ft
rename exppt05 exp_pt
rename verwzeit tenure
rename vpbbil01 vocational
rename vpbbil02 further
rename vpbbil03 no_voc

merge 1:1 persnr using wave21_junk_3
keep if _merge==3
drop _merge

recode bonus bonam jbbgy jbbgm doim doid yob perm_1 rules_ot hours_flex ///
region hrs_annual yeq perm_2 ly hrs_week hrs_agreed degree exp_ft exp_pt ///
tenure further (-3 -2 -1 = .)
recode self_employed vocational no_voc (-3 -2 -1 = .) (1/6 = 1)
recode unemployed jbbgly public_sector sex (-3 -2 -1 = .) (1 = 1) (2 = 0)
recode jbbgly_* (-3 -2 -1 =.) (1/12 = 1)
recode jobchange_within (-3 -2 -1 = .) (1/4 = 0) (5 6 = 1)
recode eu		(-3 -2 -1 = .) ///
				(1 4 5 6 10 11 12 13 14 15 16 17 18 19 28 41 =0) ///
				(2 3 20/27 29/40 40/1000 = 1)
recode married (-3 -2 -1 = .) (1 2 6 = 1) (3 4 5 = 0)
recode job_stat (-3 -2 -1 = .) (1/10 = 0) (11 12 = 1)
recode soc 	(-3 -2 -1 = .)    	///
			(0/999 = 0)    		///
			(1000/1999 = 1)    	///
			(2000/2999 = 2)    	///
			(3000/3999 = 3)    	///
			(4000/4999 = 4)    	///
			(5000/5999 = 5)    	///
			(6000/6999 = 6)    	///
			(7000/7999 = 7)    	///
			(8000/8999 = 8)    	///
			(9000/9999 = 9)
recode sic 	(-3 -2 -1 = .) 		///
			(0/9 = 0)  			///
			(10/14 = 1)  		///
			(15/39 = 2)  		///
			(40/41 = 3)  		///
			(42/49 = 4)  		///
			(50/54 = 5)  		///
			(55/59 = 6)   		///
			(60/64 = 7)  		///
			(65/69 = 8)   		///
			(70/71 = 9)			///
			(72/74 = 10)		///
			(75/79 = 11)		///
			(80/84 = 12)	   	///
			(85/89 = 13)		///
			(90 = 14)			///
			(91/92 = 15)	   	///
			(95 = 16)			///
			(96/100 = 17)

** perm_1 could still have self-employed (3)!!!! check!!!
** perm_2 could still have unemployed (3)!!!! check!!!

save wave21, replace

//---------------------------------------------------------------------------//
//---------------------------------- 2006 -----------------------------------//
//---------------------------------------------------------------------------//

use persnr hhnr wp7809 wp7810 wp3202 wp3201 wpmonin wptagin wp3602 wp04 ///
wp12402 wp81 wp8201 wp8202 wp1901 wp34 wp57 wp5002 using $dir/wp, clear

rename wp7809 bonus
rename wp7810 bonam
rename wp3202 jbbgy
rename wp3201 jbbgm
rename wpmonin doim
rename wptagin doid
rename wp3602 self_employed
rename wp04 unemployed
rename wp12402 yob
rename wp81 jbbgly
rename wp8201 jbbgly_2
rename wp8202 jbbgly_3
rename wp1901 jobchange_within
rename wp34 perm_1
rename wp57 rules_ot
rename wp5002 hours_flex

generate wave=22
generate wavey=2006

save wave22_junk_1, replace

use hhnr nuts106 using $dir/whgen, clear
sort hhnr, stable
quietly by hhnr: gen dup=cond(_N==1,0,_n)
drop if dup>1
drop dup

rename nuts106 region

merge 1:m  hhnr using wave22_junk_1
keep if _merge==3
drop _merge
save wave22_junk_2, replace

use persnr e1110106 d11102ll d1110906 e1110306 using $dir/wpequiv, clear

rename e1110106 hrs_annual
rename d11102ll sex
rename d1110906 yeq
rename e1110306 perm_2

merge 1:1 persnr using wave22_junk_2
keep if _merge==3
drop _merge
save wave22_junk_3, replace

use persnr nation06 wfamstd oeffd06 labgro06 wtatzeit wvebzeit lfs06 is8806 ///
nace06 wpsbil expft06 exppt06 werwzeit wpbbil01 wpbbil02 wpbbil03 ///
using $dir/wpgen, clear

rename nation06 eu
rename wfamstd married
rename oeffd06 public_sector
rename labgro06 ly
rename wtatzeit hrs_week
rename wvebzeit hrs_agreed
rename lfs06 job_stat
rename is8806 soc
rename nace06 sic
rename wpsbil degree
rename expft06 exp_ft
rename exppt06 exp_pt
rename werwzeit tenure
rename wpbbil01 vocational
rename wpbbil02 further
rename wpbbil03 no_voc

merge 1:1 persnr using wave22_junk_3
keep if _merge==3
drop _merge

recode bonus bonam jbbgy jbbgm doim doid yob perm_1 rules_ot hours_flex ///
region hrs_annual yeq perm_2 ly hrs_week hrs_agreed degree exp_ft exp_pt ///
tenure further (-3 -2 -1 = .)
recode self_employed vocational no_voc (-3 -2 -1 = .) (1/6 = 1)
recode unemployed jbbgly public_sector sex (-3 -2 -1 = .) (1 = 1) (2 = 0)
recode jbbgly_* (-3 -2 -1 =.) (1/12 = 1)
recode jobchange_within (-3 -2 -1 = .) (1/4 = 0) (5 6 = 1)
recode eu		(-3 -2 -1 = .) ///
				(1 4 5 6 10 11 12 13 14 15 16 17 18 19 28 41 =0) ///
				(2 3 20/27 29/40 40/1000 = 1)
recode married (-3 -2 -1 = .) (1 2 6 = 1) (3 4 5 = 0)
recode job_stat (-3 -2 -1 = .) (1/10 = 0) (11 12 = 1)
recode soc 	(-3 -2 -1 = .)    	///
			(0/999 = 0)    		///
			(1000/1999 = 1)    	///
			(2000/2999 = 2)    	///
			(3000/3999 = 3)    	///
			(4000/4999 = 4)    	///
			(5000/5999 = 5)    	///
			(6000/6999 = 6)    	///
			(7000/7999 = 7)    	///
			(8000/8999 = 8)    	///
			(9000/9999 = 9)
recode sic 	(-3 -2 -1 = .) 		///
			(0/9 = 0)  			///
			(10/14 = 1)  		///
			(15/39 = 2)  		///
			(40/41 = 3)  		///
			(42/49 = 4)  		///
			(50/54 = 5)  		///
			(55/59 = 6)   		///
			(60/64 = 7)  		///
			(65/69 = 8)   		///
			(70/71 = 9)			///
			(72/74 = 10)		///
			(75/79 = 11)		///
			(80/84 = 12)	   	///
			(85/89 = 13)		///
			(90 = 14)			///
			(91/92 = 15)	   	///
			(95 = 16)			///
			(96/100 = 17)

** perm_1 could still have self-employed (3)!!!! check!!!
** perm_2 could still have unemployed (3)!!!! check!!!

save wave22, replace

//---------------------------------------------------------------------------//
//---------------------------------- 2007 -----------------------------------//
//---------------------------------------------------------------------------//

use persnr hhnr xp9509 xp9510 xp4302 xp4301 xpmonin xptagin xp4702 xp10 ///
xp13102 xp87 xp8801 xp8802 xp3001 xp45 xp71 xp6302 using $dir/xp, clear

rename xp9509 bonus
rename xp9510 bonam
rename xp4302 jbbgy
rename xp4301 jbbgm
rename xpmonin doim
rename xptagin doid
rename xp4702 self_employed
rename xp10 unemployed
rename xp13102 yob
rename xp87 jbbgly
rename xp8801 jbbgly_2
rename xp8802 jbbgly_3
rename xp3001 jobchange_within
rename xp45 perm_1
rename xp71 rules_ot
rename xp6302 hours_flex

generate wave=23
generate wavey=2007

save wave23_junk_1, replace

use hhnr nuts107 using $dir/xhgen, clear
sort hhnr, stable
quietly by hhnr: gen dup=cond(_N==1,0,_n)
drop if dup>1
drop dup

rename nuts107 region

merge 1:m  hhnr using wave23_junk_1
keep if _merge==3
drop _merge
save wave23_junk_2, replace

use persnr e1110107 d11102ll d1110907 e1110307 using $dir/xpequiv, clear

rename e1110107 hrs_annual
rename d11102ll sex
rename d1110907 yeq
rename e1110307 perm_2

merge 1:1 persnr using wave23_junk_2
keep if _merge==3
drop _merge
save wave23_junk_3, replace

use persnr nation07 xfamstd oeffd07 labgro07 xtatzeit xvebzeit lfs07 is8807 ///
nace07 xpsbil expft07 exppt07 xerwzeit xpbbil01 xpbbil02 xpbbil03 ///
using $dir/xpgen, clear

rename nation07 eu
rename xfamstd married
rename oeffd07 public_sector
rename labgro07 ly
rename xtatzeit hrs_week
rename xvebzeit hrs_agreed
rename lfs07 job_stat
rename is8807 soc
rename nace07 sic
rename xpsbil degree
rename expft07 exp_ft
rename exppt07 exp_pt
rename xerwzeit tenure
rename xpbbil01 vocational
rename xpbbil02 further
rename xpbbil03 no_voc

merge 1:1 persnr using wave23_junk_3
keep if _merge==3
drop _merge

recode bonus bonam jbbgy jbbgm doim doid yob perm_1 rules_ot hours_flex ///
region hrs_annual yeq perm_2 ly hrs_week hrs_agreed degree exp_ft exp_pt ///
tenure further (-3 -2 -1 = .)
recode self_employed vocational no_voc (-3 -2 -1 = .) (1/6 = 1)
recode unemployed jbbgly public_sector sex (-3 -2 -1 = .) (1 = 1) (2 = 0)
recode jbbgly_* (-3 -2 -1 =.) (1/12 = 1)
recode jobchange_within (-3 -2 -1 = .) (1/4 = 0) (5 6 = 1)
recode eu		(-3 -2 -1 = .) ///
				(1 4 5 6 10 11 12 13 14 15 16 17 18 19 28 41 =0) ///
				(2 3 20/27 29/40 40/1000 = 1)
recode married (-3 -2 -1 = .) (1 2 6 = 1) (3 4 5 = 0)
recode job_stat (-3 -2 -1 = .) (1/10 = 0) (11 12 = 1)
recode soc 	(-3 -2 -1 = .)    	///
			(0/999 = 0)    		///
			(1000/1999 = 1)    	///
			(2000/2999 = 2)    	///
			(3000/3999 = 3)    	///
			(4000/4999 = 4)    	///
			(5000/5999 = 5)    	///
			(6000/6999 = 6)    	///
			(7000/7999 = 7)    	///
			(8000/8999 = 8)    	///
			(9000/9999 = 9)
recode sic 	(-3 -2 -1 = .) 		///
			(0/9 = 0)  			///
			(10/14 = 1)  		///
			(15/39 = 2)  		///
			(40/41 = 3)  		///
			(42/49 = 4)  		///
			(50/54 = 5)  		///
			(55/59 = 6)   		///
			(60/64 = 7)  		///
			(65/69 = 8)   		///
			(70/71 = 9)			///
			(72/74 = 10)		///
			(75/79 = 11)		///
			(80/84 = 12)	   	///
			(85/89 = 13)		///
			(90 = 14)			///
			(91/92 = 15)	   	///
			(95 = 16)			///
			(96/100 = 17)

** perm_1 could still have self-employed (3)!!!! check!!!
** perm_2 could still have unemployed (3)!!!! check!!!

save wave23, replace

//---------------------------------------------------------------------------//
//---------------------------------- 2008 -----------------------------------//
//---------------------------------------------------------------------------//

use persnr hhnr yp9609 yp9610 yp4202 yp4201 ypmonin yptagin yp4602 yp15 ///
yp14802 yp88 yp8901 yp8902 yp3101 yp44 yp66 yp5902 using $dir/yp, clear

rename yp9609 bonus
rename yp9610 bonam
rename yp4202 jbbgy
rename yp4201 jbbgm
rename ypmonin doim
rename yptagin doid
rename yp4602 self_employed
rename yp15 unemployed
rename yp14802 yob
rename yp88 jbbgly
rename yp8901 jbbgly_2
rename yp8902 jbbgly_3
rename yp3101 jobchange_within
rename yp44 perm_1
rename yp66 rules_ot
rename yp5902 hours_flex

generate wave=24
generate wavey=2008

save wave24_junk_1, replace

use hhnr nuts108 using $dir/yhgen, clear
sort hhnr, stable
quietly by hhnr: gen dup=cond(_N==1,0,_n)
drop if dup>1
drop dup

rename nuts108 region

merge 1:m  hhnr using wave24_junk_1
keep if _merge==3
drop _merge
save wave24_junk_2, replace

use persnr e1110108 d11102ll d1110908 e1110308 using $dir/ypequiv, clear

rename e1110108 hrs_annual
rename d11102ll sex
rename d1110908 yeq
rename e1110308 perm_2

merge 1:1 persnr using wave24_junk_2
keep if _merge==3
drop _merge
save wave24_junk_3, replace

use persnr nation08 yfamstd oeffd08 labgro08 ytatzeit yvebzeit lfs08 is8808 ///
nace08 ypsbil expft08 exppt08 yerwzeit ypbbil01 ypbbil02 ypbbil03 ///
using $dir/ypgen, clear

rename nation08 eu
rename yfamstd married
rename oeffd08 public_sector
rename labgro08 ly
rename ytatzeit hrs_week
rename yvebzeit hrs_agreed
rename lfs08 job_stat
rename is8808 soc
rename nace08 sic
rename ypsbil degree
rename expft08 exp_ft
rename exppt08 exp_pt
rename yerwzeit tenure
rename ypbbil01 vocational
rename ypbbil02 further
rename ypbbil03 no_voc

merge 1:1 persnr using wave24_junk_3
keep if _merge==3
drop _merge

recode bonus bonam jbbgy jbbgm doim doid yob perm_1 rules_ot hours_flex ///
region hrs_annual yeq perm_2 ly hrs_week hrs_agreed degree exp_ft exp_pt ///
tenure further (-3 -2 -1 = .)
recode self_employed vocational no_voc (-3 -2 -1 = .) (1/6 = 1)
recode unemployed jbbgly public_sector sex (-3 -2 -1 = .) (1 = 1) (2 = 0)
recode jbbgly_* (-3 -2 -1 =.) (1/12 = 1)
recode jobchange_within (-3 -2 -1 = .) (1/4 = 0) (5 6 = 1)
recode eu		(-3 -2 -1 = .) ///
				(1 4 5 6 10 11 12 13 14 15 16 17 18 19 28 41 =0) ///
				(2 3 20/27 29/40 40/1000 = 1)
recode married (-3 -2 -1 = .) (1 2 6 = 1) (3 4 5 = 0)
recode job_stat (-3 -2 -1 = .) (1/10 = 0) (11 12 = 1)
recode soc 	(-3 -2 -1 = .)    	///
			(0/999 = 0)    		///
			(1000/1999 = 1)    	///
			(2000/2999 = 2)    	///
			(3000/3999 = 3)    	///
			(4000/4999 = 4)    	///
			(5000/5999 = 5)    	///
			(6000/6999 = 6)    	///
			(7000/7999 = 7)    	///
			(8000/8999 = 8)    	///
			(9000/9999 = 9)
recode sic 	(-3 -2 -1 = .) 		///
			(0/9 = 0)  			///
			(10/14 = 1)  		///
			(15/39 = 2)  		///
			(40/41 = 3)  		///
			(42/49 = 4)  		///
			(50/54 = 5)  		///
			(55/59 = 6)   		///
			(60/64 = 7)  		///
			(65/69 = 8)   		///
			(70/71 = 9)			///
			(72/74 = 10)		///
			(75/79 = 11)		///
			(80/84 = 12)	   	///
			(85/89 = 13)		///
			(90 = 14)			///
			(91/92 = 15)	   	///
			(95 = 16)			///
			(96/100 = 17)

save wave24, replace

//---------------------------------------------------------------------------//
//---------------------------------- 2009 -----------------------------------//
//---------------------------------------------------------------------------//

use persnr hhnr zp9209 zp9210 zp3802 zp3801 zpmonin zptagin zp4202 zp06 ///
zp12902 zp84 zp8501 zp8502 zp2401 zp40 zp70 zp6102 using $dir/zp, clear

rename zp9209 bonus
rename zp9210 bonam
rename zp3802 jbbgy
rename zp3801 jbbgm
rename zpmonin doim
rename zptagin doid
rename zp4202 self_employed
rename zp06 unemployed
rename zp12902 yob
rename zp84 jbbgly
rename zp8501 jbbgly_2
rename zp8502 jbbgly_3
rename zp2401 jobchange_within
rename zp40 perm_1
rename zp70 rules_ot
rename zp6102 hours_flex

generate wave=25
generate wavey=2009

save wave25_junk_1, replace

use hhnr nuts109 using $dir/zhgen, clear
sort hhnr, stable
quietly by hhnr: gen dup=cond(_N==1,0,_n)
drop if dup>1
drop dup

rename nuts109 region

merge 1:m  hhnr using wave25_junk_1
keep if _merge==3
drop _merge
save wave25_junk_2, replace

use persnr e1110109 d11102ll d1110909 e1110309 using $dir/zpequiv, clear

rename e1110109 hrs_annual
rename d11102ll sex
rename d1110909 yeq
rename e1110309 perm_2

merge 1:1 persnr using wave25_junk_2
keep if _merge==3
drop _merge
save wave25_junk_3, replace

use persnr nation09 zfamstd oeffd09 labgro09 ztatzeit zvebzeit lfs09 is8809 ///
nace09 zpsbil expft09 exppt09 zerwzeit zpbbil01 zpbbil02 zpbbil03 ///
using $dir/zpgen, clear

rename nation09 eu
rename zfamstd married
rename oeffd09 public_sector
rename labgro09 ly
rename ztatzeit hrs_week
rename zvebzeit hrs_agreed
rename lfs09 job_stat
rename is8809 soc
rename nace09 sic
rename zpsbil degree
rename expft09 exp_ft
rename exppt09 exp_pt
rename zerwzeit tenure
rename zpbbil01 vocational
rename zpbbil02 further
rename zpbbil03 no_voc

merge 1:1 persnr using wave25_junk_3
keep if _merge==3
drop _merge

recode bonus bonam jbbgy jbbgm doim doid yob perm_1 rules_ot hours_flex ///
region hrs_annual yeq perm_2 ly hrs_week hrs_agreed degree exp_ft exp_pt ///
tenure further (-3 -2 -1 = .)
recode self_employed vocational no_voc (-3 -2 -1 = .) (1/6 = 1)
recode unemployed jbbgly public_sector sex (-3 -2 -1 = .) (1 = 1) (2 = 0)
recode jbbgly_* (-3 -2 -1 =.) (1/12 = 1)
recode jobchange_within (-3 -2 -1 = .) (1/4 = 0) (5 6 = 1)
recode eu		(-3 -2 -1 = .) ///
				(1 4 5 6 10 11 12 13 14 15 16 17 18 19 28 41 =0) ///
				(2 3 20/27 29/40 40/1000 = 1)
recode married (-3 -2 -1 = .) (1 2 6 = 1) (3 4 5 = 0)
recode job_stat (-3 -2 -1 = .) (1/10 = 0) (11 12 = 1)
recode soc 	(-3 -2 -1 = .)    	///
			(0/999 = 0)    		///
			(1000/1999 = 1)    	///
			(2000/2999 = 2)    	///
			(3000/3999 = 3)    	///
			(4000/4999 = 4)    	///
			(5000/5999 = 5)    	///
			(6000/6999 = 6)    	///
			(7000/7999 = 7)    	///
			(8000/8999 = 8)    	///
			(9000/9999 = 9)
recode sic 	(-3 -2 -1 = .) 		///
			(0/9 = 0)  			///
			(10/14 = 1)  		///
			(15/39 = 2)  		///
			(40/41 = 3)  		///
			(42/49 = 4)  		///
			(50/54 = 5)  		///
			(55/59 = 6)   		///
			(60/64 = 7)  		///
			(65/69 = 8)   		///
			(70/71 = 9)			///
			(72/74 = 10)		///
			(75/79 = 11)		///
			(80/84 = 12)	   	///
			(85/89 = 13)		///
			(90 = 14)			///
			(91/92 = 15)	   	///
			(95 = 16)			///
			(96/100 = 17)


save wave25, replace

//---------------------------------------------------------------------------//
//---------------------------------- 2010 -----------------------------------//
//---------------------------------------------------------------------------//

use persnr hhnr bap8309 bap8310 bap3402 bap3401 bapmonin baptagin bap3802 ///
bap06 bap15002 bap75 bap7601 bap7602 bap21 bap36 bap59 bap5002 ///
using $dir/bap, clear

rename bap8309 bonus
rename bap8310 bonam
rename bap3402 jbbgy
rename bap3401 jbbgm
rename bapmonin doim
rename baptagin doid
rename bap3802 self_employed
rename bap06 unemployed
rename bap15002 yob
rename bap75 jbbgly
rename bap7601 jbbgly_2
rename bap7602 jbbgly_3
rename bap21 jobchange_within
rename bap36 perm_1
rename bap59 rules_ot
rename bap5002 hours_flex

generate wave=26
generate wavey=2010

save wave26_junk_1, replace

use hhnr nuts110 using $dir/bahgen, clear
sort hhnr, stable
quietly by hhnr: gen dup=cond(_N==1,0,_n)
drop if dup>1
drop dup

rename nuts110 region

merge 1:m  hhnr using wave26_junk_1
keep if _merge==3
drop _merge
save wave26_junk_2, replace

use persnr e1110110 d11102ll d1110910 e1110310 using $dir/bapequiv, clear

rename e1110110 hrs_annual
rename d11102ll sex
rename d1110910 yeq
rename e1110310 perm_2

merge 1:1 persnr using wave26_junk_2
keep if _merge==3
drop _merge
save wave26_junk_3, replace

use persnr nation10 bafamstd oeffd10 labgro10 batatzeit bavebzeit lfs10 ///
is8810 nace10 bapsbil expft10 exppt10 baerwzeit bapbbil01 bapbbil02 ///
bapbbil03 using $dir/bapgen, clear

rename nation10 eu
rename bafamstd married
rename oeffd10 public_sector
rename labgro10 ly
rename batatzeit hrs_week
rename bavebzeit hrs_agreed
rename lfs10 job_stat
rename is8810 soc
rename nace10 sic
rename bapsbil degree
rename expft10 exp_ft
rename exppt10 exp_pt
rename baerwzeit tenure
rename bapbbil01 vocational
rename bapbbil02 further
rename bapbbil03 no_voc

merge 1:1 persnr using wave26_junk_3
keep if _merge==3
drop _merge

recode bonus bonam jbbgy jbbgm doim doid yob perm_1 rules_ot hours_flex ///
region hrs_annual yeq perm_2 ly hrs_week hrs_agreed degree exp_ft exp_pt ///
tenure further (-3 -2 -1 = .)
recode self_employed vocational no_voc (-3 -2 -1 = .) (1/6 = 1)
recode unemployed jbbgly public_sector sex (-3 -2 -1 = .) (1 = 1) (2 = 0)
recode jbbgly_* (-3 -2 -1 =.) (1/12 = 1)
recode jobchange_within (-3 -2 -1 = .) (1/4 = 0) (5 6 = 1)
recode eu		(-3 -2 -1 = .) ///
				(1 4 5 6 10 11 12 13 14 15 16 17 18 19 28 41 =0) ///
				(2 3 20/27 29/40 40/1000 = 1)
recode married (-3 -2 -1 = .) (1 2 6 = 1) (3 4 5 = 0)
recode job_stat (-3 -2 -1 = .) (1/10 = 0) (11 12 = 1)
recode soc 	(-3 -2 -1 = .)    	///
			(0/999 = 0)    		///
			(1000/1999 = 1)    	///
			(2000/2999 = 2)    	///
			(3000/3999 = 3)    	///
			(4000/4999 = 4)    	///
			(5000/5999 = 5)    	///
			(6000/6999 = 6)    	///
			(7000/7999 = 7)    	///
			(8000/8999 = 8)    	///
			(9000/9999 = 9)
recode sic 	(-3 -2 -1 = .) 		///
			(0/9 = 0)  			///
			(10/14 = 1)  		///
			(15/39 = 2)  		///
			(40/41 = 3)  		///
			(42/49 = 4)  		///
			(50/54 = 5)  		///
			(55/59 = 6)   		///
			(60/64 = 7)  		///
			(65/69 = 8)   		///
			(70/71 = 9)			///
			(72/74 = 10)		///
			(75/79 = 11)		///
			(80/84 = 12)	   	///
			(85/89 = 13)		///
			(90 = 14)			///
			(91/92 = 15)	   	///
			(95 = 16)			///
			(96/100 = 17)


save wave26, replace

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

foreach x in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 {
	append using wave`x'
}

replace jbbgy = jbbgy+1900 if jbbgy<100
replace yob = yob + 1000 if wave<15
generate age = wavey-yob

foreach x in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 {
	capture erase wave`x'_junk_1.dta
	capture erase wave`x'_junk_2.dta
	capture erase wave`x'_junk_3.dta
	capture erase wave`x'.dta
}

//---------------------------------------------------------------------------//
//-------------------- Codebook for selection variables ---------------------//
//---------------------------------------------------------------------------//

// job_stat: missing values, 0 (not working), 1 (working)
// unemployed: missing values, 0 (not unemployed), 1 (unemployed)
// perm_1: missing values, 1 (temporary), 2 (permanent), 3 (self-employed)
// perm_2: missing values, 1 (full time), 2 (part time), 3 (not working)
// self_employed: missing values, 1 (self-employed)
// sex: missing values, 0 (female), 1 (male)
// public_sector: missing values, 0 (private sector), 1 (public sector)

drop if sex!=1								// drop females
drop if job_stat!=1							// drop non-workers
drop if self_employed==1					// drop self-employed
drop if unemployed!=0						// double check for non-workers
//drop if perm_1==.							// double check for non-workers 
drop if perm_1==3							// double check for self-employed
drop if perm_2==.							// double check for non-workers
drop if perm_2==3							// double check for non-workers
drop if public_sector==1					// drop public sector
drop if public_sector==.					// double check on workers
drop if ly==.								// necessary condition
drop if ly==0								// necessary condition
drop if hrs_week==.							// necessary condition
drop if age<20
drop if age>65

drop public_sector job_stat self_employed unemployed

// perm_1 suffers from many missing values in certain waves and is therefore 
// not used for the subsequent analysis.

compress
sort persnr wave
save SOEP, replace

// What variables do we have left?		
// eu: 17 missing values				// jbbgy: 6403 missing values
// degree: 1269 missing values			// perm_1: 17188 missing values
// married: 65 missing values			// hours_flex: 74799 missing values
// hrs_agreed: 7159 missing values		// rules_ot: 15316 missing values
// soc: 960 missing values				// jbbgly: 22496 missing values
// sic: 2595 missing values				// jbbgly_2: 76217 missing values
// exp_ft: 1169 missing values			// jbbgly_3: 81761 missing values
// exp_pt: 1169 missing values			// bonus: 72417 missing values
// yeq: 1442 missing values				// bonam: 73220 missing values
// hrs_annual: 0 missing values			// yob: 1 missing value
// perm_2: 0 missing values		// jobchange_within1: 82272 missing values
// region: 0 missing values		// jobchange_within2: 82538 missing values
// age: 1 missing value			// jobchange_within: 72679 missing values
// jbbgm: 13730 missing values			// tenure: 104 missing values

*******************************************************************************
*******************************************************************************


*******************************************************************************
*************************** Declaring the variables ***************************
*******************************************************************************

//---------------------------------------------------------------------------//
//-------------------------------- Deflator ---------------------------------//
//---------------------------------------------------------------------------//

generate deflator=0
	label var deflator "deflator"
replace deflator=0.6818685 	if wave==1
replace deflator=0.6809861 	if wave==2	
replace deflator=0.6826879 	if wave==3
replace deflator=0.6913862 	if wave==4
replace deflator=0.7106106 	if wave==5
replace deflator=0.729772 	if wave==6
replace deflator=0.759 		if wave==7
replace deflator=0.798 		if wave==8
replace deflator=0.833 		if wave==9
replace deflator=0.856 		if wave==10
replace deflator=0.871 		if wave==11
replace deflator=0.883 		if wave==12
replace deflator=0.90 		if wave==13
replace deflator=0.909 		if wave==14
replace deflator=0.914 		if wave==15
replace deflator=0.927 		if wave==16
replace deflator=0.945 		if wave==17
replace deflator=0.959 		if wave==18
replace deflator=0.969 		if wave==19
replace deflator=0.985 		if wave==20
replace deflator=1.00 		if wave==21
replace deflator=1.016 		if wave==22
replace deflator=1.039 		if wave==23
replace deflator=1.066 		if wave==24
replace deflator=1.07 		if wave==25
replace deflator=1.082 		if wave==26

//---------------------------------------------------------------------------//
//---------------------------- Bonus information ----------------------------//
//---------------------------------------------------------------------------//

replace bonam = bonam/deflator
replace bonam = 0 if bonam==. 
	label var bonam "bonus amount"
replace bonus = 0 if bonus==.
	label var bonus "Received bonus this year"
generate bonusshare=bonam/ly
	label var bonusshare "bonus as share of gross labour income"

//---------------------------------------------------------------------------//
//-------------------------- (Log) Hourly earnings --------------------------//
//---------------------------------------------------------------------------//

// We have gross monthly income and weeks worked per week (contractual and 
// actual). 1 month has on more or less 4.3452381 weeks.
// (365/12=30.4166666667 => 30.4166666667/7=4.3452381)

generate hly=ly/(hrs_week*4.3452381)
	label var hly "Gross hourly labour earnings"
generate lnly = ln(ly)
	label var lnly "Log gross monthly labour earnings"
generate lnhly = ln(hly)
	label var lnhly "Log gross hourly labour earnings"
drop if lnhly==.

//---------------------------------------------------------------------------//
//-------------------------- Performance pay dummy --------------------------//
//---------------------------------------------------------------------------//

generate jobchange=0
by persnr: replace jobchange=1 if (tenure<tenure[_n-1] & _n!=1)
by persnr: replace jobchange=1 if (tenure<1 & _n!=1)

by persnr: generate jobs=sum(jobchange)
egen jobmatch=group(persnr jobs)
	label var jobchange "Change of jobs"
	label var jobmatch "Jobmatch"
by persnr: generate jobstot=1+jobs[_N] if jobchange[1]==0
by persnr: replace jobstot=jobs[_N] if jobchange[1]==1
	label var jobstot "Total amount of jobs held by this person"

sort jobmatch, stable
by jobmatch: generate duration=_N
by jobmatch: egen bonusjob_junk1=total(bonus)
by jobmatch: generate bonusjob_junk2=bonusjob_junk1/(_N)

by jobmatch: generate bonusjob=1 if bonusjob_junk1!=0
by jobmatch: replace bonusjob=0 if bonusjob_junk1==0
	label var bonusjob "Bonusjob"

by jobmatch: generate bonusjobfifth=1 if bonusjob_junk2>=0.2
by jobmatch: replace bonusjobfifth=0 if bonusjob_junk2<0.2
	label var bonusjobfifth "Bonusjob (using a minimum of 20% bonus payments)"

by jobmatch: generate bonusjobhalf=1 if bonusjob_junk2>=0.5
by jobmatch: replace bonusjobhalf=0 if bonusjob_junk2<0.5
	label var bonusjobhalf "Bonusjob (using a minimum of 250% bonus payments)"

drop bonusjob_junk1 bonusjob_junk2


order persnr wave jobstot jobmatch bonus bonusjob bonusjobfifth bonusjobhalf


sort persnr wave, stable

//---------------------------------------------------------------------------//
//-------------------------------- Education --------------------------------//
//---------------------------------------------------------------------------//

// We have degree, technical, university, no_technical (for dummies) and 
// yeq (only deleting missing values left)

label var yeq "Years of schooling"
generate university=1 if further==2 | further==3 | further==5 | further==6
replace university=0 if further==. | further==1 | further ==4
label var university "University degree"
generate technical=1 if further ==1 | further==4
replace technical=0 if further==. | further==2 | further==3 | further==5 ///
| further==6
label var technical "Technical degree"
replace vocational=1 if vocational==1
replace vocational=0 if vocational==. | vocational==0
label var vocational "Vocational degree"
generate no_degree=1 if university==0 | technical==0 | vocational==0
replace no_degree=0 if no_voc==.
label var no_degree "No degree"

// I decide not to drop values that have none of three. In the end, this only
// affects 431 observations!

//---------------------------------------------------------------------------//
//-------------------------------- Experience -------------------------------//
//---------------------------------------------------------------------------//

// We have full-time and part-time experience. 

label var exp_ft "Full-time experience"
label var exp_pt "Part-time experience"
generate exp=exp_ft+exp_pt
label var exp "experience"

//---------------------------------------------------------------------------//
//-------------------------------- Job tenure -------------------------------//
//---------------------------------------------------------------------------//

// We have tenure.

label var tenure "Tenure"
replace tenure=max(tenure,0)

//---------------------------------------------------------------------------//
//-------------------------------- Ethnicity --------------------------------//
//---------------------------------------------------------------------------//

// We do not have exactly ethnicity, but we do control for more or less EU.

label var eu "More or less the original EU members"

//---------------------------------------------------------------------------//
//------------------------------ Marital status -----------------------------//
//---------------------------------------------------------------------------//

// We have marital status.

label var married "Marital status"

//---------------------------------------------------------------------------//
//------------------------------ Contract type-------------------------------//
//---------------------------------------------------------------------------//

// We have contract type. We do not use perm_1 because of the many missing
// values in certain waves.

generate full_time=perm_2==1
label var full_time "Full-time contract"
generate temp=perm_1==1
label var temp "Temporary contract"

//---------------------------------------------------------------------------//
//------------------------------ Union status -------------------------------//
//---------------------------------------------------------------------------//

// We do not have this. 

//---------------------------------------------------------------------------//
//-------------------- SIC, SOC and calendar year dummies -------------------//
//---------------------------------------------------------------------------//

generate sic0=0
replace sic0=1 if sic==0

generate sic1=0
replace sic1=1 if sic==1

generate sic2=0
replace sic2=1 if sic==2

generate sic3=0
replace sic3=1 if sic==3

generate sic4=0
replace sic4=1 if sic==4

generate sic5=0
replace sic5=1 if sic==5

generate sic6=0
replace sic6=1 if sic==6

generate sic7=0
replace sic7=1 if sic==7

generate sic8=0
replace sic8=1 if sic==8

generate sic9=0
replace sic9=1 if sic==9

generate sic10=0
replace sic10=1 if sic==10

generate sic11=0
replace sic11=1 if sic==11

generate sic12=0
replace sic12=1 if sic==12

generate sic13=0
replace sic13=1 if sic==13

generate sic14=0
replace sic14=1 if sic==14

generate sic15=0
replace sic15=1 if sic==15

generate sic16=0
replace sic16=1 if sic==16

generate sic17=0
replace sic17=1 if sic==17

generate soc0=0
replace soc0=1 if soc==0

generate soc1=0
replace soc1=1 if soc==1

generate soc2=0
replace soc2=1 if soc==2

generate soc3=0
replace soc3=1 if soc==3

generate soc4=0
replace soc4=1 if soc==4

generate soc5=0
replace soc5=1 if soc==5

generate soc6=0
replace soc6=1 if soc==6

generate soc7=0
replace soc7=1 if soc==7

generate soc8=0
replace soc8=1 if soc==8

generate soc9=0
replace soc9=1 if soc==9

//---------------------------------------------------------------------------//
//---------------------------- Other indicators -----------------------------//
//---------------------------------------------------------------------------//

generate flexible=hours_flex==1
generate overtime_notpaid=rules_ot==4

*******************************************************************************
*******************************************************************************

*******************************************************************************
********************************* Cleaning up *********************************
*******************************************************************************

drop if sic==.
drop if soc==.
drop if exp_ft==.
drop if exp_pt==.
drop if tenure==.
drop if eu==.
drop if married==.
drop if full_time!=1

drop if age<20
drop if hly<1
drop if hly>100
*drop if hrs_annual>4000
*drop if hrs_annual<1000
drop if ly<600

foreach x in 1 2 3 4 5 6 7 8 {
	generate ME`x'=0
}

replace ME1=1 if wave==1 | wave==2 | wave==3
replace ME2=1 if wave==4 | wave==5 | wave==6
replace ME3=1 if wave==7 | wave==8 | wave==9
replace ME4=1 if wave==10 | wave==11 | wave==12
replace ME5=1 if wave==13 | wave==14 | wave==15
replace ME6=1 if wave==16 | wave==17 | wave==18
replace ME7=1 if wave==19 | wave==20 | wave==21
replace ME8=1 if wave==22 | wave==23 | wave==24
generate ME = 1*ME1+2*ME2+3*ME3+4*ME4+5*ME5+6*ME6+7*ME7+8*ME8

// setting up the linear probability models

generate exp2=exp*exp
generate exp3=exp*exp*exp
generate exp4=exp*exp*exp*exp
generate exp5=exp*exp*exp*exp*exp
generate tenure2=tenure*tenure
generate tenure3=tenure*tenure*tenure
generate tenure4=tenure*tenure*tenure*tenure
generate tenure5=tenure*tenure*tenure*tenure*tenure

save SOEP, replace

*******************************************************************************
*******************************************************************************

*******************************************************************************
******************************** Summary Stats ********************************
*******************************************************************************

sum hly exp tenure married eu yeq hrs_week temp flexible ///
overtime_notpaid hrs_agreed if bonusjob==1 & wave<25
quietly sum hrs_annual if bonusjob==1
display r(mean)
sum hly exp tenure married eu yeq hrs_week temp flexible ///
overtime_notpaid hrs_agreed if bonusjob==0 & wave<25
quietly sum hrs_annual if bonusjob==0
display r(mean)
sum university technical vocational if bonusjob==1 & wave<25
sum university technical vocational if bonusjob==0 & wave<25

*******************************************************************************
*******************************************************************************

