clear all 
set more off
*Roggero Giulia
*16/02/2022

global datadir "C:\Users\giuli\OneDrive\Desktop\econometrics Stata panel data"

*SIMPLE PANEL DATA MODELS IN STATA



*1-difference in differences in model
*2-panel data model with first differences



use "$datadir/KIELMC.dta", clear
*house price example
*did effect of building an incinerator on hourse prices
*key in difference in differences model: interaction term: y81nrinc
describe rprice nearinc y81 y81nrinc
summarize rprice nearinc y81 y81nrinc

*summarize house prices near and far from incinerator and before and after
 
tabulate nearinc y81

tabulate nearinc y81, summarize(rprice)

*and if I only want the mean

tabulate nearinc y81, summarize(rprice) means

*generally, if a house is near the incinerator, the price goes down(before and after). generally in year 1981 house prices has increased


*question: did building of this incinerator reduces house prices?

*slow way, double regression

*regression in after period(1981)

reg rprice nearinc if year==1981
scalar b1= _b[nearinc]
display b1
*if a house is near the incinerator it will cost 3088.27 less than a house that is far from the incinerator. (in 1981)

*regression in before period(1978)
reg rprice nearinc if year==1978
scalar b2= _b[nearinc]
display b2

*if a house is near the incinerator it will cost 18824 less than a house that is far from the incinerator. (in 1978)

*difference in differences effect
display b1-b2

*so regression in after period - regression in before period.

*regression in the other way now

*regression for treated unit (near the incinerator)
reg rprice y81 if nearinc==1
scalar b3= _b[y81]
display b3

*regression for control units (far from incinerator)
reg rprice y81 if nearinc==0
scalar b4= _b[y81]
display b4

*difference in differences effect
display b3-b4

*it's obviously the same effect
*house prices for houses that are near the incinerator are 11thousands lower in the second period compared to the ones that are far from the incinerator.

*DIFFERENCE IN DIFFERENCES REGRESSION.
*include after, treated and after*treated
*treated : nearinc
*after: y81
*interaction term: y81nrinc (key component)

reg rprice nearinc y81 y81nrinc
display _b[y81nrinc]

*notice that the interaction term is not significant!(look at the p-value). so even though the interaction term show a negative effect, ithe p value is greater that point 1. even at 10 percent level.
*OVERALL: CONCLUSIONS, building the incinerator did not result in significantly lower house prices.


********panel data model with first differences************


use "$datadir/wagepan.dta",clear

*keep only two years of data

keep if year==1980 | year==1981

*generate dummy for the year and interaction term
gen d1981=0
replace d1981=1 if year==1981

*generate interaction term
gen d1981hours= d1981*hours


*generate wage from log(wage) since it's not present in the dataset


gen wage= 10^lwage

*set the data as panel data! 
*nr is the cross sectional 
*year is the time 

xtset nr year
*we have two years of data for each person
*list describe and summarize data
list nr year wage hours educ exper in 1/10
summarize nr year wage hours educ exper
describe nr year wage hours educ exper
*the summarize does not account for the fact that we have panel data! 
*so I can use:
xtdescribe
xtsum nr year wage hours educ exper


*regression model with both years(ignoring that is a datapanel set)

reg wage hours educ exper
reg wage hours 
reg wage d1981 hours

*regression model for each year
reg wage hours if year==1980

reg wage hours if year==1981

*regression model wth different intercepts and slope for both years

reg wage d1981 hours d1981hours


*best way, generate first differences************

gen dwage=d.wage
gen deduc=d.educ
gen dhours=d.hours
gen dexper=d.exper
list nr year wage hours educ exper dwage dhours deduc dexper in 1/10
*note: we have no variation for education

*panel data model with first differences
*cannot be estimated due to perfect collinearity of deduc and dexper
reg dwage deduc dexper dhours

*so we cannot estimate a model with these two variables in them, drop them.
*so the correct way is:
reg dwage dhours
scalar b5 = _b[dhours]
display b5
*note that the coefficient is significant! look at the p-value.
*if the number of hours for the same person increases by one hour then the wages for this person would decrease by 0.035191 cent.
*so dwage is not the original variable, but it's the changing wage from one period to the next. and dhours in the changing hours from one period to the next.
*another thing to notice: the Rsquare is kinda high, which is good.















































































































