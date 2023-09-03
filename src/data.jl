using DrWatson
using TOML
using Arrow
using Distributions
using DataFrames

shared_params = TOML.parsefile(joinpath(findproject(), "params.toml"))

a = shared_params["true_values"]["alpha"]
b = shared_params["true_values"]["beta"]
N = shared_params["true_values"]["n_samples"]

filename = joinpath(findproject(), shared_params["data"]["filename"])

d = Beta(a, b)
samples = rand(d, N)

df = DataFrame((samples=samples))

Arrow.write(filename, df)
