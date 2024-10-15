# Linear Regression using Python 
## It does the regression considering the X error, but not Y error

Usage: 
1. upload the data to be fitted in "*put_here_data_to_fit.ods*" (you can overwrite what it is written now)
2. run the python script "*lin_reg.py*" (you can also do this from the terminal, as explainet in the end note)
3. look at the result

**CAUTION**:<br>
The error in the Linear Regression is evaluated only considering the X error. Y values are considered exact. Taylor does not describe how to consider both errors.

**CAUTION 2**:<br>
the data in the txt file is written in exponential format, jupyter will understand it. If excel is not too stupid he will, too.
There is no need to change it. 

End note: Run from terminal (it should work like this also on windows)
1. Open the folder of the program
2. Right click on an empty space
3. On the drop down menu click "*open in terminal*"
4. write ```python3 lin_reg.py```

## How this magic works

The idea is to reverse the axis ( (x-y) -> (y-x) ), in this way the error on the X data becomes error on the Y data.<br>
Now we can use the Y error linear regression and get the coefficients in (y-x).<br>
Then we reverse the fit in (y-x), in formulae we go from $x = Ay + B$ to $y = C(A,B)x + D(A,B)$<br>
The coefficients C e D are what we are searching.<br>
<br>
At the beginning of the code there are the calculation.





