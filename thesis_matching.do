****************************
*Thesis CEM
****************************
/* 
Economic Policy in Global Markets Thesis Code - matching regressions
Peter Horn - Horn_Peter@student.ceu.edu
2020.06.

*/

* Matching package used: https://gking.harvard.edu/cem 

clear
use "clean_data.dta"

//ssc install cem
drop if resp_age < 30
* Gen factors from strings
encode income_decile, gen(income_decile_factor)
encode S2, gen(edu_factor)
encode Country, gen(country_factor)
encode H3, gen(house_size_factor)
gen log_age = log(resp_age)
encode NUTS1, gen(nuts_factor)
encode H2, gen(building_age)

* Binary indep for matching
gen att_bin = 0
replace att_bin = 1 if att_2std > 0

* new bins

gen children_any = 0
replace children_any = 1 if children >= 1

gen employed = 0
replace employed = 1 if S3 ==1

gen unemployed = 0
replace unemployed = 1 if S3 == 2

gen pensioner = 0
replace pensioner = 1 if S3 == 3


* Matching on relevant variables

imb resp_age gender edu_factor income_decile_factor S3 country_factor detached children_any, treatment(att_bin)
return list
putexcel set "results/econ2/imbalance.xls", replace
putexcel B2 = ("L1 distance")
putexcel C2 = ("Mean dif.")
putexcel D2 = ("Min.")
putexcel E2 = ("25%")
putexcel F2 = ("50%")
putexcel G2 = ("75%")
putexcel H2 = ("Max")
putexcel B3 =  matrix(r(imbal))
putexcel A3 = ("Respondent's age")
putexcel A4 = ("Respondent's gender")
putexcel A5 = ("Respont's edu. level")
putexcel A6 = ("Respondent's income decile")
putexcel A7 = ("Respondent's job stat.")
putexcel A8 = ("Country")
putexcel A9 = ("Household rural/city")
putexcel A10 = ("Children in household")
putexcel A11 = ("Multivariate L1 distance")
putexcel B11 = (`r(L1)')

cem resp_age (30 40 50 60 70 80 93) gender (#0) edu_factor income_decile_factor (#0) country_factor (#0) detached (#0) children_any (#0) rural (#0), treatment(att_bin)
return list
putexcel set "results/econ2/balanced.xls", replace
putexcel B2 = ("L1 distance")
putexcel C2 = ("Mean dif.")
putexcel D2 = ("Min.")
putexcel E2 = ("25%")
putexcel F2 = ("50%")
putexcel G2 = ("75%")
putexcel H2 = ("Max")
putexcel B3 =  matrix(r(imbal))
putexcel A3 = ("Respondent's age")
putexcel A4 = ("Respondent's gender")
putexcel A5 = ("Respont's edu. level")
putexcel A6 = ("Respondent's income decile")
putexcel A7 = ("Respondent's job stat.")
putexcel A8 = ("Country")
putexcel A9 = ("Household rural/city")
putexcel A11 = ("Children in household")
putexcel A11 = ("Multivariate L1 distance")
putexcel B11 = (`r(L1)')
putexcel B12 = (`r(n_matched)')
putexcel A12 = ("N matched")

***********************
*EF_BULBS SHARE - MATCHING
***********************

**** Regs on full dataset
reg ef_bulbs i.att_bin, vce(cluster country_factor)
outreg2 using "results/econ2/matching_bulb.xls", replace dec(3) addtext(Individual Char., No, Household Char., No, Country FE., No) nonotes  adjr2 addnote(*** p<0.01 ** p<0.05 * p<0.1,Clustered standard errors in parentheses, Notes:The sample only includes individuals older than 29 years to observe potential decision maker, building characteristics, the respondents employment status and education level are controlled for but not included in the table, the base category for the interaction is France.)

reg ef_bulbs i.att_bin log_age i.gender i.education_bin i.income_decile_factor i.edu_factor i.S3 i.country_factor, vce(cluster country_factor)
outreg2 using "results/econ2/matching_bulb.xls", append dec(3) addtext(Individual Char., Yes, Household Char., No, Country FE., Yes) nonotes keep(i.att_bin log_age i.gender i.education_bin i.rural) adjr2 

reg ef_bulbs i.att_bin log_age i.gender i.education_bin i.income_decile_factor i.edu_factor i.S3 children elderly i.subsidy i.detached i.rural  i.house_size_factor i.country_factor, vce(cluster country_factor)
outreg2 using "results/econ2/matching_bulb.xls", append dec(3) addtext(Individual Char., Yes, Household Char., Yes, Country FE., Yes) nonotes keep(i.att_bin log_age i.gender i.education_bin i.rural children elderly i.subsidy i.detached) adjr2 

***  Regs on matched

reg ef_bulbs i.att_bin [iweight=cem_weights], vce(cluster country_factor)
outreg2 using "results/econ2/matching_bulb.xls", append dec(3) addtext(Individual Char., No, Household Char., No, Country FE., No) nonotes adjr2 addnote(*** p<0.01 ** p<0.05 * p<0.1,Clustered standard errors in parentheses, Notes:The sample only includes individuals older than 29 years to observe potential decision maker, building characteristics, the respondents employment status and education level are controlled for but not included in the table, the base category for the interaction is France.)

reg ef_bulbs i.att_bin log_age i.gender i.education_bin i.income_decile_factor i.edu_factor i.S3 i.country_factor [iweight=cem_weights], vce(cluster country_factor)
outreg2 using "results/econ2/matching_bulb.xls", append dec(3) addtext(Individual Char., Yes, Household Char., No, Country FE., Yes) nonotes keep(i.att_bin log_age i.gender i.education_bin i.rural i.children_any) adjr2 

reg ef_bulbs i.att_bin log_age i.gender i.education_bin i.income_decile_factor i.edu_factor i.S3 children elderly i.subsidy i.detached i.rural i.house_size_factor i.country_factor [iweight=cem_weights], vce(cluster country_factor)
outreg2 using "results/econ2/matching_bulb.xls", append dec(3) addtext(Individual Char., Yes, Household Char., Yes, Country FE., Yes) nonotes keep(i.att_bin log_age i.gender i.education_bin i.rural children elderly i.subsidy i.detached) adjr2 


*with interaction

reg ef_bulbs i.att_bin log_age i.gender i.education_bin i.income_decile_factor i.edu_factor i.S3 children elderly i.subsidy i.detached i.rural i.house_size_factor i.country_factor  i.att_bin#i.country_factor [iweight=cem_weights], vce(cluster country_factor)
outreg2 using "results/econ2/matching_bulb.xls", append dec(3) addtext(Individual Char., Yes, Household Char., Yes, Country FE., Yes) nonotes keep(i.att_bin log_age i.gender i.education_bin i.rural children elderly i.subsidy i.detached i.att_bin#i.country_factor) adjr2 


* WALD TEST FOR REGS WITH DIFFERENT CONTROLS	
******* Not working with weights

qui reg ef_bulbs i.att_bin log_age i.gender i.edu_factor i.income_decile_factor i.S3 i.country_factor i.rural i.children_any [iweight=cem_weights]
est store regcontrol

qui reg ef_bulbs i.att_bin log_age i.gender i.edu_factor i.income_decile_factor i.S3 i.country_factor i.rural i.children_any i.subsidy i.non_detached b6.house_size_factor [iweight=cem_weights]
est store regcontrolplus

** Wald test shows that coefficients are not significantly different in the two models, hence the positive attitude has the same effect 
suest regcontrol regcontrolplus, vce(cluster country_factor) 
test [regcontrol_mean]1.att_bin =[regcontrolplus_mean]1.att_bin 

***********************
*GREEN_3 - MATCHING
***********************

**** Regs on full dataset
reg green_3 i.att_bin, vce(cluster country_factor)
outreg2 using "results/econ2/green_3.xls", replace dec(3) addtext(Individual Char., No, Household Char., No, Country FE., No) nonotes  adjr2 addnote(*** p<0.01 ** p<0.05 * p<0.1,Clustered standard errors in parentheses, Notes:The sample only includes individuals older than 29 years to observe potential decision maker, building characteristics, the respondents employment status and education level are controlled for but not included in the table, the base category for the interaction is France.)

reg green_3 i.att_bin log_age i.gender i.education_bin i.income_decile_factor i.edu_factor i.S3 i.country_factor, vce(cluster country_factor)
outreg2 using "results/econ2/green_3.xls", append dec(3) addtext(Individual Char., Yes, Household Char., No, Country FE., Yes) nonotes keep(i.att_bin log_age i.gender i.education_bin i.rural i.children_any) adjr2 

reg green_3 i.att_bin log_age i.gender i.education_bin i.income_decile_factor i.edu_factor i.S3 children elderly i.subsidy i.detached i.rural  i.house_size_factor i.country_factor, vce(cluster country_factor)
outreg2 using "results/econ2/green_3.xls", append dec(3) addtext(Individual Char., Yes, Household Char., Yes, Country FE., Yes) nonotes keep(i.att_bin log_age i.gender i.education_bin i.rural children elderly i.subsidy i.detached) adjr2 

***  Regs on matched

reg green_3 i.att_bin [iweight=cem_weights], vce(cluster country_factor)
outreg2 using "results/econ2/green_3.xls", append dec(3) addtext(Individual Char., No, Household Char., No, Country FE., No) nonotes adjr2 addnote(*** p<0.01 ** p<0.05 * p<0.1,Clustered standard errors in parentheses, Notes:The sample only includes individuals older than 29 years to observe potential decision maker, building characteristics, the respondents employment status and education level are controlled for but not included in the table, the base category for the interaction is France.)

reg green_3 i.att_bin log_age i.gender i.education_bin i.income_decile_factor i.edu_factor i.S3 i.country_factor [iweight=cem_weights], vce(cluster country_factor)
outreg2 using "results/econ2/green_3.xls", append dec(3) addtext(Individual Char., Yes, Household Char., No, Country FE., Yes) nonotes keep(i.att_bin log_age i.gender i.education_bin i.rural i.children_any) adjr2 

reg green_3 i.att_bin log_age i.gender i.education_bin i.income_decile_factor i.edu_factor i.S3 children elderly i.subsidy i.detached i.rural i.house_size_factor i.country_factor [iweight=cem_weights], vce(cluster country_factor)
outreg2 using "results/econ2/green_3.xls", append dec(3) addtext(Individual Char., Yes, Household Char., Yes, Country FE., Yes) nonotes keep(i.att_bin log_age i.gender i.education_bin i.rural children elderly i.subsidy i.detached) adjr2 


*with interaction

reg green_3 i.att_bin log_age i.gender i.education_bin i.income_decile_factor i.edu_factor i.S3 children elderly i.subsidy i.detached i.rural i.house_size_factor i.country_factor  i.att_bin#i.country_factor [iweight=cem_weights], vce(cluster country_factor)
outreg2 using "results/econ2/green_3.xls", append dec(3) addtext(Individual Char., Yes, Household Char., Yes, Country FE., Yes) nonotes keep(i.att_bin log_age i.gender i.education_bin i.rural children elderly i.subsidy i.detached i.att_bin#i.country_factor) adjr2 


***********************
*GREEN_2 - MATCHING
***********************
**** Regs on full dataset
reg green_2 i.att_bin, vce(cluster country_factor)
outreg2 using "results/econ2/green_2.xls", replace dec(3) addtext(Individual Char., No, Household Char., No, Country FE., No) nonotes  adjr2 addnote(*** p<0.01 ** p<0.05 * p<0.1,Clustered standard errors in parentheses, Notes:The sample only includes individuals older than 29 years to observe potential decision maker, building characteristics, the respondents employment status and education level are controlled for but not included in the table, the base category for the interaction is France.)

reg green_2 i.att_bin log_age i.gender i.education_bin i.income_decile_factor i.edu_factor i.S3 i.country_factor, vce(cluster country_factor)
outreg2 using "results/econ2/green_2.xls", append dec(3) addtext(Individual Char., Yes, Household Char., No, Country FE., Yes) nonotes keep(i.att_bin log_age i.gender i.education_bin i.rural i.children_any) adjr2 

reg green_2 i.att_bin log_age i.gender i.education_bin i.income_decile_factor i.edu_factor i.S3 children elderly i.subsidy i.detached i.rural  i.house_size_factor i.country_factor, vce(cluster country_factor)
outreg2 using "results/econ2/green_2.xls", append dec(3) addtext(Individual Char., Yes, Household Char., Yes, Country FE., Yes) nonotes keep(i.att_bin log_age i.gender i.education_bin i.rural children elderly i.subsidy i.detached) adjr2 

***  Regs on matched

reg green_2 i.att_bin [iweight=cem_weights], vce(cluster country_factor)
outreg2 using "results/econ2/green_2.xls", append dec(3) addtext(Individual Char., No, Household Char., No, Country FE., No) nonotes adjr2 addnote(*** p<0.01 ** p<0.05 * p<0.1,Clustered standard errors in parentheses, Notes:The sample only includes individuals older than 29 years to observe potential decision maker, building characteristics, the respondents employment status and education level are controlled for but not included in the table, the base category for the interaction is France.)

reg green_2 i.att_bin log_age i.gender i.education_bin i.income_decile_factor i.edu_factor i.S3 i.country_factor [iweight=cem_weights], vce(cluster country_factor)
outreg2 using "results/econ2/green_2.xls", append dec(3) addtext(Individual Char., Yes, Household Char., No, Country FE., Yes) nonotes keep(i.att_bin log_age i.gender i.education_bin i.rural i.children_any) adjr2 

reg green_2 i.att_bin log_age i.gender i.education_bin i.income_decile_factor i.edu_factor i.S3 children elderly i.subsidy i.detached i.rural i.house_size_factor i.country_factor [iweight=cem_weights], vce(cluster country_factor)
outreg2 using "results/econ2/green_2.xls", append dec(3) addtext(Individual Char., Yes, Household Char., Yes, Country FE., Yes) nonotes keep(i.att_bin log_age i.gender i.education_bin i.rural children elderly i.subsidy i.detached) adjr2 


*with interaction

reg green_2 i.att_bin log_age i.gender i.education_bin i.income_decile_factor i.edu_factor i.S3 children elderly i.subsidy i.detached i.rural i.house_size_factor i.country_factor  i.att_bin#i.country_factor [iweight=cem_weights], vce(cluster country_factor)
outreg2 using "results/econ2/green_2.xls", append dec(3) addtext(Individual Char., Yes, Household Char., Yes, Country FE., Yes) nonotes keep(i.att_bin log_age i.gender i.education_bin i.rural children elderly i.subsidy i.detached i.att_bin#i.country_factor) adjr2 


************************
*WITH PROBIT/LOGIT
************************
*green_3
reg green_3 i.att_bin log_age i.gender i.education_bin i.income_decile_factor i.edu_factor i.S3 children elderly i.subsidy i.detached i.rural i.house_size_factor i.country_factor [iweight=cem_weights], vce(cluster country_factor)
outreg2 using "results/econ2/probit_econ2.xls", replace dec(3) addtext(Individual Char., Yes, Household Char., Yes, Country FE., Yes) nonotes keep(i.att_bin log_age i.gender i.education_bin i.rural children elderly i.subsidy i.detached) adjr2 

probit green_3 i.att_bin log_age i.gender i.income_decile_factor i.edu_factor i.S3 children elderly i.subsidy i.detached i.rural i.house_size_factor i.country_factor [iweight=cem_weights], vce(cluster country_factor)
margins, dydx(_all) post
outreg2 using "results/econ2/probit_econ2.xls", append dec(3) addtext(Individual Char., Yes, Household Char., Yes, Country FE., Yes) nonotes keep(i.att_bin log_age i.gender i.edu_factor i.rural children elderly i.subsidy i.detached) 

logit green_3 i.att_bin log_age i.gender i.income_decile_factor i.edu_factor i.S3 children elderly i.subsidy i.detached i.rural i.house_size_factor i.country_factor [iweight=cem_weights], vce(cluster country_factor)
margins, dydx(_all) post
outreg2 using "results/econ2/probit_econ2.xls", append dec(3) addtext(Individual Char., Yes, Household Char., Yes, Country FE., Yes) nonotes keep(i.att_bin log_age i.gender i.edu_factor i.rural children elderly i.subsidy i.detached) 

*green_2
reg green_2 i.att_bin log_age i.gender i.education_bin i.income_decile_factor i.edu_factor i.S3 children elderly i.subsidy i.detached i.rural i.house_size_factor i.country_factor [iweight=cem_weights], vce(cluster country_factor)
outreg2 using "results/econ2/probit_econ2.xls", append dec(3) addtext(Individual Char., Yes, Household Char., Yes, Country FE., Yes) nonotes keep(i.att_bin log_age i.gender i.education_bin i.rural children elderly i.subsidy i.detached) adjr2 

probit green_2 i.att_bin log_age i.gender i.income_decile_factor i.edu_factor i.S3 children elderly i.subsidy i.detached i.rural i.house_size_factor i.country_factor [iweight=cem_weights], vce(cluster country_factor)
margins, dydx(_all) post
outreg2 using "results/econ2/probit_econ2.xls", append dec(3) addtext(Individual Char., Yes, Household Char., Yes, Country FE., Yes) nonotes keep(i.att_bin log_age i.gender i.edu_factor i.rural children elderly i.subsidy i.detached) 

logit green_2 i.att_bin log_age i.gender i.income_decile_factor i.edu_factor i.S3 children elderly i.subsidy i.detached i.rural i.house_size_factor i.country_factor [iweight=cem_weights], vce(cluster country_factor)
margins, dydx(_all) post
outreg2 using "results/econ2/probit_econ2.xls", append dec(3) addtext(Individual Char., Yes, Household Char., Yes, Country FE., Yes) nonotes keep(i.att_bin log_age i.gender i.edu_factor i.rural children elderly i.subsidy i.detached) 



************************
*WITH NUTS FIXED EFFECTS
************************
preserve
* No NUTS1 info
drop if Country == "France" | Country == "United Kingdom" 

imb resp_age gender edu_factor income_decile_factor S3 country_factor detached children_any, treatment(att_bin)

cem resp_age (30 40 50 60 70 80 93) gender (#0) edu_factor income_decile_factor (#0) nuts_factor (#0) detached (#0) children_any (#0) rural (#0), treatment(att_bin)

*ef_bulbs
reg ef_bulbs i.att_bin log_age i.gender i.education_bin i.income_decile_factor i.edu_factor i.S3 children elderly i.subsidy i.detached i.rural i.house_size_factor i.country_factor [iweight=cem_weights], vce(cluster country_factor)
outreg2 using "results/econ2/nuts_level_econ2.xls", replace dec(3) addtext(Individual Char., Yes, Household Char., Yes, Country FE., Yes, Region FE., No) nonotes keep(i.att_bin log_age i.gender i.education_bin i.rural children elderly i.subsidy i.detached) adjr2 

reg ef_bulbs i.att_bin log_age i.gender i.education_bin i.income_decile_factor i.edu_factor i.S3 children elderly i.subsidy i.detached i.rural i.house_size_factor i.nuts_factor [iweight=cem_weights], vce(cluster nuts_factor)
outreg2 using "results/econ2/nuts_level_econ2.xls", append dec(3) addtext(Individual Char., Yes, Household Char., Yes, Country FE., No, Region FE., Yes) nonotes keep(i.att_bin log_age i.gender i.education_bin i.rural children elderly i.subsidy i.detached) adjr2 

*green_3
reg green_3 i.att_bin log_age i.gender i.education_bin i.income_decile_factor i.edu_factor i.S3 children elderly i.subsidy i.detached i.rural i.house_size_factor i.country_factor [iweight=cem_weights], vce(cluster country_factor)
outreg2 using "results/econ2/nuts_level_econ2.xls", append dec(3) addtext(Individual Char., Yes, Household Char., Yes, Country FE., Yes, Region FE., No) nonotes keep(i.att_bin log_age i.gender i.education_bin i.rural children elderly i.subsidy i.detached) adjr2 

reg green_3 i.att_bin log_age i.gender i.education_bin i.income_decile_factor i.edu_factor i.S3 children elderly i.subsidy i.detached i.rural i.house_size_factor i.nuts_factor [iweight=cem_weights], vce(cluster nuts_factor)
outreg2 using "results/econ2/nuts_level_econ2.xls", append dec(3) addtext(Individual Char., Yes, Household Char., Yes, Country FE., No, Region FE., Yes) nonotes keep(i.att_bin log_age i.gender i.education_bin i.rural children elderly i.subsidy i.detached) adjr2 

*green_2
reg green_2 i.att_bin log_age i.gender i.education_bin i.income_decile_factor i.edu_factor i.S3 children elderly i.subsidy i.detached i.rural i.house_size_factor i.country_factor [iweight=cem_weights], vce(cluster country_factor)
outreg2 using "results/econ2/nuts_level_econ2.xls", append dec(3) addtext(Individual Char., Yes, Household Char., Yes, Country FE., Yes, Region FE., No) nonotes keep(i.att_bin log_age i.gender i.education_bin i.rural children elderly i.subsidy i.detached) adjr2 

reg green_2 i.att_bin log_age i.gender i.education_bin i.income_decile_factor i.edu_factor i.S3 children elderly i.subsidy i.detached i.rural i.house_size_factor i.nuts_factor [iweight=cem_weights], vce(cluster nuts_factor)
outreg2 using "results/econ2/nuts_level_econ2.xls", append dec(3) addtext(Individual Char., Yes, Household Char., Yes, Country FE., No, Region FE., Yes) nonotes keep(i.att_bin log_age i.gender i.education_bin i.rural children elderly i.subsidy i.detached) adjr2 

restore