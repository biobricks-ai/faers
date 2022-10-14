import pandas as pd
import sys
import pyarrow as pyarrow
import fastparquet as fastparquet

InFileName = sys.argv[1]
OutFileName = sys.argv[2]

print(f"csv2parquet: Input file {InFileName}")
print(f"csv2parquet: Output file {OutFileName}")
DF = pd.read_csv(InFileName, index_col=False, sep='$')
DF.to_parquet(OutFileName)