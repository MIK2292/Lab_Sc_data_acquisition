using DataFrames, CSV, Plots, LaTeXStrings, Statistics, GLM


#DATA PLOT

#set latex font & stuff
plot_font = "Computer Modern"
default(fontfamily=plot_font,
        linewidth=2, framestyle=:box, label=nothing, grid=false)
scalefontsizes(1.3)

#import data
df_signal = DataFrame(CSV.File("Signal_sum.csv"))
df_errors = DataFrame(CSV.File("Error_sum.csv"))

#def plot function
function my_plot(df::DataFrame, name::String)
    p = [plot(
            df[!,"Time"]*1e3, df[!,i], 
            legend=false, 
            title="Average of " * string(2^(i-2)) * " samples"
            ) for i in 2:7
        ] 
    #correct title at first graph and add y/x labels at the correct figure
    p[1] = plot(
        df[!,"Time"]*1e3, df[!,2], 
        legend=false, 
        title="One sample",
        ylabel="Tension (V)"
        )
    p[3] = plot(
        df[!,"Time"]*1e3, df[!,4], 
        legend=false, 
        title="Average of " * string(2^(4-2)) * " samples",
        ylabel="Tension (V)"
        )
    p[5] = plot(
        df[!,"Time"]*1e3, df[!,6], 
        legend=false, 
        title="Average of " * string(2^(6-2)) * " samples",
        ylabel="Tension (V)",
        xlabel="Time (ms)"
        )
    p[6] = plot(
        df[!,"Time"]*1e3, df[!,7], 
        legend=false, 
        title="Average of " * string(2^(7-2)) * " samples",
        xlabel="Time (ms)"
        )
    plot(p..., 
        size=(800, 1000), 
        layout=(3,2),
        left_margin=4Plots.mm
        )
    savefig(name)
end

#my_plot(df_signal, "Signal.pdf")
#my_plot(df_errors, "Error.pdf")

#def plot w/ fixed y axis lims
function my_plot_fixed_axis(df::DataFrame, name::String, ylim)
    p = [plot(
            df[!,"Time"]*1e3, df[!,i], 
            legend=false, 
            ylims=ylim,
            title="Average of " * string(2^(i-2)) * " samples"
            ) for i in 2:7
        ] 
    #correct title at first graph and add y/x labels at the correct figure
    p[1] = plot(
        df[!,"Time"]*1e3, df[!,2], 
        legend=false, 
        ylims=ylim,
        title="One sample",
        ylabel="Tension (V)"
        )
    p[3] = plot(
        df[!,"Time"]*1e3, df[!,4], 
        legend=false, 
        ylims=ylim,
        title="Average of " * string(2^(4-2)) * " samples",
        ylabel="Tension (V)"
        )
    p[5] = plot(
        df[!,"Time"]*1e3, df[!,6], 
        legend=false, 
        ylims=ylim,
        title="Average of " * string(2^(6-2)) * " samples",
        ylabel="Tension (V)",
        xlabel="Time (ms)"
        )
    p[6] = plot(
        df[!,"Time"]*1e3, df[!,7], 
        legend=false, 
        ylims=ylim,
        title="Average of " * string(2^(7-2)) * " samples",
        xlabel="Time (ms)"
        )
    plot(p..., 
        size=(800, 1000), 
        layout=(3,2),
        left_margin=4Plots.mm
        )
    savefig(name)
end

my_plot_fixed_axis(df_errors, "Error_fix.pdf", (-0.25,0.25))
my_plot_fixed_axis(df_signal, "Signal_fix.pdf", (-1.25,1.25))


#STATISTICAL ANALYSIS

n_samples = [2^(i-2) for i in 2:7]
error_mean = [mean(df_errors[!,i]) for i in 2:7]
error_std = [std(df_errors[!,i]) for i in 2:7]
println("error_std = ", string(error_std))

#exp fit
std_log = log.(error_std)
x_log = log.(n_samples)

df = DataFrame(x_log=x_log, std_log=std_log)
fit = lm(@formula(std_log ~ x_log), df)

println("R2 = ", string(r2(fit)))
println("[Intercept, x-coef] = ", string(coef(fit)))
println("[Intercept error, x-coef error] = ", string(stderror(fit)))
#println("[exp Intercept, exp Intercept error] = ", string(( exp(coef(fit)[1]), exp(stderror(fit)[1])*exp(coef(fit)[1])))


x = 0.5:0.25:35
plot(x, exp(coef(fit)[1]) .* x .^ (coef(fit)[2]), 
    color=:orange, 
    label=L"Fitted curve $y=A \cdot x^B$",
    ylabel="Standard deviation of the error", 
    xlabel="Number of samples considered",
    ylims=(0,0.07),
    xlims=(-1,34),
    linestyle=:dash,
    xticks=(n_samples)
)
scatter!(n_samples, error_std,
    color=:blue, 
    label="Experimental data"
)
savefig("Std_error.pdf")












