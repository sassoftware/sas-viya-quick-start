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


## Preview the dataframe
print(df.head(5))
print(df.isna().sum())


## Create a string with SAS code to connect to CAS server, reference the casuser caslib, and delete the global table if it exists
prepareLoadingToCAS = '''
	cas conn;
	libname casuser cas caslib='casuser';
	proc cas;
		table.dropTable / name='hmeq_python', caslib='casuser', quiet=TRUE;
	quit;
'''
## Submit SAS code
SAS.submit(prepareLoadingToCAS)


## Load the DataFrame to different locations in SAS Viya

# Load to dataframe to the CAS server for use in other Viya applications
SAS.df2sd(df, 'casuser.hmeq_python(PROMOTE=YES)')

# Load the dataframe to the compute server
SAS.df2sd(df, 'work.hmeq')