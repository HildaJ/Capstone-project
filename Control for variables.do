* Processing existed variables *
* Multiple OLS regression
drop yhat
drop ur
drop sr
drop r






** H1:


* Step 1


reg ghsf6d hgage hgsex hhstate phpriin_yes hhsad10, beta

* Step 2

graph matrix ghsf6d hgage hhstate hhsad10
scatter ghsf6d hgage
pwcorr ghsf6d hgage hgsex hhstate phpriin_yes hhsad10
pwcorr ghsf6d hgage hgsex hhstate phpriin_yes hhsad10, sig // significance level

* Step 3

estat vif // variance inflation

*evaluating assumptions: looking at constant variance assumption, possible outliers, possible non-leanrity

regress sf6d hgage sex phi_yes WithoutCover HospitalCover ExtrasCover BothCover NSW VIC QLD SA WA TAS NT ACT seifa* School Certificate Dipl Bach Married Defacto SeparatedDivorced Widowed NeverMarriedDefacto Employee Ownbusiness EmployerSelf Familyworker fa1_bill fa2_living fa3_unkown, noconstant // whether I need to use xi command, sex need to create dummy variables?

* beta verstion
reg sf6d phi_yes 
reg sf6d WithoutCover HospitalCover ExtrasCover BothCover, noconstant
reg sf6d hgage Male HospitalCover ExtrasCover BothCover // endogeinity

reg sf6d hgage age_squared Male HospitalCover ExtrasCover BothCover ///
sah_ex-sah_fair /// reference: sah_poor
VIC QLD SA WA TAS NT ACT MajorCity InnerRegion OuterRegional /// reference: NSW, Remote
seifa2-seifa10 /// seifa1
Certificate Dipl Bach /// school
Defacto SeparatedDivorced Widowed NeverMarriedDefacto /// married
Ownbusiness EmployerSelf Familyworker /// employee
fa1_bill fa2_living fa3_unkown

predict yhat // generating fitted values on Y
predict ur, resid // new variable, generating unstandardized residuals
predict sr, rstandard // generating standardized residuals
predict r, rstudent // generating studentized residuals

twoway scatter r yhat, yline(0)

* unstandardized residuals
generate squr=ur^2 // plot of squared (unstandardized) residuals against fitted values can also be used to identify potential violation of constant variance assumption	
twoway scatter squr yhat // plotting squared residuals against fitted values on Y


* studentized residuals
* Detecting extremes cases (residuals) using studentized residuals
generate absVrstu=abs(r) // using to generate absolute values of studentized residuals
sort absVrstu // sorting the abosolute vaqlue of the studentized residuals from low to high
list waveid r absVrstu // to get the entire list of absolute studentized residuals

//list waveid absVrstu in 41/50

* Step 4

* Testing normality assumption with residuals
summarize ur, detail // to obtain general descriptives, including skewness and kurtosis statisticsonresiduals
sktest ur // significance test, provides statistical tests of skewness and kurtosis, and joint normality
swilk r // significance test, best used with observations <50

* Testing normality of residuals (part B) using P-P and Q-Q plots
pnorm ur
qnorm ur

estat hettest // tests of constant variance Breush-Pagan
estat imtest // tests of cosntancevariance White's test

mvtest normality ghsf6d hgage hgsex hhstate phpriin_yes hhsad10, univariate bivariate


kdensity ur, normal

**********************************************************

* Step 5 : identifying influential cases
* Three ways: Cooksd, DF fits, DF betas

regress ghsf6d hgage hgsex hhstate phpriin_yes hhsad10
predict d, cooksd
sort d
// list waveid d in 41/50 // to get the 10 cases with the largest d values 
// criterion values (Lomax & Hahs-Vaugn)> 1 or vlues > 4/n

predict dffits, dfits
gen absVdffits=abs(dffits)


reg phistatus_no total_hinc
predict xb_group1, xb

reg phistatus_hos total_hinc
predict xb_group2, xb

reg phistatus_ex total_hinc
predict xb_group3, xb

reg phistatus_both total_hinc
predict xb_group4, xb

graph bar xb_group1 xb_group2 xb_group3 xb_group4 , over(hhstate) /// name(area_gr1)
	title("PHI distribution") ///
	subtitle("by Area") ///
	ylabel(0 "0%" 20 "20%"  40 "40%" 60 "60%") ///
	blabel(total, format(%9.2f)) ///
	legend(label (1 "Without Cover") label (2 "Hospital cover only") label (3 "Extras cover only ") label (4 "Both hospital and extras cover")) ///
	note("PHI = Private Health Insurance")
	
****
// Attention! PHI status have four waves in HILDA!
****
	
	
reg phistatus_no total_hinc hgage
predict xb_group5, xb

reg phistatus_hos total_hinc hgage
predict xb_group6, xb

reg phistatus_ex total_hinc hgage
predict xb_group7, xb

reg phistatus_both total_hinc hgage
predict xb_group8, xb
	
graph bar xb_group5 xb_group6 xb_group7 xb_group8 , over(marital_status, label(labsize(vsmall))) /// name(edu_gr1) ///
	blabel(total, format(%9.2f)) ///
	ylabel(0 "0%" 20 "20%" 40 "40%" 60 "60%") ///
	title("PHI distribution, by Marital status") ///
	legend(label (1 "Without Cover") label (2 "Hospital cover only") label (3 "Extras cover only ") label (4 "Both hospital and extras cover")) ///
	note("PHI = Private Health Insurance")
	


	
	
	**************************************
*	Testing
replace cccinhh=. if cccinhh < 0
replace cccinhh = 0 if cccinhh == 2
label value cccinhh isbinary

graph bar phistatus_no phistatus_hos phistatus_ex phistatus_both, over(r_havechild25) /// name(age_gr) ///
	title("PHI distribution, by having children aged<=14 ") ///
	ylabel(0 "0%" 20 "20%"  40 "40%" 60 "60%") blabel(total,format(%9.2f) size(vsmall)) ///
	legend(label (1 "Without Cover") label (2 "Hospital cover only") label (3 "Extras cover only ") label (4 "Both hospital and extras cover"))  ///
	note("PHI = Private Health Insurance") // Each PHI type distribution by age group	