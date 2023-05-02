import pandas as pd
import numpy as np
sales_data = pd.read_csv("./data/SalesKaggle3.csv")
whole_description = sales_data.describe()
min = sales_data.min()
max = sales_data.min()
columnName = "StrengthFactor"
# print(pd.isnull(sales_data))
# print(np.where(sales_data.applymap(lambda x: x == '')))
columnVals = sales_data[columnName]
# print(columnVals.sort_values(ascending=True))
uniqueVals = columnVals.nunique()
print(uniqueVals)