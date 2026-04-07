cd "C:\Users\jzsloan\University of Michigan Dropbox\Jared Sloan\AI-Powered Lawyering - Anonymized Replication Package as of March 6th 2025"

import delimited "combined_data_for_stata.csv", clear

encode ai_condition, generate(ai_condition_cat)
encode outcome, generate(outcome_cat)
encode task, generate(task_cat)
encode student_number, generate(student_number_cat)
encode group, generate(group_cat)


bysort student_number: egen outcome_count = count(score)

preserve

collapse (max) outcome_count, by(student_number_cat)
gen completion_perc = outcome_count/48
histogram completion_perc

restore



preserve
drop if outcome_count < 48
drop if outcome == "Productivity"
drop if outcome == "Time_Spent"
drop if outcome == "Total_Score"
drop if ai_condition == "No AI"

regress score ib2.ai_condition_cat##c.avg_z i.outcome_cat i.task_cat i.student_number_cat

restore

*Productivity Regression:
preserve
keep if outcome == "Productivity"

regress score i.student_number_cat ib2.ai_condition_cat##i.task_cat, vce(cluster student_number)
tempfile prod_results
postfile handle_prod int task int condition double control double control_sd int row_n double coef double se double pval using `prod_results', replace

forvalues j=1/6{
	forvalues k=1(2)3{
		lincom `k'.ai_condition_cat +  `k'.ai_condition_cat#`j'.task_cat
	 
		 local coef = r(estimate)
		 local se = r(se)
		 local pval = r(p)
		 
		 sum score if task_cat == `j' & ai_condition_cat == 2
		 
		 local control = r(mean)
		 local control_sd = r(sd)
		 quietly count if task_cat == `j'
		 local row_n = r(N)
		 
		 post handle_prod (`j') (`k') (`control') (`control_sd') (`row_n') (`coef') (`se') (`pval') 

	}
}
postclose handle_prod
use `prod_results', clear
export delimited using "lincom_results_prod.csv", replace

restore

*Time Spent
preserve
keep if outcome == "Time_Spent"

regress score i.student_number_cat ib2.ai_condition_cat##i.task_cat, vce(cluster student_number)
tempfile time_results
postfile handle_time int task int condition double control double control_sd int row_n double coef double se double pval using `time_results', replace

forvalues j=1/6{
	forvalues k=1(2)3{
		lincom `k'.ai_condition_cat +  `k'.ai_condition_cat#`j'.task_cat
	 
		 local coef = r(estimate)
		 local se = r(se)
		 local pval = r(p)
		 
		 sum score if task_cat == `j' & ai_condition_cat == 2
		 
		 local control = r(mean)
		 local control_sd = r(sd)
		 quietly count if task_cat == `j'
		 local row_n = r(N)
		
		 post handle_time (`j') (`k') (`control') (`control_sd') (`row_n') (`coef') (`se') (`pval') 

	}
}
postclose handle_time
use `time_results', clear
export delimited using "lincom_results_time.csv", replace
restore

*Total Score
preserve

keep if outcome == "Total_Score"

regress score i.student_number_cat ib2.ai_condition_cat##i.task_cat, vce(cluster student_number)
tempfile tot_results
postfile handle_tot int task int condition double control double control_sd int row_n double coef double se double pval using `tot_results', replace

forvalues j=1/6{
	forvalues k=1(2)3{
		lincom `k'.ai_condition_cat +  `k'.ai_condition_cat#`j'.task_cat
	 
		 local coef = r(estimate)
		 local se = r(se)
		 local pval = r(p)
		 
		 sum score if task_cat == `j' & ai_condition_cat == 2
		 
		 local control = r(mean)
		 local control_sd = r(sd)
		 quietly count if task_cat == `j'
		 local row_n = r(N)
		
		 post handle_tot (`j') (`k') (`control') (`control_sd') (`row_n') (`coef') (`se') (`pval') 

	}
}
postclose handle_tot
use `tot_results', clear
export delimited using "lincom_results_tot.csv", replace
restore

*Productivity Regression no FEs:
preserve
keep if outcome == "Productivity"

regress score ib2.ai_condition_cat##i.task_cat, vce(cluster student_number)
tempfile prod_results_re
postfile handle_prod_re int task int condition double control double control_sd int row_n double coef double se double pval using `prod_results_re', replace

forvalues j=1/6{
	forvalues k=1(2)3{
		lincom `k'.ai_condition_cat +  `k'.ai_condition_cat#`j'.task_cat
	 
		 local coef = r(estimate)
		 local se = r(se)
		 local pval = r(p)
		 
		 sum score if task_cat == `j' & ai_condition_cat == 2
		 
		 local control = r(mean)
		 local control_sd = r(sd)
		 quietly count if task_cat == `j'
		 local row_n = r(N)
		 
		 post handle_prod_re (`j') (`k') (`control') (`control_sd') (`row_n') (`coef') (`se') (`pval') 

	}
}
postclose handle_prod_re
use `prod_results_re', clear
export delimited using "lincom_results_prod_re.csv", replace

restore

*Time Spent
preserve
keep if outcome == "Time_Spent"

regress score ib2.ai_condition_cat##i.task_cat, vce(cluster student_number)
tempfile time_results_re
postfile handle_time_re int task int condition double control double control_sd int row_n double coef double se double pval using `time_results_re', replace

forvalues j=1/6{
	forvalues k=1(2)3{
		lincom `k'.ai_condition_cat +  `k'.ai_condition_cat#`j'.task_cat
	 
		 local coef = r(estimate)
		 local se = r(se)
		 local pval = r(p)
		 
		 sum score if task_cat == `j' & ai_condition_cat == 2
		 
		 local control = r(mean)
		 local control_sd = r(sd)
		 quietly count if task_cat == `j'
		 local row_n = r(N)
		
		 post handle_time_re (`j') (`k') (`control') (`control_sd') (`row_n') (`coef') (`se') (`pval') 

	}
}
postclose handle_time_re
use `time_results_re', clear
export delimited using "lincom_results_time_re.csv", replace
restore

*Total Score
preserve

keep if outcome == "Total_Score"

regress score ib2.ai_condition_cat##i.task_cat, vce(cluster student_number)
tempfile tot_results_re
postfile handle_tot_re int task int condition double control double control_sd int row_n double coef double se double pval using `tot_results_re', replace

forvalues j=1/6{
	forvalues k=1(2)3{
		lincom `k'.ai_condition_cat +  `k'.ai_condition_cat#`j'.task_cat
	 
		 local coef = r(estimate)
		 local se = r(se)
		 local pval = r(p)
		 
		 sum score if task_cat == `j' & ai_condition_cat == 2
		 
		 local control = r(mean)
		 local control_sd = r(sd)
		 quietly count if task_cat == `j'
		 local row_n = r(N)
		
		 post handle_tot_re (`j') (`k') (`control') (`control_sd') (`row_n') (`coef') (`se') (`pval') 

	}
}
postclose handle_tot_re
use `tot_results_re', clear
export delimited using "lincom_results_tot_re.csv", replace
restore

import delimited "combined_data_for_stata.csv", clear

drop if outcome == "Productivity"
drop if outcome == "Time_Spent"
drop if outcome == "Total_Score"


encode ai_condition, generate(ai_condition_cat)
encode outcome, generate(outcome_cat)
encode task, generate(task_cat)
encode student_number, generate(student_number_cat)
encode group, generate(group_cat)

bysort student_number: egen outcome_count = count(score)

*print control means
forvalues i = 1/5{
	quietly sum score	if outcome_cat==`i' & ai_condition_cat==2
	di `i'
	di r(mean)
	di r(sd)
}
forvalues j = 1/6{
	quietly sum score	if task_cat==`j' & ai_condition_cat==2
	di `j'
	di r(mean)
	di r(sd)
}
sum score if ai_condition_cat==2
regress score ib2.ai_condition_cat##outcome_cat##i.task_cat, vce(cluster student_number) nofvlabel
regress score ib2.ai_condition_cat##outcome_cat##i.task_cat i.group_cat, vce(cluster student_number)

*With task
regress score ib2.ai_condition_cat##i.outcome_cat##i.task_cat, vce(cluster student_number) nofvlabel
margins outcome_cat#task_cat, at(ai_condition_cat=2)

forvalues i = 1/5 {
	forvalues j=1/6 {
		margins ai_condition_cat, at(outcome_cat=`i' task_cat=`j') pwcompare(effect)
	}
}


*Aggregates
regress score ib2.ai_condition_cat##i.outcome_cat i.task_cat, vce(cluster student_number)
margins ai_condition_cat#outcome_cat

forvalues i = 1/5 {
	margins ai_condition_cat, at(outcome_cat=`i') pwcompare(effect)
}


regress score ib2.ai_condition_cat##task_cat i.outcome_cat, vce(cluster student_number)
margins ai_condition_cat#task_cat
forvalues i = 1/6 {
	margins ai_condition_cat, at(task_cat=`i') pwcompare(effect)
}

mixed score ib2.ai_condition_cat##i.outcome_cat##i.task_cat || student_number:
est store re_mixed
estat icc
margins outcome_cat#task_cat, at(ai_condition_cat=2)

forvalues i = 1/5 {
	forvalues j=1/6 {
		margins ai_condition_cat, at(outcome_cat=`i' task_cat=`j') pwcompare(effect)
	}
}

mixed score ib2.ai_condition_cat##i.outcome_cat##i.task_cat i.student_number_cat


preserve
gen time_id = task_cat*10 + outcome_cat

* Check uniqueness
bysort student_number time_id: gen dup = _N
tab dup
drop dup

xtset student_number_cat time_id
xtreg score ib2.ai_condition_cat##i.outcome_cat##i.task_cat i.group_cat, fe
estimates store fe_model

tempfile results_order
postfile handle int task int outcome int condition double control double control_sd int row_n double coef double se double pval using `results_order', replace

forvalues i = 1/5{
	forvalues j=1/6{
		forvalues k=1(2)3{
			lincom `k'.ai_condition_cat + `k'.ai_condition_cat#`i'.outcome_cat + `k'.ai_condition_cat#`j'.task_cat + `k'.ai_condition_cat#`i'.outcome_cat#`j'.task_cat
		 
			 local coef = r(estimate)
			 local se = r(se)
			 local pval = r(p)
			 
			 sum score if task_cat == `j' & outcome_cat == `i' & ai_condition_cat == 2
			 
			 local control = r(mean)
			 local control_sd = r(sd)
			 count if task_cat == `j' & outcome_cat == `i'
			 local row_n = r(N)
			
			 post handle (`j') (`i') (`k') (`control') (`control_sd') (`row_n') (`coef') (`se') (`pval') 
		}
	}
}
postclose handle
use `results_order', clear
export delimited using "lincom_results.csv", replace

restore
lincom 3.ai_condition_cat ///
     + 3.ai_condition_cat#3.outcome_cat ///
     + 3.ai_condition_cat#1.task_cat ///
     + 3.ai_condition_cat#3.outcome_cat#1.task_cat
	 
matrix A = r(table)
di `A'
matrix list e(b)
forvalues i = 1/5 {
	forvalues j=1/6 {
		margins ai_condition_cat, at(outcome_cat=`i' task_cat=`j') pwcompare(effect)
	}
}


xtreg score ib2.ai_condition_cat##i.outcome_cat##i.task_cat, re
estimates store re_model

est table fe_model re_model, b(%9.3f) se(%9.3f) stats(N r2)

hausman fe_model re_model, sigmamore



xtreg score ib2.ai_condition_cat##i.outcome_cat##i.task_cat, re vce(cluster student_number)
regress score ib2.ai_condition_cat##i.outcome_cat##i.task_cat, vce(cluster student_number)

xtreg score ib2.ai_condition_cat##i.outcome_cat##i.task_cat, re vce(cluster student_number)
estat mundlak

* --- fit FE model (example) -----------------------
* make sure factor variables are used and FE is identified
xtset student_number_cat time_id
xtreg score ib2.ai_condition_cat##i.outcome_cat##i.task_cat, fe vce(cluster student_number)
xtreg score ib2.ai_condition_cat##i.outcome_cat##i.task_cat i.group_cat, fe vce(cluster student_number)

estimates store fe_model


regress score i.student_number_cat ib2.ai_condition_cat##i.outcome_cat##i.task_cat, vce(cluster student_number)
regress score i.student_number_cat ib2.ai_condition_cat##i.outcome_cat i.task_cat, vce(cluster student_number)
regress score i.student_number_cat ib2.ai_condition_cat i.outcome_cat##i.task_cat, vce(cluster student_number)



xtset student_number_cat time_id
xtreg score ib2.ai_condition_cat##i.outcome_cat##i.task_cat, fe

forvalues i = 1/5 {
	forvalues j=1/6 {
		margins ai_condition_cat, at(outcome_cat=`i' task_cat=`j') pwcompare(effect)
	}
}

regress score ib2.ai_condition_cat##i.outcome_cat##i.task_cat, vce(cluster student_number)
estat mundlak


*Aggregated Fixed Effects

regress score i.student_number_cat ib2.ai_condition_cat##outcome_cat i.task_cat, vce(cluster student_number)
margins ai_condition_cat#outcome_cat

forvalues i = 1/5{
	forvalues k=1(2)3{
		lincom `k'.ai_condition_cat ///
	 + `k'.ai_condition_cat#`i'.outcome_cat
	}
	
}

regress score i.student_number_cat ib2.ai_condition_cat##task_cat i.outcome_cat, vce(cluster student_number)
margins ai_condition_cat#task_cat
forvalues j=1/6{
	forvalues k=1(2)3{
		lincom `k'.ai_condition_cat ///
	 + `k'.ai_condition_cat#`j'.task_cat
	}
}


regress score i.student_number_cat ib2.ai_condition_cat i.task_cat i.outcome_cat, vce(cluster student_number)
regress score ib2.ai_condition_cat i.task_cat i.outcome_cat, vce(cluster student_number)
sum score if ai_condition_cat==2

*Mundlak test per outcome
forvalues i=1/5{
	di `i'
	regress score ib2.ai_condition_cat##i.task_cat if outcome_cat == `i'
	forvalues j=1/6{
		margins ai_condition_cat, at(task_cat=`j') pwcompare(effect)
	}
}

regress score ib2.ai_condition_cat##i.outcome_cat##i.task_cat
estimates store re

regress score ib2.ai_condition_cat##i.outcome_cat##i.task_cat i.student_number_cat
estimates store fe

suest re fe, vce(cluster student_number)
test [re_mean = fe_mean],cons common


