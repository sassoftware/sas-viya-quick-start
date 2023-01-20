/*******************************************************************************/
/*  Copyright © 2022, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved. */
/*  SPDX-License-Identifier: Apache-2.0                                        */
/*******************************************************************************/


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
              BAD_CAT = lambda _df: _df.BAD.map({1:'Default', 0:'Repaid'})                        ## Map values of 1 and 0 with the values Default and Repaid        
       )
      .rename(columns=lambda colName:colName.lower().replace("_",""))                             ## Lowercase column names and remove underscores
)

SAS.df2sd(df, 'work.hmeq')

endsubmit;
quit;

* Connect to the CAS Server *;
cas conn;

* Drop the global scope CAS table if it exists *;
proc cas;
	table.dropTable / name='hmeq_sas', caslib='casuser', quiet=TRUE;
quit;

* Send the SAS data set to the CAS server *;
proc casutil;
	load data=work.hmeq casout="hmeq_sas" outcaslib="casuser" promote;
quit;

* Terminate the CAS connection *;
cas conn terminate;