using DataFrames, CSV, FFTW

#opens all 32 data files in a single array of dataframes
df_collection_signal = [
    DataFrame(CSV.File(
        "sum_signal/sum_" * string(i) * ".csv",
        skipto=13, header=["Time", "Value"])) 
    for i in 1:32
    ]

#riassunto di analysis_p1.jl
#set some parameters
N_punti = length(df_collection_signal[1][!,1]) #Numero di punti 
fs = 1000000 #frequenza di campionamento

#evaluate fft frequencies (x axis)
freq = fftfreq(N_punti, fs)

function isolate_error(df::DataFrame)
    #evaluate fft
    fft_res = fft(df[!,2])

    #set to "zero" the main frequency
    interval = 7:27
    #fft_res[6] = sum(fft_res[interval])/length(interval)
    fft_res[6] = maximum(hypot.(fft_res[interval]))
    fft_res[end-4] = fft_res[6]
    fft_res[1] = fft_res[6]
    
    #inverse fft
    ifft_res = ifft(fft_res)

    #return df with only real part
    return DataFrame(Time=df[!,1], Value=real.(ifft_res))
end

#create array of dataframe for error
df_collection_error = [isolate_error(df_collection_signal[i]) for i in 1:32]


#save signal 
df_collection = df_collection_signal
df_sum = DataFrame(
    Time        = (df_collection[1][!,"Time"]),
    one         = (df_collection[1][!,"Value"]),
    two         = (df_collection[1][!,"Value"] .+ df_collection[2][!,"Value"]) /2,
    four        = (df_collection[1][!,"Value"] .+ df_collection[2][!,"Value"] .+
                df_collection[3][!,"Value"] .+ df_collection[4][!,"Value"]) /4,
    eight       = (df_collection[1][!,"Value"] .+ df_collection[2][!,"Value"] .+
                df_collection[3][!,"Value"] .+ df_collection[4][!,"Value"] .+
                df_collection[5][!,"Value"] .+ df_collection[6][!,"Value"] .+
                df_collection[7][!,"Value"] .+ df_collection[8][!,"Value"]) /8,
    sixteen     = (df_collection[1][!,"Value"] .+ df_collection[2][!,"Value"] .+
                df_collection[3][!,"Value"] .+ df_collection[4][!,"Value"] .+
                df_collection[5][!,"Value"] .+ df_collection[6][!,"Value"] .+
                df_collection[7][!,"Value"] .+ df_collection[8][!,"Value"] .+
                df_collection[9][!,"Value"] .+ df_collection[10][!,"Value"] .+
                df_collection[11][!,"Value"] .+ df_collection[12][!,"Value"] .+
                df_collection[13][!,"Value"] .+ df_collection[14][!,"Value"] .+
                df_collection[15][!,"Value"] .+ df_collection[16][!,"Value"]) /16,
    thirtytwo   = (df_collection[1][!,"Value"] .+ df_collection[2][!,"Value"] .+
                df_collection[3][!,"Value"] .+ df_collection[4][!,"Value"] .+
                df_collection[5][!,"Value"] .+ df_collection[6][!,"Value"] .+
                df_collection[7][!,"Value"] .+ df_collection[8][!,"Value"] .+
                df_collection[9][!,"Value"] .+ df_collection[10][!,"Value"] .+
                df_collection[11][!,"Value"] .+ df_collection[12][!,"Value"] .+
                df_collection[13][!,"Value"] .+ df_collection[14][!,"Value"] .+
                df_collection[15][!,"Value"] .+ df_collection[16][!,"Value"] .+
                df_collection[17][!,"Value"] .+ df_collection[18][!,"Value"] .+
                df_collection[19][!,"Value"] .+ df_collection[20][!,"Value"] .+
                df_collection[21][!,"Value"] .+ df_collection[22][!,"Value"] .+
                df_collection[23][!,"Value"] .+ df_collection[24][!,"Value"] .+
                df_collection[25][!,"Value"] .+ df_collection[26][!,"Value"] .+
                df_collection[27][!,"Value"] .+ df_collection[28][!,"Value"] .+
                df_collection[29][!,"Value"] .+ df_collection[30][!,"Value"] .+
                df_collection[31][!,"Value"] .+ df_collection[32][!,"Value"]) /32
                )
CSV.write("Signal_sum.csv", df_sum)


#save error
df_collection = df_collection_error
df_sum_err = DataFrame(
    Time        = (df_collection[1][!,"Time"]),
    one         = (df_collection[1][!,"Value"]),
    two         = (df_collection[1][!,"Value"] .+ df_collection[2][!,"Value"]) /2,
    four        = (df_collection[1][!,"Value"] .+ df_collection[2][!,"Value"] .+
                df_collection[3][!,"Value"] .+ df_collection[4][!,"Value"]) /4,
    eight       = (df_collection[1][!,"Value"] .+ df_collection[2][!,"Value"] .+
                df_collection[3][!,"Value"] .+ df_collection[4][!,"Value"] .+
                df_collection[5][!,"Value"] .+ df_collection[6][!,"Value"] .+
                df_collection[7][!,"Value"] .+ df_collection[8][!,"Value"]) /8,
    sixteen     = (df_collection[1][!,"Value"] .+ df_collection[2][!,"Value"] .+
                df_collection[3][!,"Value"] .+ df_collection[4][!,"Value"] .+
                df_collection[5][!,"Value"] .+ df_collection[6][!,"Value"] .+
                df_collection[7][!,"Value"] .+ df_collection[8][!,"Value"] .+
                df_collection[9][!,"Value"] .+ df_collection[10][!,"Value"] .+
                df_collection[11][!,"Value"] .+ df_collection[12][!,"Value"] .+
                df_collection[13][!,"Value"] .+ df_collection[14][!,"Value"] .+
                df_collection[15][!,"Value"] .+ df_collection[16][!,"Value"]) /16,
    thirtytwo   = (df_collection[1][!,"Value"] .+ df_collection[2][!,"Value"] .+
                df_collection[3][!,"Value"] .+ df_collection[4][!,"Value"] .+
                df_collection[5][!,"Value"] .+ df_collection[6][!,"Value"] .+
                df_collection[7][!,"Value"] .+ df_collection[8][!,"Value"] .+
                df_collection[9][!,"Value"] .+ df_collection[10][!,"Value"] .+
                df_collection[11][!,"Value"] .+ df_collection[12][!,"Value"] .+
                df_collection[13][!,"Value"] .+ df_collection[14][!,"Value"] .+
                df_collection[15][!,"Value"] .+ df_collection[16][!,"Value"] .+
                df_collection[17][!,"Value"] .+ df_collection[18][!,"Value"] .+
                df_collection[19][!,"Value"] .+ df_collection[20][!,"Value"] .+
                df_collection[21][!,"Value"] .+ df_collection[22][!,"Value"] .+
                df_collection[23][!,"Value"] .+ df_collection[24][!,"Value"] .+
                df_collection[25][!,"Value"] .+ df_collection[26][!,"Value"] .+
                df_collection[27][!,"Value"] .+ df_collection[28][!,"Value"] .+
                df_collection[29][!,"Value"] .+ df_collection[30][!,"Value"] .+
                df_collection[31][!,"Value"] .+ df_collection[32][!,"Value"]) /32
                )
CSV.write("Error_sum.csv", df_sum_err)
