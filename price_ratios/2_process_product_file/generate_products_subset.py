
import os
import pandas as pd

# Get the TMPDIR environment variable
tmpdir = os.getenv('TMPDIR')
product_module_code = os.getenv('PRODUCT_MODULE')
product_group_code = os.getenv('PRODUCT_GROUP')

# Define the path to the TSV file
prod_file = os.path.join(tmpdir, 'products.tsv')

# Load the TSV file into a pandas DataFrame with 'ISO-8859-1' encoding
df = pd.read_csv(
    prod_file,
    sep='\t',
    encoding='ISO-8859-1',
    usecols=[
        'upc',
        'upc_ver_uc',
        'product_module_code',
        'product_group_code',
        'size1_amount',
        'size1_units'
    ],
    dtype = {'upc': 'str'}
)


df = df.loc[
    (df['product_module_code'] == int(product_module_code)) &
    (df['product_group_code'] == int(product_group_code)) &
    (df['upc_ver_uc'] == 1)
    ]

df =  df[['upc', 'size1_amount', 'size1_units']]

# Save the subset of products to a new TSV file
df.to_csv(os.path.join(tmpdir, 'size1_units.tsv'), sep='\t', index=False)
