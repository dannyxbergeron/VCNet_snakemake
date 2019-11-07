import pandas as pd
import numpy as np

file = snakemake.input[0]
# file = '/home/danx/Documents/projects/VCNet_gene_correlation/data/raw_data/snoRNA_filtered_1tpm_mean_matrix.tsv'

data = pd.read_csv(file, sep='\t')

splitted = [df_split for df_split in np.array_split(data, len(snakemake.output))]

for idx, df in enumerate(splitted):

    df.to_csv(snakemake.output[idx], sep='\t', index=False)
