using Plots, CSV , DataFrames ,LaTeXStrings
using DSP, FFTW , Statistics
# plotlyjs()
gr()


plot_font = "Computer Modern"
default(fontfamily=plot_font,
        linewidth=4, framestyle=:box, label=nothing, grid=false)

function find_max(data)
    index  = argmax(data)
    max = maximum(data)
    return max
end

function flattop(N)
    a0,a1,a2,a3,a4 = 0.21557895, 0.41663158, 0.277263158, 0.083578947, 0.006947368
    n = 0:N-1
    w = a0 .- a1*cos.(2π*n/(N-1)) .+ a2*cos.(4π*n/(N-1)) .- a3*cos.(6π*n/(N-1)) .+ a4*cos.(8π*n/(N-1))
    return w
end


function max_width(x, y)
    y = y[1:Int(50e3)]
    max = maximum(y)
    index_max = argmax(y)
    mean_value = mean(y[700:end])
    
    fwhm = mean_value + (max - mean_value)/2
    
    left_index = index_max
    while left_index > 1 && y[left_index] > fwhm
        left_index -= 1
    end

    a = x[left_index] .+ ((fwhm .- y[left_index]) ./(y[index_max] .- y[left_index])) .* (x[index_max] .- x[left_index])
    
    right_index = index_max
    while right_index < length(y) && y[right_index] > fwhm
        right_index += 1
    end

    b = x[index_max] .+ ((fwhm .- y[index_max]) ./(y[right_index] .- y[index_max])) .* (x[right_index] .- x[index_max])

    d = b - a

    return max, index_max, d, a, b, fwhm
end
#list of the time windows 
t_w = ["2ms.csv", "5ms.csv", "10ms.csv", "20ms.csv", "50ms.csv"]
times_scale = ["2 ms", "5 ms", "10 ms", "20 ms", "50 ms"]

#list of the windows
windows = ["rectangle", "hanning"]

#list of the paths
signal_path = [raw"Lab_Sc_data_acquisition\03_Windowing\raw_data\Segnale\sig_"]

scope_paths = [raw"03_Windowing\raw_data\Rettangolo\rect_" , raw"03_Windowing\raw_data\Von Hann\vonhann_"]


#RAW SIGNAL
plotz = []
for (i,t) in enumerate(t_w)
    
    data_frames = CSV.read( signal_path[1] * t, DataFrame, header=13)
    signal = data_frames[:,2]
    
    time = data_frames[:,1]

    max = find_max(signal)

    flat = flattop(length(signal))

    #frequency definition
    fs = 1/(time[2]-time[1])
    freq = fs*(0:length(signal)-1)/length(signal)
    signal_fft = 20 .* log10.((abs.(fft(signal .* ones(length(signal))))))
    hanning_fft = 20 .* log10.(abs.(fft(signal .* hanning(length(signal)))))
    blackman_fft = 20 .* log10.(abs.(fft(signal .* blackman(length(signal)))))
    flattop_fft = 20 .* log10.(abs.(fft(signal .* flat)))
    hamming_fft = 20 .* log10.(abs.(fft(signal .* hamming(length(signal)))))

    # peak_values, index , peakwidth, a , b , fwhm = max_width(freq, signal_fft)
    # println("peak frequence: & $(freq[index]) & $(peakwidth)")
    if i == 5
    
    p = plot(freq, hamming_fft, 
         xlim = (950, 1.05e3),
         xlabel="Frequency [Hz]", 
         ylabel="Amplitude [dBV]", 
         title=" $(times_scale[i]) Hamming Window FFT",
         titlefont = (size = 17), 
         left_margin = 3Plots.mm,
         fontsize = 16,
         linewidth = 0.89,  
             legend=false
    )
             
    # plot!(p, [a , b], [fwhm , fwhm], line = :dash, color = :red, label = false)
    # push!(plotz, p)
    # display(p)
    savefig(p, "sig_hamming_$(times_scale[i]).pdf")
    
    end 


end
# combined_plot = plot(plotz..., layout=(5,1), size=(1000,1400), linewidth=0.89)
# #savefig(combined_plot, "rectangle.pdf")
# display(combined_plot)


#OSCILLOSCOPE SIGNAL
# hann_plot = []
# rect_plot = []
# for (i, t) in enumerate(t_w)

#     for (j , w) in enumerate(scope_paths)
#         data = CSV.read(w*t, DataFrame, header=13)
#         signal = data[:,4]
#         frequency = data[:,1]
#         p = plot(frequency, signal, xlim = (500 , 1500),
#                  xlabel = "Frequency [Hz]", 
#                  ylabel = "Amplitude [dBV]", 
#                  title = "$(times_scale[i]) Oscilloscope $(windows[j]) window FFT",
#                  titlefont = (size = 20), 
#                  left_margin = 6Plots.mm,
#                  fontsize = 14,  
#                  legend = false
#         )
            
#         if j == 1
#             push!(rect_plot, p)
#         else
#             push!(hann_plot, p)
#         end
#         # index_max = find_max(signal)
#         # println("$(windows[j]) window $(times_scale[i]) peak frequency: $(frequency[index_max])")
#         # if i == 5
#         #     p = plot(frequency, signal, xlim = (500 , 1500),
#         #              xlabel = "Frequency [Hz]", 
#         #              ylabel = "Amplitude [dBV]", 
#         #              title = "$(times_scale[i]) Oscilloscope $(windows[j]) window FFT",
#         #              titlefont = (size = 20), 
#         #              left_margin = 6Plots.mm,
#         #              fontsize = 14,  
#         #              legend = false)
#         #     push!(zplot, p)
#         # end
    
#     end
# end
# # combined_plot = plot(zplot..., layout=(2,1), 
# #                      size=(700,1000),
# #                      left_margin = 10Plots.mm,
# #                      right_margin = 5Plots.mm,
# #                      linewidth=0.89)
# # # savefig(combined_plot, "scope_fft.pdf")
# # display(combined_plot)
# rect_plot = plot(rect_plot..., layout=(5,1), size=(1000,1400), linewidth=0.89)
# hann_plot = plot(hann_plot..., layout=(5,1), size=(1000,1400), linewidth=0.89)
# display(rect_plot)
# display(hann_plot)