*******************************************************************************
*************************** Variance decomposition ****************************
*******************************************************************************

local bonusjob "bonusjob"
local jobmatch "jobmatch"

set more off

//xtmixed lnhly if bonusjob1==1 || pid:, variance nolog

//xtmixed lnhly if bonusjob1==0 || pid:, variance nolog

//xtmixed lnhly if bonusjob1==1 || pid: || jobmatch1:, variance nolog

//xtmixed lnhly if bonusjob1==0 || pid: || jobmatch1:, variance nolog

//

xtmixed outcomepp_r if `bonusjob'==1 || pid: , variance nolog

xtmixed outcomenpp_r if `bonusjob'==0 || pid: , variance nolog

xtmixed outcomepp_r if `bonusjob'==1 || pid: || `jobmatch':, variance nolog

xtmixed outcomenpp_r if `bonusjob'==0 || pid: || `jobmatch':, variance nolog

// What for people that have been in both jobs?

by pid: egen bonustotal=total(`bonusjob')
by pid: generate split=1
by pid: replace split=0 if bonustotal==0
by pid: replace split=0 if _N==bonustotal

xtmixed outcomepp_r if (`bonusjob'==1 & split==1) || pid:, variance nolog

xtmixed outcomenpp_r if (`bonusjob'==0 & split==1) || pid:, variance nolog

xtmixed outcomepp_r if (`bonusjob'==1 & split==1) || pid: || `jobmatch': , ///
variance nolog

xtmixed outcomenpp_r if (`bonusjob'==0 & split==1) || pid: || `jobmatch': , ///
variance nolog

// What with different factor loadings for different periods?

//generate JM1 = `jobmatch'*ME1
//generate JM2 = `jobmatch'*ME2
//generate JM3 = `jobmatch'*ME3
//generate JM4 = `jobmatch'*ME4
//generate JM5 = `jobmatch'*ME5
//generate JM6 = `jobmatch'*ME6

//xtmixed outcomepp_r if (`bonusjob'==1 & split==1) || pid: || JM1: || JM2: ///
//|| JM3: || JM4: || JM5: || JM6:, variance nolog

//xtmixed outcomenpp_r if (`bonusjob'==0 & split==1) || pid: || JM1: || JM2: ///
//|| JM3: || JM4: || JM5: || JM6:, variance nolog


*******************************************************************************
*******************************************************************************
