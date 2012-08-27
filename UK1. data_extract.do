clear all
set more off
cd "/Users/pieterdevlieger/Desktop/plan B - wage inequality/BHPS"
set maxvar 32767
global dir UKDA-5151-stata8/stata8

*******************************************************************************
************************** Setting up the long panel **************************
*******************************************************************************

// Check the logical steps for this procedure in the first loop.

use ahid pid ajbonus ajbbgy4 ajbbgm ajbbgd adoim adoid afiyr afiyrl ajbhrs ///
ajbot anjbwks anjiwks anjuwks ajbrise ahoh amastat ajbsemp atujbpl atuin1 ///
ajbsic ajbsect aqfachi aage ajbsoc ajbstat ajbbgly amrjsic ajbterm axrwght ///
aregion acjsten using $dir/aindresp, clear

gen wave = 1
rename a* *
rename xrwght lrwght
generate doiy4=1991
	
save aindresp_junk, replace
	
use pid race racel scend feend sex using $dir/xwavedat, clear

merge 1:1 pid using aindresp_junk
keep if _merge==3
drop _merge
	
save amerge1_junk, replace

use pid ajhpldf ajhstpy ajhstat using $dir/ajobhist, clear
sort pid, stable

// this is based on workplace (yes/no, not available last 3 waves)
by pid: egen maxc1=max(ajhpldf)
generate jc1=maxc1==2
// replace jc1=. if maxc1<0                           ?What do we do with this?
drop  maxc1 ajhpldf

// this is based on promotion
generate c2=0 if ajhstpy==1
replace c2=1 if ajhstpy>1
replace c2=-1 if ajhstpy<1
by pid: egen maxc2=max(c2)
generate jc2=maxc2==1
replace jc2=. if maxc2<0
drop c2 maxc2 //ajhstpy
rename ajhstpy jhstpy

// this is based on "different job same employer"
generate c3=0 if ajhstat==1
replace c3=1 if ajhstat>1
replace c3=-1 if ajhstat<1
by pid: egen maxc3=max(c3)
generate jc3=maxc3==1
replace jc3=. if maxc3<0
drop c3 maxc3 ajhstat

sort pid, stable
quietly by pid: gen dup=cond(_N==1,0,_n)
drop if dup>1
drop dup

merge 1:1 pid using amerge1_junk

save mwavea, replace

foreach x in b c d e f {

	use `x'hid pid `x'jbonus `x'jbbgy4 `x'jbbgm `x'jbbgd `x'doiy4 `x'doim ///
	`x'doid `x'fiyr `x'fiyrl `x'jbhrs `x'jbot `x'njbwks `x'njiwks `x'njuwks ///
	`x'jbrise `x'hoh `x'mastat `x'jbsemp `x'tujbpl `x'tuin1 `x'jbsic ///
	`x'jbsect `x'qfachi `x'age `x'jbsoc `x'jbstat `x'jbbgly `x'mrjsic ///
	`x'jbterm `x'lrwght `x'region `x'cjsten using $dir/`x'indresp, clear
	
// Extract non-stationary data. I dropped variable `x'tuin2 from the list, 
// as it is not available in all waves.

	generate wave = 1+index("bcdef","`x'")
	rename `x'* *

// Create wave variable
// Rename variables for compatability across waves.
	
	save `x'indresp_junk, replace
	
// save database so it can be used as using database for merging.
	
	use pid race racel scend feend sex using $dir/xwavedat, clear
	
// Extract stationary data.
	
	merge 1:1 pid using `x'indresp_junk
	keep if _merge==3
	drop _merge
	save `x'merge1_junk, replace
	
// Merge stationary to non-stationary data and save files for later appending. 
// Merging will create an entry for every wave (because of the stationary data.
// Get rid of the superfluous wave entries from the stationary data.

	use pid `x'jhpldf `x'jhstpy `x'jhstat using $dir/`x'jobhist, clear
	sort pid, stable
	
	by pid: egen maxc1=max(`x'jhpldf)
	generate jc1=maxc1==2
	// replace jc1=. if maxc1<0                       ?What do we do with this?
	drop  maxc1 `x'jhpldf
	
	generate c2=0 if `x'jhstpy==1
	replace c2=1 if `x'jhstpy>1
	replace c2=-1 if `x'jhstpy<1
	by pid: egen maxc2=max(c2)
	generate jc2=maxc2==1
	replace jc2=. if maxc2<0
	drop c2 maxc2 //`x'jhstpy
	rename `x'jhstpy jhstpy
	
	generate c3=0 if `x'jhstat==1
	replace c3=1 if `x'jhstat>1
	replace c3=-1 if `x'jhstat<1
	by pid: egen maxc3=max(c3)
	generate jc3=maxc3==1
	replace jc3=. if maxc3<0
	drop c3 maxc3 `x'jhstat
	
// Define 3 variables that may identify a more narrow concept of job changes.

	sort pid, stable
	quietly by pid: gen dup=cond(_N==1,0,_n)
	drop if dup>1
	drop dup
	
// This database has duplicates, so get rid of these.
	
	merge 1:1 pid using `x'merge1_junk


	save mwave`x', replace
	
// save merged wave files

}

use ghid pid gjbonus gjbonam gjbbgy4 gjbbgm gjbbgd gdoiy4 gdoim gdoid gfiyr ///
gfiyrl gjbhrs gjbot gnjbwks gnjiwks gnjuwks gjbrise ghoh gmastat gjbsemp ///
gtujbpl gtuin1 gjbsic gjbsect gqfachi gage gjbsoc gjbstat gjbbgly gmrjsic ///
gjbterm glrwght gregion gcjsten using $dir/gindresp, clear

gen wave = 7
rename g* *

save gindresp_junk, replace
	
use pid race racel scend feend sex using $dir/xwavedat, clear

merge 1:1 pid using gindresp_junk
keep if _merge==3
drop _merge
	
save gmerge1_junk, replace

use pid gjhpldf gjhstpy gjhstat using $dir/gjobhist, clear
sort pid, stable

by pid: egen maxc1=max(gjhpldf)
generate jc1=maxc1==2
// replace jc1=. if maxc1<0                           ?What do we do with this?
drop  maxc1 gjhpldf

generate c2=0 if gjhstpy==1
replace c2=1 if gjhstpy>1
replace c2=-1 if gjhstpy<1
by pid: egen maxc2=max(c2)
generate jc2=maxc2==1
replace jc2=. if maxc2<0
drop c2 maxc2 //gjhstpy
rename gjhstpy jhstpy

generate c3=0 if gjhstat==1
replace c3=1 if gjhstat>1
replace c3=-1 if gjhstat<1
by pid: egen maxc3=max(c3)
generate jc3=maxc3==1
replace jc3=. if maxc3<0
drop c3 maxc3 gjhstat

sort pid, stable
quietly by pid: gen dup=cond(_N==1,0,_n)
drop if dup>1
drop dup

merge 1:1 pid using gmerge1_junk

save mwaveg, replace



use hhid pid hjbonus hjbonam hjbperfp hjbbgy4 hjbbgm hjbbgd hdoiy4 hdoim ///
hdoid hfiyr hfiyrl hjbhrs hjbot hnjbwks hnjiwks hnjuwks hjbrise hhoh ///
hmastat hjbsemp htujbpl htuin1 hjbsic hjbsect hqfachi hage hjbsoc hjbstat ///
hjbbgly hmrjsic hjbterm hlrwght hregion hcjsten using $dir/hindresp, clear

gen wave = 8
rename h* *

save hindresp_junk, replace
	
use pid race racel scend feend sex using $dir/xwavedat, clear

merge 1:1 pid using hindresp_junk
keep if _merge==3
drop _merge
	
save hmerge1_junk, replace

use pid hjhpldf hjhstpy hjhstat using $dir/hjobhist, clear
sort pid, stable

by pid: egen maxc1=max(hjhpldf)
generate jc1=maxc1==2
// replace jc1=. if maxc1<0                           ?What do we do with this?
drop  maxc1 hjhpldf

generate c2=0 if hjhstpy==1
replace c2=1 if hjhstpy>1
replace c2=-1 if hjhstpy<1
by pid: egen maxc2=max(c2)
generate jc2=maxc2==1
replace jc2=. if maxc2<0
drop c2 maxc2 //hjhstpy
rename hjhstpy jhstpy

generate c3=0 if hjhstat==1
replace c3=1 if hjhstat>1
replace c3=-1 if hjhstat<1
by pid: egen maxc3=max(c3)
generate jc3=maxc3==1
replace jc3=. if maxc3<0
drop c3 maxc3 hjhstat

sort pid, stable
quietly by pid: gen dup=cond(_N==1,0,_n)
drop if dup>1
drop dup

merge 1:1 pid using hmerge1_junk

save mwaveh, replace

foreach x in i j k l m n o {

	use `x'hid pid `x'jbonus `x'jbonam `x'jbperfp `x'jbbgy4 `x'jbbgm ///
	`x'jbbgd `x'doiy4 `x'doim `x'doid `x'fiyr `x'fiyrl `x'jbhrs `x'jbot ///
	`x'njbwks `x'njiwks `x'njuwks `x'jbrise `x'hoh `x'mastat `x'jbsemp ///
	`x'tujbpl `x'tuin1 `x'jbsic `x'jbsect `x'qfachi `x'age `x'jbsoc ///
	`x'jbstat `x'jbbgly `x'mrjsic `x'jbterm1 `x'lrwght `x'region ///
	`x'cjsten using $dir/`x'indresp, clear
	
	gen wave = 8 + index("ijklmno","`x'")
	rename `x'* *
	
	save `x'indresp_junk, replace

	use pid race racel scend feend sex using $dir/xwavedat, clear
	
	merge 1:1 pid using `x'indresp_junk
	keep if _merge==3
	drop _merge
	save `x'merge1_junk, replace
	
	use pid `x'jhpldf `x'jhstpy `x'jhstat using $dir/`x'jobhist, clear
	sort pid, stable
	
	by pid: egen maxc1=max(`x'jhpldf)
	generate jc1=maxc1==2
	// replace jc1=. if maxc1<0                       ?What do we do with this?
	drop  maxc1 `x'jhpldf
	
	generate c2=0 if `x'jhstpy==1
	replace c2=1 if `x'jhstpy>1
	replace c2=-1 if `x'jhstpy<1
	by pid: egen maxc2=max(c2)
	generate jc2=maxc2==1
	replace jc2=. if maxc2<0
	drop c2 maxc2 //`x'jhstpy
	rename `x'jhstpy jhstpy
	
	generate c3=0 if `x'jhstat==1
	replace c3=1 if `x'jhstat>1
	replace c3=-1 if `x'jhstat<1
	by pid: egen maxc3=max(c3)
	generate jc3=maxc3==1
	replace jc3=. if maxc3<0
	drop c3 maxc3 `x'jhstat
	
	sort pid, stable
	quietly by pid: gen dup=cond(_N==1,0,_n)
	drop if dup>1
	drop dup
	
	merge 1:1 pid using `x'merge1_junk
	
	save mwave`x', replace
	
}

foreach x in p q r {

	use `x'hid pid `x'jbonus `x'jbonam `x'jbperfp `x'jbbgy4 `x'jbbgm ///
	`x'jbbgd `x'doiy4 `x'doim `x'doid `x'fiyr `x'fiyrl `x'jbhrs `x'jbot ///
	`x'njbwks `x'njiwks `x'njuwks `x'jbrise `x'hoh `x'mastat `x'jbsemp  ///
	`x'tujbpl `x'tuin1 `x'jbsic92 `x'jbsect `x'qfachi `x'age `x'jbsoc ///
	`x'jbstat `x'jbbgly `x'mrjsic `x'jbterm1 `x'lrwght `x'region ///
	`x'cjsten using $dir/`x'indresp, clear
	
	gen wave = 15 + index("pqr","`x'")
	rename `x'* *
	capture rename id pid
	
	save `x'indresp_junk, replace

	use pid race racel scend feend sex using $dir/xwavedat, clear
	
	merge 1:1 pid using `x'indresp_junk
	keep if _merge==3
	drop _merge
	save `x'merge1_junk, replace
	
	use pid `x'jhstpy `x'jhstat using $dir/`x'jobhist, clear
	sort pid, stable
	
	//dropped `x'jhpldf since not available in these waves
	
	//by pid: egen maxc1=max(`x'jhpldf)
	//generate jc1=maxc1==2
	// replace jc1=. if maxc1<0                       ?What do we do with this?
	//drop  maxc1 `x'jhpldf
	
	generate c2=0 if `x'jhstpy==1
	replace c2=1 if `x'jhstpy>1
	replace c2=-1 if `x'jhstpy<1
	by pid: egen maxc2=max(c2)
	generate jc2=maxc2==1
	replace jc2=. if maxc2<0
	drop c2 maxc2 //`x'jhstpy
	rename `x'jhstpy jhstpy
	
	generate c3=0 if `x'jhstat==1
	replace c3=1 if `x'jhstat>1
	replace c3=-1 if `x'jhstat<1
	by pid: egen maxc3=max(c3)
	generate jc3=maxc3==1
	replace jc3=. if maxc3<0
	drop c3 maxc3 `x'jhstat
	
	sort pid, stable
	quietly by pid: gen dup=cond(_N==1,0,_n)
	drop if dup>1
	drop dup
	
	merge 1:1 pid using `x'merge1_junk
	
	save mwave`x', replace
	
}

foreach x in a b c d e f g h i j k l m n o p q  {
	append using mwave`x'
}

// Appending the data (list does not go up to r!!)

compress
save BHPS, replace

foreach x in a b c d e f g h i j k l m n o p q r {
	capture erase `x'indresp_junk.dta
	capture erase `x'merge1_junk.dta
	capture erase mwave`x'.dta
}

// Delete intermediary databases that are not of use anymore.

sort pid wave

// list pid wave hid age jbonus jbbgy4 jbhrs jbsic jbsic92 in 1/50, clean


// Get rid of the superfluous wave entries from the stationary data.

gen wavey=1990+wave
label var wave "wave"
label var wavey "year of wave"
label var jc1 "job change (type 1)"
label var jc2 "job change (type 2)"
label var jc3 "job change (type 3)"

// All variables are labeled appropriately.

drop _merge

// Delete merge variable

*******************************************************************************
*******************************************************************************
