clear all 
cd " "
use "Stats_proj_delhi.dta",clear
set graphics on

gen period = .
replace period = 1 if inrange(year, 1981, 1990)
replace period = 2 if inrange(year, 2016, 2025)

drop if period==.
label define p 1 "1981-1990" 2 "2016-2025"
label values period p


gen season = .

replace season = 1 if inlist(month,12,1,2)        // winter
replace season = 2 if inlist(month,3,4)           // spring
replace season = 3 if inlist(month,5,6)           // summer
replace season = 4 if inlist(month,7,8,9)         // monsoon
replace season = 5 if inlist(month,10,11)         // autumn

label define s 1 "winter" 2 "spring" 3 "summer" 4 "monsoon" 5 "autumn"
label values season s

gen rain = (preci_total > 0)
gen d_tavg = tavg[_n+1] - tavg
drop if missing(d_tavg)

ttest d_tavg if season==1, by(rain)     // winter
ttest d_tavg if season==2, by(rain)    // spring
ttest d_tavg if season==3, by(rain)   // summer
ttest d_tavg if season==4, by(rain)  // monsoon
ttest d_tavg if season==5, by(rain) // autumn

ttest d_tavg if season==1 & period==2, by(rain)		// winter
ttest d_tavg if season==2 & period==2, by(rain) 	// spring
ttest d_tavg if season==3 & period==2, by(rain)		// summer
ttest d_tavg if season==4 & period==2, by(rain) 	// monsoon
ttest d_tavg if season==5 & period==2, by(rain)		// autumn


gen d2_tavg = tavg[_n+2] - tavg
drop if missing(d2_tavg)
ttest d2_tavg if season==1 & period==2, by(rain)		// winter
ttest d2_tavg if season==2 & period==2, by(rain) 	// spring
ttest d2_tavg if season==3 & period==2, by(rain)		// summer
ttest d2_tavg if season==4 & period==2, by(rain) 	// monsoon
ttest d2_tavg if season==5 & period==2, by(rain)		// autumn


gen d_day1 = tavg[_n+1] - tavg
gen d_day2 = tavg[_n+2] - tavg[_n+1]
drop if missing(d_day2)



ttest d_day1 if season==1 & period==2, by(rain)   // winter
ttest d_day1 if season==2 & period==2, by(rain)   // spring
ttest d_day1 if season==3 & period==2, by(rain)   // summer
ttest d_day1 if season==4 & period==2, by(rain)   // monsoon
ttest d_day1 if season==5 & period==2, by(rain)   // autumn


display "===== DAY 2 EFFECT ====="

ttest d_day2 if season==1 & period==2, by(rain)   // winter
ttest d_day2 if season==2 & period==2, by(rain)   // spring
ttest d_day2 if season==3 & period==2, by(rain)   // summer
ttest d_day2 if season==4 & period==2, by(rain)   // monsoon
ttest d_day2 if season==5 & period==2, by(rain)   // autumn
