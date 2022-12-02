@safetestset "generate_mnemonic" begin
    using Bip39

    mnemonic = Bip39.generate_mnemonic(256, "english")
    @test length(mnemonic) === 24

    mnemonic = Bip39.generate_mnemonic(128, "english")
    @test length(mnemonic) === 12
end

@safetestset "detect_language" begin
    using Bip39

    mnemonic = Bip39.generate_mnemonic(256, "english")
    @test Bip39.detect_language(mnemonic) === "english"

    mnemonic = Bip39.generate_mnemonic(256, "italian")
    @test Bip39.detect_language(mnemonic) === "italian"

    mnemonic = Bip39.generate_mnemonic(128, "italian")
    @test Bip39.detect_language(mnemonic) === "italian"

    mnemonic = Bip39.generate_mnemonic(256, "spanish")
    @test Bip39.detect_language(mnemonic) === "spanish"

    mnemonic = Bip39.generate_mnemonic(256, "french")
    @test Bip39.detect_language(mnemonic) === "french"
end

@safetestset "check_mnemonic" begin
    using Bip39

    mnemonic = Bip39.generate_mnemonic(256, "english")
    @test Bip39.check_mnemonic(mnemonic, "english") === true

    mnemonic = Bip39.generate_mnemonic(128, "english")
    @test Bip39.check_mnemonic(mnemonic, "english") === true

    mnemonic = Bip39.generate_mnemonic(256, "italian")
    @test Bip39.check_mnemonic(mnemonic, "english") === false
end