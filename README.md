# README

1. In order to use this repo, you can either __download it as a zip__ (click on the green button 'Clone or Download'), or __clone__ it somewhere on your computer from the command line: 

```
> git clone https://github.com/thierrymoudiki/ins-sirn-2018.git
```

2. If using the command line, access to the repo. Otherwise, go to point 3.: 

```
> cd ins-sirn-2018
> ls
```

You should see this: 
```
README.md	cv-data		functions	runME.R
```

3. In file `runME.R`, uncomment an execute line 1 only if you want to clean the environment. 

```
# rm(list=ls())
```

4. At line 4, in `runME.R`, provide the path to the directory of your computer containing `ins-sirn-2018` (provide it to variable `path_to_working_directory`)

```
# path to the directory containing folder 'ins-sirn-2018' here
path_to_working_directory <- ""
```

5. Execute the whole file `runME.R`, one section after the other.
