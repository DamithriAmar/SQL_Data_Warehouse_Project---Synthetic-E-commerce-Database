import csv

with open(r'C:\Users\damit\Downloads\archive\returns.csv', mode='r', newline='', encoding='utf-8') as infile, \
     open(r'C:\Users\damit\Desktop\new_returns.csv', mode='w', newline='', encoding='utf-8') as outfile:
    
    reader = csv.reader(infile)
    writer = csv.writer(outfile)
    
    # Read the first row to determine the expected number of columns
    header = next(reader, None)
    
    if header:
        expected_columns = len(header)
        writer.writerow(header)  # Write the header to the new file
        
        for row in reader:
            missing = expected_columns - len(row)
            
            if missing > 0:
                row.extend(['Null'] * missing)
                
            writer.writerow(row)

print("Successfully Completed!!")