capture program drop zipCreate
program define zipCreate
syntax , 							///
	inputDir(string)				///
	outputDir(string)				/// 
	zipName(string)					///
	typeFile(string)				///

	
	cd "`inputDir'"
	
	
	// Tab

	local tabList : dir "`inputDir'" files "*.`typeFile'" , nofail respectcase
	
	local tabList : list clean tabList
	
	zipfile `tabList', saving("`outputDir'/`zipName'.zip", replace)

end
