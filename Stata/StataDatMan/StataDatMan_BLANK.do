* **Topics**
*
* * Generating and replacing variables 
* * Missing values
* * Variable types and conversion
* * Merging, appending, and joining
* * Creating summarized data sets
*
* ## Setup 
*
* ### Class structure and organization 
*
* * Please feel free to ask questions at any point if they are relevant to the current topic (or if you are lost!)
* * Collaboration is encouraged - please introduce yourself to your neighbors!
* * If you are using a laptop, you will need to adjust file paths accordingly
* * Make comments in your do-file - save on flash drive or email to yourself

* ### Prerequisites
*
* * This is an introduction to data management in Stata
* * Assumes basic knowledge of Stata
* * Not appropriate for people already familiar with Stata
* * If you are catching on before the rest of the class, experiment with command features described in help files

* ### Goals
*
* We will learn about the Stata language by analyzing data from the general social survey (gss). In particular, our goals are to learn: 
*
* 1. Basic data manipulation commands
* 2. Dealing with missing values
* 3. Variable types and conversion
* 4. Merging and appending datasets

* ## Opening Files
*
* **GOAL: To understand the working directory of Stata, how to change working directory, and open files from the working directory.** In particular:  
*
* Look at bottom left hand corner of Stata screen, this is the directory Stata is currently reading from. Files are located in the `StataDatMan` folder in your user directory. Let's start by telling Stata where to look for these:

// change directory

## 

// Use dir to see what is in the directory:

##

* Now we can read in the `gss.dta` dataset:

##

* ## Generating & replacing variables
*
* **GOAL: You'll learn how to generate new variables or recode existing variables.** In particular, we will learn to use: 
*
* 1. `generate` (`gen`) to create new variables
* 2. `egenerate` (`egen`) to create new variables using more complicated calculations than `gen` allows
* 3. `replace` to replace existing variables
* 4. `recode` to change existing categorical variables


* ### Generate & Replace
*
* The `generate` command creates a new variables. Often, this is used in combination with the `replace` command and logic statements to create a new variable. Available logical operators include the following:
*
* | Operator | Meaning                  |
* |:---------|:-------------------------|
* | ==       | equal to                 |
* | !=       | not equal to             |
* | >        | greater than             |
* | >=       | greater than or equal to |
* | <        | less than                |
* | <=       | less than or equal to    |
* | &        | and                      |
* | |        | or                       |
*
* For example:

//create "hapnew" variable

##

//set to 0 if happy equals 1

##

//set to 1 if happy both and hapmar are greater than 3

##

// tabulate the new 

##


* ### Recode
*
* The `recode` command is basically `generate` and `replace` combined. You can `recode` an existing variable OR use `recode` to create a new variable (via the `gen` option).

// recode the wrkstat variable 

##

// recode wrkstat into a new variable named wrkstat2

##

// tabulate workstat

##

* The table below illustrates common forms of recoding:
*
* | Rule          | Example      | Meaning                  |                          
* |:--------------|:-------------|:-------------------------|
* | \#=\#         | 3=1          | 3 recoded to 1           |                          
* | \#\#=\#       | 2.=9         | 2 and . recoded to 9     |                          
* | \#/\#=\#      | 1/5=4        | 1 through 5 recoded to 4 |
* | nonmissing=\# | nonmiss=8    | nonmissing recoded to 8  |                          
* | missing=\#    | miss=9       | missing recoded to 9     |                          

* ### egen
*
* The `egen` command ("extensions" to the `gen` command) reaches beyond simple computations (var1 + var2, log(var1), etc.) to add descriptive stats, standardizations and more. For example, we can use `egen` to create a new variable that counts the number of "yes" responses on computer, email and internet use:

// count number of yes on use comp email and net 

##

* Here are some additional examples of `egen` in action:

// assess how much missing data each participant has:

##

// compare values on multiple variables

##


* You will need to refer to the documentation to discover what else `egen` can do: type `help egen` in Stata to get a complete list of available functions.

* ### Exercise 0
*
* 1.  Open the `gss.dta` data, `generate` a new variable that represents the squared value of `age`.

*#

* 2.  `generate` a new variable equal to "1" if `income` is greater than "19".

*#

* 3.  Create a new variable that counts the number of missing responses for each respondent. What is the maximum number of missing variables?

*#



* ## Missing values
*
* **GOAL: Learn how missing values are coded and how to recode them.**
*
* Stata's symbol for a missing value is a period `.` and this value is coded and treated as **positive infinity** (i.e., the largest possible value), so it's easy to make mistakes when making logical and relational comparisons!
*
* ### Making sure missingness is preserved 
*
* To identify highly educated women, we might use the command:

// generate and replace without considering missing values

##

// What happens to our missing values?

##


* It looks like around 66% have higher education, but look closer:

// generate hi_ed2, but only set a value if wifeduc is not missing

##

// only replace non-missing values

##

//check to see that missingness is preserved

##


* The correct value is 10%. Moral of the story? Be careful with missing values and remember that Stata considers missing values to be **positive infinity**!

* ### Bulk Conversion to missing values
*
* Often the data collection / generating procedure will have used some other value besides `.` to represent missing values. The `mvdecode` command will convert all these values to missing. For example:

##

* The `_all` command tells Stata to perform this conversion for all variables. Use this command carefully! If you have any variables where "999" is a legitimate value, Stata is going to recode it to missing. As an alternative, you could list var names separately rather than using `_all`.

* ## Variable types
*
* **GOAL: Learn about the two main types of variables that Stata uses: string and numeric.** 
*
* To be able to perform any mathematical operations, your variables need to be in a numeric format. Stata can store numbers with differing levels of precision, as described in the table below:
*
* | type   | Minimum                         | Maximum                        | being 0              | bytes |
* |:-------|:--------------------------------|:-------------------------------|:---------------------|:------|
* | byte   | -127                            | 100                            | +/-1                 | 1     |
* | int    | -32,767                         | 32,740                         | +/-1                 | 2     |
* | long   | -2,147,483,647                  | 2,147,483,620                  | +/-1                 | 4     |
* | float  | -1.70141173319\*10<sup>38</sup> | 1.70141173319\*10<sup>38</sup> | +/-10<sup>-38</sup>  | 4     |
* | double | -8.9884656743\*10<sup>307</sup> | 8.9884656743\*10<sup>307</sup> | +/-10<sup>-323</sup> | 8     |
*
* Precision for float is 3.795x10<sup>-8</sup>. Precision for double is 1.414x10<sup>-16</sup>.

* ### Converting to & from Strings
*
* Stata provides several ways to convert to and from strings. You can use `tostring` and `destring` to convert from one type to the other:

// convert degree to a string

##

// and back to a number

##

* Use `decode` and `encode` to convert to / from variable labels:

// convert degree to a descriptive string

##

// and back to a number with labels

##


* ### Converting strings to date / time
*
* Often date / time variables start out as strings --- you'll need to convert them to numbers using one of the conversion functions listed below:
*
* | Format | Meaning      | String-to-numeric conversion function |
* |:-------|:-------------|:--------------------------------------|
* | %tc    | milliseconds | clock(string, mask)                   |
* | %td    | days         | date(string, mask)                    |
* | %tw    | weeks        | weekly(string, mask)                  |
* | %tm    | months       | monthly(string, mask)                 |
* | %tq    | quarters     | quarterly(string, mask)               |
* | %ty    | years        | yearly(string, mask)                  |
*
* Date / time variables are stored as the number of units elapsed since 01 January 1960 00:00:00.000. For example, the `date` function returns the number of days since that time, and the `clock` function returns the number of milliseconds since that time.

// create string variable and convert to date

##


* ### Formatting numbers as dates
*
* Once you have converted a string to a number you can format it for display. You can either accept the defaults used by your formatting string or provide details to customize it.

// format so humans can read the date

##

// format with detail

##


* ### Exercise 1
*
* **Missing values, string conversion, & by processing**
*
* 1.  Recode values "99" and "98" on the variable `hrs1` as missing.

*#

* 2.  Recode the `marital` variable into a string variable and then back into a numeric variable.

*#

* 3.  Create a new variable that associates each individual with the average number of hours worked among individuals with matching educational degrees (see the last `by` example for inspiration).

*#



* ## Merging, appending, & collapsing 
*
* **GOAL: To learn the basic commands to merge, append, or join two dataset in Stata.** In particular:
*
* 1. How to append datasets 
* 2. How to merge datasets and types of merge 
* 3. Collapse from master data and create a new dataset of summary statistics

* ### Appending datasets
*
* Sometimes you have observations in two different datasets, or you'd like to add observations to an existing dataset. In this case you can use the `append` command to add observations to the end of the observations in the master dataset. For example:

clear

// from the append help file

webuse even
list
webuse odd
list

// Append even data to the end of the odd data

append using "http://www.stata-press.com/data/r14/even"
list
clear

* To keep track of where observations came from, use the `generate` option as shown below:

webuse odd
append using "http://www.stata-press.com/data/r14/even", generate(observesource)
list
clear

* There is a `force` option will allow for data type mismatches, but this is not recommended. Remember, `append` is for adding observations (i.e., rows) from a second data set to your current dataset.

* ### Merging datasets
*
* You can `merge` variables from a second dataset to the dataset you're currently working with. There are different ways that you might be interested in merging data:
*
* * Two datasets with same participant pool, one row per participant (1:1)
* * A dataset with one participant per row with a dataset with multiple rows per participant (1:many or many:1)
*
* Before you begin:
*
* 1. Identify the `ID` that you will use to merge your two datasets
* 2. Determine which variables you'd like to merge
* 3. Variable types must match across datasets (there is a `force` option to get around this, but it is not recommended)
*
* Note --- data do NOT have to be sorted prior to merging.

// Adapted from the merge help page

##

##

// keep only the matches (AKA "inner join")

##

* Remember, `merge` is for adding variables (i.e., columns) from a second data set.

* ### Merge Options
*
* There are several options that provide more fine-grain control over what happens to non-id columns contained in both data sets. If you've carefully cleaned and prepared the data prior to merging this shouldn't be an issue, but here are some details about how Stata handles this situation.
*
* * In standard merge, the current active dataset is the authority and WON'T CHANGE
* * If your current dataset has missing data and some of those values are not missing in your new dataset, specify `update` -- this will fill in missing data in the current dataset
* * If you want data from your new dataset to overwrite that in your current dataset, specify `replace update` --- this will replace current data with new data UNLESS the value is missing in the new dataset

* ### Many-to-many merges - joinby command 
*
* Stata allows you to specify merges like `merge m:m id` using `newdata.dta`, but it is difficult to imagine a situation where this would be useful. If you are thinking about using `merge m:m` chances are good that you actually need `joinby`. Please refer to the `joinby` help page for details. 

* ### Collapse
*
* `collapse` will take your current active dataset and create a new dataset of summary statistics
*
* * Useful in hierarchical linear modeling if you'd like to create aggregate, summary statistics
* * Can generate group summary data for many descriptive stats
* * Can also attach weights
*
* Before you `collapse`:
*
* * Save your current dataset and then save it again under a new name (this will prevent `collapse` from writing over your original data
* * Consider issues of missing data. Do you want Stata to use all possible observations? If not, the `cw` (casewise) option will make casewise deletions

// Adapted from the collapse help page

##

// mean and sd by hospital

##

* You could also generate different statistics for multiple variables.

* ### Exercise 2
*
* **Append, merge, & collapse**
*
* Open the `gss2.dta` dataset. This dataset contains only half of the variables that are in the complete gss dataset.
*
* 1.  Merge dataset `gss1.dta` with dataset `gss2.dta`. The identification variable is `id`.

*#

* 2.  Open the `gss.dta` dataset and merge in data from the `marital.dta` dataset, which includes income information grouped by individuals' marital status. The `marital.dta` dataset contains collapsed data regarding average statistics of individuals based on their marital status.

*#

* 3.  Open the `gssAppend.dta` dataset and create a new dataset that combines the observations in `gssAppend.dta` with those in `gssAddObserve.dta`.

*#

* 4.  Open the `gss.dta` dataset and create a new dataset that summarizes the mean and standard deviation of income based on individuals' degree status (`degree`). In the process of creating this new dataset, rename your three new variables.

*#



* ## Wrap-up
*
* ### Feedback
*
* These workshops are a work-in-progress, please provide any feedback to: help@iq.harvard.edu
*
* ### Resources
*
* * IQSS 
*     + Workshops: <https://dss.iq.harvard.edu/workshop-materials>
*     + Data Science Services: <https://dss.iq.harvard.edu/>
*     + Research Computing Environment: <https://iqss.github.io/dss-rce/>
*
* * HBS
*     + Research Computing Services workshops: <https://training.rcs.hbs.org/workshops>
*     + Other HBS RCS resources: <https://training.rcs.hbs.org/workshop-materials>
*     + RCS consulting email: <mailto:research@hbs.edu>
*
* * Stata
*     + UCLA website: <http://www.ats.ucla.edu/stat/Stata/>
*     + Stata website: <http://www.stata.com/help.cgi?contents>
*     + Email list: <http://www.stata.com/statalist/>