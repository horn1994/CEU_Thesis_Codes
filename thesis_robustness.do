/* 
Economic Policy in Global Markets Thesis Code - appendix regressions
Peter Horn - Horn_Peter@student.ceu.edu
2020.06.

Only regressions - data cleaning and visualisation in Thesis_code.ipynb file
*/

clear
use "data/main_data.dta"

//drop if resp_age < 30
* Gen factors from strings
encode income_decile, gen(income_decile_factor)
encode S2, gen(edu_factor)
encode Country, gen(country_factor)
encode H3, gen(house_size_factor)
gen log_electricity = log(electricity_cost_monthly)
gen log_heat = log(heating_cost_yearly)
gen log_age = log(resp_age)
encode NUTS1, gen(nuts_factor)
encode H2, gen(building_age)

***********
*APPENDIX
***********

*NUTS regions A1

preserve
* No NUTS1 info
drop if Country == "France" | Country == "United Kingdom" 

*ef_bulbs
reg ef_bulbs att_2std log_age i.gender i.education_bin income_decile_factor children elderly i.subsidy i.detached i.rural b2.edu_factor i.S3 b6.house_size_factor i.country_factor [pweight=w], vce(cluster country_factor)
outreg2 using "results/regs_app1.xls", replace dec(3) keep(att_2std log_age i.gender i.education_bin income_decile_factor children elderly i.subsidy i.rural i.detached) addtext(Sample weights, Yes, Individual Char., Yes, Household Char., Yes, Country FE., Yes, Region FE., No) nonotes addnote(*** p<0.01 ** p<0.05 * p<0.1, Clustered standard errors in parentheses, Sample weights are used, Sample only includes individuals older than 29 years old, the average age of household appliances renewable related subsidy house characteristics emplyment status and education levels are controlled for but not shown in table, Region FE. based on NUTS1 regions, Region FE. model does not include the UK and France)

reg ef_bulbs att_2std log_age i.gender i.education_bin income_decile_factor children elderly i.subsidy i.detached i.rural b2.edu_factor i.S3 b6.house_size_factor i.nuts_factor [pweight=w], vce(cluster country_factor)
outreg2 using "results/regs_app1.xls", append dec(3) keep(att_2std log_age i.gender i.education_bin income_decile_factor children elderly i.subsidy i.rural i.detached) addtext(Sample weights, Yes, Individual Char., Yes, Household Char., Yes, Country FE., No, Region FE., Yes) 

*green_3
reg green_3 att_2std log_age i.gender i.education_bin income_decile_factor children elderly i.subsidy i.detached i.rural i.S3 b6.house_size_factor b3.country_factor [pweight=w], vce(cluster country_factor)
outreg2 using "results/regs_app1.xls", append dec(3) keep(att_2std log_age i.gender i.education_bin income_decile_factor children elderly i.subsidy i.rural i.detached) addtext(Sample weights, Yes, Individual Char., Yes, Household Char., Yes, Country FE., Yes, Region FE., No) 

reg green_3 att_2std log_age i.gender i.education_bin income_decile_factor children elderly i.subsidy i.detached i.rural i.S3 b6.house_size_factor i.nuts_factor [pweight=w], vce(cluster country_factor)
outreg2 using "results/regs_app1.xls", append dec(3) keep(att_2std log_age i.gender i.education_bin income_decile_factor children elderly i.subsidy i.rural i.detached) addtext(Sample weights, Yes, Individual Char., Yes, Household Char., Yes, Country FE., No, Region FE., Yes) 

*green_2

reg green_2 att_2std log_age i.gender i.education_bin income_decile_factor children elderly i.subsidy i.detached i.rural i.S3 b6.house_size_factor b3.country_factor [pweight=w], vce(cluster country_factor)
outreg2 using "results/regs_app1.xls", append dec(3) keep(att_2std log_age i.gender i.education_bin income_decile_factor children elderly i.subsidy i.rural i.detached) addtext(Sample weights, Yes, Individual Char., Yes, Household Char., Yes, Country FE., Yes, Region FE., No) 

reg green_2 att_2std log_age i.gender i.education_bin income_decile_factor children elderly i.subsidy i.detached i.rural i.S3 b6.house_size_factor i.nuts_factor [pweight=w], vce(cluster country_factor)
outreg2 using "results/regs_app1.xls", append dec(3) keep(att_2std log_age i.gender i.education_bin income_decile_factor children elderly i.subsidy i.rural i.detached) addtext(Sample weights, Yes, Individual Char., Yes, Household Char., Yes, Country FE., No, Region FE., Yes) 


restore

*LOGIT/PROBIT A2

*green_3
reg green_3 att_2std log_age i.gender i.education_bin income_decile_factor children elderly i.subsidy i.detached i.rural i.S3 b6.house_size_factor b3.country_factor [pweight=w], vce(cluster country_factor)
outreg2 using "results/regs_app2.xls", replace dec(3) keep(att_2std log_age i.gender i.education_bin income_decile_factor children elderly i.subsidy i.rural i.detached) addtext(Sample weights, Yes, Individual Char., Yes, Household Char., Yes, Country FE., Yes, Region FE., No) nonotes addnote(*** p<0.01 ** p<0.05 * p<0.1, Clustered standard errors in parentheses, Sample weights are used, Sample only includes individuals older than 29 years old, the average age of household appliances renewable related subsidy house characteristics emplyment status and education levels are controlled for but not shown in table)

probit green_3 att_2std log_age i.gender i.education_bin income_decile_factor children elderly i.subsidy i.detached i.rural i.S3 b6.house_size_factor b3.country_factor [pweight=w], vce(cluster country_factor)
margins, dydx(_all) post
outreg2 using "results/regs_app2.xls", append dec(3) keep(att_2std log_age i.gender i.education_bin income_decile_factor children elderly i.subsidy i.rural i.detached) addtext(Sample weights, Yes, Individual Char., Yes, Household Char., Yes, Country FE., Yes, Region FE., No) 

logit green_3 att_2std log_age i.gender i.education_bin income_decile_factor children elderly i.subsidy i.detached i.rural i.S3 b6.house_size_factor b3.country_factor [pweight=w], vce(cluster country_factor)
margins, dydx(_all) post
outreg2 using "results/regs_app2.xls", append dec(3) keep(att_2std log_age i.gender i.education_bin income_decile_factor children elderly i.subsidy i.rural i.detached) addtext(Sample weights, Yes, Individual Char., Yes, Household Char., Yes, Country FE., Yes, Region FE., No) 

*green_2
reg green_2 att_2std log_age i.gender i.education_bin income_decile_factor children elderly i.subsidy i.detached i.rural i.S3 b6.house_size_factor b3.country_factor [pweight=w], vce(cluster country_factor)
outreg2 using "results/regs_app2.xls", append dec(3) keep(att_2std log_age i.gender i.education_bin income_decile_factor children elderly i.subsidy i.rural i.detached) addtext(Sample weights, Yes, Individual Char., Yes, Household Char., Yes, Country FE., Yes, Region FE., No)

probit green_2 att_2std log_age i.gender i.education_bin income_decile_factor children elderly i.subsidy i.detached i.rural i.S3 b6.house_size_factor b3.country_factor [pweight=w], vce(cluster country_factor)
margins, dydx(_all) post
outreg2 using "results/regs_app2.xls", append dec(3) keep(att_2std log_age i.gender i.education_bin income_decile_factor children elderly i.subsidy i.rural i.detached) addtext(Sample weights, Yes, Individual Char., Yes, Household Char., Yes, Country FE., Yes, Region FE., No) 

logit green_2 att_2std log_age i.gender i.education_bin income_decile_factor children elderly i.subsidy i.detached i.rural i.S3 b6.house_size_factor b3.country_factor [pweight=w], vce(cluster country_factor)
margins, dydx(_all) post
outreg2 using "results/regs_app2.xls", append dec(3) keep(att_2std log_age i.gender i.education_bin income_decile_factor children elderly i.subsidy i.rural i.detached) addtext(Sample weights, Yes, Individual Char., Yes, Household Char., Yes, Country FE., Yes, Region FE., No) 

*ELECTRICITY CONTROL A3

/*
preserve

drop if log_electricity == . 

reg ef_bulbs att_2std log_age i.gender i.education_bin income_decile_factor children elderly i.subsidy i.detached i.rural i.S3 b6.house_size_factor b3.country_factor [pweight=w], vce(cluster country_factor)
outreg2 using "results/regs_app3.xls", replace dec(3) keep(att_2std log_electricity log_age i.gender i.education_bin income_decile_factor children elderly i.subsidy i.rural i.detached) addtext(Sample weights, Yes, Individual Char., Yes, Household Char., Yes, Country FE., Yes) nonotes addnote(*** p<0.01 ** p<0.05 * p<0.1, Clustered standard errors in parentheses, Sample weights are used, Sample only includes individuals older than 29 years old, the average age of household appliances renewable related subsidy house characteristics emplyment status and education levels are controlled for but not shown in table)

reg ef_bulbs att_2std log_electricity log_age i.gender i.education_bin income_decile_factor children elderly i.subsidy i.detached i.rural i.S3 b6.house_size_factor b3.country_factor [pweight=w], vce(cluster country_factor)
outreg2 using "results/regs_app3.xls", append dec(3) keep(att_2std log_electricity log_age i.gender i.education_bin income_decile_factor children elderly i.subsidy i.rural i.detached) addtext(Sample weights, Yes, Individual Char., Yes, Household Char., Yes, Country FE., Yes) nonotes addnote(*** p<0.01 ** p<0.05 * p<0.1, Clustered standard errors in parentheses, Sample weights are used, Sample only includes individuals older than 29 years old, the average age of household appliances renewable related subsidy house characteristics emplyment status and education levels are controlled for but not shown in table)

reg green_3 att_2std log_age i.gender i.education_bin income_decile_factor children elderly i.subsidy i.detached i.rural i.S3 b6.house_size_factor b3.country_factor [pweight=w], vce(cluster country_factor)
outreg2 using "results/regs_app3.xls", append dec(3) keep(att_2std log_electricity log_age i.gender i.education_bin income_decile_factor children elderly i.subsidy i.rural i.detached) addtext(Sample weights, Yes, Individual Char., Yes, Household Char., Yes, Country FE., Yes) nonotes addnote(*** p<0.01 ** p<0.05 * p<0.1, Clustered standard errors in parentheses, Sample weights are used, Sample only includes individuals older than 29 years old, the average age of household appliances renewable related subsidy house characteristics emplyment status and education levels are controlled for but not shown in table)

reg green_3 att_2std log_electricity log_age i.gender i.education_bin income_decile_factor children elderly i.subsidy i.detached i.rural i.S3 b6.house_size_factor b3.country_factor [pweight=w], vce(cluster country_factor)
outreg2 using "results/regs_app3.xls", append dec(3) keep(att_2std log_electricity log_age i.gender i.education_bin income_decile_factor children elderly i.subsidy i.rural i.detached) addtext(Sample weights, Yes, Individual Char., Yes, Household Char., Yes, Country FE., Yes) nonotes addnote(*** p<0.01 ** p<0.05 * p<0.1, Clustered standard errors in parentheses, Sample weights are used, Sample only includes individuals older than 29 years old, the average age of household appliances renewable related subsidy house characteristics emplyment status and education levels are controlled for but not shown in table)

reg green_2 att_2std log_age i.gender i.education_bin income_decile_factor children elderly i.subsidy i.detached i.rural i.S3 b6.house_size_factor b3.country_factor [pweight=w], vce(cluster country_factor)
outreg2 using "results/regs_app3.xls", append dec(3) keep(att_2std log_electricity log_age i.gender i.education_bin income_decile_factor children elderly i.subsidy i.rural i.detached) addtext(Sample weights, Yes, Individual Char., Yes, Household Char., Yes, Country FE., Yes) nonotes addnote(*** p<0.01 ** p<0.05 * p<0.1, Clustered standard errors in parentheses, Sample weights are used, Sample only includes individuals older than 29 years old, the average age of household appliances renewable related subsidy house characteristics emplyment status and education levels are controlled for but not shown in table)

reg green_2 att_2std log_electricity log_age i.gender i.education_bin income_decile_factor children elderly i.subsidy i.detached i.rural i.S3 b6.house_size_factor b3.country_factor [pweight=w], vce(cluster country_factor)
outreg2 using "results/regs_app3.xls", append dec(3) keep(att_2std log_electricity log_age i.gender i.education_bin income_decile_factor children elderly i.subsidy i.rural i.detached) addtext(Sample weights, Yes, Individual Char., Yes, Household Char., Yes, Country FE., Yes) nonotes addnote(*** p<0.01 ** p<0.05 * p<0.1, Clustered standard errors in parentheses, Sample weights are used, Sample only includes individuals older than 29 years old, the average age of household appliances renewable related subsidy house characteristics emplyment status and education levels are controlled for but not shown in table)

restore
*/















