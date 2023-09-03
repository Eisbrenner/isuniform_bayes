# Test uniformity

```bash
julia --project=. -e "using Pkg; Pkg.instantiate()"
```

then open with

```
julia --project=.
```

or start julia

```bash
julia
```

then

```julia
]
activate .
instantiate
```

return to input repl with back key.

## pipeline

```bash
julia --project=. src/data.jl
julia --project=. --threads=4 src/update.jl
```
