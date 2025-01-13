*! version 1.0.0  01Jan2025  Neel Lal nlal@uchicago.edu

cap program drop rdpbt
program define rdpbt
    version 16.0 
    syntax varlist(min=2 max=2) [if] [in], ///
        [donut(varlist)] /// 
        event_var(varlist) /// 
        group_var(varlist) /// 
        group_range(numlist) 
		

    * Apply if condition
        marksample touse, novarlist
        keep if `touse'

    * Assign variables
    local dep_var `1'  // The dependent variable
    local score_var `2'  // The score variable

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
	

    * Create a temporary file to store results
		preserve
			clear
		        tempfile results
			save `results', emptyok
		restore

    * Get unique levels of `event_var`
        levelsof `event_var', local(event)

    * Generate necessary variables
        capture drop treat score_sq treatxscore treatxscore_sq
        gen treat = `score_var' >= 0
        gen score_sq = `score_var'^2
        gen treatxscore = treat * `score_var'
        gen treatxscore_sq = treat * score_sq

    * Loop over unique events
        foreach e of local event {

            * Loop over group ranges
                forvalues i = 1/`group_range' {

                    * Run regressions without donut
                        reg `dep_var' treat if inrange(`group_var', -`i', `i') & `event_var' == `e', robust
                        local levels = _b[treat]

                        reg `dep_var' treat `score_var' treatxscore if inrange(`group_var', -`i', `i') & `event_var' == `e', robust
                        local linear = _b[treat]

                        reg `dep_var' treat `score_var' treatxscore score_sq treatxscore_sq  if inrange(`group_var', -`i', `i') & `event_var' == `e', robust
                        local quadratic = _b[treat]

                    * Run regressions with donut if specified
                        if "`donut_var'" != "" {
                            reg `dep_var' treat if inrange(`group_var', -`i', `i') & `donut_var' == 0 & `event_var' == `e', robust
                            local levels_d = _b[treat]

                            reg `dep_var' treat `score_var' treatxscore if inrange(`group_var', -`i', `i') & `donut_var' == 0 & `event_var' == `e', robust
                            local linear_d = _b[treat]

                            reg `dep_var' treat `score_var' treatxscore score_sq treatxscore_sq if inrange(`group_var', -`i', `i') & `donut_var' == 0 & `event_var' == `e', robust
                            local quadratic_d = _b[treat]
                        }

                    * Save results into temporary file
						preserve 
							clear
							set obs 1
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
							append using `results'
							tempfile results
							save `results', replace
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
        reshape long rmse_, i(group) j(model) string
        sort rmse_
        local model = model[1]
        local bw = group[1]
        di "Optimal Specification is `model' with a `bw' group bandwidth"
		

end
