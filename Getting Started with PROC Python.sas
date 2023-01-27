* Python code to access and prepare the data *;
proc python;
submit;

## Packages and Options
import pandas as pd
import numpy as np
pd.set_option('display.max_columns', None)


## Access Data
df_raw = pd.read_csv(r'https://support.sas.com/documentation/onlinedoc/viya/exampledatasets/home_equity.csv')


## Prepare Data
df = (df_raw
      .fillna(df_raw[df_raw.select_dtypes(include = np.number).columns.to_list()].mean())         ## Fill all numeric missing values with the mean
      .fillna(df_raw[df_raw.select_dtypes(include = object).columns.to_list()].mode().iloc[0])    ## Fill all character missing values with the mode
      .assign(DIFF = lambda _df: _df.MORTDUE - _df.VALUE,                                         ## Difference between mortgage due and value
              LOAN_STATUS = lambda _df: _df.BAD.map({1:'Default', 0:'Repaid'})                    ## Map values of 1 and 0 with the values Default and Repaid        
       )
      .rename(columns=lambda colName:colName.lower().replace("_",""))                             ## Lowercase column names and remove underscores
)


## Preview the dataframe and number of missing values
print(df.head(5))
print(df.isna().sum())


## Write the DataFrame as a SAS data set in the WORK library
SAS.df2sd(df, 'work.home_equity_compute_sas')

endsubmit;
quit;


* Connect to the CAS Server *;
cas conn;

* Drop and then load data to the CAS server *;
proc casutil;
	* Drop the global scope CAS table if it exists *;
	droptable casdata='home_equity_cas_sas' incaslib="casuser" quiet;

	* Send the SAS data set to the CAS server and promote the table *;
	load data=work.home_equity_compute_sas casout="home_equity_cas_sas" outcaslib="casuser" promote;

	* View in-memory CAS tables *;
	list tables;
quit;

* Terminate the CAS connection *;
cas conn terminate;