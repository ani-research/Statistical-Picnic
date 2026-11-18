************************************************************
* LOAD PREPARED DATA
************************************************************
clear all
cd "C:\Users\khosl\OneDrive\Desktop\SF\Stat proj\Devv"
use "shimla_prepared.dta", clear

tsset date
set graphics on
set more off

************************************************************
*EMPIRICAL DISTRIBUTION
************************************************************
preserve
    keep if !missing(spell_len)

    gen k = spell_len
    replace k = 20 if k >= 20   // tail grouping

    contract k season era, freq(freq)

    bysort season era: egen total = total(freq)
    gen emp = freq / total

    save "emp_all.dta", replace
restore

************************************************************
*ESTIMATE p = P(rain | yesterday dry)
************************************************************
preserve
    gen dry_lag1 = L1.dry
    keep if dry_lag1 == 1

    collapse (mean) p = rain, by(season era)
    save "p_by_season_era.dta", replace
restore

************************************************************
*THEORETICAL GEOMETRIC PMF (WITH MATCHING TAIL)
************************************************************
clear
set obs 21
gen k = _n - 1   // k = 0,...,20

tempfile grid
save `grid', replace

use "p_by_season_era.dta", clear
cross using `grid'

gen pmf = p * (1 - p)^k

* tail adjustment: P(X ≥ 20)
replace pmf = (1 - p)^20 if k == 20

bysort season era k: keep if _n == 1

save "theo_all.dta", replace

************************************************************
*MERGE
************************************************************
use "emp_all.dta", clear
merge 1:1 season era k using "theo_all.dta", nogen

bysort season era k: keep if _n == 1

************************************************************
*CHI-SQUARE GOODNESS OF FIT
************************************************************
preserve
	drop if missing(era)
    bysort season era: egen N = total(freq)

    gen expected = pmf * total
    drop if expected == 0

    gen chi_comp = (freq - expected)^2 / expected

    collapse (sum) chi_sq = chi_comp ///
             (count) categories = k, by(season era)

    * df = bins - 1 - parameters estimated (p)
    gen df = categories - 1 - 1

    gen p_value = chi2tail(df, chi_sq)

    format chi_sq %9.2f
    format p_value %9.4f

    display "======================================"
    display "Chi-square Goodness-of-Fit Results"
    display "======================================"
    list season era chi_sq df p_value, sepby(season)

restore

************************************************************
* LOAD PREPARED DATA
************************************************************
clear all
cd "C:\Users\khosl\OneDrive\Desktop\SF\Stat proj\Devv"
use "shimla_prepared.dta", clear

tsset date
set graphics on
set more off

************************************************************
*EMPIRICAL (GRAPH VERSION - NO TAIL GROUPING)
************************************************************
preserve
    keep if !missing(spell_len)

    gen k = spell_len
    contract k season era, freq(freq)

    bysort season era: egen total = total(freq)
    gen emp = freq / total

    save "emp_graph.dta", replace
restore

************************************************************
*EMPIRICAL (CHI-SQUARE VERSION - TAIL GROUPED)
************************************************************
preserve
    keep if !missing(spell_len)

    gen k = spell_len
    replace k = 20 if k >= 20

    contract k season era, freq(freq)

    save "emp_chi.dta", replace
restore

************************************************************
*ESTIMATE p = P(rain | yesterday dry)
************************************************************
preserve
    gen dry_lag1 = L1.dry
    keep if dry_lag1 == 1

    collapse (mean) p = rain, by(season era)
    save "p_by_season_era.dta", replace
restore

************************************************************
*PMF (GRAPH VERSION - NO GROUPING)
************************************************************
clear
set obs 40
gen k = _n - 1

tempfile grid1
save `grid1', replace

use "p_by_season_era.dta", clear
cross using `grid1'

gen pmf = p * (1 - p)^k
bysort season era k: keep if _n == 1

save "theo_graph.dta", replace

************************************************************
*(Grouping for Chi)
************************************************************
clear
set obs 21
gen k = _n - 1

tempfile grid2
save `grid2', replace

use "p_by_season_era.dta", clear
cross using `grid2'

gen pmf = p * (1 - p)^k
replace pmf = (1 - p)^20 if k == 20   // tail prob

bysort season era k: keep if _n == 1

save "theo_chi.dta", replace

************************************************************
*MERGE FOR GRAPHS
************************************************************
use "emp_graph.dta", clear
merge 1:1 season era k using "theo_graph.dta", nogen

drop if missing(era)
bysort season era k: keep if _n == 1

tempfile graphdata
save `graphdata'

************************************************************
*CHI-SQUARE TEST (USES GROUPED DATA)
************************************************************
preserve
    use "emp_chi.dta", clear
    merge 1:1 season era k using "theo_chi.dta", nogen

    drop if missing(era)

    bysort season era: egen N = total(freq)

    gen expected = pmf * N
    drop if expected == 0

    gen chi_comp = (freq - expected)^2 / expected

    collapse (sum) chi_sq = chi_comp ///
             (count) categories = k, by(season era)

    gen df = categories - 1 - 1
    gen p_value = chi2tail(df, chi_sq)

    display "======================================"
    display "Chi-square Goodness-of-Fit Results"
    display "======================================"
    list season era chi_sq df p_value, sepby(season)
restore

************************************************************
*LABELS
************************************************************
capture label define s 1 "winter" 2 "spring" 3 "summer" 4 "monsoon" 5 "autumn"
capture label values season s

capture label define era_lbl 1 "1981-1990" 2 "2016-2025"
capture label values era era_lbl

************************************************************
*GRAPH 
************************************************************
use `graphdata', clear

levelsof season, local(seasons)

foreach s of local seasons {

    twoway ///
    (bar emp k if season==`s' & era==1 & k<=20, ///
        barwidth(0.8) color(blue%40)) ///
    (line pmf k if season==`s' & era==1 & k<=20, ///
        sort lcolor(blue) lwidth(medthick)) ///
    (bar emp k if season==`s' & era==2 & k<=20, ///
        barwidth(0.5) color(red%40)) ///
    (line pmf k if season==`s' & era==2 & k<=20, ///
        sort lcolor(red) lwidth(medthick)), ///
    title("Season `s': Dry Spells") ///
    xtitle("Dry days before rain") ///
    ytitle("Probability") ///
    legend(order(1 "Observed Old" 2 "Fitted Old" ///
                 3 "Observed New" 4 "Fitted New")) ///
    name(g`s', replace)

    graph export "geom_season_`s'.png", replace
}

************************************************************
* DONE
************************************************************