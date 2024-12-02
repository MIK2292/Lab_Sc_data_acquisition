using CSV , DataFrames
using Statistics , Interpolations
using Plots
plotlyjs()
#gr()


plot_font = "Computer Modern"
default(fontfamily=plot_font,
        linewidth=4, framestyle=:box, label=nothing, grid=false
)

#Funzione per trovare la larghezza dei picchi
function peaks_width_finder(data_set, freq)

    subset = data_set[1:1000]
    subset1 = data_set[1:5]

    max = maximum(subset)
    index = argmax(subset)
    middle = maximum(subset1)

    threshold = middle + (max - middle) / 2 
    
    left_index = index
    while left_index > 1 && data_set[left_index] > threshold
        left_index -= 1
    end

    right_index = index
    while right_index < length(data_set) && data_set[right_index] > threshold
        right_index += 1
    end

    peakwidth = freq[right_index] - freq[left_index]

    #return max, index , peakwidth , left_index , right_index
    return max , peakwidth , left_index , right_index , threshold
end

#set di liste
window_types = ["Blackman","Flattop","Hamming","Rectangle","Hanning"]

tempo = ["_2ms.csv","_5ms.csv","_10ms.csv","_20ms.csv","_50ms.csv"]

percorsi = [raw"03_Windowing\raw_data\Blackman\blackman",
            raw"03_Windowing\raw_data\Flattop\flattop",
            raw"03_Windowing\raw_data\Hamming\hamming",
            raw"03_Windowing\raw_data\Rettangolo\rect",
            raw"03_Windowing\raw_data\Von Hann\vonhann"
]


#OSCILLOSCOPE DATA PLOTTER
for (i,time_scale) in enumerate(tempo)
    plotz = []
    for (j,path) in enumerate(percorsi)
        df = CSV.read(path * time_scale, DataFrame, header = 13)
        frequenza = df[:,1]
        fourier_transf = df[:,4]
        #limito il range di punti
        freq = frequenza[1:Int(10e3)]
        fft = fourier_transf[1:Int(10e3)]  
        
        p = plot(freq, fft, xlim = (50, 2000),
                 title = window_types[j], 
                 xlabel = "Frequence [Hz]", 
                 ylabel = "Amplitude[dbV]", 
                 bottom_margin = 5Plots.mm,
                 titlefont = (size = 16), 
                 left_margin = 5Plots.mm,
                 legend = false)
        push!(plotz, p)

    end
    combined = plot(plotz..., 
                    size = (800, 1500),
                    layout = (5,1), 
                    linewidth = 0.89,
                    left_margin = 20Plots.mm,
    )
    # if i == 5
    #     savefig(combined, "scope_50ms.pdf")
    # end
    display(combined)

end



#OSCILLOSCOPE WIDTH FINDER
# for (i , time_scale) in enumerate(tempo)
#     println("________________________________________________________")
#     println("Tempo: $time_scale")
#     for (j , path) in enumerate(percorsi)
#         df = CSV.read(path*time_scale, DataFrame, header=13)
#         freq = df[:,1]
#         fft = df[:,4]

#         max , width , left_index , right_index , threshold = peaks_width_finder(fft , freq)

#         println(window_types[j],"  width:  $width")
#     end
# end
