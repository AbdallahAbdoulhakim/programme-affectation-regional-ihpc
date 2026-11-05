capture program drop doAffectation
program define doAffectation
syntax , 							///
	inputDir(string)				///
	outputDir(string)				/// 
	mainFile(string)				///
	interview(string)				///
	
	
	// inputdir
	
	cd "`inputDir'"
	
	// Questionnaire principale

	use "`mainFile'", clear
	
	keep ile caran qtrcod carmoi carsem 

	duplicates drop

	gen interview__id = "`interview'"

	tempfile quest
	save "`quest'", replace
	

	// questionnaire HE

	use "`mainFile'", clear

	keep if sertyp == 4

	count


	if `r(N)' >= 1 {


	keep varcod varlib varliblng
	sort varlib

	ren * *_1
	
	
	
	gen he_varlist = varcod_1
	gen HE__id = _n

	gen interview__id = "`interview'"
	
	tempfile output_he
	save "`output_he'", replace
	
	keep interview__id he_varlist 	
	
	ren he_varlist tmp_he_varlist__

	gen n = _n

	replace n = n-1

	reshape wide tmp_he_varlist__*, i(interview__id ) j(n)
	
	
	local nb_Var =  `r(k)' - 2 
	
	egen number_non_miss = rownonmiss(tmp_he_varlist__*), strok
	
	local nb_Obs =  _N
	
		
	forvalues i = 1(1)`nb_Obs'{
		di "Observation `i'"
		local nb_Rempli = number_non_miss[`i']
		
		local k = 0
		
		forvalues j=0(1)`nb_Var'{
			local val = tmp_he_varlist__`j'[`i']
			
			if ("`val'" != "") {
				capture desc he_varlist__`k'
				
				if (_rc != 0){
					gen he_varlist__`k' = "`val'" in `i'
				}
				else {
					replace he_varlist__`k' = "`val'" in `i'
				}
				
				local k = `k'+1
			}	
		}
	}
	
	drop tmp_he_varlist__* number_non_miss
	
	tempfile he
	save "`he'", replace


	}


	// questionnaire O1

	use "`mainFile'", clear

	keep if sertyp == 1

	count

	if `r(N)' >= 1 {

	keep varcod varlib varliblng
	sort varcod

	ren * *_2
		
	gen o1_varlist = varcod_2
	gen O1__id = _n

	gen interview__id = "`interview'"
	
	tempfile output_o1
	save "`output_o1'", replace
	

	keep interview__id o1_varlist

	ren o1_varlist tmp_o1_varlist__

	gen n = _n

	replace n = n-1

	reshape wide tmp_o1_varlist__*, i(interview__id) j(n)
	
	local nb_Var =  `r(k)' - 2 
	
	egen number_non_miss = rownonmiss(tmp_o1_varlist__*), strok
	
	local nb_Obs =  _N
	
	forvalues i = 1(1)`nb_Obs'{
		di "Observation `i'"
		local nb_Rempli = number_non_miss[`i']
		local k = 0
		
		forvalues j=0(1)`nb_Var'{
			local val = tmp_o1_varlist__`j'[`i']
			
			if ("`val'" != "") {
				capture desc o1_varlist__`k'
				
				if (_rc != 0){
					gen o1_varlist__`k' = "`val'" in `i'
				}
				else {
					replace o1_varlist__`k' = "`val'" in `i'
				}
				
				local k = `k'+1
			}	
		}
	}
	
	drop tmp_o1_varlist__* number_non_miss
	
	tempfile o1
	save "`o1'", replace

	}
	

	// questionnaire O1O2


	use "`mainFile'", clear

	keep if inlist(sertyp,2,3)

	count

	if `r(N)' >= 1 {

	keep varcod varlib varliblng sertyp
	sort varcod

	ren * *_3


	gen o2o3_varlist = varcod_3
	gen O2O3__id = _n

	gen interview__id = "`interview'"
	
	tempfile output_o2o3
	save "`output_o2o3'", replace

	keep interview__id o2o3_varlist
	

	ren o2o3_varlist tmp_o2o3_varlist__

	gen n = _n

	replace n = n-1

	reshape wide tmp_o2o3_varlist__*, i(interview__id ) j(n)
	
	local nb_Var =  `r(k)' - 2
	
	egen number_non_miss = rownonmiss(tmp_o2o3_varlist__*), strok
	
	local nb_Obs =  _N
	
	forvalues i = 1(1)`nb_Obs'{
		di "Observation `i'"
		local nb_Rempli = number_non_miss[`i']
		local k = 0
		
		forvalues j=0(1)`nb_Var'{
			local val = tmp_o2o3_varlist__`j'[`i']
			
			if ("`val'" != "") {
				capture desc o2o3_varlist__`k'
				
				if (_rc != 0){
					gen o2o3_varlist__`k' = "`val'" in `i'
				}
				else {
					replace o2o3_varlist__`k' = "`val'" in `i'
				}
				
				local k = `k'+1
			}	
		}
	}
	
	drop tmp_o2o3_varlist__* number_non_miss
	
	tempfile o2o3
	save "`o2o3'", replace
	
	}
	
	
	
	// he
	
	capture use "`output_he'", clear

	
	if (_rc == 0){
	   
	

		order HE__id he_varlist varcod_1  varlib_1 varliblng_1  interview__id
	
		export delimited using "`outputDir'/HE.tab", delimiter(tab) replace
	    
	}
	
	// o1
	
	capture use "`output_o1'", clear
	
	
	if (_rc == 0) {
	   
		order O1__id o1_varlist  varcod_2  varlib_2 varliblng_2  interview__id
		export delimited using "`outputDir'/O1.tab", delimiter(tab) replace
	    
	}
	
	// o2o3
	
	capture use "`output_o2o3'", clear
	
	
	if (_rc == 0) {

		order O2O3__id o2o3_varlist varcod_3  varlib_3 varliblng_3 sertyp_3 interview__id
		export delimited using "`outputDir'/O2O3.tab", delimiter(tab) replace
	    
	}
	
	

	// Questionnaire principale

	use "`mainFile'", clear
	
	keep ile caran carmoi qtrcod carsem
	
	duplicates drop
	
	gen interview__id = "`interview'"
	
	capture merge 1:1 interview__id  using "`he'", nogen
	capture merge 1:1 interview__id  using "`o1'", nogen
	capture merge 1:1 interview__id  using "`o2o3'", nogen
	
	gen has_he = 2
	gen has_o1  = 2	
	gen has_o2o3 = 2
	
	capture describe he_varlist__*
	
	local he_existe = _rc
	
	if (_rc == 0) {
		egen nnmiss_he = rownonmiss(he_varlist__*), strok
		replace has_he = 1 if nnmiss_he >= 1 & !mi(nnmiss_he)
		drop nnmiss_he
		
	} 
	
	capture describe o1_varlist__*
	
	local o1_existe = _rc
	
	if (_rc == 0) {
		egen nnmiss_o1 = rownonmiss(o1_varlist__*), strok
		replace has_o1 = 1 if nnmiss_o1 >= 1 & !mi(nnmiss_o1)
		drop nnmiss_o1
		
	} 
	
	capture describe o2o3_varlist__*
	
	local o2o3_existe = _rc
	
	if (_rc == 0) {
		egen nnmiss_o2o3 = rownonmiss(o2o3_varlist__*), strok
		replace has_o2o3 = 1 if nnmiss_o2o3 >= 1 & !mi(nnmiss_o2o3)
		drop nnmiss_o2o3
		
	} 
	
	capture order interview__id ile caran carmoi qtrcod carsem

	export delimited using "`outputDir'/regional_ihpc_carnet.tab", delimiter(tab) replace
	

end
