@safetestset "generate_mnemonic" begin
    using BIP39

    mnemonic = BIP39.generate_mnemonic(256, "english")
    @test length(mnemonic) === 24

    mnemonic = BIP39.generate_mnemonic(128, "english")
    @test length(mnemonic) === 12
end

@safetestset "detect_language" begin
    using BIP39

    mnemonic = BIP39.generate_mnemonic(256, "english")
    @test BIP39.detect_language(mnemonic) === "english"

    mnemonic = BIP39.generate_mnemonic(256, "italian")
    @test BIP39.detect_language(mnemonic) === "italian"

    mnemonic = BIP39.generate_mnemonic(128, "italian")
    @test BIP39.detect_language(mnemonic) === "italian"
end