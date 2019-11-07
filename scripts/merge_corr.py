import pandas as pd

files = snakemake.input

dfs = [pd.read_csv(f, sep='\t') for f in files]

final_df = pd.concat(dfs, ignore_index=True, sort=False)
final_df.sort_values(['p.value_TransFnorm'], inplace=True)
final_df = final_df.loc[final_df['p.value_TransFnorm'] < 0.05]

final_df.to_csv(snakemake.output[0], sep='\t', index=False)
