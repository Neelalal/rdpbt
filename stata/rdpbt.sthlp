{smcl}
{* *! version 1.0.0 2025-01-01}{...}
{viewerjumpto "Syntax" "rdpbt##syntax"}{...}
{viewerjumpto "Description" "rdpbt##description"}{...}
{viewerjumpto "Options" "rdpbt##options"}{...}
{viewerjumpto "Example" "rdpbt##example"}{...}
{viewerjumpto "Stored results" "rdpbt##stored_results"}{...}
{viewerjumpto "References" "rdpbt##references"}{...}
{viewerjumpto "Authors" "rdpbt##authors"}{...}

{title:Title}

{p 4 8}{cmd:rdpbt} {hline 2} Regression Discontinuity Design Optimal Bandwidth Selection Tool.{p_end}


{marker syntax}{...}
{title:Syntax}

{p 4 8}{cmd:rdpbt} {it:dep_var score_var} {ifin}{cmd:,} {opt event_var(event_var)} {opt group_var(group_var)} {opt group_range(#)} [{opt donut(donut_var)} {opt treat(treat_var)} {opt placebo(placebo_var)} {opt tag(string)}]{p_end}
{p 8 8}
where {it:score_var} refers to the running variable representing the distance from the treatment threshold.{p_end}


{marker description}{...}
{title:Description}

{p 4 8}{cmd:rdpbt} selects the optimal combination of bandwidth and polynomial order in regression discontinuity designs. The command loops through specified placebo events to identify the combination that minimizes the root mean squared error (RMSE). The provided dataset should only reflect placebo observations or should include a variable, {it:placebo_var}, that indicates the placebo observations. {p_end}

{p 4 8}The algorithm is detailed in {browse "https://www.nber.org/papers/w32343":Goldin et al. (2024)} and, provided that the tag command is not specified, returns a dataset detailing RMSE values by {it:group_var}.{p_end}


{marker options}{...}
{title:Options}

{synoptset 22 tabbed}{...}
{synopthdr}
{synoptline}
{synopt: {opt donut(donut_var)}} Specifies a variable indicating donut observations. The command runs additional regressions excluding observations where {it:donut_var} equals 1.{p_end}
{synopt: {opt event_var(event_var)}} Specifies the event variable that defines the events to loop through for the regression.{p_end}
{synopt: {opt group_var(group_var)}} Specifies the group variable that defines the bandwidths to loop through within each event. The {it:group_var} must be centered around zero, with no observations equal to zero. For example, if {it:group_var} refers to months, January could be coded as 1, December as -1, February as 2, and November as -2.{p_end}
{synopt: {opt group_range(#)}} Specifies the maximum range for groups to consider on each side of the cutoff. Must be a positive numeric value.{p_end}
{synopt: {opt treat(treat_var)}} Specifies the treatment variable. Default is to consider observations with {it:score_var} greater than or equal to zero as a part of the treatment group.{p_end}
{synopt: {opt placebo(placebo_var)}} Specifies the variable identifying the placebo dataset. Default is to consider the input data as the placebo dataset. {p_end}
{synopt: {opt tag(tag_var)}} When specified, restores the original dataset and creates new variable {it:tag_var} identifying observations in the optimal bandwidth. Observations are tagged if they fall within the bandwidth that minimizes RMSE and satisfy the optimal donut condition (if applicable).{p_end}


{marker example}{...}
{title:Example}

{p 4 8} Example usage of {cmd:rdpbt}:{p_end}
{p 8 8} {cmd:. use "rdpbt_sim.dta", clear}{p_end}
{p 8 8} {cmd:. rdpbt has_inc score if inrange(group, -9, 9), donut(donut) event_var(period) group_var(group) group_range(9)}{p_end}


{marker stored_results}{...}
{title:Stored Results}

{p 4 8} {cmd:rdpbt} stores either of the following in memory:{p_end}
{p 8 8} A dataset containing RMSE values by bandwidth and model specification.{p_end}
{p 8 8} When the {cmd:tag} option is specified, the original dataset is restored with {it:tag_var} identifying observations within the optimal bandwidth.{p_end}


{marker references}{...}
{title:References}

{p 4 8}Goldin, J., T. Homonoff, N. Lal, I. Lurie, K. Michelmore, and M. Unrath. 2024.  
{browse "https://www.nber.org/papers/w32343":Work Requirements and Child Tax Benefits}. {p_end}


{marker authors}{...}
{title:Authors}

{p 4 8}Jacob Goldin {break}
University of Chicago Law School {break}
Chicago, IL {break}
{cmd:Email:} {browse "mailto:jsgoldin@gmail.com":jsgoldin@gmail.com}{p_end}

{p 4 8}Tatiana Homonoff {break}
Robert F. Wagner School of Public Service, New York University {break}
New York, NY {break}
{cmd:Email:} {browse "mailto:tatiana.homonoff@nyu.edu":tatiana.homonoff@nyu.edu}{p_end}

{p 4 8}Neel Lal {break}
University of Chicago Law School {break}
Chicago, IL {break}
{cmd:Email:} {browse "mailto:nlal@uchicago.edu":nlal@uchicago.edu}{p_end}

{p 4 8}Ithai Lurie {break}
Department of the Treasury {break}
Washington, DC {break}
{cmd:Email:} {browse "mailto:ithai.lurie@treasury.gov":ithai.lurie@treasury.gov}{p_end}

{p 4 8}Katherine Michelmore {break}
Gerald R. Ford School of Public Policy, University of Michigan {break}
Ann Arbor, MI {break}
{cmd:Email:} {browse "mailto:kmichelm@umich.edu":kmichelm@umich.edu}{p_end}

{p 4 8}Matthew Unrath {break}
Sol Price School of Public Policy, University of Southern California {break} 
Los Angeles, CA {break}
{cmd:Email:} {browse "mailto:unrath@usc.edu":unrath@usc.edu}{p_end}


