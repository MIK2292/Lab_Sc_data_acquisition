using Plots
plotlyjs()
using CSV
using DataFrames
using DSP, FFTW

#creazione della finestra flattop
function flattop(N)
    a0,a1,a2,a3,a4 = 0.21557895, 0.41663158, 0.277263158, 0.083578947, 0.006947368
    n = 0:N-1
    w = a0 .- a1*cos.(2π*n/(N-1)) .+ a2*cos.(4π*n/(N-1)) .- a3*cos.(6π*n/(N-1)) .+ a4*cos.(8π*n/(N-1))
    return w
end

#scala temporale
time_scale = "_10ms.csv"

#Lettura del segnale
segnale = CSV.read(raw"03_Windowing\raw_data\Segnale\sig"*time_scale, DataFrame, header=13)

#segnale acquisito dall'oscilloscopio
sin = segnale[:,2]
time = segnale[:,1]

N = length(sin) #numero di punti

#Creazioone delle finestre di misura
blackman_window = blackman(N)
flattop_window = flattop(N)
hamming_window = hamming(N)
rectangle_window = ones(N)
hanning_window = hanning(N)

#Applicazione delle finestre al segnale
sin_blackman = sin .* blackman_window
sin_flattop = sin .* flattop_window
sin_hamming = sin .* hamming_window
sin_rectangle = sin .* rectangle_window
sin_hanning = sin .* hanning_window

#Calcolo della FFT
#fft_blackman = abs.(fft(sin_blackman))
fft_blackman =    log.(abs.(fft(sin_blackman)))
fft_flattop =     log.(abs.(fft(sin_flattop)))
fft_hamming =     log.(abs.(fft(sin_hamming)))
fft_rectangle =   log.(abs.(fft(sin_rectangle)))
fft_hanning =     log.(abs.(fft(sin_hanning)))

#asse delle frequenze
Fs = 1/(time[2]-time[1]) 
freq = Fs*(0:N-1)/N

#limite asse x
lim = (0, 10e3)

#plot delle FFT
p1 = plot(freq, fft_blackman, xlim = lim, title = "Blackman", xlabel = "Frequence[Hz]", ylabel = "Amplitude [dBV]")
p2 = plot(freq, fft_flattop, xlim = lim, title = "Flattop", xlabel = "Frequence[Hz]", ylabel = "Amplitude [dBV]")
p3 = plot(freq, fft_hamming, xlim = lim, title = "Hamming", xlabel = "Frequence[Hz]", ylabel = "Amplitude [dBV]")
p4 = plot(freq, fft_rectangle, xlim = lim, title = "Rectangle", xlabel = "Frequence[Hz]", ylabel = "Amplitude [dBV]")
p5 = plot(freq, fft_hanning, xlim = lim, title = "Hanning", xlabel = "Frequence [Hz]", ylabel = "Amplitude [dBV]")

combined = plot(p1, p2, p3, p4, p5, layout = (5,1), size = (800, 1000), legend = false, linewidth = 0.89)

display(combined)