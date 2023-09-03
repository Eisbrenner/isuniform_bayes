using DrWatson
using TOML
using Arrow
using Turing
using DataFrames
using Random

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
include("model.jl")

# sampling
rng = Random.MersenneTwister(seed);
chns = sample(
    # FIXME do I force all chains to be the same?
    rng,
    beta(samples),
    NUTS(warmup, magic_nuts_number),
    MCMCThreads(),
    ndraws,
    nchains,
)

# data formatting and saving
# FIXME while writing to disc the meta data is lost
# FIXME how to do subsequent visualization with ArviZ.jl is unclear
Arrow.write(outfile, chns)
