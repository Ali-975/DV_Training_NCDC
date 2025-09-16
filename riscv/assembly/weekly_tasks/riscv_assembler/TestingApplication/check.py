import sys 

def compare_files(file1, file2):
    diffs = 0
    with open(file1, 'r') as f1, open(file2, 'r') as f2:
        # Read lines from each file
        file1_lines = f1.readlines()
        file2_lines = f2.readlines()
    
    # Compare lines from both files
    for i, (line1, line2) in enumerate(zip(file1_lines, file2_lines)):
        if line1.upper() != line2.upper():
            diffs = diffs + 1
            print(f"Files differ at line {i + 1}:\n{file1}: {line1}\n{file2}: {line2}")
    
    if diffs == 0:
    # If all lines are identical
        return "Files are identical"
    else:
        return f"Total Differences: {diffs}"

if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("Usage: python script.py <file1> <file2>")
        sys.exit(1)
    
    file1 = sys.argv[1]
    file2 = sys.argv[2]
    
    # Compare files
    result = compare_files(file1, file2)
    print(result)
