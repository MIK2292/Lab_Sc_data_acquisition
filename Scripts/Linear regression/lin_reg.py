import numpy as np
from pandas import read_excel
import matplotlib.pyplot as plt
from sklearn import datasets, linear_model


# y = Ax + B

#import data from file
Filename = "put_here_data_to_fit.ods"
Dataframe = read_excel(Filename)

#assignment of values
X = Dataframe.X.values
Y = Dataframe.Y.values
Xerr = Dataframe.Xerr.values
Yerr = Dataframe.Yerr.values
Ndata = len(X)


# +++ Regression evaluation +++
# y = Ax + B

#adjust data for regression
x = X.reshape(Ndata, 1)
y = Y.reshape(Ndata, 1)

#evaluate the regression
regr = linear_model.LinearRegression(fit_intercept = True)
regr.fit(x, y)

#saving values
A = regr.coef_[0][0]	#Coefficient
B = regr.intercept_[0]	#Intercept


# +++ ERROR evaluation +++
# y = Ax + B

#variables declaration
Sx2 = 0		#\sum_i (X_i)^2
Sx = 0		#\sum_i (X_i)
Somma = 0	#\sum_i ( Y_i - (A X_i + B) )^2

#variables evaluation
for i in range(Ndata):
    Sx2 += X[i]**2
    Sx += X[i]
    Somma += ( Y[i] - ( regr.coef_[0][0]*X[i] + regr.intercept_[0] ) )**2

#variables evaluation (2)
Delta = Ndata * Sx2 - (Sx)**2
sigmay = np.sqrt( Somma/(Ndata - 2) )

#variables evaluation (3)
#and saving error values
sigmaA = sigmay * np.sqrt(Sx2 / Delta)
sigmaB = sigmay * np.sqrt(Ndata / Delta)


'''
# +++ Recap of saved variables +++

Now we have:

A = regr.coef_[0][0]	#Coefficient
B = regr.intercept_[0]	#Intercept

sigmaA			#Coefficient error
sigmaB			#Intercept error

'''

def output_terminal():
	#output over terminal
	print("Coefficient \t\t= %.6f\t= %.6e" % (A, A))
	print("Intercept \t\t= %.6f\t= %.6e" % (B ,B))
	print("Coefficient error \t= %.6f\t= %.6e" % (sigmaA, sigmaA))
	print("Intercept error \t= %.6f\t= %.6e" % (sigmaB, sigmaB))
	
	
def output_txt_file():
	#output over txt file to copy end values to jupiter notebook or excel file
	# Open a file in write mode (this will create the file if it doesn't exist)
	with open('output.txt', 'w') as file:
	    # Write the message to the file
	    file.write("Copy the following lines to jupyter notebook:\n")
	    file.write("Coefficient = %.15e\n" % A)
	    file.write("Intercept = %.15e\n" % B)
	    file.write("Coefficient_error = %.15e\n" % sigmaA)
	    file.write("Intercept_error = %.15e\n" % sigmaB)
	    file.write("\n")
	    file.write("Copy the following lines to excel:\n")
	    file.write("Coefficient\t%.15e\n" % A)
	    file.write("Intercept\t%.15e\n" % B)
	    file.write("Coefficient_error\t%.15e\n" % sigmaA)
	    file.write("Intercept_error\t%.15e\n" % sigmaB)
	
	
def output_plot():
	#output over plot to check veridicity
	plt.figure(figsize=(12,8))
	plt.errorbar(x=X, y=Y, xerr=Xerr, yerr=Yerr, ecolor="black", capsize=3, elinewidth=0.5, label="Experimental data")
	
	#aggiungo il 10% a dx e sx del fit per vedere se fitta bene
	ten_percent_of_interval = 0.1 * (max(X) - min(X))
	xx = np.linspace(min(X) - ten_percent_of_interval, max(X) + ten_percent_of_interval, 150)
	yy = A * xx + B
	
	label_equation = "%.3e \cdot x + %.3e" % (A, B)
	plt.plot(xx, yy, label="Fitted line: $" +label_equation+ "$" )
	
	plt.legend()
	plt.grid()
	
	plt.show()
	plt.savefig("output_plot.png")




output_plot()
output_terminal()
output_txt_file()
























