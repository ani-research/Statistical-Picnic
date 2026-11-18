clear all 
cd " "
use "Stats_proj_shimla.dta",clear
set graphics on

*Period
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






* Tmin: period 1 (1981–1990)
histogram tmin if season==1 & period==1, normal bin(30) ///
    xscale(range(0 30)) name(tminW_old, replace)

histogram tmin if season==2 & period==1, normal bin(30) ///
    xscale(range(0 30)) name(tminSP_old, replace)

histogram tmin if season==3 & period==1, normal bin(30) ///
    xscale(range(0 30)) name(tminSU_old, replace)

histogram tmin if season==4 & period==1, normal bin(30) ///
    xscale(range(0 30)) name(tminMON_old, replace)

histogram tmin if season==5 & period==1, normal bin(30) ///
    xscale(range(0 30)) name(tminAUT_old, replace)

	
* Tmin: period 2 (2016–2025)
histogram tmin if season==1 & period==2, normal bin(30) ///
    xscale(range(0 30)) name(tminW_new, replace)

histogram tmin if season==2 & period==2, normal bin(30) ///
    xscale(range(0 30)) name(tminSP_new, replace)

histogram tmin if season==3 & period==2, normal bin(30) ///
    xscale(range(0 30)) name(tminSU_new, replace)

histogram tmin if season==4 & period==2, normal bin(30) ///
    xscale(range(0 30)) name(tminMON_new, replace)

histogram tmin if season==5 & period==2, normal bin(30) ///
    xscale(range(0 30)) name(tminAUT_new, replace)
	
* Tmax: period 1
histogram tmax if season==1 & period==1, normal bin(30) ///
    xscale(range(10 45)) name(tmaxW_old, replace)

histogram tmax if season==2 & period==1, normal bin(30) ///
    xscale(range(10 45)) name(tmaxSP_old, replace)

histogram tmax if season==3 & period==1, normal bin(30) ///
    xscale(range(10 45)) name(tmaxSU_old, replace)

histogram tmax if season==4 & period==1, normal bin(30) ///
    xscale(range(10 45)) name(tmaxMON_old, replace)

histogram tmax if season==5 & period==1, normal bin(30) ///
    xscale(range(10 45)) name(tmaxAUT_old, replace)

* Tmax: period 2
histogram tmax if season==1 & period==2, normal bin(30) ///
    xscale(range(10 45)) name(tmaxW_new, replace)

histogram tmax if season==2 & period==2, normal bin(30) ///
    xscale(range(10 45)) name(tmaxSP_new, replace)

histogram tmax if season==3 & period==2, normal bin(30) ///
    xscale(range(10 45)) name(tmaxSU_new, replace)

histogram tmax if season==4 & period==2, normal bin(30) ///
    xscale(range(10 45)) name(tmaxMON_new, replace)

histogram tmax if season==5 & period==2, normal bin(30) ///
    xscale(range(10 45)) name(tmaxAUT_new, replace)
	
graph combine ///
    tminW_old tminW_new ///
    tminSP_old tminSP_new ///
    tminSU_old tminSU_new ///
    tminMON_old tminMON_new ///
    tminAUT_old tminAUT_new, /// 
	col(2) name(g_tmin, replace)
graph combine ///
    tmaxW_old tmaxW_new ///
    tmaxSP_old tmaxSP_new ///
    tmaxSU_old tmaxSU_new ///
    tmaxMON_old tmaxMON_new ///
    tmaxAUT_old tmaxAUT_new, /// 
	col(2) name(g_tmax, replace)

table season period, statistic(mean tmax) statistic(sd tmax) ///
                     statistic(mean tmin) statistic(sd tmin)
	

*Tavg: period 1 (1981–1990)
histogram tavg if season==1 & period==1, normal bin(30) ///
    xscale(range(0 30)) name(tavgW_old, replace)

histogram tavg if season==2 & period==1, normal bin(30) ///
    xscale(range(0 30)) name(tavgSP_old, replace)

histogram tavg if season==3 & period==1, normal bin(30) ///
    xscale(range(0 30)) name(tavgSU_old, replace)

histogram tavg if season==4 & period==1, normal bin(30) ///
    xscale(range(0 30)) name(tavgMON_old, replace)

histogram tavg if season==5 & period==1, normal bin(30) ///
    xscale(range(0 30)) name(tavgAUT_old, replace)

*Tavg: period 2 (2016-2025)
histogram tavg if season==1 & period==2, normal bin(30) ///
    xscale(range(0 30)) name(tavgW_new, replace)

histogram tavg if season==2 & period==2, normal bin(30) ///
    xscale(range(0 30)) name(tavgSP_new, replace)

histogram tavg if season==3 & period==2, normal bin(30) ///
    xscale(range(0 30)) name(tavgSU_new, replace)

histogram tavg if season==4 & period==2, normal bin(30) ///
    xscale(range(0 30)) name(tavgMON_new, replace)

histogram tavg if season==5 & period==2, normal bin(30) ///
    xscale(range(0 30)) name(tavgAUT_new, replace)
	
graph combine ///
    tavgW_old tavgW_new ///
    tavgSP_old tavgSP_new ///
    tavgSU_old tavgSU_new ///
    tavgMON_old tavgMON_new ///
    tavgAUT_old tavgAUT_new, /// 
	col(2) name(g_tavg, replace)
	
table season period, statistic(mean tavg) statistic(sd tavg)
table season period, stat(mean dtr)




**# PROBABILITY


	
* 10<P<20 for Tavg
statsby mu=r(mean) sd=r(sd), by(season period) clear: ///
    summarize tavg
gen p_10_20 = normal((20 - mu)/sd) - normal((10 - mu)/sd)
list season period mu sd p_10_20, sepby(season)

* 10<P<20 for Tmin Tmax
preserve

* --- tmin stats ---
statsby mu_min=r(mean) sd_min=r(sd), by(season period) clear: ///
    summarize tmin

tempfile tminstats
save `tminstats'

restore
preserve

* --- tmax stats ---
statsby mu_max=r(mean) sd_max=r(sd), by(season period) clear: ///
    summarize tmax

* --- merge ---
merge 1:1 season period using `tminstats', nogen

* --- probabilities ---
gen p_min = normal((20 - mu_min)/sd_min) - normal((10 - mu_min)/sd_min)
gen p_max = normal((20 - mu_max)/sd_max) - normal((10 - mu_max)/sd_max)
gen p_joint = p_min * p_max

list season period mu_min sd_min mu_max sd_max p_min p_max p_joint, sepby(season)

restore

**# sHAPIRO WILKS

clear all 
cd "C:\Users\khosl\Downloads\Stat proj"
use "Stats_proj_shimla.dta", clear
set graphics on

* Period
gen period = .
replace period = 1 if inrange(year, 1981, 1990)
replace period = 2 if inrange(year, 2016, 2025)

drop if period==.
label define p 1 "1981-1990" 2 "2016-2025"
label values period p

* Season
gen season = .
replace season = 1 if inlist(month,12,1,2)
replace season = 2 if inlist(month,3,4)
replace season = 3 if inlist(month,5,6)
replace season = 4 if inlist(month,7,8,9)
replace season = 5 if inlist(month,10,11)

label define s 1 "winter" 2 "spring" 3 "summer" 4 "monsoon" 5 "autumn"
label values season s


*Create results container

tempname results
postfile `results' ///
    str10 variable str10 season str12 era ///
    W_stat p_value ///
    using swilk_results, replace


*Loop (tmin, tavg, tmax)

foreach var in tmin tavg tmax {
    foreach s in 1 2 3 4 5 {
        foreach p in 1 2 {

            preserve
            keep if season==`s' & period==`p'
            keep if !missing(`var')

            count
            if r(N) < 30 {
                restore
                continue
            }

            
            * TRIM EXTREMES (1%–99%)
            
            summarize `var', detail
            scalar p1  = r(p1)
            scalar p99 = r(p99)

            keep if inrange(`var', p1, p99)

            
            * SHAPIRO–WILK TEST
            
            swilk `var'

            scalar W    = r(W)
            scalar pval = r(p)

           
            * LABELS
           
            local sname : label s `s'
            local pname : label p `p'

           
            * STORE
           
            post `results' ("`var'") ("`sname'") ("`pname'") (W) (pval)

            restore
        }
    }
}

postclose `results'


* STEP 3: Clean output

use swilk_results, clear

format W_stat %9.5f
format p_value %9.6f

sort variable season era
list, sepby(variable season)



**# NEGATIVE BINOMIAL

clear all
cd  " "
use "Stats_proj_shimla.dta", clear
set graphics on 


* BASIC SETUP


* Period
gen period = .
replace period = 1 if inrange(year, 1981, 1990)
replace period = 2 if inrange(year, 2016, 2025)
drop if period==.
label define p 1 "1981-1990" 2 "2016-2025"
label values period p

* Season
gen season = .
replace season = 1 if inlist(month,12,1,2)
replace season = 2 if inlist(month,3,4)
replace season = 3 if inlist(month,5,6)
replace season = 4 if inlist(month,7,8,9)
replace season = 5 if inlist(month,10,11)
label define s 1 "winter" 2 "spring" 3 "summer" 4 "monsoon" 5 "autumn"
label values season s


*Rain indicator

gen rain = (Preci_total > 0)


* STEP 2: Monthly ID

gen ym = ym(year, month)
format ym %tm


*Collapse to monthly counts

collapse (sum) rain, by(ym year month season period)


*Prepare loop + results container

levelsof season, local(seasons)
levelsof period, local(periods)

local graphlist

tempname results
postfile `results' str10 season str12 era chi_sq df p_value ///
    using chisq_clean, replace


*Loop

foreach s of local seasons {
    foreach p of local periods {

        preserve
        keep if season==`s' & period==`p'


        
        * FIT NB
        
        nbreg rain

        scalar alpha = e(alpha)
        scalar r_nb = 1/alpha

        sum rain
        scalar mu = r(mean)
        scalar p_nb = r_nb / (r_nb + mu)
        scalar N_sample = r(N)

        
        * CHI-SQUARE
        
        contract rain
        rename _freq obs

        gen exp = exp(lngamma(rain+r_nb) - lngamma(r_nb) - lngamma(rain+1)) ///
                  * (p_nb^r_nb) * ((1-p_nb)^rain) * N_sample

        gen group = rain
        replace group = 15 if rain >= 15

collapse (sum) obs exp, by(group)


        gen chi = (obs - exp)^2 / exp
        sum chi
        scalar chi2 = r(sum)
if r(N) <= 3 {
    di "Skipping (too few bins)"
    restore
    continue
}
        count
        scalar df = r(N) - 1 - 2
        scalar pval = chi2tail(df, chi2)

       
        * STORE RESULT (manual labels to avoid errors)
        
        if `s' == 1 local sname "winter"
        if `s' == 2 local sname "spring"
        if `s' == 3 local sname "summer"
        if `s' == 4 local sname "monsoon"
        if `s' == 5 local sname "autumn"

        if `p' == 1 local pname "1981-1990"
        if `p' == 2 local pname "2016-2025"

        post `results' ("`sname'") ("`pname'") (chi2) (df) (pval)

        restore
        preserve

       
        * GRAPH (UNCHANGED as requested)
        
        keep if season==`s' & period==`p'

        sum rain
        local max = r(max)

        capture drop x nb_pmf nb_freq

        range x 0 `max' `=`max'+1'

        gen nb_pmf = exp(lngamma(x+r_nb) - lngamma(r_nb) - lngamma(x+1)) ///
                     * (p_nb^r_nb) * ((1-p_nb)^x)

        gen nb_freq = nb_pmf * N_sample

        twoway ///
        (histogram rain, discrete frequency width(1)) ///
        (spike nb_freq x, lcolor(red)), ///
title("`sname' | `pname'") ///
        name(g_`s'_`p', replace)

        local graphlist `graphlist' g_`s'_`p'

        restore
    }
}


* COMBINE ALL GRAPHS

graph combine `graphlist', cols(2) ///
title("Negative Binomial Fit by Season & Period")


* CLEAN CHI-SQUARE TABLE OUTPUT

postclose `results'

use chisq_clean, clear

format chi_sq %9.5f
format p_value %9.6f

sort season era
order season era chi_sq df p_value

list, sepby(season)

**# T TEST FOR TEMP CHANGE



* CREATE RESULTS CONTAINER

tempname results
postfile `results' ///
    str6 variable str10 season ///
    mean_old mean_new diff t_stat p_value ///
    using ttest_results, replace


* LOOP + STORE RESULTS

foreach var in tmin tavg tmax {
    foreach s in 1 2 3 4 5 {

        preserve
        keep if season==`s' & !missing(`var')

        count
        if r(N) < 30 {
            restore
            continue
        }

        * Get means manually
        summarize `var' if period==1
        scalar m1 = r(mean)

        summarize `var' if period==2
        scalar m2 = r(mean)

        * Run t-test
        quietly ttest `var', by(period) unequal

        scalar diff = m1 - m2
        scalar tval = r(t)
        scalar pval = r(p)

        * Season label
        local sname : label s `s'

        * Store
        post `results' ///
            ("`var'") ("`sname'") ///
            (m1) (m2) (diff) (tval) (pval)

        restore
    }
}

postclose `results'


* CLEAN TABLE

use ttest_results, clear

format mean_old mean_new diff %9.3f
format t_stat %9.3f
format p_value %9.5f

sort variable season
list, sepby(variable)


