# paths and config
using DrWatson
using TOML

# data IO
using Arrow
using DataFrames
# using NCDatasets

# plotting
using ArviZ

# load parameters
params = TOML.parsefile(joinpath(findproject(), "params.toml"))

filename = joinpath(findproject(), params["updating"]["filename"])

# load samples
turing_chns = DataFrame(Arrow.Table(filename))

# data_path = joinpath(findproject(), params["updating"]["ncfile"])
# idata = from_netcdf(data_path)

# FIXME ArviZ.jl is not designed to work with the loaded data type
# FIXME but with the original Turing.jl output data type instead
