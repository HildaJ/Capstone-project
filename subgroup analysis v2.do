* BIG TABLE for subgroup analysis

* RE model variables - for subgroup analysis by gender

* RE model variables - subgroup - age
global xvars_age Male ///
VIC QLD SA WA TAS NT ACT MajorCity InnerRegion OuterRegional /// reference: NSW, Remote
seifa2 seifa3 seifa4 seifa5 seifa6 seifa7 seifa8 seifa9 seifa10 /// Lowest decile
Lowincome Mediumincome Highincome Vhighincome /// Vlowincome
Certificate Dipl Bach edu_missing /// school
Defacto SeparatedDivorced Widowed NeverMarriedDefacto marital_missing /// married
EmployerSelf employment_missing /// employee
wave13 wave17

* FE model variables - subgroup - age
global xvars_fe_age ///
Lowincome Mediumincome Highincome Vhighincome /// Vlowincome
Defacto SeparatedDivorced Widowed NeverMarriedDefacto marital_missing /// married
Certificate Dipl Bach edu_missing ///
EmployerSelf employment_missing
*****************************************************************************************
* RE model variables - subgroup - gender
global xvars_gender hgage age_squared ///
VIC QLD SA WA TAS NT ACT MajorCity InnerRegion OuterRegional /// reference: NSW, Remote
seifa2 seifa3 seifa4 seifa5 seifa6 seifa7 seifa8 seifa9 seifa10 /// Lowest decile
Lowincome Mediumincome Highincome Vhighincome /// Vlowincome
Certificate Dipl Bach edu_missing /// school
Defacto SeparatedDivorced Widowed NeverMarriedDefacto marital_missing /// married
EmployerSelf employment_missing /// employee
wave13 wave17
*****************************************************************************************


* SF-6D

********************************SUBGROUP ANALYSI FOR AGE**************************************

xtreg sf6d HospitalCover ExtrasCover BothCover secondary_care interaction_hos interaction_ex interaction_both  expenditure_annual $xvars_age if hgage < 65, re i(waveid) vce(robust)
outreg2 using table2-sub.doc,dec (3) ctitle(RE model) label addstat("rho",e(rho)) replace 

xtreg sf6d HospitalCover ExtrasCover BothCover secondary_care interaction_hos interaction_ex interaction_both expenditure_annual $xvars_fe_age if hgage < 65, fe i(waveid) vce(robust)
outreg2 using table2-sub.doc,dec (3) ctitle(FE model) label addstat("rho",e(rho)) append 

xtreg sf6d HospitalCover ExtrasCover BothCover secondary_care interaction_hos interaction_ex interaction_both expenditure_annual $xvars_age if hgage >= 65 & hgage <. , re i(waveid) vce(robust)
outreg2 using table2-sub.doc,dec (3) ctitle(RE model) label addstat("rho",e(rho)) append

xtreg sf6d HospitalCover ExtrasCover BothCover secondary_care interaction_hos interaction_ex interaction_both expenditure_annual $xvars_fe_age if hgage >= 65 & hgage <. , fe i(waveid) vce(robust)
outreg2 using table2-sub.doc,dec (3) ctitle(FE model) label addstat("rho",e(rho)) append 

********************************SUBGROUP ANALYSI FOR GENDER**************************************
xtreg sf6d HospitalCover ExtrasCover BothCover secondary_care interaction_hos interaction_ex interaction_both expenditure_annual $xvars_gender if Male == 0, re i(waveid) vce(robust)
outreg2 using table2-sub.doc,dec (3) ctitle(RE model) label addstat("rho",e(rho)) append

xtreg sf6d HospitalCover ExtrasCover BothCover secondary_care interaction_hos interaction_ex interaction_both expenditure_annual $xvars_fe if Male == 0, fe i(waveid) vce(robust)
outreg2 using table2-sub.doc,dec (3) ctitle(FE model) label addstat("rho",e(rho)) append 

xtreg sf6d HospitalCover ExtrasCover BothCover secondary_care interaction_hos interaction_ex interaction_both expenditure_annual $xvars_gender if Male == 1, re i(waveid) vce(robust)
outreg2 using table2-sub.doc,dec (3) ctitle(RE model) label addstat("rho",e(rho)) append

xtreg sf6d HospitalCover ExtrasCover BothCover secondary_care interaction_hos interaction_ex interaction_both expenditure_annual $xvars_fe if Male == 1, fe i(waveid) vce(robust)
outreg2 using table2-sub.doc,dec (3) ctitle(FE model) label addstat("rho",e(rho)) append 


********************************SUBGROUP ANALYSI FOR IMMIGRANT**************************************

xtreg sf6d HospitalCover ExtrasCover BothCover secondary_care interaction_hos interaction_ex interaction_both expenditure_annual $xvars if immigrant == 0, re i(waveid) vce(robust)
outreg2 using table2-sub.doc,dec (3) ctitle(RE model) label addstat("rho",e(rho)) append 

xtreg sf6d HospitalCover ExtrasCover BothCover secondary_care interaction_hos interaction_ex interaction_both expenditure_annual $xvars_fe if immigrant == 0, fe i(waveid) vce(robust)
outreg2 using table2-sub.doc,dec (3) ctitle(FE model) label addstat("rho",e(rho)) append 

xtreg sf6d HospitalCover ExtrasCover BothCover secondary_care interaction_hos interaction_ex interaction_both expenditure_annual $xvars if immigrant == 1, re i(waveid) vce(robust)
outreg2 using table2-sub.doc,dec (3) ctitle(RE model) label addstat("rho",e(rho)) append

xtreg sf6d HospitalCover ExtrasCover BothCover secondary_care interaction_hos interaction_ex interaction_both expenditure_annual $xvars_fe if immigrant == 1, fe i(waveid) vce(robust)
outreg2 using table2-sub.doc,dec (3) ctitle(FE model) label addstat("rho",e(rho)) append 







* OOP expenditure

********************************SUBGROUP ANALYSI FOR AGE**************************************

xtreg oop HospitalCover ExtrasCover BothCover secondary_care interaction_hos interaction_ex interaction_both expenditure_annual $xvars_age if hgage < 65, re i(waveid) vce(robust)
outreg2 using table6-sub.doc,dec (3) ctitle(RE model) label addstat("rho",e(rho)) replace 

xtreg oop HospitalCover ExtrasCover BothCover secondary_care interaction_hos interaction_ex interaction_both expenditure_annual $xvars_fe_age if hgage < 65, fe i(waveid) vce(robust)
outreg2 using table6-sub.doc,dec (3) ctitle(FE model) label addstat("rho",e(rho)) append 

xtreg oop HospitalCover ExtrasCover BothCover secondary_care interaction_hos interaction_ex interaction_both expenditure_annual $xvars_age if hgage >= 65 & hgage <. , re i(waveid) vce(robust)
outreg2 using table6-sub.doc,dec (3) ctitle(RE model) label addstat("rho",e(rho)) append

xtreg oop HospitalCover ExtrasCover BothCover secondary_care interaction_hos interaction_ex interaction_both expenditure_annual $xvars_fe_age if hgage >= 65 & hgage <. , fe i(waveid) vce(robust)
outreg2 using table6-sub.doc,dec (3) ctitle(FE model) label addstat("rho",e(rho)) append 

********************************SUBGROUP ANALYSI FOR GENDER**************************************
xtreg oop HospitalCover ExtrasCover BothCover secondary_care interaction_hos interaction_ex interaction_both expenditure_annual $xvars_gender if Male == 0, re i(waveid) vce(robust)
outreg2 using table6-sub.doc,dec (3) ctitle(RE model) label addstat("rho",e(rho)) append

xtreg oop HospitalCover ExtrasCover BothCover secondary_care interaction_hos interaction_ex interaction_both expenditure_annual $xvars_fe if Male == 0, fe i(waveid) vce(robust)
outreg2 using table6-sub.doc,dec (3) ctitle(FE model) label addstat("rho",e(rho)) append 

xtreg oop HospitalCover ExtrasCover BothCover secondary_care interaction_hos interaction_ex interaction_both expenditure_annual $xvars_gender if Male == 1, re i(waveid) vce(robust)
outreg2 using table6-sub.doc,dec (3) ctitle(RE model) label addstat("rho",e(rho)) append

xtreg oop HospitalCover ExtrasCover BothCover secondary_care interaction_hos interaction_ex interaction_both expenditure_annual $xvars_fe if Male == 1, fe i(waveid) vce(robust)
outreg2 using table6-sub.doc,dec (3) ctitle(FE model) label addstat("rho",e(rho)) append 


********************************SUBGROUP ANALYSI FOR IMMIGRANT**************************************

xtreg oop HospitalCover ExtrasCover BothCover secondary_care interaction_hos interaction_ex interaction_both expenditure_annual $xvars if immigrant == 0, re i(waveid) vce(robust)
outreg2 using table6-sub.doc,dec (3) ctitle(RE model) label addstat("rho",e(rho)) append 

xtreg oop HospitalCover ExtrasCover BothCover secondary_care interaction_hos interaction_ex interaction_both expenditure_annual $xvars_fe if immigrant == 0, fe i(waveid) vce(robust)
outreg2 using table6-sub.doc,dec (3) ctitle(FE model) label addstat("rho",e(rho)) append 

xtreg oop HospitalCover ExtrasCover BothCover secondary_care interaction_hos interaction_ex interaction_both expenditure_annual $xvars if immigrant == 1, re i(waveid) vce(robust)
outreg2 using table6-sub.doc,dec (3) ctitle(RE model) label addstat("rho",e(rho)) append

xtreg oop HospitalCover ExtrasCover BothCover secondary_care interaction_hos interaction_ex interaction_both expenditure_annual $xvars_fe if immigrant == 1, fe i(waveid) vce(robust)
outreg2 using table6-sub.doc,dec (3) ctitle(FE model) label addstat("rho",e(rho)) append 









* Factor 1

********************************SUBGROUP ANALYSI FOR AGE**************************************

xtreg fa1_bill HospitalCover ExtrasCover BothCover secondary_care interaction_hos interaction_ex interaction_both expenditure_annual $xvars_age if hgage < 65, re i(waveid) vce(robust)
outreg2 using table7-sub.doc,dec (3) ctitle(RE model) label addstat("rho",e(rho)) replace 

xtreg fa1_bill HospitalCover ExtrasCover BothCover secondary_care interaction_hos interaction_ex interaction_both expenditure_annual $xvars_fe_age if hgage < 65, fe i(waveid) vce(robust)
outreg2 using table7-sub.doc,dec (3) ctitle(FE model) label addstat("rho",e(rho)) append 

xtreg fa1_bill HospitalCover ExtrasCover BothCover secondary_care interaction_hos interaction_ex interaction_both expenditure_annual $xvars_age if hgage >= 65 & hgage <. , re i(waveid) vce(robust)
outreg2 using table7-sub.doc,dec (3) ctitle(RE model) label addstat("rho",e(rho)) append

xtreg fa1_bill HospitalCover ExtrasCover BothCover secondary_care interaction_hos interaction_ex interaction_both expenditure_annual $xvars_fe_age if hgage >= 65 & hgage <. , fe i(waveid) vce(robust)
outreg2 using table7-sub.doc,dec (3) ctitle(FE model) label addstat("rho",e(rho)) append 

********************************SUBGROUP ANALYSI FOR GENDER**************************************
xtreg fa1_bill HospitalCover ExtrasCover BothCover secondary_care interaction_hos interaction_ex interaction_both expenditure_annual $xvars_gender if Male == 0, re i(waveid) vce(robust)
outreg2 using table7-sub.doc,dec (3) ctitle(RE model) label addstat("rho",e(rho)) append

xtreg fa1_bill HospitalCover ExtrasCover BothCover secondary_care interaction_hos interaction_ex interaction_both expenditure_annual $xvars_fe if Male == 0, fe i(waveid) vce(robust)
outreg2 using table7-sub.doc,dec (3) ctitle(FE model) label addstat("rho",e(rho)) append 

xtreg fa1_bill HospitalCover ExtrasCover BothCover secondary_care interaction_hos interaction_ex interaction_both expenditure_annual $xvars_gender if Male == 1, re i(waveid) vce(robust)
outreg2 using table7-sub.doc,dec (3) ctitle(RE model) label addstat("rho",e(rho)) append

xtreg fa1_bill HospitalCover ExtrasCover BothCover secondary_care interaction_hos interaction_ex interaction_both expenditure_annual $xvars_fe if Male == 1, fe i(waveid) vce(robust)
outreg2 using table7-sub.doc,dec (3) ctitle(FE model) label addstat("rho",e(rho)) append 


********************************SUBGROUP ANALYSI FOR IMMIGRANT**************************************

xtreg fa1_bill HospitalCover ExtrasCover BothCover secondary_care interaction_hos interaction_ex interaction_both expenditure_annual $xvars if immigrant == 0, re i(waveid) vce(robust)
outreg2 using table7-sub.doc,dec (3) ctitle(RE model) label addstat("rho",e(rho)) append 

xtreg fa1_bill HospitalCover ExtrasCover BothCover secondary_care interaction_hos interaction_ex interaction_both expenditure_annual $xvars_fe if immigrant == 0, fe i(waveid) vce(robust)
outreg2 using table7-sub.doc,dec (3) ctitle(FE model) label addstat("rho",e(rho)) append 

xtreg fa1_bill HospitalCover ExtrasCover BothCover secondary_care interaction_hos interaction_ex interaction_both expenditure_annual $xvars if immigrant == 1, re i(waveid) vce(robust)
outreg2 using table7-sub.doc,dec (3) ctitle(RE model) label addstat("rho",e(rho)) append

xtreg fa1_bill HospitalCover ExtrasCover BothCover secondary_care interaction_hos interaction_ex interaction_both expenditure_annual $xvars_fe if immigrant == 1, fe i(waveid) vce(robust)
outreg2 using table7-sub.doc,dec (3) ctitle(FE model) label addstat("rho",e(rho)) append 


* Factor 2


********************************SUBGROUP ANALYSI FOR AGE**************************************

xtreg fa2_living HospitalCover ExtrasCover BothCover secondary_care interaction_hos interaction_ex interaction_both expenditure_annual $xvars_age if hgage < 65, re i(waveid) vce(robust)
outreg2 using table8-sub.doc,dec (3) ctitle(RE model) label addstat("rho",e(rho)) replace 

xtreg fa2_living HospitalCover ExtrasCover BothCover secondary_care interaction_hos interaction_ex interaction_both expenditure_annual $xvars_fe_age if hgage < 65, fe i(waveid) vce(robust)
outreg2 using table8-sub.doc,dec (3) ctitle(FE model) label addstat("rho",e(rho)) append 

xtreg fa2_living HospitalCover ExtrasCover BothCover secondary_care interaction_hos interaction_ex interaction_both expenditure_annual $xvars_age if hgage >= 65 & hgage <. , re i(waveid) vce(robust)
outreg2 using table8-sub.doc,dec (3) ctitle(RE model) label addstat("rho",e(rho)) append

xtreg fa2_living HospitalCover ExtrasCover BothCover secondary_care interaction_hos interaction_ex interaction_both expenditure_annual $xvars_fe_age if hgage >= 65 & hgage <. , fe i(waveid) vce(robust)
outreg2 using table8-sub.doc,dec (3) ctitle(FE model) label addstat("rho",e(rho)) append 

********************************SUBGROUP ANALYSI FOR GENDER**************************************
xtreg fa2_living HospitalCover ExtrasCover BothCover secondary_care interaction_hos interaction_ex interaction_both expenditure_annual $xvars_gender if Male == 0, re i(waveid) vce(robust)
outreg2 using table8-sub.doc,dec (3) ctitle(RE model) label addstat("rho",e(rho)) append

xtreg fa2_living HospitalCover ExtrasCover BothCover secondary_care interaction_hos interaction_ex interaction_both expenditure_annual $xvars_fe if Male == 0, fe i(waveid) vce(robust)
outreg2 using table8-sub.doc,dec (3) ctitle(FE model) label addstat("rho",e(rho)) append 

xtreg fa2_living HospitalCover ExtrasCover BothCover secondary_care interaction_hos interaction_ex interaction_both expenditure_annual $xvars_gender if Male == 1, re i(waveid) vce(robust)
outreg2 using table8-sub.doc,dec (3) ctitle(RE model) label addstat("rho",e(rho)) append

xtreg fa2_living HospitalCover ExtrasCover BothCover secondary_care interaction_hos interaction_ex interaction_both expenditure_annual $xvars_fe if Male == 1, fe i(waveid) vce(robust)
outreg2 using table8-sub.doc,dec (3) ctitle(FE model) label addstat("rho",e(rho)) append 


********************************SUBGROUP ANALYSI FOR IMMIGRANT**************************************

xtreg fa2_living HospitalCover ExtrasCover BothCover secondary_care interaction_hos interaction_ex interaction_both expenditure_annual $xvars if immigrant == 0, re i(waveid) vce(robust)
outreg2 using table8-sub.doc,dec (3) ctitle(RE model) label addstat("rho",e(rho)) append 

xtreg fa2_living HospitalCover ExtrasCover BothCover secondary_care interaction_hos interaction_ex interaction_both expenditure_annual $xvars_fe if immigrant == 0, fe i(waveid) vce(robust)
outreg2 using table8-sub.doc,dec (3) ctitle(FE model) label addstat("rho",e(rho)) append 

xtreg fa2_living HospitalCover ExtrasCover BothCover secondary_care interaction_hos interaction_ex interaction_both expenditure_annual $xvars if immigrant == 1, re i(waveid) vce(robust)
outreg2 using table8-sub.doc,dec (3) ctitle(RE model) label addstat("rho",e(rho)) append

xtreg fa2_living HospitalCover ExtrasCover BothCover secondary_care interaction_hos interaction_ex interaction_both expenditure_annual $xvars_fe if immigrant == 1, fe i(waveid) vce(robust)
outreg2 using table8-sub.doc,dec (3) ctitle(FE model) label addstat("rho",e(rho)) append 








