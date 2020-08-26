# August 2020 puzzle 

## Ben's problem: reading excel spreadsheets efficiently into R: relatively simple example. 

I find I have recently had to read data typically from multi-sheet files, often from ONS. Format is variously in  .xls , .xlsx. or (single-sheet files) .csv.  I usually want data only on a few columns and selected rows.  The software I have found for .xls/.xlxs files (readxl) seems to require me to count the lines before the data proper starts or specify the entire  range of the data, and tends to leave numerical columns as characters. OK to sort out myself once or twice, but I thought that better guessing by software might be possible.  Ideally I thought it would also be good to be able to select columns and sub-groups of rows (by value of one of the columns) at the time of reading – but perhaps those are best selected as separate stages. 

Example: COVID deaths from ONS by Local Authority (I also needed this by MSOA, but we will leave that), which are on Table 2 of: 

https://www.ons.gov.uk/file?uri=%2fpeoplepopulationandcommunity%2fbirthsdeathsandmarriages%2fdeaths%2fdatasets%2fdeathsinvolvingcovid19bylocalareaanddeprivation%2f1march2020to30june2020/referencetablesworkbook2.xlsx 

I only needed the first 5 character/factor columns and the last 4 numerical ones (and only for COVID-16, both sexes combined). One issue with this file and commonly is that column names in the excel file are effectively spread over two rows (super- and sub-heading; here Month and deaths/rate/etc).

## Jocelyn's problem: reading excel spreadsheets efficiently into R: complicated example
 
What makes it complicated is:

1. Sheets within a workbook
2. Excel formatting (merged cells)
3. Multiple column titles in each sheet
4. Column titles for each sheet can be distinct
5. Rows for each sheet can be distinct
6. Non-specific column titles (Missing)
