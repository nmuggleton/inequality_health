# Load required libraries
library(data.table)  # For fast data manipulation
library(stringr)     # For string manipulation

# Read the file 'output.txt' into a data table without headers
files <- fread('params/output.txt', header = F)

# Remove rows where the first column (V1) contains the string 'Annual_Files'
files <- files[!str_detect(V1, 'Annual_Files')]

# Extract the year (a four-digit number) from the file names in the first column
files[, year := str_extract(V1, '\\d{4}')]

# Extract the product group (the four-digit number before an underscore) from the file names
files[, product_group := str_extract(V1, '(?<=Movement_Files/)\\d{1,4}(?=_)')]

# Extract the product module (the four-digit number before '_<year>.tsv') from the file names
files[, product_module := str_extract(V1, '\\d{4}(?=_\\d{4}.tsv)')]

# Write the columns 'year', 'product_group', and 'product_module' to 'array.txt'
# The output file has no row names, no column names, and uses tab as the separator
write.table(
  files[, .(year, product_group, product_module)],  # Select the desired columns
  file = 'params/array.txt',                        # Specify the output file
  row.names = F,                                    # Do not include row names
  col.names = F,                                    # Do not include column names
  sep = '\t',                                       # Use tab as the separator
  quote = F                                         # Do not quote the entries
)
