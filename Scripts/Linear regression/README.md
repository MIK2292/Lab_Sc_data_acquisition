# Linear Regression using Python 
## UPDATE: now it does the regression considering the Y error, but not X error

Usage: 
1. upload the data to be fitted in "*put_here_data_to_fit.ods*" (you can overwrite what it is written now)
2. run the python script "*lin_reg.py*" (you can also do this from the terminal, as explainet in the end note)
3. look at the result

**CAUTION**:<br>
The error in the Linear Regression is evaluated only considering the Y error. X values are considered exact. The old version did not even considered the Y error. Taylor does not describe how to consider both errors.

**CAUTION 2**:<br>
the data in the txt file is written in exponential format, jupyter will understand it. If excel is not too stupid he will, too.
There is no need to change it. 

End note: Run from terminal (it should work like this also on windows)
1. Open the folder of the program
2. Right click on an empty space
3. On the drop down menu click "*open in terminal*"
4. write ```python3 lin_reg.py```