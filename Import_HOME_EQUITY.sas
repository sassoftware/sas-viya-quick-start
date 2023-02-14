/*******************************************************************************/
/*  Copyright © 2022, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved. */
/*  SPDX-License-Identifier: Apache-2.0                                        */
/*******************************************************************************/


/*********************************************/
/* Read the home_equity.csv sample data from */ 
/*     the SAS Support Example Data website  */
/*     and create WORK.HOME_EQUITY.          */
/*********************************************/

filename data TEMP;

proc http 
   method="GET" 
   url="https://support.sas.com/documentation/onlinedoc/viya/exampledatasets/home_equity.csv" 
   out=data;
run;

/*  Import edu_hmeq.csv and create WORK.HOME_EQUITY */
proc import file="data" dbms=csv out=work.t_home_equity replace;
    guessingrows=5960;
run;

data work.home_equity;
    set work.t_home_equity;
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
    informat _all_;
run;

proc datasets lib=work nolist;
    delete t_home_equity;
run;

proc contents data=work.home_equity;
run;

filename data clear;

/*****************************************************************************/
/*  Create a default CAS session and create SAS librefs for existing caslibs */
/*  so that they are visible in the SAS Studio Libraries tree.               */
/*****************************************************************************/

cas; 
libname casuser cas caslib="casuser";
















