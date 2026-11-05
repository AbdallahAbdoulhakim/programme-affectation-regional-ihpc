/*=============================================================================
Paramètres du Projet
=============================================================================*/

// Dossiers de travail

local projDir "D:\automatisation_chapo\affectations_regional"
local inputDir "`projDir'/input"
local outputDir "`projDir'/output"
local progDir "`projDir'/prog"
local tmpDir "`projDir'/tmp"

/*********************************************

				Début Paramétrage

**********************************************/

// 1 pour Mwali, 2 pour Ndzuwani

local ile 1

// Semaine dans le mois 1,2,3 ou 4
local carsem 4

// mois 1 à 12
local carmoi 6

// code agent 1,2 pour Anjouan ou 1,2 pour mwali

local qtrcod 1

// Année
local caran 2026
/*********************************************

				Fin Paramétrage

**********************************************/

// Preparation

include "`progDir'/preparation.do"
include "`progDir'/doAffectation.do"
include "`progDir'/zipCreate.do"

// Créer répertoire

! mkdir "`outputDir'/ihpc_ile`ile'_an`caran'_mois`carmoi'_sem`carsem'_agent`qtrcod'"


* do affectations

doAffectation , 												///
	inputDir("`tmpDir'") 										///
	outputDir("`outputDir'/ihpc_ile`ile'_an`caran'_mois`carmoi'_sem`carsem'_agent`qtrcod'") 		///
	mainFile("affect_ile`ile'_an`caran'_mois`carmoi'_sem`carsem'_agent`qtrcod'")					///
	interview("c17160704caa4c3da5e0f8cb8c78c3b7")				
	
	
zipCreate ,													///
	inputDir("`outputDir'/ihpc_ile`ile'_an`caran'_mois`carmoi'_sem`carsem'_agent`qtrcod'")	///
	outputDir("`outputDir'")								/// 
	zipName("ihpc_ile`ile'_an`caran'_mois`carmoi'_sem`carsem'_agent`qtrcod'")					///
	typeFile("tab")											///
	
	
// Supprimer repertoire

cd "`progDir'"

! rmdir "`outputDir'/ihpc_ile`ile'_an`caran'_mois`carmoi'_sem`carsem'_agent`qtrcod'" /s /q


erase "`tmpDir'/affect_ile`ile'_an`caran'_mois`carmoi'_sem`carsem'_agent`qtrcod'.dta"

clear 

exit

