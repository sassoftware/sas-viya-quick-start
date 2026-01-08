## Copyright © 2025, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved.
##  SPDX-License-Identifier: Apache-2.0      


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
              LOAN_STATUS = lambda _df: _df.BAD.map({1:'Default', 0:'Repaid'})                        ## Map values of 1 and 0 with the values Default and Repaid        
       )
      .rename(columns=lambda colName:colName.lower().replace("_",""))                             ## Lowercase column names and remove underscores
)


## Preview the dataframe and number of missing values
print(df.head(5))


##
## Load the DataFrame to different locations in SAS Viya
##

# Load the DataFrame to the compute server as a SAS data set
SAS.df2sd(df, 'work.homeequity_py')


## Create a string with SAS code to connect to the CAS server, delete the global table if it exists, and then load data to CAS
## NOTE: You can also use the Python SWAT package to accomplish the same tasks below using all Python.

LoadToCAS = '''
* Connect to the CAS Server *;
cas mySession;

* Drop and load data to the CAS server *;
proc casutil;
	* Drop the global scope CAS table if it exists *;
	droptable casdata='homeequity_py' incaslib="casuser" quiet;

	* Send the SAS data set to the CAS server and promote the table *;
	load data=work.homeequity_py casout="homeequity_py" outcaslib="casuser" promote;

	* View in-memory CAS tables *;
	list tables;
quit;
'''

# Submit the above SAS code
SAS.submit(LoadToCAS)
