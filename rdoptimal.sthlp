{smcl}
{title:Title}
    {bf:rdoptimal} --- Regression Discontinuity Design Optimal Bandwidth Selection Tool

{phang}
    {bf:Syntax}
    {cmd:rdoptimal} {it:dep_var score_var} [{cmd:if}] {cmd:,} [{opt include_graphs} {opt donut(donut_var)}] {cmd:event_var(event_var)} {cmd:group_var(group_var)} {cmd:group_range(#)}
    where {it:score_var} refers to the running variable representing the distance from the treatment threshold. Values of {it:score_var} greater than or equal to zero indicate membership in the treatment group.


{phang}
    {bf:Description}
       {cmd:rdoptimal} is a Stata command for selecting the optimal combination of bandwidth and polynomial order in regression discontinuity designs. The command iterates through specified placebo events to identify the combination that minimizes the root mean squared error (RMSE). The procedure is further detailed in {browse "https://www.nber.org/papers/w32343": Goldin et al. 2024}. This algorithm returns a dataset detailing RMSE by group_var.

{marker options}{...}
{title:Options}
    {phang}
    {opt include_graphs} --- If specified, includes a graph in the output comparing RMSE values by bandwidth across models.

    {phang}
    {opt donut(donut_var)} --- Specifies a variable indicating donut observations. The command runs additional regressions excluding observations where {it:donut_var} equals 1, in addition to the standard regressions including all observations.


    {phang}
    {opt event_var(event_var)} --- Specifies the events to loop through for the regression.

    {phang}
    {opt group_var(group_var)} --- Specifies the bandwidths to loop through within each event. The {it:group_var} must be centered around zero, with no observations equal to zero. For example, if {it:group_var} represents months, January could be coded as 1, December as -1, February as 2, and November as -2.


    {phang}
    {opt group_range(#)} --- Specifies the maximum range for groups to consider on each side of the cutoff. Must be a positive numeric value.

{marker example}{...}
{title:Example}
    {phang}
    Example dataset:
    {cmd: use "rdd_optimal_sim.dta", clear}
    {phang}
    Example usage of {cmd:rdoptimal}:
    {cmd: rdoptimal has_inc score if inrange(group, -9, 9), include_graphs donut(donut) event_var(period) group_var(group) group_range(9)}

{marker author}{...}
{title:Authors}
    {phang}
    Neel Lal
    University of Chicago Law School    
    {phang}
    {cmd:Email:} {it:nlal@uchicago.edu}

    {phang}
    Jacob Goldin
    {phang}
    University of Chicago Law School
    {phang}
    {cmd:Email:} {it:jsgoldin@gmail.com}

    {phang}
    Tatiana Homonoff
    {phang}
    Robert F. Wagner School of Public Service, New York University
    {phang}
    {cmd:Email:} {it:tatiana.homonoff@nyu.edu}

    {phang}
    Ithai Lurie
    {phang}
    Department of the Treasury
    {phang}
    {cmd:Email:} {it:Ithai.Lurie@treasury.gov}


    {phang}
    Katherine Michelmore
    {phang}
    Gerald R. Ford School of Public Policy, University of Michigan
    {phang}
    {cmd:Email:} {it:kmichelm@umich.edu}

    {phang}
    Matthew Unrath
    {phang}
    Sol Price School of Public Policy, University of Southern California
    {phang}
    {cmd:Email:} {it:unrath@usc.edu}

{marker references}{...}
{title:References}

{p 4 8} Goldin, J., T. Homonoff, N. Lal, I. Lurie, K. Michelmore, and M. Unrath. 2024.
{browse "https://www.nber.org/papers/w32343":Work Requirements and Child Tax Benefits}. {p_end}


{marker version}{...}
{title:Version}
    {phang}
    Version 1.0.0 (01 Jan 2025)

