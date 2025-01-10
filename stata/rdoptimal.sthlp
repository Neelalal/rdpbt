{smcl}
{* *! version 1.0.0 2025-01-01}{...}
{viewerjumpto "Syntax" "rdoptimal##syntax"}{...}
{viewerjumpto "Description" "rdoptimal##description"}{...}
{viewerjumpto "Options" "rdoptimal##options"}{...}
{viewerjumpto "Example" "rdoptimal##example"}{...}
{viewerjumpto "Stored results" "rdoptimal##stored_results"}{...}
{viewerjumpto "References" "rdoptimal##references"}{...}
{viewerjumpto "Authors" "rdoptimal##authors"}{...}

{title:Title}

{p 4 8}{cmd:rdoptimal} {hline 2} Regression Discontinuity Design Optimal Bandwidth Selection Tool.{p_end}


{marker syntax}{...}
{title:Syntax}

{p 4 8}{cmd:rdoptimal} {it:dep_var score_var} {ifin} {cmd:,} [{opt include_graphs}] [{opt donut(donut_var)}] {cmd:event_var(event_var)} {cmd:group_var(group_var)} {cmd:group_range(#)}{p_end}
{p 8 8}
where {it:score_var} refers to the running variable representing the distance from the treatment threshold. Values of {it:score_var} greater than or equal to zero indicate membership in the treatment group.{p_end}


{marker description}{...}
{title:Description}

{p 4 8}{cmd:rdoptimal} selects the optimal combination of bandwidth and polynomial order in regression discontinuity designs. The command loops through specified placebo events to identify the combination that minimizes the root mean squared error (RMSE).{p_end}

{p 4 8}The algorithm is detailed in {browse "https://www.nber.org/papers/w32343":Goldin et al. (2024)} and returns a dataset detailing RMSE values by {it:group_var}.{p_end}


{marker options}{...}
{title:Options}

{synoptset 22 tabbed}{...}
{synopthdr}
{synoptline}
{synopt: {opt include_graphs}} If specified, includes a graph in the output comparing RMSE values across models by bandwidth.{p_end}
{synopt: {opt donut(donut_var)}} Specifies a variable indicating donut observations. The command runs additional regressions excluding observations where {it:donut_var} equals 1.{p_end}
{synopt: {opt event_var(event_var)}} Specifies the event variable that defines the events to loop through for the regression.{p_end}
{synopt: {opt group_var(group_var)}} Specifies the group variable that defines the bandwidths to loop through within each event. The {it:group_var} must be centered around zero, with no observations equal to zero. For example, if {it:group_var} represents months, January could be coded as 1, December as -1, February as 2, and November as -2.{p_end}
{synopt: {opt group_range(#)}} Specifies the maximum range for groups to consider on each side of the cutoff. Must be a positive numeric value.{p_end}


{marker example}{...}
{title:Example}

{p 4 8} Example usage of {cmd:rdoptimal}:{p_end}
{p 8 8} {cmd:. use "rdd_optimal_sim.dta", clear}{p_end}
{p 8 8} {cmd:. rdoptimal has_inc score if inrange(group, -9, 9), include_graphs donut(donut) event_var(period) group_var(group) group_range(9)}{p_end}

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


