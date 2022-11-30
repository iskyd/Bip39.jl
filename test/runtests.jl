cd(@__DIR__)

using Test, TestSetExtensions, SafeTestsets
using Bip39

@testset ExtendedTestSet "BIP39 tests" begin
    @includetests ARGS #[(endswith(t, ".jl") && t[1:end-3]) for t in ARGS]
end