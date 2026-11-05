cd "`inputDir'"

use variete, clear

keep if qtrcod == `qtrcod' & carsem == `carsem' & ile == `ile'

gen carmoi = `carmoi'
gen caran = `caran'

save "`tmpDir'\affect_ile`ile'_an`caran'_mois`carmoi'_sem`carsem'_agent`qtrcod'", replace
