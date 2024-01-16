/*******************************************************************************/
/*  Copyright © 2022, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved. */
/*  SPDX-License-Identifier: Apache-2.0                                        */
/*******************************************************************************/


/***************************************************/
/* Run this program to load the HOME_EQUITY        */
/*     table used the SAS Viya Quick Start Videos. */
/***************************************************/

%macro loadHomeEquity;
    /* Create copy of HOMEEQUITY in quick-start folder */

    %let fileName = %scan(&_sasprogramfile,-1,'/');
    %let path = %sysfunc(tranwrd(&_sasprogramfile, &fileName,));
    libname outlib "&path";

    %if %sysfunc(exist(sashelp.homeequit)) %then %do;
        %put NOTE: HOME_EQUITY in-memory table loaded from SASHELP.HOMEEQUITY;
        data outlib.home_equity;
		    set sashelp.homeequity;
		run;
    %end;

    %else %do;
        
		filename data TEMP;
        %put NOTE: HOME_EQUITY in-memory table loaded from home_equity.csv on support.sas.com;
		proc http 
		   method="GET" 
		   url="https://support.sas.com/documentation/onlinedoc/viya/exampledatasets/home_equity.csv" 
		   out=data;
		run;
		
		/*  Import home_equity.csv and create WORK.HOMEEQUITY */
		proc import file="data" dbms=csv out=outlib.home_equity replace;
		    guessingrows=5960;
		run;
		
		proc datasets lib=outlib memtype=data nolist;
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
		quit;
		
		filename data clear;			
    %end;

    /*  Load and promote the HOME_EQUITY into memory in the CASUSER caslib. */
    /*  Save HOME_EQUITY.sashdat in the CASUSER caslib so it is saved on disk.  */

    cas mysession;
    proc casutil;
        droptable casdata="home_equity" incaslib="casuser" quiet;
        load data=outlib.home_equity outcaslib="casuser" casout="home_equity" promote;
        save casdata="home_equity" incaslib="casuser" casout="home_equity" outcaslib="casuser" replace;
        list tables incaslib="casuser";
    quit;
    cas mysession terminate;

    libname outlib clear;


%mend loadHomeEquity;

%loadHomeEquity
