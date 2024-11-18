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
time_scale = ["_2ms.csv", "_5ms.csv", "_10ms.csv", "_20ms.csv", "_50ms.csv"]

all_width_blackman = []
all_width_flatop = []
all_width_hamming = []
all_width_rectangle = []
all_width_hanning = []


for t in time_scale


#Lettura del segnale
segnale = CSV.read(raw"03_Windowing\raw_data\Segnale\sig"*t, DataFrame, header=13)

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

#parte del codice per ottenere il massimo e la larghezza del picco
max_blackman, index_blackman, width_blackman, left_blackman, right_blackman = peaks_width_finder(fft_blackman, freq)
max_flattop, index_flattop, width_flattop, left_flattop, right_flattop = peaks_width_finder(fft_flattop, freq)
max_hamming, index_hamming, width_hamming, left_hamming, right_hamming = peaks_width_finder(fft_hamming, freq)
max_rectangle, index_rectangle, width_rectangle, left_rectangle, right_rectangle = peaks_width_finder(fft_rectangle, freq)
max_hanning, index_hanning, width_hanning, left_hanning, right_hanning = peaks_width_finder(fft_hanning, freq)

#aggiungere lista con le larghezze dei picchi per le finestre utilizzate e le scale temporali
println("scala temporale: $t")
println("Blackman Frequency:  $(freq[index_blackman]) Hz; ", " Blackman Peak Width:  $width_blackman Hz")
println("Flattop Frequency:   $(freq[index_flattop]) Hz; ",  " Flattop Peak Width:   $width_flattop Hz")
println("Hamming Frequency:   $(freq[index_hamming]) Hz; ",  " Hamming Peak Width:   $width_hamming Hz")
println("Rectangle Frequency: $(freq[index_rectangle]) Hz; "," Rectangle Peak Width: $width_rectangle Hz")
println("Hanning Frequency:   $(freq[index_hanning]) Hz; ",  " Hanning Peak Width:   $width_hanning Hz")
println("_________________________________________________________________________________________")

push!(all_width_blackman, width_blackman)
push!(all_width_flatop, width_flattop)
push!(all_width_hamming, width_hamming)
push!(all_width_rectangle, width_rectangle)
push!(all_width_hanning, width_hanning)

end

println("Blackman: ", all_width_blackman)
println("Flattop: ", all_width_flatop)
println("Hamming: ", all_width_hamming)
println("Rectangle: ", all_width_rectangle)
println("Hanning: ", all_width_hanning) 


