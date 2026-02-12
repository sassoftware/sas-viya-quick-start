## Copyright © 2022, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved.
##  SPDX-License-Identifier: Apache-2.0                                        


## Packages and Options
import pandas as pd

## Access Data
df = pd.read_csv(r'https://support.sas.com/documentation/onlinedoc/viya/exampledatasets/loan_customers.csv')

SAS.df2sd(df, 'work.loan_customers')