using Plots
plotlyjs() 
using CSV
using DataFrames

#Selezione della scala temporale
tempo = "_10ms.csv"

#lattura del file csv(diverse tipi di finestre stesso tempo )
df_Blackman = CSV.read(raw"03_Windowing\raw_data\Blackman\blackman" * tempo, DataFrame, header=13)
df_Flattop = CSV.read(raw"03_Windowing\raw_data\Flattop\flattop" * tempo, DataFrame, header=13)
df_Hamming = CSV.read(raw"03_Windowing\raw_data\Hamming\hamming" * tempo, DataFrame, header=13)
df_Rectangle = CSV.read(raw"03_Windowing\raw_data\Rettangolo\rect" * tempo, DataFrame, header=13)
df_Hanning = CSV.read(raw"03_Windowing\raw_data\Von Hann\vonhann" * tempo, DataFrame, header=13)


#creazione del plot 
#Blackman
f1 = df_Blackman[:,1]
fft1 = df_Blackman[:,4]
#Flattop
f2 = df_Flattop[:,1]
fft2 = df_Flattop[:,4]
#Hamming
f3 = df_Hamming[:,1]
fft3 = df_Hamming[:,4]
#Rectangle
f4 = df_Rectangle[:,1]
fft4 = df_Rectangle[:,4]
#Hanning
f5 = df_Hanning[:,1]
fft5 = df_Hanning[:,4]

#limite asse x
lim = (0, 20e3)

#plot singloari delle fft
p2 = plot(f2, fft2, xlim = lim, title = "Flattop", ylabel = "Amplitude [dBV]")
p3 = plot(f3, fft3, xlim = lim, title = "Hamming", ylabel = "Amplitude [dBV]")
p1 = plot(f1, fft1, xlim = lim, title = "Blackman", ylabel = "Amplitude [dBV]")
p4 = plot(f4, fft4, xlim = lim, title = "Rectangle", ylabel = "Amplitude [dBV]")
p5 = plot(f5, fft5, xlim = lim, title = "Hanning", xlabel = "Frequence [Hz]", ylabel = "Amplitude [dBV]")

#plot multiplo

combined = plot(p1, p2, p3, p4, p5, layout = (5,1), size = (800, 1000), legend = false, linewidth = 0.89)

display(combined)