/*******************************************************************************/
/*  Copyright © 2022, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved. */
/*  SPDX-License-Identifier: Apache-2.0                                        */
/*******************************************************************************/


/******************************************/
/* SAS Program Executed on Compute Server */
/******************************************/

title "Compute Server Program";

libname mydata "c:/mydata";

data mydata.home_equity;
    length LOAN_OUTCOME $ 7;
    set work.home_equity;
    LTV=MortDue/Value;
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

/*************************************************************/
/* SAS Program Executed on CAS Server with CAS-Enabled Steps */
/*************************************************************/

cas mySession;

/* Option #1: Load Data into Memory via CASUTIL Step */
proc casutil;
    load data=work.home_equity outcaslib="casuser" casdata="home_equity";
quit;

/* Option #2: Load Data into Memory via DATA Step */
caslib _all_ assign;

title "CAS-Enabled PROCS";
data casuser.home_equity;
    length LOAN_OUTCOME $ 7;
    set work.home_equity;
    LTV=MortDue/Value;
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

/************************************************/
/* SAS Program Executed on CAS Server with CASL */
/************************************************/

cas mySession;
caslib _all_ assign;

title "CASL Results";
proc cas;
    tbl={name='home_equity', caslib='casuser'};
    source ds;
        data casuser.home_equity;
            length LOAN_OUTCOME $ 7;
            set work.home_equity;
            LTV=MortDue/Value;
            CITY=propcase(City);
            if BAD=0 then LOAN_OUTCOME='Paid';
                else LOAN_OUTCOME='Default';
            label LTV='Loan to Value Ratio'
                  LOAN_OUTCOME='Loan Outcome';
            format LTV percent6.;
        run;
    endsource;
    table.dropTable / name=tbl['name'], caslib=tbl['caslib'], quiet=true;
    /* update the path to match location of HOME_EQUITY.sas7bdat in Files */
    upload path="/export/sas-viya/homes/user5/Studio Video/HOME_EQUITY.sas7bdat";
    dataStep.runCode / code=ds;
    table.columnInfo / 
        table=tbl;
    simple.freq / 
        table=tbl, 
        inputs={'Loan_Outcome', 'Reason', 'Job'};
    simple.summary / 
        table=tbl, 
        input={'Loan', 'MortDue', 'Value', 'DebtInc'}, 
        casOut={name='orders_sum', replace=true};
quit;
title;

cas mySession terminate;



