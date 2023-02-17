/*******************************************************************************/
/*  Copyright © 2022, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved. */
/*  SPDX-License-Identifier: Apache-2.0                                        */
/*******************************************************************************/

/***************************/
/* Create work.home_equity */
/***************************/

%let fileName = %scan(&_sasprogramfile,-1,'/');
%let path = %sysfunc(tranwrd(&_sasprogramfile, &fileName,));
%include "&path/Load_Quick_Start_Data.sas";


/******************************************************/
/* Scenario 1: SAS Program Executed on Compute Server */
/******************************************************/

title "Compute Server Program";

libname mydata "c:\mydata";

data mydata.home_equity;
    length LOAN_OUTCOME $ 7;
    set work.home_equity;
    if Value ne . and MortDue ne . then LTV=MortDue/Value;
    CITY=propcase(City);
    if BAD=0 then LOAN_OUTCOME='Paid';
        else LOAN_OUTCOME='Default';
    label LTV='Loan to Value Ratio'
          LOAN_OUTCOME='Loan Outcome';
    format LTV percent6.;
run;

proc contents data=mydata.home_equity;
run;
title;

proc freq data=mydata.home_equity;
    tables Loan_Outcome Reason Job;
run;

proc means data=mydata.home_equity noprint;
    var Loan DebtInc LTV;
    output out=home_equity_summary;
run;


/*************************************************************************/
/* Scenario 2: SAS Program Executed on CAS Server with CAS-Enabled Steps */
/*************************************************************************/

cas mySession;

/* Option #1: Load Data into Memory via CASUTIL Step */
proc casutil;
    load data=work.home_equity outcaslib="casuser" casdata="home_equity";
quit;

/* Option #2: Load Data into Memory via DATA Step */
* Assign librefs to all caslibs;
caslib _all_ assign;

* Assign libref CASUSER to corresponding caslib;
*libname casuser cas caslib=casuser;

title "CAS-Enabled PROCS";
data casuser.home_equity;
    length LOAN_OUTCOME $ 7;
    set work.home_equity;
    if Value ne . and MortDue ne . then LTV=MortDue/Value;
    CITY=propcase(City);
    if BAD=0 then LOAN_OUTCOME='Paid';
        else LOAN_OUTCOME='Default';
    label LTV='Loan to Value Ratio'
          LOAN_OUTCOME='Loan Outcome';
    format LTV percent6.;
run;

proc contents data=casuser.home_equity;
run;

proc freqtab data=casuser.home_equity;
    tables Loan_Outcome Reason Job;
run;

proc mdsummary data=casuser.home_equity;
    var Loan MortDue Value DebtInc;
    output out=casuser.home_equity_summary;
run;

cas mySession terminate;


/************************************************************/
/* Scenario 3: SAS Program Executed on CAS Server with CASL */
/************************************************************/

cas mySession;

title "CASL Results";
proc cas;
  * Create dictionary to reference home_equity table in Casuser;
    tbl={name='home_equity', caslib='casuser'};
  * Create CASL variable named DS to store DATA step code. Both 
      input and output tables must be in-memory;
    source ds;
        data casuser.home_equity;
            length LOAN_OUTCOME $ 7;
            set casuser.home_equity;
            if Value ne . and MortDue ne . then LTV=MortDue/Value;
            CITY=propcase(City);
            if BAD=0 then LOAN_OUTCOME='Paid';
                else LOAN_OUTCOME='Default';
            label LTV='Loan to Value Ratio'
                  LOAN_OUTCOME='Loan Outcome';
            format LTV percent6.;
        run;
    endsource;
  * Drop home_equity from casuser if it exists;
    table.dropTable / name=tbl['name'], caslib=tbl['caslib'], quiet=true;
  * Load home_equity.sas7bdat to casuser;
    upload path="&path/home_equity.sas7bdat" 
        casout={caslib="casuser", name="home_equity", replace="true"};
  * Execute DATA step code;
    dataStep.runCode / code=ds;
  * List home_equity column attributes, similar to PROC CONTENTS;
    table.columnInfo / 
        table=tbl;
  * Generate frequency report, similar to PROC FREQ;
    simple.freq / 
        table=tbl, 
        inputs={'Loan_Outcome', 'Reason', 'Job'};
  * Generate summary table, similar to PROC MEANS;
    simple.summary / 
        table=tbl, 
        input={'Loan', 'MortDue', 'Value', 'DebtInc'}, 
        casOut={name='orders_sum', replace=true};
quit;
title;

cas mySession terminate;
