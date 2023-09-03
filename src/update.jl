# paths and config
using DrWatson
using TOML

# data IO
using Arrow
using DataFrames
# using NCDatasets
# using ArviZ

# computations
using Random
using Turing

# unknown parameter of the sampler
magic_nuts_number = 0.8

# load parameters
shared_params = TOML.parsefile(joinpath(findproject(), "params.toml"))

infile = joinpath(findproject(), shared_params["data"]["filename"])
outfile = joinpath(findproject(), shared_params["updating"]["filename"])
ndraws = shared_params["updating"]["n_draws"]
nchains = shared_params["updating"]["n_chains"]
seed = shared_params["updating"]["seed"]
warmup = shared_params["updating"]["warmup"]

# load samples
samples = DataFrame(Arrow.Table(infile))[:, :samples]

# load model
include(joinpath(findproject(), "src/model.jl"))

# sampling
rng = Random.MersenneTwister(seed);
turing_chns = sample(
    # FIXME do I force all chains to be the same?
    rng,
    beta(samples),
    NUTS(warmup, magic_nuts_number),
    MCMCThreads(),
    ndraws,
    nchains,
)

# convert to ArviZ inference data and save to disc
idata_turing_post = from_mcmcchains(turing_chns; library="Turing")

# FIXME needs NCDatasets but NCDatasets fails to pre-compile
# outfile = joinpath(findproject(), shared_params["updating"]["ncfile"])
# to_netcdf(idata_turing_post, outfile)
# FIXME use Arrow until fixed
Arrow.write(outfile, turing_chns)
