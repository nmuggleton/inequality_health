import os
import pandas as pd
import re

def process_file(file, dir_path, cols_dict):
    # Create a key for the dictionary
    key = os.path.splitext(file)[0]
    # Extract the year from the filename
    year_match = re.search(r'20\d{2}', key)
    if year_match:
        year = int(year_match.group())
    else:
        print(f"No year found in filename {file}")
        return None
    # Determine which columns to load based on the year
    usecols = cols_dict.get(year)
    if usecols is None:
        print(f"No column definition found for year {year}")
        return None
    try:
        # Try to read the .xlsx file into a DataFrame
        df = pd.read_excel(
            os.path.join(dir_path, file),
            engine='openpyxl',
            usecols=usecols,
            nrows=1000  # Only read the first 1000 rows for now
        )
        print(file)
        return df
    except Exception as e:
        # If an error occurs, print the error message and continue with the next file
        print(f"Error reading file {file}: {e}")
        return None

dir_path = os.getcwd()  # Get the current working directory

# Get a list of all .xlsx files in the directory
xls_files = [f for f in os.listdir(dir_path) if f.endswith('.xlsx')]
years = [re.search(r'20\d{2}', f).group() for f in xls_files if re.search(r'20\d{2}', f)]

# Create the dictionary
year_file_dict = dict(zip(years, xls_files))

# Sort the dictionary by keys (years)
files = sorted(year_file_dict.items())

# Initialize an empty dictionary to hold your DataFrames
dfs = {}

# Define the columns to load for each year
cols_dict = {
    2011: [
        'househiold ID',  # Household ID
        'Survey number',  # Survey number
        'Q1_Ailment5 Anxiety/Depression',  # Anxiety/Depression
        'Q1_Ailment20 Headache - chronic/tension/migraine',  # Headache - chronic/tension/migraine
        'Q1_Ailment21 Heart Disease/Heart Attack/Angina/Heart Failure',  # Heart Disease/Heart Attack/Angina/Heart Failure
        'Q1_Ailment22 High Blood Pressure/Hypertension',    # High Blood Pressure/Hypertension
        'Q1_Ailment24 Insomnia/Sleepless',  # Insomnia/Sleepless
        'Q7 Age Break',     # Which of the following age breaks best describes this household member?
        'Q8',   # Is this household member a regular smoker of cigarettes or other tobacco products?  By “regular” we mean smokes at least once a day.
        'Q13a_yy',  # What is his/her date of birth?
        'Q14'   # Is this household member male (1) or female (2)
    ],
    2012: [
        'Household ID',
        'Survey number',  # Survey number
        'Q1_Ailment5 Anxiety/Depression',  # Anxiety/Depression
        'Q1_Ailment20 Headache - chronic/tension/migraine',  # Headache - chronic/tension/migraine
        'Q1_Ailment21 Heart Disease/Heart Attack/Angina/Heart Failure',  # Heart Disease/Heart Attack/Angina/Heart Failure
        'Q1_Ailment22 High Blood Pressure/Hypertension',    # High Blood Pressure/Hypertension
        'Q1_Ailment24 Insomnia/Sleepless',  # Insomnia/Sleepless
        'Q7 Age Break',     # Which of the following age breaks best describes this household member?
        'Q8',   # Is this household member a regular smoker of cigarettes or other tobacco products?  By “regular” we mean smokes at least once a day.
        'Q13a_yy',  # What is his/her date of birth?
        'Q14'   # Is this household member male (1) or female (2)
    ],
    2013: [
        'househiold ID',
        'Survey number',  # Survey number
        'Q1_Ailment5 Anxiety/Depression',  # Anxiety/Depression
        'Q1_Ailment20 Headache - chronic/tension/migraine',  # Headache - chronic/tension/migraine
        'Q1_Ailment21 Heart Disease/Heart Attack/Angina/Heart Failure',  # Heart Disease/Heart Attack/Angina/Heart Failure
        'Q1_Ailment22 High Blood Pressure/Hypertension',    # High Blood Pressure/Hypertension
        'Q1_Ailment24 Insomnia/Sleepless',  # Insomnia/Sleepless
        'Q7 Age Break',     # Which of the following age breaks best describes this household member?
        'Q8',   # Is this household member a regular smoker of cigarettes or other tobacco products?  By “regular” we mean smokes at least once a day.
        'Q13a_yy',  # What is his/her date of birth?
        'Q14'   # Is this household member male (1) or female (2)
    ],
    2014: [
        'Household ID',
        'Survey number',  # Survey number
        'Q1_Ailment5 Anxiety/Depression',  # Anxiety/Depression
        'Q1_Ailment20 Headache - chronic/tension/migraine',  # Headache - chronic/tension/migraine
        'Q1_Ailment21 Heart Disease/Heart Attack/Angina/Heart Failure',  # Heart Disease/Heart Attack/Angina/Heart Failure
        'Q1_Ailment22 High Blood Pressure/Hypertension',    # High Blood Pressure/Hypertension
        'Q1_Ailment24 Insomnia/Sleepless',  # Insomnia/Sleepless
        'Q7 Age Break',     # Which of the following age breaks best describes this household member?
        'Q8',   # Is this household member a regular smoker of cigarettes or other tobacco products?  By “regular” we mean smokes at least once a day.
        'Q13a_yy',  # What is his/her date of birth?
        'Q14'   # Is this household member male (1) or female (2)
    ],
    2015: [
        'Household Id',
        'Survey number',  # Survey number
        'Q1_Ailment5 Anxiety/Depression',  # Anxiety/Depression
        'Q1_Ailment20 Headache - chronic/tension/migraine',  # Headache - chronic/tension/migraine
        'Q1_Ailment21 Heart Disease/Heart Attack/Angina/Heart Failure',  # Heart Disease/Heart Attack/Angina/Heart Failure
        'Q1_Ailment22 High Blood Pressure/Hypertension',    # High Blood Pressure/Hypertension
        'Q1_Ailment24 Insomnia/Sleepless',  # Insomnia/Sleepless
        'Q7 Age Break',     # Which of the following age breaks best describes this household member?
        'Q8',   # Is this household member a regular smoker of cigarettes or other tobacco products?  By “regular” we mean smokes at least once a day.
        'Q13a_yy',  # What is his/her date of birth?
        'Q14'   # Is this household member male (1) or female (2)
    ],
    2016: [
        'Household ID',   # Household ID
        'survey number',  # Survey number
        'Q31_mem1_Ailment19',  # Anxiety/Depression
        'Q31_mem2_Ailment19',  # Anxiety/Depression
        'Q31_mem2_Ailment19',  # Anxiety/Depression
        'Q31_mem2_Ailment19',  # Anxiety/Depression
        'Q31_mem2_Ailment19',  # Anxiety/Depression
        'Q31_mem2_Ailment19',  # Anxiety/Depression
        'Q31_mem2_Ailment19',  # Anxiety/Depression
        'Q31_mem2_Ailment19',  # Anxiety/Depression
        'Q31_mem2_Ailment19',  # Anxiety/Depression
        'Q16_Ailment29',  # Headache - migraine (missing 28 chronic/tension)
        'Q16_Ailment30',  # Heart Disease/Heart Attack/Angina/Heart Failure
        'Q16_Ailment32',  # High Blood Pressure/Hypertension
        'Q16_Ailment35',  # Insomnia/Sleepless
        'Q7 Age Break',
        'Q8',
        '',  #
        'Q14'
    ],
    # ... (add more years here) ...
}

for year, file in files:
    df = process_file(file, dir_path, cols_dict)
    if df is not None:
        dfs[file] = df


df = pd.read_excel(
    os.path.join(dir_path, '2016_160269_HealthCare_ParsedData.xlsx'),
    engine='openpyxl',
    nrows=100  # Only read the first 1000 rows for now
)

df.columns.tolist()