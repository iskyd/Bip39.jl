@safetestset "generate_mnemonic" begin
    using Bip39

    mnemonic = generate_mnemonic(256, "english")
    @test length(mnemonic) === 24

    mnemonic = generate_mnemonic(128, "english")
    @test length(mnemonic) === 12
end

@safetestset "detect_language" begin
    using Bip39

    mnemonic = generate_mnemonic(256, "english")
    @test detect_language(mnemonic) === "english"

    mnemonic = generate_mnemonic(256, "italian")
    @test detect_language(mnemonic) === "italian"

    mnemonic = generate_mnemonic(128, "italian")
    @test detect_language(mnemonic) === "italian"

    mnemonic = Bip39.generate_mnemonic(256, "spanish")
    @test Bip39.detect_language(mnemonic) === "spanish"

    mnemonic = generate_mnemonic(256, "french")
    @test detect_language(mnemonic) === "french"
end

@safetestset "check_mnemonic" begin
    using Bip39

    mnemonic = generate_mnemonic(256, "english")
    @test check_mnemonic(mnemonic, "english") === true

    mnemonic = generate_mnemonic(128, "english")
    @test check_mnemonic(mnemonic, "english") === true

    mnemonic = generate_mnemonic(256, "italian")
    @test check_mnemonic(mnemonic, "english") === false
end