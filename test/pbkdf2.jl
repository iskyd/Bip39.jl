@safetestset "pbkdf2" begin
    using Bip39

    @test Bip39.pbkdf2("password", "mnemonic", 1000, 512) === "k1wSQ0LrNjFHkh8IIGppeoKIkzToPSgf+h1opyx2umesPqdGq0pBYnr88JEYW6OF/UFCgR5keWkApEqrmSdBmw=="
end