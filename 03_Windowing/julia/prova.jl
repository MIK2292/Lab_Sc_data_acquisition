using Plots , CSV , DataFrames ,LaTeXStrings
gr()

plot_font = "Computer Modern"
default(fontfamily=plot_font,
        linewidth=4, framestyle=:box, label=nothing, grid=false)


Title = ["Rectangle", "Hann", "Blackman", "Flattop", "Hamming"]
time = ["2 ms", "5 ms", "10 ms", "20 ms", "50 ms"]
times = ["_2ms.csv", "_5ms.csv", "_10ms.csv", "_20ms.csv", "_50ms.csv"]




paths = [raw"Lab_Sc_data_acquisition\03_Windowing\raw_data\Rettangolo\rect",
         raw"Lab_Sc_data_acquisition\03_Windowing\raw_data\Von Hann\vonhann",
         raw"Lab_Sc_data_acquisition\03_Windowing\raw_data\Blackman\blackman",
         raw"Lab_Sc_data_acquisition\03_Windowing\raw_data\Flattop\flattop",
         raw"Lab_Sc_data_acquisition\03_Windowing\raw_data\Hamming\hamming"
]



for (j,path) in enumerate(paths)

    for (i,t) in enumerate(times)
        data = CSV.read(path * t, DataFrame, header=13)
        x = data[:, 1]
        y = data[:, 4]

        if  i == 5
        p = plot(x , y, xlim = (500, 1.5e3),
             title = "$(time[i]) Oscilloscope $(Title[j]) Window FFT",
             xlabel = "Frequency [Hz]",
             ylabel = "Amplitude [dBV]",
             titlefont = (size = 17), 
             left_margin = 3Plots.mm,
             fontsize = 16,  
             legend = false,
             linewidth = 0.89
        )
        # display(p)

        savefig(p, "scope_$(Title[j])_$(time[i]).pdf")
        end
    end


end










    