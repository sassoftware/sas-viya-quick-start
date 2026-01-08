/*******************************************************************************/
/*  Copyright © 2025, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved. */
/*  SPDX-License-Identifier: Apache-2.0                                        */
/*******************************************************************************/


/*********************************************************/
/* Run this program to load the HOMEEQUITY and CUSTOMER  */
/*     table used the SAS Viya Quick Start Videos.       */
/*********************************************************/

%macro loadQuickStart;
    /* Create copy of HOMEEQUITY in quick-start folder */

    %let fileName = %scan(&_sasprogramfile,-1,'/');
    %let path = %sysfunc(tranwrd(&_sasprogramfile, &fileName,));
    libname outlib "&path";

    %if %sysfunc(exist(sashelp.homeequity)) %then %do;
        %put NOTE: HOMEEQUITY in-memory table loaded from SASHELP.HOMEEQUITY;
        data outlib.homeequity work.homeequity;
		    set sashelp.homeequity;
		run;
    %end;

    %else %do;
        
        %put NOTE: HOMEEQUITY in-memory table loaded from homeequity.csv;
		
		/*  Import homeequity.csv and create HOMEEQUITY.sas7bdat in quick-start folder */
		proc import file="&path/homeequity.csv" dbms=csv out=outlib.homeequity replace;
		    guessingrows=5960;
		run;
		
		proc datasets lib=outlib memtype=data nolist;
		    modify homeequity;
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
        proc copy out=work in=outlib;
		    select homeequity;
        run;
		
    %end;

	/*  Import customer.csv and create CUSTOMER.sas7bdat in quick-start folder */
	proc import file="&path/customer.csv" dbms=csv out=outlib.customer replace;
	    guessingrows=10000;
	run;	

    /*  Load and promote HOMEEQUITY and CUSTOMER into memory in the CASUSER caslib. */
    /*  Save HOMEEQUITY.sashdat in the CASUSER caslib so it is saved on disk.  */

    cas mysession;
    proc casutil;
        droptable casdata="homeequity" incaslib="casuser" quiet;
        droptable casdata="customer" incaslib="casuser" quiet;
        droptable casdata="countrylookup" incaslib="casuser" quiet;

        load data=outlib.homeequity outcaslib="casuser" casout="homeequity" promote;
        load data=outlib.customer outcaslib="casuser" casout="customer" promote;
        load file="&path/countrylookup.csv" outcaslib="casuser" casout="countrylookup";

        save casdata="homeequity" incaslib="casuser" casout="homeequity" outcaslib="casuser" replace;
        save casdata="customer" incaslib="casuser" casout="customer.parquet" outcaslib="casuser" replace;
        save casdata="countrylookup" incaslib="casuser" casout="countrylookup.csv" outcaslib="casuser" replace;

        droptable casdata="countrylookup" incaslib="casuser" quiet;

        list tables incaslib="casuser";
    quit;
    cas mysession terminate;

    libname outlib clear;

%mend loadQuickStart;

%loadQuickStart