using DataFrames, CSV

function create_data(n::Int)
	name = string(n)
	if length(name) < 2
		name = "0" * name
	end
	
	x = range(0,50,2000)
	y = @. 2sin(x) + 0.1rand()
	
	df = DataFrame("x"=>x, "y"=>y)
	CSV.write("fake_data_" * name * ".txt", df)
end

for i in 1:17
	create_data(i)
end

