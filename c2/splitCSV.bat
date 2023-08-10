@echo off

rem Get the input and output directories
set input_file=owid-covid-data.csv
set output_dir=zz_split_dataset

rem Create the output directory if it doesn't exist
if not exist "%output_dir%" (
  mkdir "%output_dir%"
)

rem Get the number of rows in the input file
for /f %%i in ('type "%input_file%" ^| find /c /v ""') do set row_count=%%i
echo The number of rows in the input file is %row_count%

rem Calculate the number of chunks
set /a chunk_count=(%row_count% + 329) / 330
echo The number of chunks is %chunk_count%

rem Initialize row counter
set start_row=1

rem Iterate over the chunks
for /l %%i in (1,1,%chunk_count%) do (
  rem Set the end row number for the current chunk
  set /a end_row=start_row+329
  
  rem Create the output file name
  set output_file="%output_dir%\part_%%i.csv"
  echo The output file name for chunk %%i is %output_file%

  rem Write the chunk to the output file
  (for /f "skip=%start_row% tokens=*" %%j in (%input_file%) do (
    echo %%j
    set /a start_row+=1
    if !start_row! gtr %end_row% goto :next_chunk
  )) > %output_file%

  :next_chunk
  echo Writing chunk %%i to file...
)

echo Done!

