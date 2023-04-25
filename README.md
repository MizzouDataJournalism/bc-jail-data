# bc-jail-data
Data scrape and analysis on the county jail in Boone County, Missouri

Data is pulled every day from the following two websites, which are updated daily.
Boone County current detainees list: https://report.boonecountymo.org/mrcjava/servlet/RMS01_MP.I00030s
07:00 Report (everyone who was incarcerated between 7:00 am and 7:00 am the previous day): https://report.boonecountymo.org/mrcjava/servlet/RMS01_MP.I00090s

These datasets contain a lot of overlap, including many of the same individuals. At the same time, they have different demographic information, and the 07:00 report contains more detailed information about a person's booking time, bond, and other data points.

The ultimate goal of this project is to compile several months' of both datasets, combine them in a way that is useful, and use them to analyze the demographic make-up of the jail, who is returning to the jail most often and on what kinds of charges, and whether those who are bonded are staying out of jail.

This repository includes one RMD file used to do the daily scrape, saving each day of data into a master file for each respective dataset. This RMD -- jailscrape2.Rmd -- also contains code to create several other configurations of the data that may be useful for analysis later. The most important is called bcjmaster.csv, which is essentially a running list of each person who is incarcerated at the jail. It includes their booking date, charges, bond, and -- if they were released -- the last date they were present in the jail. If a person leaves the jail and returns on new charges, they will appear in this list twice.

Another RMD file, bcj_analysis.Rmd, contains additional code to analyze any trends present in the data. This file is a work-in-progress, as I am still collecting data every day. The first day of data collection was Dec. 1, 2022.
