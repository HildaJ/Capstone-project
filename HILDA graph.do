******************************************************************
             /* Only for calculate percentages */ 
******************************************************************

replace phistatus_no = phistatus_no*100
replace phistatus_hos = phistatus_hos*100
replace phistatus_ex = phistatus_ex*100
replace phistatus_both = phistatus_both*100
replace phi_yes = phi_yes*100

replace dentist0_6 = dentist0_6*100
replace dentist6_12 = dentist6_12*100
replace dentist1_2 = dentist1_2*100
replace dentist2_5 = dentist2_5*100
replace dentist5_more = dentist5_more*100
replace dentist_never = dentist_never*100





quietly tab phi_status, gen(phistatus_gr) // facilitate plotting
rename phistatus_gr1 phistatus_no
rename phistatus_gr2 phistatus_hos
rename phistatus_gr3 phistatus_ex
rename phistatus_gr4 phistatus_both





/* 1. Bivariate analysis */

//                              //
//>>>>>>>>>>>> H1 >>>>>>>>>>>>>>//
//                              //

* X: Age Y: PHI *
univar hgage if phpriin < . , by(phpriin) onehdr boxplot // descriptive table

graph bar phistatus_no phistatus_hos phistatus_ex phistatus_both, over(age_cat) /// name(age_gr) ///
	title("PHI distribution, by age") ///
	ylabel(0 "0%" 20 "20%"  40 "40%" 60 "60%") blabel(total,format(%9.2f) size(vsmall)) ///
	legend(label (1 "Without Cover") label (2 "Hospital cover only") label (3 "Extras cover only ") label (4 "Both hospital and extras cover"))  ///
	note("PHI = Private Health Insurance") // Each PHI type distribution by age group


//gr drop age_gr
//graph bar phpriin_yes phpriin_no, over(age_cat) title(" Age distribution, by insurance status", size(medsmall)) blabel(total, format(%9.2f)) ylabel(0 "0%" 0.2 "20%"  0.4 "40%" 0.6 "60%") legend(label (1 "With Cover") label (2 "Without Cover")) // Number of patients with or without PHI for each age group

* X: Income Y: PHI *
// graph bar phpriin_yes phpriin_no, over(hhiu) // X: Income unit

// graph bar phpriin_yes phpriin_no, over(total_hinc_30) title("Figure1: PHI membership distribution, by household gross total income", size(small)) ylabel(0 "0%" 0.2 "20%" 0.4 "40%" 0.6 "60%" 0.8 "80%") legend(label (1 "With Cover") label (2 "Without Cover")) // X: Gross total income

// graph bar phpriin_no phitype_hos phitype_ex phitype_both, over(total_hinc_30) title("PHI types distribution, by household gross toal income") ylabel(0 "0%" 0.2 "20%" 0.4 "40%" 0.6 "60%" 0.8 "80%" 1 "100%") legend(label (1 "Without Cover") label (2 "Hospital cover only") label (3 "Extras cover only ") label (4 "Both hospital and extras cover"))  note("PHI = Private Health Insurance") // X: household Gross total income

bysort total_hinc_100: egen minc_phpriin_no = mean(phistatus_no) // calculate the proportion of PHI types
bysort total_hinc_100: egen minc_phitype_hos = mean(phistatus_hos)
bysort total_hinc_100: egen minc_phitype_ex = mean(phistatus_ex)
bysort total_hinc_100: egen minc_phitype_both = mean(phistatus_both)

	line minc_phpriin_no total_hinc_100, lpattern(longdash) ///
	|| line  minc_phitype_hos minc_phitype_ex minc_phitype_both total_hinc_100, yaxis(1 2) ///
	|| , ///
	title("PHI types distribution, by household gross toal income")	///
	ylabel(0 "0%" 20 "20%"  40 "40%" 60 "60%" 80 "80%", axis(2) gmax angle(horizontal)) ///
	ylabel(0 "0%" 5 "5%" 10 "10%" 15 "15%", axis(1)   gmin angle(horizontal)) ///
	ylabel(, axis(2) grid) ///
	xlabel(0(10)100) xtitle("Income",) ///
	legend(label (1 "Without Cover") ///
	label (2 "Hospital cover only") label (3 "Extras cover only ") label (4 "Both hospital and extras cover")) ///
	note("PHI = Private Health Insurance")

gr drop hinc_gr

tab phi_status total_hinc_10

* X: Gender Y: PHI *
// graph bar phpriin_yes phpriin_no, over(hgsex) title("Gender Vs. PHI status") blabel(total, format(%9.2f)) legend(label (1 "With Cover") label (2 "Without Cover"))

graph bar phistatus_no phistatus_hos phistatus_ex phistatus_both, over(hgsex) /// name(gender_gr) blabel(total)
	title("PHI distribution, by Gender") ///
	ylabel(0 "0%" 20 "20%"  40 "40%") ///
	blabel(total, format(%9.2f)) ///
	legend(label (1 "Without Cover") label (2 "Hospital cover only") label (3 "Extras cover only ") label (4 "Both hospital and extras cover")) ///
	note("PHI = Private Health Insurance")

gr display gender_gr
gr drop gender_gr

* X: Area Y: PHI *
// graph bar phpriin_yes phpriin_no, over(hhstate) title("Area Vs. PHI status") blabel(total, format(%9.2f)) ylabel(0 "0%" 0.2 "20%" 0.4 "40%" 0.6 "60%" 0.8 "80%") legend(label (1 "With Cover") label (2 "Without Cover")) // X: State

graph bar phistatus_no phistatus_hos phistatus_ex phistatus_both , over(hhstate) /// name(area_gr1)
	title("PHI distribution") ///
	subtitle("by Area") ///
	ylabel(0 "0%" 20 "20%"  40 "40%" 60 "60%") ///
	blabel(total, format(%9.2f)) ///
	legend(label (1 "Without Cover") label (2 "Hospital cover only") label (3 "Extras cover only ") label (4 "Both hospital and extras cover")) ///
	note("PHI = Private Health Insurance")
	
gr display area_gr1
gr drop area_gr1

// graph bar phpriin_yes phpriin_no, over(hhssos) title("Area Vs. PHI status")  blabel(total, format(%9.2f)) ylabel(0 "0%" 0.2 "20%" 0.4 "40%" 0.6 "60%" 0.8 "80%") legend(label (1 "With Cover") label (2 "Without Cover")) // X: Section of state

graph bar phistatus_no phistatus_hos phistatus_ex phistatus_both, over(remote) /// name(area_gr2) blabel(total) ///
	title("PHI distribution, by Section of state distribution") ///
	ylabel(0 "0%" 20 "20%"  40 "40%" 60 "60%") ///
	blabel(total, format(%9.2f)) ///
	legend(label (1 "Without Cover") label (2 "Hospital cover only") label (3 "Extras cover only ") label (4 "Both hospital and extras cover")) ///
	note("PHI = Private Health Insurance" "Major cities: Person resides in major cities" "Inner region: Person resides in inner regional areas" "Other: Person resides in outer regional and (very) remote" "Ref: 10.1016/j.jhealeco.2013.11.007") 

gr drop area_gr2

//graph bar (sum) phpriin_yes phpriin_no, over(hhsgcc) // X: Greater Capital City Statistical Area
//graph bar (sum) phitype_hos phitype_ex phitype_both , over(hhsgcc) blabel(total) 

* X: SEIFA Y:PHI *

graph bar phistatus_no phistatus_hos phistatus_ex phistatus_both, over(hhsad10, label(angle(15) labsize(vsmall))) /// name(area_gr2) blabel(total) ///
	title("PHI distribution, by SEIFA 2011") ///
	ylabel(0 "0%" 20 "20%"  40 "40%" 60 "60%" 80 "80%") ///
	blabel(total, format(%9.2f)) ///
	legend(size(vsmall) label (1 "Without Cover") label (2 "Hospital cover only") label (3 "Extras cover only ") label (4 "Both hospital and extras cover")) ///
	note("PHI = Private Health Insurance" "SEIFA: Socio-Economic Indexes for Areas") 

* X: Education Y:PHI *
// graph bar phpriin_yes , over(edu) title("Education Vs. PHI status") blabel(total, format(%9.2f)) legend(label (1 "With Cover") label (2 "Without Cover")) // Highest education level achieved

graph bar phistatus_no phistatus_hos phistatus_ex phistatus_both , over(edu) /// name(edu_gr1) ///
	blabel(total, format(%9.2f)) ///
	ylabel(0 "0%" 20 "20%" 40 "40%" 60 "60%") ///
	title("PHI distribution, by Education") ///
	legend(label (1 "Without Cover") label (2 "Hospital cover only") label (3 "Extras cover only ") label (4 "Both hospital and extras cover")) ///
	note("PHI = Private Health Insurance")

gr drop edu_gr1

* X: Employment status Y: PHI

graph bar phistatus_no phistatus_hos phistatus_ex phistatus_both , over(esbrd, label(labsize(vsmall))) /// name(edu_gr1) ///
	blabel(total, format(%9.2f)) ///
	ylabel(0 "0%" 20 "20%" 40 "40%" 60 "60%") ///
	title("PHI distribution, by Labour force status(broad)") ///
	legend(label (1 "Without Cover") label (2 "Hospital cover only") label (3 "Extras cover only ") label (4 "Both hospital and extras cover")) ///
	note("PHI = Private Health Insurance")
	

graph bar phistatus_no phistatus_hos phistatus_ex phistatus_both , over(esdtl, label(labsize(vsmall))) /// name(edu_gr1) ///
	blabel(total, format(%9.2f)) ///
	ylabel(0 "0%" 20 "20%" 40 "40%" 60 "60%") ///
	title("PHI distribution, by Labour Force Status(detailed)") ///
	legend(label (1 "Without Cover") label (2 "Hospital cover only") label (3 "Extras cover only ") label (4 "Both hospital and extras cover")) ///
	note("PHI = Private Health Insurance")
	
	
graph bar phistatus_no phistatus_hos phistatus_ex phistatus_both , over(labour_status, label(labsize(vsmall))) /// name(edu_gr1) ///
	blabel(total, format(%9.2f)) ///
	ylabel(0 "0%" 20 "20%" 40 "40%" 60 "60%") ///
	title("PHI distribution, by Labour Force Status(detailed)") ///
	legend(label (1 "Without Cover") label (2 "Hospital cover only") label (3 "Extras cover only ") label (4 "Both hospital and extras cover")) ///
	note("PHI = Private Health Insurance")
	
graph bar phistatus_no phistatus_hos phistatus_ex phistatus_both , over(esempdt, label(labsize(vsmall))) /// name(edu_gr1) ///
	blabel(total, format(%9.2f)) ///
	ylabel(0 "0%" 20 "20%" 40 "40%" 60 "60%") ///
	title("PHI distribution, by Employment Status") ///
	legend(label (1 "Without Cover") label (2 "Hospital cover only") label (3 "Extras cover only ") label (4 "Both hospital and extras cover")) ///
	note("PHI = Private Health Insurance")

graph bar phistatus_no phistatus_hos phistatus_ex phistatus_both , over(employment_status, label(labsize(vsmall))) /// name(edu_gr1) ///
	blabel(total, format(%9.2f)) ///
	ylabel(0 "0%" 20 "20%" 40 "40%" 60 "60%") ///
	title("PHI distribution, by Employment Status (new)") ///
	legend(label (1 "Without Cover") label (2 "Hospital cover only") label (3 "Extras cover only ") label (4 "Both hospital and extras cover")) ///
	note("PHI = Private Health Insurance")
	
	
* Marital status
graph bar phistatus_no phistatus_hos phistatus_ex phistatus_both , over(marital_status, label(labsize(vsmall))) /// name(edu_gr1) ///
	blabel(total, format(%9.2f)) ///
	ylabel(0 "0%" 20 "20%" 40 "40%" 60 "60%") ///
	title("PHI distribution, by Marital status") ///
	legend(label (1 "Without Cover") label (2 "Hospital cover only") label (3 "Extras cover only ") label (4 "Both hospital and extras cover")) ///
	note("PHI = Private Health Insurance")

* SF-6D/SF36

graph bar phistatus_no phistatus_hos phistatus_ex phistatus_both , over(ghsf6d_cat) /// name(edu_gr1) ///
	blabel(total, format(%9.2f)) ///
	ylabel(0 "0%" 20 "20%" 40 "40%" 60 "60%") ///
	title("PHI distribution, by SF-6D") ///
	legend(label (1 "Without Cover") label (2 "Hospital cover only") label (3 "Extras cover only ") label (4 "Both hospital and extras cover")) ///
	note("PHI = Private Health Insurance")

* self-assessed health
graph bar phistatus_no phistatus_hos phistatus_ex phistatus_both , over(gh1, label(labsize(vsmall))) name(sah_gr1) ///
	blabel(total, format(%9.2f)) ///
	ylabel(0 "0%" 20 "20%" 40 "40%" 60 "60%") ///
	title("PHI distribution, by Self-assessed Health") ///
	legend(label (1 "Without Cover") label (2 "Hospital cover only") label (3 "Extras cover only ") label (4 "Both hospital and extras cover")) ///
	note("PHI = Private Health Insurance")
	
	
graph bar phistatus_no phistatus_hos phistatus_ex phistatus_both , over(herate, label(labsize(vsmall))) name(sah_gr2) ///
	blabel(total, format(%9.2f)) ///
	ylabel(0 "0%" 20 "20%" 40 "40%" 60 "60%") ///
	title("PHI distribution, by generally rate your health") ///
	legend(label (1 "Without Cover") label (2 "Hospital cover only") label (3 "Extras cover only ") label (4 "Both hospital and extras cover")) ///
	note("PHI = Private Health Insurance")

grc1leg sah_gr1 sah_gr2

* Health conditions

graph bar phistatus_no phistatus_hos phistatus_ex phistatus_both , over(diagnosed, label(labsize(vsmall))) /// name(ill_gr17) ///
	blabel(total, format(%9.2f) size(vsmall)) ///
	ylabel(0 "0%" 20 "20%" 40 "40%" 60 "60%" 80 "80%") ///
	/// title("PHI distribution, by Diagnosed with serious illness") ///
	legend(rows(1) size(vsmall) position(0) bplacement(neast) symxsize(*0.5) keygap(1) label (1 "Without Cover") label (2 "Hospital cover only") label (3 "Extras cover only ") label (4 "Both hospital and extras cover" )) 
	note("PHI = Private Health Insurance" "1: Arthritis or osteoporosis, 2: Asthama, 3: Any type of cancer, " "4: Chronic bronchitis or emphysema, 5: Depression or anxiety, 6: Type 1 diabetes," "7: Type 2 diabetes, 8: High blood pressure or hypertension, 9: Heart disease" "10: Any other serious cirtulatory condition (eg stroke, hardening of the arteries), 11: Other mental illness", size(vsmall))


//gr combine age_gr hinc_gr gender_gr area_gr1 area_gr2 edu_gr1

grc1leg age_gr gender_gr area_gr1 area_gr2 edu_gr1

* Language

graph bar phistatus_no phistatus_hos phistatus_ex phistatus_both, over(lang_flu) /// name(age_gr) ///
	title("PHI distribution, by English proficiency") ///
	ylabel(0 "0%" 20 "20%"  40 "40%" 60 "60%" 80 "80%") blabel(total,format(%9.2f) size(vsmall)) ///
	legend(label (1 "Without Cover") label (2 "Hospital cover only") label (3 "Extras cover only ") label (4 "Both hospital and extras cover"))  ///
	note("PHI = Private Health Insurance") // Each PHI type distribution by age group	


graph bar phistatus_no phistatus_hos phistatus_ex phistatus_both, over(lang_spk) /// name(age_gr) ///
	title("PHI distribution, by spoken language") ///
	ylabel(0 "0%" 20 "20%"  40 "40%" 60 "60%") blabel(total,format(%9.2f) size(vsmall)) ///
	legend(label (1 "Without Cover") label (2 "Hospital cover only") label (3 "Extras cover only ") label (4 "Both hospital and extras cover"))  ///
	note("PHI = Private Health Insurance") // Each PHI type distribution by age group	

graph bar phistatus_no phistatus_hos phistatus_ex phistatus_both, over(lang_first) /// name(age_gr) ///
	title("PHI distribution, by first language") ///
	ylabel(0 "0%" 20 "20%"  40 "40%" 60 "60%") blabel(total,format(%9.2f) size(vsmall)) ///
	legend(label (1 "Without Cover") label (2 "Hospital cover only") label (3 "Extras cover only ") label (4 "Both hospital and extras cover"))  ///
	note("PHI = Private Health Insurance") // Each PHI type distribution by age group	








//                              //
//>>>>>>>>>>>> H2 >>>>>>>>>>>>>>//
//                              //


* X: PHI Y: How long since last saw a dentist *
label value phctype phitypel
label value phpriin phpriinl

graph bar hedent0_6 hedent6_12 hedent1_2 hedent2_5 hedent5_more hedent_never, over(phi_status, gap(*2)) ///
	bargap(30) ///
	blabel(total, format(%9.2f)) ///
	ylabel(0 "0%" 20 "20%" 40 "40%" 60 "60%") ///
	legend(label (1 "Less than 6 months ago") label (2 "Six to less than 12 months ago") label (3 "One to less than 2 years ago") label (4 "Two to less than 5 years ago") label (5 "Five or more years ago") label (6 "Never been to a dentist")) 

/* graph bar hedent0_6 hedent6_12 hedent1_2 hedent2_5 hedent5_more hedent_never, over(phpriin) /// name(dent1) ///
	ylabel(0 "0%" 0.2 "20%" 0.4 "40%") ///
	legend(label (1 "Less than 6 months ago") label (2 "Six to less than 12 months ago") label (3 "One to less than 2 years ago") label (4 "Two to less than 5 years ago") label (5 "Five or more years ago") label (6 "Never been to a dentist")) */
	
	
/* graph bar hedent0_6 hedent6_12 hedent1_2 hedent2_5 hedent5_more hedent_never, over(phi_status, gap(*5)) name(dent2) ///
	blabel(total,format(%9.2f)) ylabel(0 "0%" 20 "20%" 40 "40%") ///
	legend(label (1 "Less than 6 months ago") label (2 "Six to less than 12 months ago") label (3 "One to less than 2 years ago") label (4 "Two to less than 5 years ago") label (5 "Five or more years ago") label (6 "Never been to a dentist")) */
	
//grc1leg dent1 dent2,ycommon title("How long since last saw a dentist") subtitle("by PHI status") note("PHI = Private Health Insurance")

//graph drop dent1 dent2


* X: PHI Y: Sees a particular GP or clinic*

//graph bar phpriin_yes phpriin_no, over(hegpc) name(hegpc1) title("Sees a particular GP or clinic Vs. PHI types") legend(label (1 "With PHI") label (2 "Without PHI"))
//graph bar phitype_hos phitype_ex phitype_both, over(hegpc) name(hegpc2) title("Sees a particular GP or clinic Vs. PHI types") legend(label (1 "Hospital cover only") label (2 "Extras cover only") label (3 "Both hospital and extras cover"))

graph bar phistatus_no phistatus_hos phistatus_ex phistatus_both, over(hegpc) /// name(hegpc1)
	blabel(total, format(%9.2f)) ///
	ylabel(0 "0%" 20 "20%" 40 "40%" 60 "60%") ///
	title("% of people sees a particular GP or clinic, by PHI status") 
	
	legend(label (1 "Without Cover") label (2 "Hospital cover only") label (3 "Extras cover only") label (4 "Both hospital and extras cover")) ///
	note("PHI = Private Health Insurance")  

gr drop hegpc1
gr display hegpc1

* X: PHI Y: Number of doctor visits * Need check again
graph bar phpriin_yes phpriin_no, over(hegpn_cat, gap(*0)) ///
	title("PHI distribution, by Number of doctor visits") ///
	ylabel(0 "0%" 20 "20%" 40 "40%" 60 "60%") ///
	legend(label (1 "With PHI") label (2 "Without PHI")) ///
	note("PHI = Private Health Insurance")


graph bar hegpn, over(phctype) title("Number of doctor visits Vs. PHI types")  // it should show in the table


bysort hegpn: egen mgp_phistatus_no = mean(phistatus_no)
bysort hegpn: egen mgp_phistatus_hos = mean(phistatus_hos)
bysort hegpn: egen mgp_phistatus_ex = mean(phistatus_ex)
bysort hegpn: egen mgp_phistatus_both = mean(phistatus_both)
twoway scatter mgp_phistatus_no mgp_phistatus_hos mgp_phistatus_ex mgp_phistatus_both hegpn


graph bar phistatus_no phistatus_hos phistatus_ex phistatus_both, over(hegpn_cat) ///
	title("Number of doctor visits") subtitle("by PHI status") ///
	blabel(total, format(%9.2f)) ///
	ylabel(0 "0%" 20 "20%" 40 "40%" 60 "60%") ///
	yla(, ang(h)) ///
	legend(size(small) label (1 "Without Cover") label (2 "Hospital cover only") label (3 "Extras cover only") label (4 "Both hospital and extras cover")) 

* X: PHI Y: Number of hospital admissions *
//graph bar phpriin_yes phpriin_no, over(hehan_cat) title("Number of hospital admissions Vs. PHI status") legend(label (1 "With PHI") label (2 "Without PHI"))
graph bar mgp_phistatus_no mgp_phistatus_hos mgp_phistatus_ex mgp_phistatus_both, over(hehan_cat) ///name(hehan_gr1) 
	title("Number of hospital admissions, by PHI status") ///
	blabel(total, format(%9.2f)) ///
	ylabel(0 "0%" 20 "20%" 40 "40%" 60 "60%" ) ///
	legend(label (1 "Without Cover") label (2 "Hospital cover only") label (3 "Extras cover only") label (4 "Both hospital and extras cover")) ///
	note("PHI = Private Health Insurance")

graph bar mgp_phistatus_no mgp_phistatus_hos mgp_phistatus_ex mgp_phistatus_both, over(hehan) ///
	title("PHI distribution, by Number of hospital admissions") /// 
	ylabel(0 "0%" 20 "20%" 40 "40%" 60 "60%" 80 "80%" 100 "100%") ///
	legend(label (1 "Without Cover") label (2 "Hospital cover only") label (3 "Extras cover only") label (4 "Both hospital and extras cover")) ///
	note("PHI = Private Health Insurance")

gr drop hehan_gr1 
gr drop hehan_gr2
grc1leg hehan_gr1 hehan_gr2
gr drop hehan_gr1 hehan_gr2

//we need a table
/////use xtile to describe them

* X: PHI Y: Number of nights in hospital *
//graph bar phpriin_yes phpriin_no, over(hehnn_cat) title("PHI distribution, by number of nights in hospital") ylabel(0 "0%" 0.2 "20%" 0.4 "40%" 0.6 "60%") legend(label (1 "With PHI") label (2 "Without PHI"))
graph bar mgp_phistatus_no mgp_phistatus_hos mgp_phistatus_ex mgp_phistatus_both, over(hehnn_cat) ///
	title("PHI distribution, by number of nights in hospital") ///
	blabel(total,format(%9.2f)) ///
	ylabel(0 "0%" 20 "20%" 40 "40%" 60 "60%") ///
	legend(label (1 "Without Cover") label (2 "Hospital cover only") label (3 "Extras cover only") label (4 "Both hospital and extras cover")) ///
	note("PHI = Private Health Insurance")


* X: PHI Y: Overnight stays for most recent overnight admission to hospital *
//graph bar phpriin_yes phpriin_no, over(phrecad_cat) title("Overnight stays for most recent overnight admission to hospital Vs. PHI status", size(small)) legend(label (1 "With PHI") label (2 "Without PHI"))  note("PHI = Private Health Insurance")
graph bar mgp_phistatus_no mgp_phistatus_hos mgp_phistatus_ex mgp_phistatus_both, over(phrecad_5) ///
	title("PHI distribution, by overnight stays for most recent overnight admission to hospital", size(medsmall)) ///
	ylabel(0 "0%" 20 "20%" 40 "40%" 60 "60%") ///
	blabel(total, format(%9.2f)) ///
	legend(label (1 "Without Cover") label (2 "Hospital cover only") label (3 "Extras cover only") label (4 "Both hospital and extras cover")) ///
	note("PHI = Private Health Insurance")

////////////////////////////////////////////////////////////////////
* X: PHI Y: Hospital day patient admission type *
//graph bar phpriin_yes phpriin_no, over(phdayin) stack title("Hospital day patient admission type Vs. PHI status") legend(label (1 "With PHI") label (2 "Without PHI"))
graph bar mgp_phistatus_no mgp_phistatus_hos mgp_phistatus_ex mgp_phistatus_both, over(phdayin, label(labsize(vsmall))) ///name(phdayin_gr) 
	title("PHI distribution") ///
	subtitle("by hospital day patient admission type") ///
	blabel(total, format(%9.2f)) ///
	ylabel(0 "0%" 20 "20%" 40 "40%" 60 "60%") ///
	legend(label (1 "Without Cover") label (2 "Hospital cover only") label (3 "Extras cover only") label (4 "Both hospital and extras cover")) ///
	legend(size(vsmall)) ///
	note("PHI = Private Health Insurance") 

gr drop phdayin_gr

* X: PHI Y: Hospital overnight patient admission type *
//graph bar phpriin_yes phpriin_no, over(phonin) title("Hospital overnight patient admission type Vs. PHI status") legend(label (1 "With PHI") label (2 "Without PHI"))
graph bar mgp_phistatus_no mgp_phistatus_hos mgp_phistatus_ex mgp_phistatus_both, over(phonin, label(labsize(vsmall))) /// name(phonin_gr) 
	title("PHI distribution, by hospital overnight patient admission type") ///
	subtitle("by hospital day patient admission type") ///
	legend(label (1 "Without Cover") label (2 "Hospital cover only") label (3 "Extras cover only") label (4 "Both hospital and extras cover")) ///
	ylabel(0 "0%" 20 "20%" 40 "40%" 60 "60%" 80 "80%") ///
	blabel(total, format(%9.2f)) ///
	note("PHI = Private Health Insurance") legend(size(vsmall))

grc1leg phdayin_gr phonin_gr

gr drop phdayin_gr 
gr drop phonin_gr



* Takes prescription medication
mrgraph bar hepmart hepmast hepmcan hepmcbe hepmdi1 hepmdi2 hepmdep hepmomi hepmhd hepmhbp, sort by(phi_status) stat(row) width(20) blabel(total, format(%9.2f))

mrtab hepmart hepmast hepmcan hepmcbe hepmdi1 hepmdi2 hepmdep hepmomi hepmhd hepmhbp, by (phi_status) row width(20)


//                              //
//>>>>>>>>>>>> H3 >>>>>>>>>>>>>>//
//                              //

graph bar hxyhlpi hxyphii hxyphmi, over(phpriin) name(exp1) ///
	legend(label (1 "Fees paid to health practitioners") label (2 "Private health insurance") label (3 "Medicines, prescriptions, pharmaceuticals, alternative medicines")) 

graph bar hxyhlpi hxyphii hxyphmi, over(phctype) name(exp2) ///
	legend(label (1 "Fees paid to health practitioners") label (2 "Private health insurance") label (3 "Medicines, prescriptions, pharmaceuticals, alternative medicines")) 

grc1leg exp1 exp2, title("Average Household Annual Expenditure") subtitle("by PHI status")note("PHI = Private Health Insurance") 

gr drop exp1
gr drop exp2
//                              //
//>>>>>>>>>>>> H4 >>>>>>>>>>>>>>//
//                              //

* X: PHI Y: financial stressors *
graph bar fiprb* , over(phpriin) name(stress1) legend(label (1 "Could not pay bills on time")  label (2 "Could not pay the mortgage or rent on time") label (3 "Pawned or sold something") label (4 "Went without meals") label (5 "Was unable to heat home") label (6 "Asked for financial help from friends or family") label (7 "Asked for help from welfare/community organisations")) ylabel(0 "0" 0.05 "5%" 0.1 "10%" 0.15 "15%" 0.2 "20%")

graph bar fiprb* , over(phctype) name(stress2) legend(label (1 "Could not pay bills on time") label (2 "Could not pay the mortgage or rent on time") label (3 "Pawned or sold something") label (4 "Went without meals") label (5 "Was unable to heat home") label (6 "Asked for financial help from friends or family") label (7 "Asked for help from welfare/community organisations")) ylabel(0 "0" 0.05 "5%" 0.1 "10%" 0.15 "15%" 0.2 "20%")

grc1leg stress1 stress2, ycommon title("PHI distribution") subtitle("by Financial stress indicators") note("PHI = Private Health Insurance") 


gr drop stress1 stress2
******************************************************************
/* Table */
******************************************************************





















/* For dependent variables */
summarize i.phpriin i.phctype

/* For independet variables */
// H1 //
summarize i.phctype i.phpriin

// H2 //
summarize i.hedent i.hegpc i.hegpn_cat i.hehan_cat i.hehnn_cat i.phdayin i.phonin i.phrecad_cat // How long since last saw a dentist, DV: Sees a particular GP or clinic if sick or needs health advice, DV: Number of doctor visits (including 0), DV: Number of hospital admissions (including 0), DV: Number of nights in hospital (including 0), Hospital day patient admission type, Hospital overnight patient admission type, Overnight stays for most recent overnight admission to hospital


// H3 //
summarize hxyhlpi hxyphii hxyphmi // fees paid to GP, fees paid to PHI, fees paid to Medicines

rename hxyhlpi gpfees
rename hxyphii phifees
rename hxyphmi medfees
summarize gpfees phifees medfees

/// Self-assessed health https://rbnzmuseum.govt.nz/-/media/ReserveBank/Files/Publications/Seminars%20and%20workshops/2019/anzesg/session-2-paper-4.pdf?revision=b712acfc-3759-4754-86e9-3dee81feb8d0&la=en
///  

