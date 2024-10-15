import numpy as np
from pandas import read_excel
import matplotlib.pyplot as plt
from sklearn import linear_model

'''
L'idea è di invertire gli assi x-y in y-x 
e trovare i coeff A e B della retta nel piano y-x,
quindi invertiamo analiticamente l'eq della retta per rappresentarla nel piano x-y

Il vantaggio è che consideriamo gli errori su x, trascurando quelli su y
'''

'''
CALCOLI: inversione di 
# x = Ay + B	(1)
in 
# y = Cx + D	(2)

Vogliamo la dipendenza di C e D da A e B, cioè vogliamo trovare C(A,B) e D(A,B)
Divido la (1) per A
	=> x/A = y + B/A
	=> y = (1/A) * x - B/A 
cioè
	C = 1/A
	D = -B/A

Vediamo ora gli ERRORI:
Per moltiplicazione e divisione si sommano gli errori relativi

C = 1/A
errC = | C * |errA / A| |
	= | errA / A^2 |

D = -B/A
errD = | D * (  |errA / A| + |errB / B|  ) |
	= | ( B / A ) * (  |errA / A| + |errB / B|  ) | 
'''

#import data from file
Filename = "put_here_data_to_fit.ods"
Dataframe = read_excel(Filename)

#assignment of values
X = Dataframe.X.values
Y = Dataframe.Y.values
Xerr = Dataframe.Xerr.values 
Yerr = Dataframe.Yerr.values #used only in the plot
Ndata = len(X)

#weight calculation
Xweight = Xerr**(-2)
#Yweight = Yerr**(-2)


# +++ Regression evaluation +++
# y = Ax + B

#adjust data for regression (only "X" needs to be reshaped)
x = X
y = Y.reshape(Ndata, 1)

#evaluate the regression considering only the "y" error
regr = linear_model.LinearRegression(fit_intercept = True)
regr.fit(y, x, sample_weight=Xweight)

#saving values
A = regr.coef_[0]#[0]	#Coefficient
B = regr.intercept_#[0]	#Intercept


'''
# +++ ERROR evaluation without weights +++
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

# +++ ERROR evaluation with only Y weights +++
# y = Ax + B
#Taylor, p201

#variables declaration
S_weight = sum(Xweight)
S_weight_y = sum(Xweight * Y)
S_weight_y2 = sum(Xweight * Y * Y)

Delta = (S_weight * S_weight_y2) - (S_weight_y)**2

sigmaA = np.sqrt(S_weight_y2 / Delta)
sigmaB = np.sqrt(S_weight / Delta)



'''
# +++ Recap of saved variables +++

Now we have:

A = regr.coef_[0][0]	#Coefficient
B = regr.intercept_[0]	#Intercept

sigmaA			#Coefficient error
sigmaB			#Intercept error

'''



#Now we can reverse again both axis 
'''
Recap from before:

C = 1/A
errC = | errA / A^2 |

D = -B/A
errD = | ( B / A ) * (  |errA / A| + |errB / B|  ) | 
'''
C = 1/A
sigmaC = np.abs( sigmaA / (A**2) )

D = -B/A
sigmaD = np.abs(  ( B / A ) * ( np.abs( sigmaA / A ) + np.abs( sigmaB / B ) )  )


#Update A and B
A = C
B = D
sigmaA = sigmaC
sigmaB = sigmaD


def output_terminal():
	#output over terminal
	print("Coefficient \t\t= %.6f\t= %.6e" % (A, A))
	print("Intercept \t\t= %.6f\t= %.6e" % (B ,B))
	print("Coefficient error \t= %.6f\t= %.6e" % (sigmaA, sigmaA))
	print("Intercept error \t= %.6f\t= %.6e" % (sigmaB, sigmaB))
	
	
def output_txt_file():
	#output over txt file to copy end values to jupiter notebook or excel file
	# Open a file in write mode (this will create the file if it doesn't exist)
	file = open('output.txt', 'w')
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
	file.close()
	
	
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
	
	plt.savefig("output_plot.png")
	plt.show()




output_plot()
output_terminal()
output_txt_file()
























