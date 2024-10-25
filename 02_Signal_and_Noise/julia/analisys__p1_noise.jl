println("Importing libraries...")
using Plots, DataFrames, CSV, LaTeXStrings, Statistics
using StatsPlots, Distributions, LinearAlgebra, StatsBase
#using Random, HypotesisTset

#set latex font & stuff
plot_font = "Computer Modern"
default(fontfamily=plot_font,
        linewidth=2, framestyle=:box, label=nothing, grid=false)
scalefontsizes(1.3)

#import data
println("Opening file...")
df = DataFrame(CSV.File("extracted_noise.csv"))
data = df[!,1]

#evaluate mean and std
n_mean = mean(data)
n_std = std(data)

#print values
println("Noise data")
println("mean = ", n_mean)
println("std = ", n_std)

mu = n_mean
s = n_std

#=
#fit normal 
mu_s = fit(Normal, data)
mu_s_tup = params(mu_s) #get data as tuple

#assign values
mu = mu_s_tup[1]
s = mu_s_tup[2]

#print values
println("")
println("Noise data (method 2)")
println("mean = ", mu)
println("std = ", s)
=#


### beginning of HISTOGRAM and CHI SQUARED TEST (plots at the end)


#define the number of bins of the histogram 
#just take as many bins as the square root of number of points
N_bins = round( sqrt(length(data)) ) 
println("") 
println("N bins used = ", N_bins)

#and the step to be used in the range definition 
minn = minimum(data)
maxx = maximum(data)
step = abs(maxx-minn)/N_bins

#define the range
r = minn:step:maxx 

#transform the data to 
hist = fit(Histogram, data, r)

#extract the observed values (occurrence per bin) of the histogram 
Observed_values = hist.weights
println("length(obs) = ", length(Observed_values))
#and normalize to 1
Observed_values_norm = normalize(Observed_values, 1)

#evaluate x for expected values 
#(must be centered in the middle point of the bin)
#a maxx ho dovuto sottrarre un epsilon perchè altrimenti mi creava un bin in più, 
#di conseguenza non potevo eseguire operazioni tra un vettore di 70 ed uno di 71 elementi 
center_points = (minn + step/2):step:(maxx - step/2 - 1e-14step)

#evaluate the expected values
#pdf = probability density function
#cdf = cumulative probability density function
#cdf(~) = integrale della gaussiana fino a (expected_x)
Integral = cdf(Normal(mu, s), r)
Integral_sx = Integral[1:end-1]
Integral_dx = Integral[2:end]
Expected_values = Integral_dx .- Integral_sx
Expected_values_real = Expected_values .* 5e3

#brute formula for chi squared (chi2) (normalized data) SBAGLIATO
#temp =@. ((Observed_values_norm - Expected_values)^2)/Expected_values
#chi2 = sum(temp)

#brute formula for chi squared (chi2) (real data)
temp =@. ((Observed_values - Expected_values_real)^2)/Expected_values_real
chi2 = sum(temp)

#gradi di libertà
d = N_bins - 1 - 3
println("chi quadro = ", chi2)
println("chi quadro ridotto = ", chi2/d)


### Now let's generate the plots

#Histogram of data not normalized
bar(r, 
	Observed_values, 
	linewidth=0,
	xlabel="Noise (mV)", 
	ylabel="Occurence", 
	title="Noise histogram with " * string(N_bins) * " bins"
	)
savefig("Noise_hist.pdf")

#Histogram of data normalized, with expected distribution
bar(r, Observed_values_norm, 
	bar_width=step,
	linewidth=0,
	#ylims=(0,0.06),
	xlabel="Noise (mV)", 
	ylabel="pdf", 
	title="Noise histogram normalized and expected distribution",
	titlefontsize=15, 
	label="Observed values (normalized)",
	size=(800, 450),
	bottom_margin=4Plots.mm,
	left_margin=4Plots.mm)
plot!(center_points, Expected_values, 
	marker=true,
	label="Expected values")
savefig("Noise_hist_normalized_and_Normal_distr.pdf")

#Histogram of data NOT normalized, with expected distribution
bar(r, Observed_values, 
	bar_width=step,
	linewidth=0,
	ylims=(0,300),
	xlabel="Noise (mV)", 
	ylabel="pdf", 
	title="Noise histogram and expected distribution values",
	titlefontsize=15, 
	label="Observed values",
	size=(800, 450),
	bottom_margin=4Plots.mm,
	left_margin=4Plots.mm,
	xticks=(-0.25:0.05:0.25),
	yticks=(0:50:300))
plot!(center_points, Expected_values_real, 
	marker=true,
	markersize=3,
	label="Expected values")
savefig("Noise_hist_and_Normal_distr_expected_v.pdf")

#TEST: Histogram of expected values, with expected distribution
bar(r, 
	Expected_values,
	linewidth=0, 
	xlabel="Noise (mV)", 
	ylabel="pdf", 
	title="Expected values\nand expected distribution"
	)
plot!(center_points, Expected_values, 
	marker=true)
savefig("Exp_values_and_Normal_distr.pdf")











#create histogram
##histogram(data, xlabel="Noise (mV)", ylabel="Occurence", title="Noise histogram")
#savefig("Noise_hist.pdf")



