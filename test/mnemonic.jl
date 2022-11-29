@safetestset "generate_mnemonic" begin
    using BIP39

    mnemonic = BIP39.generate_mnemonic(256, "english")
    @test length(mnemonic) === 24

    mnemonic = BIP39.generate_mnemonic(128, "english")
    @test length(mnemonic) === 12
end