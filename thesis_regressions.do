/* 
Economic Policy in Global Markets Thesis Code - Only Regressions
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
gen children_any = 0
replace children_any = 1 if children >= 1
gen elderly_any = 0
replace elderly_any = 1 if elderly >= 1


***********************
*EF_BULBS SHARE
***********************

reg ef_bulbs att_2std [pweight=w], vce(cluster country_factor)
outreg2 using "results/regs.xls", replace dec(3) addtext(Sample weights, Yes, Individual Char., No, Household Char., No, Country FE., No, Region FE., No) nonotes addnote(*** p<0.01 ** p<0.05 * p<0.1, Clustered standard errors in parentheses, Sample weights are used, Sample only includes individuals older than 29 years old, the average age of household appliances renewable related subsidy house characteristics emplyment status and education levels are controlled for but not shown in table)

reg ef_bulbs att_2std log_age i.gender i.education_bin income_decile_factor i.edu_factor i.S3 [pweight=w], vce(cluster country_factor)
outreg2 using "results/regs.xls", append dec(3) keep(att_2std log_age i.gender i.education_bin income_decile_factor) addtext(Sample weights, Yes, Individual Char., Yes, Household Char., No, Country FE., No, Region FE., No)

reg ef_bulbs att_2std log_age i.gender i.education_bin income_decile_factor children elderly i.subsidy i.detached i.rural b2.edu_factor i.S3 b6.house_size_factor [pweight=w], vce(cluster country_factor)
outreg2 using "results/regs.xls", append dec(3) keep(att_2std log_age i.gender i.education_bin income_decile_factor children elderly i.subsidy i.rural i.detached) addtext(Sample weights, Yes, Individual Char., Yes, Household Char., Yes, Country FE., No, Region FE., No) 

reg ef_bulbs att_2std log_age i.gender i.education_bin income_decile_factor children elderly i.subsidy i.detached i.rural b2.edu_factor i.S3 b6.house_size_factor b3.country_factor [pweight=w], vce(cluster country_factor)
outreg2 using "results/regs.xls", append dec(3) keep(att_2std log_age i.gender i.education_bin income_decile_factor children elderly i.subsidy i.rural i.detached) addtext(Sample weights, Yes, Individual Char., Yes, Household Char., Yes, Country FE., Yes, Region FE., No) 

reg ef_bulbs att_2std log_age i.gender i.education_bin income_decile_factor children elderly i.subsidy i.detached i.rural b2.edu_factor i.S3 b6.house_size_factor i.country_factor c.att_2std##i.country_factor [pweight=w], vce(cluster country_factor)
outreg2 using "results/regs.xls", append dec(3) keep(att_2std log_age i.gender i.education_bin income_decile_factor children elderly i.subsidy i.rural i.detached c.att_2std##i.country_factor) addtext(Sample weights, Yes, Individual Char., Yes, Household Char., Yes, Country FE., Yes, Region FE., No) 

*The effect of the Attitude Index is the highest in Hungary, in Germany and Norway it is not significant - This is prob. due to the already high share of efficient light bulbs or earlier policy action (look into it)



***********************
*GREEN_3
***********************

reg green_3 att_2std [pweight=w], vce(cluster country_factor)
outreg2 using "results/regs2.xls", replace dec(3) addtext(Sample weights, Yes, Individual Char., No, Household Char., No, Country FE., No, Region FE., No) nonotes addnote(*** p<0.01 ** p<0.05 * p<0.1, Clustered standard errors in parentheses, Sample weights are used, Sample only includes individuals older than 29 years old, the average age of household appliances renewable related subsidy house characteristics emplyment status and education levels are controlled for but not shown in table, Region FE. based on NUTS1 regions, Region FE. model does not include the UK and France)

reg green_3 att_2std log_age i.gender i.education_bin income_decile_factor i.S3 [pweight=w], vce(cluster country_factor)
outreg2 using "results/regs2.xls", append dec(3) keep(att_2std log_age i.gender i.education_bin income_decile_factor) addtext(Sample weights, Yes, Individual Char., Yes, Household Char., No, Country FE., No, Region FE., No)

reg green_3 att_2std log_age i.gender i.education_bin income_decile_factor children elderly i.subsidy i.detached i.rural i.S3 b6.house_size_factor [pweight=w], vce(cluster country_factor)
outreg2 using "results/regs2.xls", append dec(3) keep(att_2std log_age i.gender i.education_bin income_decile_factor children elderly i.subsidy i.rural i.detached) addtext(Sample weights, Yes, Individual Char., Yes, Household Char., Yes, Country FE., No, Region FE., No) 

reg green_3 att_2std log_age i.gender i.education_bin income_decile_factor children elderly i.subsidy i.detached i.rural i.S3 b6.house_size_factor b3.country_factor [pweight=w], vce(cluster country_factor)
outreg2 using "results/regs2.xls", append dec(3) keep(att_2std log_age i.gender i.education_bin income_decile_factor children elderly i.subsidy i.rural i.detached) addtext(Sample weights, Yes, Individual Char., Yes, Household Char., Yes, Country FE., Yes, Region FE., No) 

reg green_3 att_2std log_age i.gender i.education_bin income_decile_factor children elderly i.subsidy i.detached i.rural i.S3 b6.house_size_factor i.country_factor c.att_2std##i.country_factor [pweight=w], vce(cluster country_factor)
outreg2 using "results/regs2.xls", append dec(3) keep(att_2std log_age i.gender i.education_bin income_decile_factor children elderly i.subsidy i.rural i.detached c.att_2std##i.country_factor) addtext(Sample weights, Yes, Individual Char., Yes, Household Char., Yes, Country FE., Yes, Region FE., No) 


***********************
*GREEN_2
***********************

reg green_2 att_2std [pweight=w], vce(cluster country_factor)
outreg2 using "results/regs3.xls", replace dec(3) addtext(Sample weights, Yes, Individual Char., No, Household Char., No, Country FE., No, Region FE., No) nonotes addnote(*** p<0.01 ** p<0.05 * p<0.1, Clustered standard errors in parentheses, Sample weights are used, Sample only includes individuals older than 29 years old, the average age of household appliances renewable related subsidy house characteristics emplyment status and education levels are controlled for but not shown in table, Region FE. based on NUTS1 regions, Region FE. model does not include the UK and France)

reg green_2 att_2std log_age i.gender i.education_bin income_decile_factor i.S3 [pweight=w], vce(cluster country_factor)
outreg2 using "results/regs3.xls", append dec(3) keep(att_2std log_age i.gender i.education_bin income_decile_factor) addtext(Sample weights, Yes, Individual Char., Yes, Household Char., No, Country FE., No, Region FE., No)

reg green_2 att_2std log_age i.gender i.education_bin income_decile_factor children elderly i.subsidy i.detached i.rural i.S3 b6.house_size_factor [pweight=w], vce(cluster country_factor)
outreg2 using "results/regs3.xls", append dec(3) keep(att_2std log_age i.gender i.education_bin income_decile_factor children elderly i.subsidy i.rural i.detached) addtext(Sample weights, Yes, Individual Char., Yes, Household Char., Yes, Country FE., No, Region FE., No) 

reg green_2 att_2std log_age i.gender i.education_bin income_decile_factor children elderly i.subsidy i.detached i.rural i.S3 b6.house_size_factor b3.country_factor [pweight=w], vce(cluster country_factor)
outreg2 using "results/regs3.xls", append dec(3) keep(att_2std log_age i.gender i.education_bin income_decile_factor children elderly i.subsidy i.rural i.detached) addtext(Sample weights, Yes, Individual Char., Yes, Household Char., Yes, Country FE., Yes, Region FE., No) 

reg green_2 att_2std log_age i.gender i.education_bin income_decile_factor children elderly i.subsidy i.detached i.rural i.S3 b6.house_size_factor i.country_factor c.att_2std##i.country_factor [pweight=w], vce(cluster country_factor)
outreg2 using "results/regs3.xls", append dec(3) keep(att_2std log_age i.gender i.education_bin income_decile_factor children elderly i.subsidy i.rural i.detached c.att_2std##i.country_factor) addtext(Sample weights, Yes, Individual Char., Yes, Household Char., Yes, Country FE., Yes, Region FE., No) 