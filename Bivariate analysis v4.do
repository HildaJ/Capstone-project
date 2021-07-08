**************************************************************************
                               /* Packages */
**************************************************************************
*net from http://www.stata.com/stb/stb51/
*net install sg67_1 // the installation of univar
*net install grc1leg, from(http://www.stata.com/users/vwiggins) // Combine graph
*ssc install mrtab
**************************************************************************
              /* Last updated: 7 July ‎2021*/
**************************************************************************
clear
clear matrix
set maxvar 6000

cd "D:\Univerisity of Melbourne\HILDA survey\ADA\2. STATA 190c (Zip File 1 of 2 - Combined Data Files)"

use "Combined_i190c.dta", clear

renvars, predrop (1)
drop hhrpid hhpno
drop if hgage <18 // drop children who are not covered by PHI

/* keep phpriin phctype /// PHI
hedent hegpc hegpn hehan hehnn phdayin phonin phrecad hegpc /// Health Services
hhfam hgage hgsex mrcurr esbrd esdtl losat j bhruc hhfty hhiu hhpers hhtype hhstate hhssos hhsgcc hhda10 ancob edhigh1 edfts edagels /// Useful covariaes
pdk10s pdk10rc slhrwk heany ffsrw pnopene/// Health Measurement , not include SF-6D/SF36
heart heast hecan hecbe hedep hedi1 hedi2 hedk2 hehbp hehcd heoc heomi herf2 /// Serious health conditions
losat losateo losatfs losatft losathl losatlc losatnl losatsf losatyh /// Satisfaction
es esbrd esdtl esempdt esempst /// Employment
hehtyp hhstate hhstrat hhtype aneab mrcurr mrcms mrclc bmwt bmi bmht hsdebt hsdebtf hsdebti hsvalui /// Demographic
leins lemar lemvd lepcm leprg leprm lercl lertr lesep ledsc ledrl ledfr lebth lefni lefnw leinf // Life event
jbcasab jbmcnt jbm682 jbhruc jbmhruc jbmi61 jbmi62 jbmii2 jbmsch /// Jobs
anaf99 gh8 ///
hhad10 hhda10 hhec10 hhed10 hhsad10 hhsec10 hhsed10 ///
tifeftp tifeftn /// Income
edhigh1 /// Education
anaucit anaures anbcob ancitiz anyoan /// */


* Frequently used labels *
label define isbinary 0 "No" 1"Yes"
label define phpriinl 0 "Without Cover" 1 "With Cover"
label define phistatus 0 "Without Cover" 1 "Hospital Cover only" 2 "Extras Cover only" 3 "Both"
label define tertile 1 "Low" 2 "Medium" 3 "High"
label define quintile 1 "Very Low" 2 "Low" 3 "Medium" 4 "High" 5 "Very High"
label define phitypel 1 "Hospital Cover only" 2 "Extras Cover only" 3 "Both"
label define ghsf6dl 1 "Bad" 2 "Fair" 3 "Good" 4 "Very Good"
label define genderl 0 "Female" 1 "Male"
label define remotel 0 "Major cities" 1 "Inner Region" 2 "Outer Regional"3 "(Very) Remote"


**********RECODE MISSING DATA & DERIVE NEW VARIABLES**********
                /* Independent varaibles */
**************************************************************
gen phi_binary =. // PHI status,
replace phi_binary = 1 if phpriin == 1 // 
replace phi_binary = 0 if phpriin == 2 // [0] Without Cover [1] Without Cover
label value phi_binary isbinary
quietly tab phi_binary, gen(phi_binary) // Create dummy variables
rename phi_binary1 phi_no
rename phi_binary2 phi_yes

gen phi_type =. // PHI type
replace phi_type = 1 if phctype == 1 // Hospital cover only
replace phi_type = 2 if phctype == 2 // Extras cover only
replace phi_type = 3 if phctype == 3 // Both covers
quietly tab phi_type, gen(phi_type) // Create dummy variables
label value phi_type phitypel
rename phi_type1 phitype_hos
rename phi_type2 phitype_ex
rename phi_type3 phitype_both

					**************
					* Group them *
					**************

gen phi_status = .
replace phi_status = 0 if phpriin == 2 // Without Cover
replace phi_status = 1 if phctype == 1 // Hospital
replace phi_status = 2 if phctype == 2 // Extras
replace phi_status = 3 if phctype == 3 // Both
label value phi_status phistatus
quietly tab phi_status, gen(phistatus_cat)
rename phistatus_cat1 WithoutCover
rename phistatus_cat2 HospitalCover
rename phistatus_cat3 ExtrasCover
rename phistatus_cat4 BothCover

**************************************************************
                 /* Dependent varaibles */
**************************************************************

				/// H1: Health Outcome ///
/*				
* Serious Health Conditions *

replace heany =. if heany < 0 // Have any of these serious illness
replace heany = 0 if phpriin == 2 // [2] No
label value heany isbinary // recode binary variables

* Serious Health Conditions
replace heart =. if heart < 0 // Arthritis or osteoporosis
replace heast =. if heast < 0 // Asthma
replace hecan =. if hecan < 0 // Any type of cancer
replace hecbe =. if hecbe < 0 // Chronic bronchitis or emphysema
replace hedep =. if hedep < 0 // Depression or anxiety
replace hedi1 =. if hedi1 < 0 // Type 1 diabetes
replace hedi2 =. if hedi2 < 0 // Type 2 diabetes
replace hedk2 =. if hedk2 < 0 // Dont know
replace hehbp =. if hehbp < 0 // High blood pressure or hypertension
replace hehcd =. if hehcd < 0 // Heart disease
replace heoc =. if heoc < 0 // Any other serious circulatory condition
replace heomi =. if heomi < 0 // Other mental illness

preserve
gen idnum = _n
expand 11
bysort idnum: gen recnum = _n

/*gen hesys_cat = .
replace hesys_cat = 1 if heart == 1 & recnum == 1 // Arthritis or osteoporosis
replace hesys_cat = 2 if heast == 1 & recnum == 2 | hecbe == 1 & recnum == 4 // Asthama + Chronic bronchitis or emphysema = Respiratory Diseases
replace hesys_cat = 3 if hecan == 1 & recnum == 3 // Any type of cancer
replace hesys_cat = 4 if heoc == 1 & recnum == 5 | hehbp == 1 & recnum == 8 | hehcd == 1 & recnum == 9 // CVD
replace hesys_cat = 5 if hedi1 == 1 & recnum == 6 | hedi2 == 1 & recnum == 7 // Diabetes
replace hesys_cat = 6 if hedep == 1 & recnum == 10 | heomi == 1 & recnum == 11 // Mental health
label define hesys_cat 1 "Arthritis or osteoporosis" 2 "Respiratory Diseases" 3 "Cancer" 4 "CVD" 5 "Diabetes" 6 "Mental health"

graph bar phistatus_no phistatus_hos phistatus_ex phistatus_both , over(hesys_cat, label(labsize(vsmall))) /// name(ill_gr17) ///
	blabel(total, format(%9.2f) size(vsmall)) ///
	ylabel(0 "0%" 20 "20%" 40 "40%" 60 "60%" 80 "80%") ///
	title("PHI distribution, by Diagnosed with serious illness") ///
	legend(rows(1) size(vsmall) position(0) bplacement(neast) symxsize(*0.5) keygap(1) label (1 "Without Cover") label (2 "Hospital cover only") label (3 "Extras cover only ") label (4 "Both hospital and extras cover" )) ///
	note("PHI = Private Health Insurance" "1: Arthritis or osteoporosis, 2: Asthama, 3: Any type of cancer, " "4: Chronic bronchitis or emphysema, 5: Depression or anxiety, 6: Type 1 diabetes," "7: Type 2 diabetes, 8: High blood pressure or hypertension, 9: Heart disease" "10: Any other serious cirtulatory condition (eg stroke, hardening of the arteries), 11: Other mental illness", size(vsmall)) */

gen diagnosed = .
replace diagnosed = 1 if heart == 1 & recnum == 1 // Arthritis or osteoporosis
replace diagnosed = 2 if hecan == 1 & recnum == 2 // Any type of cancer

replace diagnosed = 3 if heast == 1 & recnum == 3 // Asthama
replace diagnosed = 4 if hecbe == 1 & recnum == 4 // Chronic bronchitis or emphysema


replace diagnosed = 5 if hedi1 == 1 & recnum == 5 // Type 1 diabetes
replace diagnosed = 6 if hedi2 == 1 & recnum == 6 // Type 2 diabetes

replace diagnosed = 7 if heoc == 1 & recnum == 7 // Any other serious cirtulatory condition (eg stroke, hardening of the arteries)
replace diagnosed = 8 if hehbp == 1 & recnum == 8 // High blood pressure or hypertension
replace diagnosed = 9 if hehcd == 1 & recnum == 9 // Heart disease

replace diagnosed = 10 if hedep == 1 & recnum == 10 // Depression or anxiety
replace diagnosed = 11 if heomi == 1 & recnum == 11 // Other mental illness
tab2 diagnosed phi_status

 graph bar phistatus_no phistatus_hos phistatus_ex phistatus_both , over(diagnosed, label(labsize(vsmall))) /// name(ill_gr17) ///
	blabel(total, format(%9.2f) size(vsmall)) ///
	ylabel(0 "0%" 20 "20%" 40 "40%" 60 "60%" 80 "80%") ///
	title("PHI distribution, by Diagnosed with serious illness") ///
	legend(rows(1) size(vsmall) position(0) bplacement(neast) symxsize(*0.5) keygap(1) label (1 "Without Cover") label (2 "Hospital cover only") label (3 "Extras cover only ") label (4 "Both hospital and extras cover" )) ///
	note("PHI = Private Health Insurance" "1: Arthritis or osteoporosis, 2: Any type of cancer, 3: Asthama, " "4: Chronic bronchitis or emphysema, 5: Type 1 diabetes, 6: Type 2 diabetes," "7: Any other serious cirtulatory condition (eg stroke, hardening of the arteries), 8: High blood pressure or hypertension, 9: Heart disease" "10: Depression or anxiety, 11: Other mental illness", size(vsmall))
restore 

mrtab heart heast hecan hecbe heoc hedi1 hedi2 hehbp hehcd hedep heomi, by (phi_status) title(phi distribution by Serious health conditions) row width(35)


* Physical/Mental categories

gen physicalmental_cat = .
replace physicalmental_cat = 3 if heart == 1 & hedep == 1 | heast == 1 & hedep == 1 | hecan == 1 & hedep == 0 | hecbe == 1 & hedep == 0 | heoc == 1  & hedep == 0 | hedi1 == 1 & hedep == 0 | hedi2 == 1 & hedep == 0 | hehbp == 1 & hedep == 0 | hehcd == 1 & hedep == 0 | heart == 1 & heomi == 1 | heast == 1 & heomi == 1 | hecan == 1 & heomi == 1 | hecbe == 1 & heomi == 1 | heoc == 1  & heomi == 1 | hedi1 == 1 & heomi == 1 | hedi2 == 1 & heomi == 1 | hehbp == 1 & heomi == 1 | hehcd == 1 & heomi == 1
replace physicalmental_cat = 2 if heart == 1 & hedep == 0 & heomi == 0
replace physicalmental_cat = 2 if heast == 1 & hedep == 0 & heomi == 0
replace physicalmental_cat = 2 if hecan == 1 & hedep == 0 & heomi == 0
replace physicalmental_cat = 2 if hecbe == 1 & hedep == 0 & heomi == 0
replace physicalmental_cat = 2 if heoc == 1  & hedep == 0 & heomi == 0
replace physicalmental_cat = 2 if hedi1 == 1 & hedep == 0 & heomi == 0
replace physicalmental_cat = 2 if hedi2 == 1 & hedep == 0 & heomi == 0
replace physicalmental_cat = 2 if hehbp == 1 & hedep == 0 & heomi == 0
replace physicalmental_cat = 2 if hehcd == 1 & hedep == 0 & heomi == 0
replace physicalmental_cat = 1 if hedep == 1 & heart == 0 & heast == 0 & hecan == 0 & hecbe == 0 & heoc == 0 & hedi1 == 0 & hedi2 == 0 & hehbp == 0 & hehcd == 0 | heomi == 1 & heart == 0 & heast == 0 & hecan == 0 & hecbe == 0 & heoc == 0 & hedi1 == 0 & hedi2 == 0 & hehbp == 0 & hehcd == 0 
label define physicalmental_catl 3 "Both" 2 "Physical problems only" 1 "Mental problems only"
label value physicalmental_cat physicalmental_catl

graph bar phistatus_no phistatus_hos phistatus_ex phistatus_both , over(physicalmental_cat, label(labsize(vsmall))) /// name(ill_gr17) ///
	blabel(total, format(%9.2f) size(vsmall)) ///
	ylabel(0 "0%" 20 "20%" 40 "40%" 60 "60%" 80 "80%") ///
	title("PHI distribution, by Physical/Mental health") ///
	legend(rows(1) size(vsmall) position(0) bplacement(neast) symxsize(*0.5) keygap(1) label (1 "Without Cover") label (2 "Hospital cover only") label (3 "Extras cover only ") label (4 "Both hospital and extras cover" ))
	
	
*****************************
* ↓  Diseases Categorise  ↓ *
*****************************

* Long term health conditions
label variable hespnc "Sight problems" // Sight problems not corrected by glasses / lenses
label variable hespch "Speech problems" // Speech problems
label variable heslu "Difficulty learning" // Difficulty learning or understanding things
label variable hesbdb "Diffifulty breathing" // Shortness of breath or difficulty breathing
label variable hehear "Hearing problems" // Hearing problems
label variable hebflc "Loss of consciousness" // Blackouts, fits or loss of consciousness
label variable heluaf "Limited use of arms/fingers" // Limited use of arms or fingers
label variable hedgt "Difficulty gripping" //  Difficulty gripping things
label variable helufl "Limited use of feet/legs" // Limited use of feet or legs
label variable henec "Emotional condition" // A nervous or emotional condition which requires treatment
label variable hecrpa "Any condition restricts physical work" //  Any condition that restricts physical activity or physical work (e.g. back problems, migraines)
label variable hedisf "Disfigurement/deformity" // Any disfigurement or deformity
label variable hemirh "Mental illness" // Any mental illness which requires help or supervision
label variable hecrp "Chronic/recurring pain" // Chronic or recurring pain
label variable hehibd "Effects of brain damage" // Long term effects as a result of a head injury, stroke or other brain damage
label variable hemed "Long-term condition after treatment" //  Long-term condition or ailment which is still restrictive even though it is being treated
label variable heoth "Any other long-term condition" // Any other long-term condition such as arthritis, asthma, heart disease, Alzheimers, dementia etc


** Divided by number
egen long_hecount = anycount(hespnc hespch heslu hesbdb hehear hebflc heluaf hedgt helufl henec hecrpa hedisf hemirh hecrp hehibd hemed heoth), values (1)

gen long_hecat =.
replace long_hecat = 0 if long_hecount == 0
replace long_hecat = 1 if long_hecount == 1
replace long_hecat = 2 if long_hecount == 2
replace long_hecat = 3 if long_hecount == 3
replace long_hecat = 4 if long_hecount == 4
replace long_hecat = 5 if long_hecount == 5
replace long_hecat = 6 if long_hecount == 6
replace long_hecat = 7 if long_hecount >= 7

label define long_hecatl 0 "0" 1 "1" 2 "2" 3 "3" 4 "4" 5 "5" 6 "6" 7 "7+"
label value long_hecat long_hecatl

/* graph bar phistatus_no phistatus_hos phistatus_ex phistatus_both, over(long_hecat) /// name(age_gr) ///
	title("PHI distribution, by long term conditions") ///
	ylabel(0 "0%" 20 "20%"  40 "40%" 60 "60%") blabel(total,format(%9.2f) size(vsmall)) ///
	legend(label (1 "Without Cover") label (2 "Hospital cover only") label (3 "Extras cover only ") label (4 "Both hospital and extras cover"))  ///
	note("PHI = Private Health Insurance")  */

** Confrom to existing categories

mrtab hespnc hespch heslu hesbdb hehear hebflc heluaf hedgt helufl henec hecrpa hedisf hemirh hecrp hehibd hemed heoth, sort by(phi_status) title(phi distribution by long-term conditions) row width(20)

mrgraph hbar hespnc hespch heslu hesbdb hehear hebflc heluaf hedgt helufl henec hecrpa hedisf hemirh hecrp hehibd hemed heoth, sort by(phi_status) stat(row)

*Long term health conditions impacts on employment

/* hechjob
heonas
heothed
hepuwrk
herhour
herjob
hetowrk // need additional time off work
hespeq // need special equipment/ arrangements */

egen he_empcount = anycount(hechjob heonas heothed hepuwrk herhour herjob hetowrk hespeq), values (1)

gen he_empcat =.
replace he_empcat = 0 if he_empcount == 0 
replace he_empcat = 1 if he_empcount == 1
replace he_empcat = 2 if he_empcount == 2 
replace he_empcat = 3 if he_empcount == 3 
replace he_empcat = 4 if he_empcount == 4 
replace he_empcat = 5 if he_empcount >= 5

label define he_empcatl 0 "0" 1 "1" 2 "2" 3 "3" 4 "4" 5 "5+"
label value he_empcat he_empcatl

graph bar phistatus_no phistatus_hos phistatus_ex phistatus_both, over(he_empcat) /// name(age_gr) ///
	title("PHI distribution, by long term conditions") ///
	ylabel(0 "0%" 20 "20%"  40 "40%" 60 "60%") blabel(total,format(%9.2f) size(vsmall)) ///
	legend(label (1 "Without Cover") label (2 "Hospital cover only") label (3 "Extras cover only ") label (4 "Both hospital and extras cover"))  ///
	note("PHI = Private Health Insurance")


	
	
* Physical or Mental measurement *
replace pdk10s =. if pdk10s < 0 // K10 score, continuous

replace pdk10rc =. if pdk10rc < 0 // K10 risk categories
tabulate pdk10rc, gen(pdk10rc) // Create dummy variables
*/


* SF-6D/SF36

gen sf6d = ghsf6ap - ghsf6an if ghsf6ap >= 0 // Australian weights

*Self-assessed health (SAH) P.S drop gh1, because of small sample size
gen sah =.
replace sah = 1 if herate == 1
replace sah = 2 if herate == 2
replace sah = 3 if herate == 3
replace sah = 4 if herate == 4
replace sah = 5 if herate == 5

label define sahl 1 "Excellent" 2 "Very good" 3 "Good" 4 "Fair" 5 "Poor"
label value sah sahl

qui tab sah, gen(sah)
rename (sah1 sah2 sah3 sah4 sah5) (sah_ex sah_vgood sah_good sah_fair sah_poor)

* Which ones?

* hetosch // need additional time off school / study

* Long term health condition/disability/impairment from PQ
* helth

* Type of disability

* Whether has disability / health condition


				/// H2: Health services ///
				
* Doctor and hospital visits * 

gen dentist = .
replace dentist = 1 if hedent == 1 // How long since last saw a dentist
replace dentist = 2 if hedent == 2
replace dentist = 3 if hedent == 3
replace dentist = 4 if hedent == 4
replace dentist = 5 if hedent == 5
replace dentist = 8 if hedent == 8
quietly tabulate dentist, gen(dentist)
rename (dentist1 dentist2 dentist3 dentist4 dentist5 dentist6) (dentist0_6 dentist6_12 dentist1_2 dentist2_5 dentist5_more dentist_never)

gen gpclinic = .
replace gpclinic = 1 if hegpc == 1 // Sees a particular GP or clinic
replace gpclinic = 0 if hegpc == 2 
label value gpclinic isbinary

gen gpn = hegpn
replace gpn = . if hegpn < 0 // Number of doctor visits
xtile gpn_cat = gpn, nq(5)
label value gpn_cat quintile

gen hehan_cat = .
replace hehan_cat = 0 if hehan == 0 // Number of hospital admissions
replace hehan_cat = 1 if hehan == 1
replace hehan_cat = 2 if hehan == 2
replace hehan_cat = 3 if hehan == 3
replace hehan_cat = 4 if hehan >= 4 & hehan <.
label define hsad_catl 0 "0" 1 "1" 2 "2" 3 "3" 4 "4+"
label value hehan_cat hsad_catl

gen hehnn_cat =.
replace hehnn_cat = 0 if hehnn == 0 // Number of nights in hospital
replace hehnn_cat = 1 if hehnn == 1
replace hehnn_cat = 2 if hehnn == 2
replace hehnn_cat = 3 if hehnn == 3
replace hehnn_cat = 4 if hehnn == 4
replace hehnn_cat = 5 if hehnn == 5
replace hehnn_cat = 6 if hehnn == 6
replace hehnn_cat = 7 if hehnn >= 7 & hehnn <.
label define hsngs_catl 0 "0" 1 "1" 2 "2" 3 "3" 4 "4" 5 "5" 6 "6" 7 "7+"
label value hehnn_cat hsng_catl

gen nightstay = phrecad
replace nightstay = . if phrecad < 0 // Overnight stays for most recent overnight admission to hospital
xtile phrecad_5 = phrecad, nq(5)
label value phrecad_5 quintile

gen dayptype= phdayin
replace dayptype =. if phdayin < 0 // Hospital day patient admission type
quietly tab dayptype, gen(dayptype)
rename dayptype1 day_pubpatient
rename dayptype2 day_pri_pripatient
rename dayptype3 day_pri_pubpatient
rename dayptype4 day_other

gen nightptype = phonin
replace nightptype =. if phonin < 0 // Hospital overnight patient admission type
quietly tab nightptype, gen(nightptype)
rename nightptype1 night_pubpatient
rename nightptype2 night_pri_pripatient
rename nightptype3 night_pri_pubpatient
rename nightptype4 night_other

* Takes prescription medication

gen med_art = hepmart
gen med_asthma = hepmast
gen med_cancer = hepmcan
gen med_emphysema = hepmcbe
gen med_di1 = hepmdi1
gen med_di2 = hepmdi2
gen med_dep = hepmdep
gen med_mental = hepmomi
gen med_heart = hepmhd
gen med_hbp = hepmhbp

replace med_art =. if hepmart <0
replace med_asthma =. if hepmast <0
replace med_cancer =. if hepmcan <0
replace med_emphy =. if hepmcbe <0
replace med_di1 =. if hepmdi1 <0
replace med_di2 =. if hepmdi2 <0
replace med_dep =. if hepmdep <0
replace med_mental =. if hepmomi <0
replace med_heart =. if hepmhd <0
replace med_hbp =. if hepmhbp <0

label variable med_art "Arthritis or osteoporosis"
label variable med_asthma "Asthma"
label variable med_cancer "Cancer"
label variable med_emphy "Chronic bronchitis or emphysema"
label variable med_di1 "Type 1 Diabetes"
label variable med_di2 "Type 2 Diabetes"
label variable med_dep "Depression or anxiety"
label variable med_mental "Other mental illness"
label variable med_heart "Heart disease"
label variable med_hbp "High blood pressure or hypertension"

/// H3: Health expenditure ///
 
* hxyhlpi         //  Fees paid to health practitioners
* hxyphii         // Private health insurance
* hxyphmi         //  Medicines, prescriptions, pharmaceuticals, alternative medicines

* OOP expenditure/ GPs/ PHI/specialists/ dentists / https://www.publish.csiro.au/ah/fulltext/AH18191


/// H4: financial stress ///
* financial stressors *
gen fs_askedff = .
replace fs_askedff = 1 if fiprbfh == 1
replace fs_askedff = 0 if fiprbfh == 2

gen fs_mortgage = .
replace fs_mortgage = 1 if fiprbmr == 1
replace fs_mortgage = 0 if fiprbmr == 2

gen fs_pawned = .
replace fs_pawned = 1 if fiprbps == 1
replace fs_pawned = 0 if fiprbps == 2

gen fs_heat = .
replace fs_heat = 1 if fiprbuh == 1
replace fs_heat = 0 if fiprbuh == 2

gen fs_meal = .
replace fs_meal = 1 if fiprbwm == 1
replace fs_meal = 0 if fiprbwm == 2

gen fs_askedwo = .
replace fs_askedwo = 1 if fiprbwo == 1 
replace fs_askedwo = 0 if fiprbwo == 2

gen fs_bill = .
replace fs_bill = 1 if fiprbeg == 1
replace fs_bill = 0 if fiprbeg == 2

label value fs_askedff isbinary
label value fs_mortgage isbinary
label value fs_pawned isbinary
label value fs_heat isbinary
label value fs_meal isbinary
label value fs_askedwo isbinary
label value fs_bill isbinary

					******************
					* Factor analysis*
					******************
					
quietly describe fs_*
quietly sum fs_*
quietly factor fs_*
quietly rotate
quietly predict fa1_bill fa2_living fa3_unkown
quietly sum fa1_bill fa2_living fa3_unkown


******************************************************************
                   /* Covariates */
******************************************************************

				*************************
				* Demographic variables ↓
				*************************

****************
**  LANGUAGE  **
****************

* language spoken other than English

gen lang_flu=. //How well speaks English
replace lang_flu = 1 if aneab == 1
replace lang_flu = 2 if aneab > 1 & aneab <.
label define lang_flul 1 "Very Well" 2 "Well or Worse"
label value lang_flu lang_flul

gen lang_spk=. // Speak language other than English
replace lang_spk = 1 if anlote == 1
replace lang_spk = 0 if anlote == 2
label value lang_spk isbinary

gen lang_first=. // History: Is English the first language you learned to speak as a child ???????????? why history
replace lang_first = 1 if anengf == 1
replace lang_first = 0 if anengf == 2
label value lang_first isbinary

***************
** HOUSEHOLD **
***************
/*
* 	Has resident children (includes RC without natural parent in HH) !!!!!!!!!!!! MIGHT HAVE BETTER VARIABLE TO INDICATE having or not having CHILDREN

gen r_havechild =.
replace r_havechild = 1 if rchave == 1
replace r_havechild = 0 if rchave == 2
label value r_havechild isbinary

graph bar phistatus_no phistatus_hos phistatus_ex phistatus_both, over(r_havechild) /// name(age_gr) ///
	title("PHI distribution, by having resident children or not") ///
	ylabel(0 "0%" 20 "20%"  40 "40%" 60 "60%") blabel(total,format(%9.2f) size(vsmall)) ///
	legend(label (1 "Without Cover") label (2 "Hospital cover only") label (3 "Extras cover only ") label (4 "Both hospital and extras cover"))  ///
	note("PHI = Private Health Insurance") // Each PHI type distribution by age group
	
gen r_havechild25 =.
replace r_havechild25 = 0 if tcr25 == 0
replace r_havechild25 = 1 if tcr25 == 1
replace r_havechild25 = 2 if tcr25 >= 2
label define r_havechild25l 0 "0" 1 "1" 2 "2+"
label value r_havechild25 r_havechild25l

* the number of respondent's resident children < 25 years
gen nr_child25 =.
replace nr_child25 = 1 if ncudr25 == 2
replace nr_child25 = 0 if ncudr25 == 1
label value nr_child isbinary

/* graph bar phistatus_no phistatus_hos phistatus_ex phistatus_both, over(nr_child) /// name(age_gr) ///
	title("PHI distribution, by non-resident children < 25 years") ///
	ylabel(0 "0%" 20 "20%"  40 "40%" 60 "60%") blabel(total,format(%9.2f) size(vsmall)) ///
	legend(label (1 "Without Cover") label (2 "Hospital cover only") label (3 "Extras cover only ") label (4 "Both hospital and extras cover"))  ///
	note("PHI = Private Health Insurance") // Each PHI type distribution by age group	*/

gen nr_child18 =. // Any non-resident children aged < 18
replace nr_child18 = 1 if ncudr17 == 1
replace nr_child18 = 0 if ncudr17 == 2
label value nr_child18 isbinary

/* graph bar phistatus_no phistatus_hos phistatus_ex phistatus_both, over(nr_child18) /// name(age_gr) ///
	title("PHI distribution, by non-resident children < 18 years") ///
	ylabel(0 "0%" 20 "20%"  40 "40%" 60 "60%") blabel(total,format(%9.2f) size(vsmall)) ///
	legend(label (1 "Without Cover") label (2 "Hospital cover only") label (3 "Extras cover only ") label (4 "Both hospital and extras cover"))  ///
	note("PHI = Private Health Insurance") // Each PHI type distribution by age group	*/

gen nr_child4 =.
replace nr_child4 = 0 if tcn04 == 0 // DV: Count of own non-resident children aged 0-4
replace nr_child4 = 1 if tcn04 >0
label value nr_child4 isbinary

 graph bar phistatus_no phistatus_hos phistatus_ex phistatus_both, over(nr_child4) /// name(age_gr) ///
	title("PHI distribution, by non-resident children < 18 years") ///
	ylabel(0 "0%" 20 "20%"  40 "40%" 60 "60%") blabel(total,format(%9.2f) size(vsmall)) ///
	legend(label (1 "Without Cover") label (2 "Hospital cover only") label (3 "Extras cover only ") label (4 "Both hospital and extras cover"))  ///
	note("PHI = Private Health Insurance") // Each PHI type distribution by age group 

*/

* The covariaes below refer to Table3.2: List of useful variables in HILDA User Mannual 19, Page 13 *


* Age
gen age_cat =.
replace age_cat = 1 if hgage >= 18 & hgage < 25
replace age_cat = 2 if hgage >= 25 & hgage < 35
replace age_cat = 3 if hgage >= 35 & hgage < 45 
replace age_cat = 4 if hgage >= 45 & hgage < 55
replace age_cat = 5 if hgage >= 55 & hgage < 65
replace age_cat = 6 if hgage >= 65 & hgage < 75
replace age_cat = 7 if hgage >= 75 & hgage < 85
replace age_cat = 8 if hgage >= 85 & hgage < .
label define agel 1 "18-24" 2 "25-34" 3 "35-44" 4 "45-54" 5 "55-64" 6 "65-74" 7 "75-84" 8 "85+"
label value age_cat agel // 

gen age_squared = .
replace age_squared = hgage * hgage if hgage >=18 & hgage <.

* Sex
gen sex = .
replace sex = 1 if hgsex == 1
replace sex = 0 if hgsex == 2
label value sex genderl

gen Male = sex

* SEIFA 
qui tab hhsad10, gen(seifa)

* Household Income
* see Appendix in Wilkins (2014) 'Derived income variables in the HILDA survey' for explanation *

gen total_hinc =  hifeftp - hifeftn // 	household level gross total income
rename total_hinc income
xtile income_100 = income, nq(100)


* Marital status
gen marital_status = .
replace marital_status = 1 if mrcurr == 1 // Married
replace marital_status = 2 if mrcurr == 2 // Defacto
replace marital_status = 3 if mrcurr == 3 | mrcurr == 4
replace marital_status = 4 if mrcurr == 5
replace marital_status = 5 if mrcurr == 6
label define maritall 1 "Legally married" 2 "De facto" 3 "Separated/Divorced" 4 "Widowed" 5 "Never married and not de facto"
label value marital_status maritall
qui tab marital_status, gen(marital_status)
rename (marital_status1 marital_status2 marital_status3 marital_status4 marital_status5) (Married Defacto SeparatedDivorced Widowed NeverMarriedDefacto)

******************
**  EMPLOYMENT  **
******************

* Employment/ Labour force status

replace esbrd = . if esbrd < 0 | hgage >65 // DV: Current labour force status - broad
replace esdtl = . if esdtl < 0 | hgage > 65	// labour forece status - detail
gen labour_status =.
replace labour_status = 1 if esdtl == 1
replace labour_status = 2 if esdtl == 2
replace labour_status = 3 if esdtl == 3 | esdtl == 4
replace labour_status = 4 if esdtl == 5 | esdtl == 6
replace labour_status = 5 if esdtl == 7
label define labourl 1 "Employed FT" 2 "Employed PT" 3 "Unemployed" 4 "Not in the labour force" 5 "Employed but unkown usual work hours"
label value labour_status labourl


replace es = . if es < 0 | hgage > 65 // Current employment status (ABS defined)
replace esempst = . if esempst < 0 | hgage > 65 // Current employment status


replace esempdt = . if esempdt < 0 | hgage > 65 // employment status
gen employment_status =.
replace employment_status = 1 if esempdt == 1
replace employment_status = 2 if esempdt == 2 | esempdt == 3
replace employment_status = 3 if esempdt == 4 | esempdt == 5
replace employment_status = 4 if esempdt == 6
label define employmentl 1 "Employee" 2 "Employee of own business" 3 "Employer/Self-employed" 4 "Unpaid family worker"
label value employment_status employmentl


qui tab employment_status, gen(employment_status)
rename (employment_status1 employment_status2 employment_status3 employment_status4) (Employee Ownbusiness EmployerSelf Familyworker)

************
* Location *
************
qui tab hhstate, gen(hhstate) // State
rename (hhstate1 hhstate2 hhstate3 hhstate4 hhstate5 hhstate6 hhstate7 hhstate8) (NSW VIC QLD SA WA TAS NT ACT)

gen remote =. // Areas
replace remote = 0 if hhra == 0
replace remote = 1 if hhra == 1
replace remote = 2 if hhra == 2 
replace remote = 3 if hhra == 3 | hhra == 4
label value remote remotel
qui tab remote, gen (remote)
rename (remote1 remote2 remote3 remote4) (MajorCity InnerRegion OuterRegional Remote)

replace hhda10 = . if hhda10 < 0
replace edfts = . if edfts < 0
replace edagels = . if edagels < 0

* This division refers to Terence Chai Cheng's 'Measuring the effects of removing subsidies for private insurance on public expenditure for health care'*
gen edu = .
replace edu = 1 if edhigh1 == 9 | edhigh1 == 8 //highest qual. is Year 12 or below
replace edu = 2 if edhigh1 == 5 // highest qual. is a Certificate
replace edu = 3 if edhigh1 == 4 // highest qual. is a (Advanced) Diploma
replace edu = 4 if edhigh1 == 3 | edhigh1 == 2 | edhigh1 == 1 // highest qual. is a degree or above
label define edul 1 "School" 2 "Certificate" 3 "Dipl/ Adv Dipl" 4 "Bach. above" 
label value edu edul

qui tab edu, gen(edu) 
rename (edu1 edu2 edu3 edu4) (School Certificate Dipl Bach)


tab es, gen(es)
tab esempdt
tab esempst, gen(esempst)
rename esempst3 selfemployed
