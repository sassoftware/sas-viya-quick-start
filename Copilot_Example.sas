%let fileName = %scan(&_sasprogramfile, -1, '/');
%let path = %sysfunc(tranwrd(&_sasprogramfile, &fileName, ));
libname out "&path";

data out.homeequity;
set sashelp.homeequity;
ltv=Loan/Value;
label ltv="Loan to Value Ratio";
format ltv percent6.1;
if bad = 0 then LoanStatus = "Paid" else if bad = 1 then LoanStatus = "Default";
run;
