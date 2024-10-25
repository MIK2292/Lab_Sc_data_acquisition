using Plots, DataFrames, CSV, FFTW, LaTeXStrings, Statistics

#set latex font & stuff
plot_font = "Computer Modern"
default(fontfamily=plot_font,
        linewidth=2, framestyle=:box, label=nothing, grid=false)
scalefontsizes(1.3)

#create dataframe and load data
df = DataFrame(CSV.File("sum_signal/sum_1.csv"))


#HANN WINDOW
USE_HANN_WINDOW = false

if USE_HANN_WINDOW == true
	x = df[!,1]
	window_size = x[end] - x[1]
	hann_window =@. cos(x * pi/window_size)^2
	df[!, "Windowed_value"] = df[!,2] .* hann_window
end

#set some parameters
N_punti = length(df[!,1]) #Numero di punti 
fs = 1000000 #frequenza di campionamento
plot_size = (800, 450) #plot dimension in pixels

#evaluate fft
if USE_HANN_WINDOW == true
	fft_res = fft(df[!,3]) # WINDOWED
else 
	fft_res = fft(df[!,2]) #NON WINDOWED
end
freq = fftfreq(N_punti, fs)

#eval fft in dBV
fft_res_dBV = 20*log10.(fft_res)

#save signal (plot, NON WINDOWED)
plot(df[!,1] .* 1e3,df[!,2], 
	xlabel="Time (ms)", 
	ylabel="Amplitude (V)", 
	title="Raw signal of sine wave and noise",
	grid=true, 
	xticks=(-2.5:0.5:2.5),
	titlefontsize=15, 
	size=plot_size,
	bottom_margin=4Plots.mm,
	left_margin=4Plots.mm,
	marker=true,
	markersize=0.5,
	label="Signal",
	legend=:bottomright)
savefig("./signal01.pdf")

#save signal (plot, WINDOWED)
if USE_HANN_WINDOW == true
	plot(df[!,1] .* 1e3,df[!,3], 
		xlabel="Time (ms)", 
		ylabel="Amplitude (V)", 
		title="Windowed signal of sine wave and noise",
		grid=true, 
		xticks=(-2.5:0.5:2.5),
		titlefontsize=15, 
		size=plot_size,
		bottom_margin=4Plots.mm,
		left_margin=4Plots.mm)
	savefig("./signal01_window.pdf")
end

#save signal (scatter)
scatter(df[!,1] .* 1e3 ,df[!,2], 
	xlabel="Time (ms)", 
	ylabel="Amplitude (V)", 
	title="Raw signal of sine wave and noise",
	grid=true, 
	xticks=(-2.5:0.5:2.5),
	markersize=0.5,
	titlefontsize=15, 
	size=plot_size,
	bottom_margin=4Plots.mm,
	left_margin=4Plots.mm)
savefig("./signal01_scatter.pdf")

#save fft
plot(freq[1:div(N_punti, 2)] ./ 1e3, 
	hypot.(fft_res[1:div(N_punti, 2)]), 
	xlim=(0,30), 
	xlabel="Frequency (kHz)", 
	ylabel="Magnitude", 
	title="FFT Magnitude Spectrum", 
	yaxis=:log10, 
	yticks=(10.0 .^ (-1:1:3)),
	xticks=(0:5:30),
	titlefontsize=15, 
	grid=true,
	size=plot_size,
	bottom_margin=4Plots.mm,
	left_margin=4Plots.mm)
savefig("./fft01.pdf")

#save fft in dBV, far
plot(freq[1:div(N_punti, 2)] ./ 1e3, 
	hypot.(fft_res_dBV[1:div(N_punti, 2)]), 
	xlim=(0,30), 
	xlabel="Frequency (kHz)", 
	ylabel="Magnitude (dBV)", 
	title="FFT Magnitude Spectrum", 
	titlefontsize=15, 
	grid=true,
	xticks=(0:5:30),
	size=plot_size,
	bottom_margin=4Plots.mm,
	left_margin=4Plots.mm)
savefig("./fft01_dBV.pdf")


#set to zero the main frequency
fft_res[6] = 1 #mean(fft_res[10:100])
fft_res[end-4] = fft_res[6]

if USE_HANN_WINDOW == true
	fft_res[end-3] = fft_res[6]
	fft_res[end-5] = fft_res[6]
	fft_res[7] = fft_res[6]
	fft_res[5] = fft_res[6]
	fft_res[1] = fft_res[6]
	fft_res[end] = fft_res[6]
	fft_res[2] = fft_res[6]
end

#save fft w/ main frequency
plot(freq[1:div(N_punti, 2)] ./ 1e3, 
	hypot.(fft_res[1:div(N_punti, 2)]), 
	xlim=(0,50000), 
	xlabel="Frequency (kHz)", 
	ylabel="Magnitude", 
	title="FFT Magnitude Spectrum, without main frequency", 
	yaxis=:log10, 
	titlefontsize=15, 
	grid=true,
	size=plot_size,
	bottom_margin=4Plots.mm,
	left_margin=4Plots.mm)
savefig("./fft01_w0.pdf")

#save fft w/ main frequency, full spectrum
plot(freq, hypot.(fft_res), xlim=(-50000,50000), xlabel="Frequency (Hz)", ylabel="Magnitude", title="FFT Magnitude Spectrum, without main frequency", yaxis=:log, size=plot_size)
savefig("./fft01_w0_fs.pdf")

#inverse fft
ifft_res = ifft(fft_res)
CSV.write("extracted_noise.csv", DataFrame(ifft_res))

#plot signal without main frequency
plot(df[!,1] .* 1e3, real.(ifft_res), 
	xlabel="Time (ms)", 
	ylabel="Amplitude (V)", 
	title="Reconstructed noise of the signal", 
	titlefontsize=15, 
	grid=true,
	xticks=(-2.5:0.5:2.5),
	size=plot_size,
	bottom_margin=4Plots.mm,
	left_margin=4Plots.mm,
	marker=true,
	markersize=0.5,
	label="Noise",
	legend=:bottomright)
savefig("./signal01_only_noise.pdf")

#scatter signal without main frequency
scatter(df[!,1] .* 1e3, real.(ifft_res), 
	xlabel="Time (ms)", 
	ylabel="Amplitude (V)", 
	title="Reconstructed noise of the signal",
	markersize=0.5, 
	titlefontsize=15, 
	grid=true,
	xticks=(-2.5:0.5:2.5),
	size=plot_size,
	bottom_margin=4Plots.mm,
	left_margin=4Plots.mm)
savefig("./signal01_only_noise_scatter.pdf")





















