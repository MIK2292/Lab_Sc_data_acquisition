using Plots
using CSV , LaTeXStrings
using DataFrames
using DSP, FFTW
gr()

# #set latex strings
# plot_font = "Computer Modern"
# default(fontfamily=plot_font,
#         linewidth=2, framestyle=:box, label=nothing, grid=false)
# scalefontsizes(1)

plot_font = "Computer Modern"
default(fontfamily=plot_font,
        linewidth=4, framestyle=:box, label=nothing, grid=false)

#creazione della finestra flattop
function flattop(N)
    a0,a1,a2,a3,a4 = 0.21557895, 0.41663158, 0.277263158, 0.083578947, 0.006947368
    n = 0:N-1
    w = a0 .- a1*cos.(2π*n/(N-1)) .+ a2*cos.(4π*n/(N-1)) .- a3*cos.(6π*n/(N-1)) .+ a4*cos.(8π*n/(N-1))
    return w
end

#funzione per analizzare la larghezza dei picchi
function peaks_width_finder(data_set, freq)
    
    subset = data_set[1:10000]

    max = maximum(subset)
    index = argmax(subset)

    treshold = max/2 #valore di soglia(metà del picco)
    
    left_index = index
    while left_index > 1 && data_set[left_index] > treshold
        left_index -= 1
    end

    right_index = index
    while right_index < length(data_set) && data_set[right_index] > treshold
        right_index += 1
    end

    peakwidth = freq[right_index] - freq[left_index]

    return max, index , peakwidth , left_index , right_index
end

#scala temporale
time_scale = "_50ms.csv"

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
fft_list = [20*log10.(abs.(fft(sin_blackman))),
            20*log10.(abs.(fft(sin_flattop))),
            20*log10.(abs.(fft(sin_hamming))),
            20*log10.(abs.(fft(sin_rectangle))),
            20*log10.(abs.(fft(sin_hanning)))
]

#asse delle frequenze
Fs = 1/(time[2]-time[1]) 
freq = Fs*(0:N-1)/N

#set di liste utili
window_types = ["Blackman","Flattop","Hamming","Rectangle","Hanning"]


#parte del codice per ottenere il massimo e la larghezza del picco
# max_blackman, index_blackman, width_blackman, left_blackman, right_blackman = peaks_width_finder(fft_blackman, freq)
# max_flattop, index_flattop, width_flattop, left_flattop, right_flattop = peaks_width_finder(fft_flattop, freq)
# max_hamming, index_hamming, width_hamming, left_hamming, right_hamming = peaks_width_finder(fft_hamming, freq)
# max_rectangle, index_rectangle, width_rectangle, left_rectangle, right_rectangle = peaks_width_finder(fft_rectangle, freq)
# max_hanning, index_hanning, width_hanning, left_hanning, right_hanning = peaks_width_finder(fft_hanning, freq)

#plotting
plotz = []
for (i , fft) in enumerate(fft_list)
    p = plot(freq, fft, xlim = (750, 1250),
             title = window_types[i], 
             xlabel = "Frequence [Hz]", 
             ylabel = "Amplitude[dbV]", 
             bottom_margin = 5Plots.mm,
             titlefont = (size = 16), 
             left_margin = 5Plots.mm,
             legend = false)
    push!(plotz, p)

 
 combined = plot(plotz..., 
                size = (800, 1500),
                layout = (5,1), 
                linewidth = 0.89,
                left_margin = 20Plots.mm,
 )
end
# savefig(combined , "fft_signal_50ms.pdf")
display(combined)


          



