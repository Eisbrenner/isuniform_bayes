using Distributions
using Turing

@model function beta(y)
    a ~ FlatPos(0)
    b ~ FlatPos(0)
    return y ~ Beta(a, b)
end
