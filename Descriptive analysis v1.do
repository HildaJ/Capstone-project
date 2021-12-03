* Update: 08/10/2021
* 1. Delete POLS analysis
* 2. Delete redundant variables in descriptive analysis, like SEIFA & income
* 3. Collation and optimization
* 4. add interaction term in other analysis
* 5. New table for oral presentation

set maxvar 9000

use "D:\Univerisity of Melbourne\HILDA survey\ADA\2. STATA 190c (Zip File 1 of 2 - Combined Data Files)\HILDA-combined-09-17.dta", clear
* Table1: Descriptive analysis*
* Variable Definition and Descriptive Statistics

gen interaction_hos = secondary_care*HospitalCover
gen interaction_ex = secondary_care*ExtrasCover
gen interaction_both = secondary_care*BothCover

tab wave, gen (wave) 
rename (wave1 wave2 wave3) (wave9 wave13 wave17) 

* RE model variables - full population
global xvars hgage age_squared Male ///
VIC QLD SA WA TAS NT ACT MajorCity InnerRegion OuterRegional /// reference: NSW, Remote
seifa2 seifa3 seifa4 seifa5 seifa6 seifa7 seifa8 seifa9 seifa10 /// Lowest decile
Lowincome Mediumincome Highincome Vhighincome /// Vlowincome
Certificate Dipl Bach edu_missing /// school
Defacto SeparatedDivorced Widowed NeverMarriedDefacto marital_missing /// married
EmployerSelf employment_missing /// employee
wave13 wave17

* FE model variables - full population
global xvars_fe hgage age_squared ///
Lowincome Mediumincome Highincome Vhighincome /// Vlowincome
Defacto SeparatedDivorced Widowed NeverMarriedDefacto marital_missing /// married
Certificate Dipl Bach edu_missing ///
EmployerSelf employment_missing


**********************************************

asdoc 
codebook WithoutCover ExtrasCover HospitalCover BothCover if wave9 == 1
codebook WithoutCover ExtrasCover HospitalCover BothCover if wave13 == 1
codebook WithoutCover ExtrasCover HospitalCover BothCover if wave17 == 1

sum hxyhlpi if wave9 == 1, by(phi_status)
sum hxyphmi if wave9 == 1

bysort phi_status: sum hxyhlpi if wave9 ==1 
bysort phi_status: sum hxyhlpi if wave13 ==1
bysort phi_status: sum hxyhlpi if wave17 ==1  

bysort phi_status: sum hxyphmi if wave9 ==1 
bysort phi_status: sum hxyphmi if wave13 ==1
bysort phi_status: sum hxyphmi if wave17 ==1  

bysort phi_status: sum oop if wave9 ==1 
bysort phi_status: sum oop if wave13 ==1
bysort phi_status: sum oop if wave17 ==1  
***********************************

* DESCRIPTIVE ANALYSIS *
asdoc sum Male hgage immigrant WithoutCover ExtrasCover HospitalCover BothCover ///
/// SAH
VIC NSW QLD SA WA TAS NT ACT MajorCity InnerRegion OuterRegional Remote ///
School Certificate Dipl Bach ///
Married Defacto SeparatedDivorced Widowed NeverMarriedDefacto ///
EmployerSelf, save(Descriptive analysis.doc) label stat(N mean sd min max) title(Table 1: Summary statistics) abb(.) dec(2) replace

* SEIFA
tabstat WithoutCover HospitalCover ExtrasCover BothCover, by(seifa) stat(mean sd) nototal  col(stat) long

***********************************

* Table2: The relationship between health outcome (SF-6d) and PHI status*
xtreg sf6d HospitalCover ExtrasCover BothCover interaction_hos interaction_ex interaction_both secondary_care expenditure_annual $xvars, re i(waveid) vce(robust)
outreg2 using table2.doc,dec (3) ctitle(RE model) label addstat("rho",e(rho)) replace 

xtreg sf6d HospitalCover ExtrasCover BothCover interaction_hos interaction_ex interaction_both secondary_care expenditure_annual $xvars_fe, fe i(waveid) vce(robust)
outreg2 using table2.doc,dec (3) ctitle(FE model) label addstat("rho",e(rho)) append 

***********************************

* Table6: The relationship between out-of-pocket expenditure and PHI status*
xtreg oop HospitalCover ExtrasCover BothCover interaction_hos interaction_ex interaction_both secondary_care expenditure_annual $xvars, re i(waveid) vce(robust)
outreg2 using table6.doc,dec(3) ctitle(RE model) label addstat("rho",e(rho)) replace 
xtreg oop HospitalCover ExtrasCover BothCover interaction_hos interaction_ex interaction_both secondary_care expenditure_annual $xvars_fe, fe i(waveid) vce(robust)
outreg2 using table6.doc,dec(3) append ctitle(FE model) label addstat("rho",e(rho)) 

***********************************

* Table7: The relationship between financial stress and PHI status*
xtreg fa1_bill HospitalCover ExtrasCover BothCover interaction_hos interaction_ex interaction_both secondary_care expenditure_annual $xvars, re i(waveid) vce(robust)
outreg2 using table7.doc,dec(3) ctitle(RE model) label addstat("rho",e(rho)) replace 
xtreg fa1_bill HospitalCover ExtrasCover BothCover interaction_hos interaction_ex interaction_both secondary_care expenditure_annual $xvars_fe, fe i(waveid) vce(robust)
outreg2 using table7.doc,append dec(3) ctitle(FE model) label addstat("rho",e(rho))

xtreg fa2_living HospitalCover ExtrasCover BothCover interaction_hos interaction_ex interaction_both secondary_care expenditure_annual $xvars, re i(waveid) vce(robust)
outreg2 using table7.doc,append dec(3) ctitle(RE model) label addstat("rho",e(rho)) 
xtreg fa2_living HospitalCover ExtrasCover BothCover interaction_hos interaction_ex interaction_both secondary_care expenditure_annual $xvars_fe, fe i(waveid) vce(robust)
outreg2 using table7.doc,append dec(3) ctitle(FE model) label addstat("rho",e(rho)) 

***********************************

* Table for ORAL PRESENTATION
* Table: SF-6D
xtreg sf6d HospitalCover ExtrasCover BothCover interaction_hos interaction_ex interaction_both secondary_care  expenditure_annual $xvars, re i(waveid) vce(robust)
outreg2 using table8.doc,dec (3) ctitle(RE model) label addstat("rho",e(rho)) replace 
xtreg sf6d HospitalCover ExtrasCover BothCover interaction_hos interaction_ex interaction_both secondary_care  expenditure_annual $xvars_fe, fe i(waveid) vce(robust)
outreg2 using table8.doc,dec (3) ctitle(FE model) label addstat("rho",e(rho)) append 

* Table: The relationship between out-of-pocket expenditure and PHI status*
xtreg oop HospitalCover ExtrasCover BothCover interaction_hos interaction_ex interaction_both secondary_care  expenditure_annual $xvars, re i(waveid) vce(robust)
outreg2 using table8.doc,dec(3) ctitle(RE model) label addstat("rho",e(rho)) append
xtreg oop HospitalCover ExtrasCover BothCover interaction_hos interaction_ex interaction_both secondary_care  expenditure_annual $xvars_fe, fe i(waveid) vce(robust)
outreg2 using table8.doc,dec(3) ctitle(FE model) label addstat("rho",e(rho)) append

* Table: The relationship between financial stress and PHI status*
xtreg fa1_bill HospitalCover ExtrasCover BothCover interaction_hos interaction_ex interaction_both secondary_care  expenditure_annual $xvars, re i(waveid) vce(robust)
outreg2 using table8.doc,dec(3) ctitle(RE model) label addstat("rho",e(rho)) append
xtreg fa1_bill HospitalCover ExtrasCover BothCover interaction_hos interaction_ex interaction_both secondary_care  expenditure_annual  $xvars_fe, fe i(waveid) vce(robust)
outreg2 using table8.doc, dec(3) ctitle(FE model) label addstat("rho",e(rho)) append



* Appendix
* Robustness test *
* Table1: The relationship between health outcome (K10) and PHI status *
* Table2: The relationship between health outcome (SAH) and PHI status *
* Table3: The sub group analysis*