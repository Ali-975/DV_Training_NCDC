#!/usr//bin/python3
#
# driver.py - The driver tests the correctness of the student's cache
#     simulator. It uses ./test-csim to check the correctness of the
#     simulator 
#
import subprocess;
import re;
import os;
import sys;
import optparse;

#
# main - Main function
#
def main():

    # Configure maxscores here
    maxscore= {};
    maxscore['csim'] = 48

    # Check the correctness of the cache simulator
    print("Testing cache simulator")
    print("Running ./test-csim")
    p = subprocess.Popen("./test-csim", 
                         shell=True, stdout=subprocess.PIPE)
    stdout_data = p.communicate()[0].decode('utf-8')

    # Emit the output from test-csim
    stdout_data = re.split('\n', stdout_data)
    for line in stdout_data:
        if re.match("TEST_CSIM_RESULTS", line):
            resultsim = re.findall(r'(\d+)', line)
        else:
            print("%s" % (line))

    # Compute the scores 
    csim_cscore = list(map(int, resultsim[0:1]))

    # Summarize the results
    print("\nCache Lab summary:")
    print("%-22s%8s%10s%12s" % ("", "Points", "Max pts", "Misses"))
    print("%-22s%8.1f%10d" % ("Csim correctness", csim_cscore[0], 
                              maxscore['csim']))
 
    
# execute main only if called as a script
if __name__ == "__main__":
    main()
