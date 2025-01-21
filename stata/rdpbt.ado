*! version 1.0.1  21Jan2025  Neel Lal nlal@uchicago.edu

cap program drop rdpbt
program define rdpbt
    version 16.0 
    syntax varlist(min=2 max=2) [if] [in] , ///
        event_var(varlist) /// 
        group_var(varlist) /// 
        group_range(numlist) ///
        [donut(varlist)] /// 
	[treat(varlist)] ///
	[placebo(varlist)] ///
	[tag(string)] ///

	*Save original dataset
		qui tempfile original
		qui save `original', replace
		
    * Apply if condition
        marksample touse, novarlist
        qui keep if `touse'

    * Assign variables
		local dep_var `1'  // The dependent variable
		local score_var `2'  // The score variable
		
		local score = subinstr("`score'", ",", "",.) //Corrects error where `score' without space next to "," caused var to be stored as `score,'
	
	* Check for invalid names
		capture confirm variable `dep_var'
		if _rc {
			di as err "The dependent variable `dep_var' is not found in the dataset."
			exit 198
		}

		capture confirm variable `score_var'
		if _rc {
			di as err "The score variable `score_var' is not found in the dataset."
			exit 198
		}

    * Validate and handle `event_var`
        if "`event_var'" == "" {
            di as err "The `event_var` option is required but not specified."
            exit 198
        }
    local event_var `event_var'

    * Validate and handle `group_var`
        if "`group_var'" == "" {
            di as err "The `group_var` option is required but not specified."
            exit 198
        }
    local group_var `group_var'

    * Validate and handle `group_range`
        if "`group_range'" == "" {
            di as err "The `group_range` option is required but not specified."
            exit 198
        }
    local group_range = real("`group_range'")
        if missing(`group_range') {
            di as err "The `group_range` option must be a numeric value."
            exit 198
        }

    * Validate and handle `donut`
		local donut_var ""
		if "`donut'" != "" {
			capture confirm variable `donut'
			if _rc {
				di as err "The variable specified in the `donut` option is not found in the dataset."
				exit 198
			}
			local donut_var `donut'
		}
		
    * Validate and handle `treat`
		local treat_var ""
		if "`treat'" == "" {
			capture drop treat
			gen treat = `score_var' >= 0
			local treat_var "treat"
		} 
		if "`treat'" != "" {
			capture confirm variable `treat'
			if _rc {
				di as err "The variable specified in the `treat` option is not found in the dataset."
				exit 198
			}
			local treat_var `treat'
		}
	
    * Validate and handle `placebo`
		local placebo_var ""
		if "`placebo'" != "" {
			capture confirm variable `placebo'
			if _rc {
				di as err "The variable specified in the `placebo` option is not found in the dataset."
				exit 198
			}
			keep if `placebo' == 1
		}
	
			
	* Validate the `tag` option
		local tag_var ""
		if "`tag'" != "" {
			capture confirm variable `tag'
			if !_rc {
				di as err "The variable `tag' already exists."
				exit 198
			}
			local tag_var `tag'
		} 

    * Create a temporary file to store results
		preserve
			clear
		    qui tempfile results
			qui save `results', emptyok
		restore

    * Get unique levels of `event_var`
        qui levelsof `event_var', local(event)

    * Generate necessary variables
        capture drop score_sq treatxscore treatxscore_sq
        gen score_sq = `score_var'^2
        gen treatxscore = `treat_var' * `score_var'
        gen treatxscore_sq = `treat_var' * score_sq

    * Loop over unique events
        foreach e of local event {

            * Loop over group ranges
                forvalues i = 1/`group_range' {

                    * Run regressions without donut
						qui reg `dep_var' `treat_var' if inrange(`group_var', -`i', `i') & `event_var' == `e', robust
                        local levels = _b[treat]

                        qui reg `dep_var' `treat_var' `score_var' treatxscore if inrange(`group_var', -`i', `i') & `event_var' == `e', robust
                        local linear = _b[treat]

                        qui reg `dep_var' `treat_var' `score_var' treatxscore score_sq treatxscore_sq  if inrange(`group_var', -`i', `i') & `event_var' == `e', robust
                        local quadratic = _b[treat]

                    * Run regressions with donut if specified
                        if "`donut_var'" != "" {
                            qui reg `dep_var' `treat_var' if inrange(`group_var', -`i', `i') & `donut_var' == 0 & `event_var' == `e', robust
                            local levels_d = _b[treat]

                            qui reg `dep_var' `treat_var' `score_var' treatxscore if inrange(`group_var', -`i', `i') & `donut_var' == 0 & `event_var' == `e', robust
                            local linear_d = _b[treat]

                            qui reg `dep_var' `treat_var' `score_var' treatxscore score_sq treatxscore_sq if inrange(`group_var', -`i', `i') & `donut_var' == 0 & `event_var' == `e', robust
                            local quadratic_d = _b[treat]
                        }

                    * Save results into temporary file
						preserve 
							clear
							qui set obs 1
							gen event = `e'
							gen group = `i'
							gen levels = `levels'
							gen linear = `linear'
							gen quadratic = `quadratic'

							if "`donut_var'" != "" {
								gen levels_d = `levels_d'
								gen linear_d = `linear_d'
								gen quadratic_d = `quadratic_d'
							}
							qui append using `results'
							qui tempfile results
							qui save `results', replace
						restore
                }
        }

    * Load results and calculate RMSE
        use `results', clear
        gen rmse_levels = levels^2
        gen rmse_linear = linear^2
        gen rmse_quadratic = quadratic^2

        if "`donut_var'" != "" {
            gen rmse_levels_d = levels_d^2
            gen rmse_linear_d = linear_d^2
            gen rmse_quadratic_d = quadratic_d^2
        }

    * Collapse RMSE values by group
        collapse (mean) rmse*, by(group)

    * Find the optimal specification
        qui reshape long rmse_, i(group) j(model) string

		if "`donut_var'" == "" {
			sort rmse_
			local model = model[1]
			local bw = group[1]
			di "Optimal Specification is `model' with a `bw' group bandwidth"
		}
		if "`donut_var'" != "" {
			sort rmse_
			qui split model, p(_)
			local donut = model2[1]
			local include_donut = cond("`donut'" == "d" ,"with", "without")
			
			local model = model1[1]
			local bw = group[1]
			di "Optimal Specification is `model' with a `bw' group bandwidth `include_donut' a donut"
			
		}	
		
	if "`tag_var'" != "" {
		
		*Reopen original dataset
			use `original', clear
			
			*Generate a tag for the optimal bandwidth and donut
			local include_donut = "with"
				gen `tag_var' = inrange(`group_var', -`bw', `bw')
				if "`include_donut'" == "with" {
					qui replace `tag_var' = 0 if `donut_var' == 1
				}

	}

end
