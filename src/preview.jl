using DrWatson
using TOML
using Arrow
using ArviZ
using DataFrames

# load parameters
params = TOML.parsefile(joinpath(findproject(), "params.toml"))

filename = joinpath(findproject(), params["updating"]["filename"])

# load samples
turing_chns = DataFrame(Arrow.Table(filename))

# FIXME ArviZ.jl is not designed to work with the loaded data type
# FIXME but with the original Turing.jl output data type instead
