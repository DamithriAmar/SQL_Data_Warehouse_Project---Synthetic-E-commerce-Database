<h1>Fix for CSV Files</h1>
<h2>Found Errors in the CSV files:</h2>
<b>01. </b>Several rows contain double commas(,,)</br>
<b>02. </b>Several rows contain less number of data than the number of header rows.
<h2>Suggested Fixes</h2>
<b>01. </b>Replacing all the double-commas with a single-comma using a text file editor such as Notepad.</br>
<b>02. </b>Adding 'NULL' values at the end of each row if a row does not contain the required number of data.
