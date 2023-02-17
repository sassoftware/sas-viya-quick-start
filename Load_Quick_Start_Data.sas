/*******************************************************************************/
/*  Copyright © 2022, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved. */
/*  SPDX-License-Identifier: Apache-2.0                                        */
/*******************************************************************************/


/***************************************************/
/* Run this program to load the home_equity.csv    */
/*     files used the SAS Viya Quick Start Videos. */
/***************************************************/

 /* Read the home_equity.csv sample data from the SAS Support Example Data website */
filename data TEMP;

proc http 
   method="GET" 
   url="https://support.sas.com/documentation/onlinedoc/viya/exampledatasets/home_equity.csv" 
   out=data;
run;

/*  Import home_equity.csv and create WORK.HOME_EQUITY */
proc import file="data" dbms=csv out=work.home_equity replace;
    guessingrows=5960;
run;

proc datasets lib=work memtype=data nolist;
    modify home_equity;
    label APPDATE="Loan Application Date"
          BAD="Loan Status"
          CITY="City"
          CLAGE="Age of Oldest Credit Line (months)"
          CLNO="Number of Credit Lines"
          DEBTINC="Debt to Income Ratio"
          DELINQ="Number of Delinquent Credit Lines"
          DEROG="Number of Derogatory Reports"
          DIVISION="Division"
          JOB="Job Category"
          LOAN="Amount of Loan Request"
          MORTDUE="Amount Due on Existing Mortgage"
          NINQ="Number of Recent Credit Inquiries"
          REASON="Loan Purpose"
          REGION="Region"
          STATE="State"
          VALUE="Value of Current Property"
          YOJ="Years at Present Job";
    format APPDATE date9.
           CLAGE comma8.1
           LOAN MORTDUE VALUE dollar12.
           DEBTINC 8.1
           BAD CITY CLNO DELINQ DEROG DIVISION JOB NINQ REASON REGION STATE YOJ;
    attrib _all_ informat=;
run;

filename data clear;

/* Create copy of HOME_EQUITY in quick-start folder */

%let fileName = %scan(&_sasprogramfile,-1,'/');
%let path = %sysfunc(tranwrd(&_sasprogramfile, &fileName,));
libname temp "&path";

proc copy in=work out=temp;
    select home_equity;
run;

libname temp clear;

/*  Load the HOME_EQUITY into memory in the CASUSER caslib. */
/*  Save HOME_EQUITY.sashdat in the CASUSER caslib so it is saved on disk.  */

cas mysession;
proc casutil;
    droptable casdata="home_equity" incaslib="casuser" quiet;
    load data=work.home_equity outcaslib="casuser" casout="home_equity";
    save casdata="home_equity" incaslib="casuser" casout="home_equity" outcaslib="casuser" replace;
    list files incaslib="casuser";
quit;
cas mysession terminate;
