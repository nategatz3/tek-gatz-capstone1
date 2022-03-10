import pandas as pd
import sqlalchemy

### df = "Data Frame" - Technically any variable could be used. But, "pandas.read_sql("Table_name",configuration)" make a Data Frame so df. ### Also con = Configuration ###

con = sqlalchemy.create_engine('mysql+pymysql://root:Password123@localhost/tractortek')
dfone = pd.read_sql("sales",con)

lenone = len(dfone)
print(f"The amount of records in 'sales' table is: {lenone}")

print(dfone.dtypes)
