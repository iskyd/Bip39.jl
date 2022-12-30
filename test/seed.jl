@safetestset "get_seed" begin
    using Bip39

    mnemonic = ["army", "van", "defense", "carry", "jealous", "true", "garbage", "claim", "echo", "media", "make", "crunch"]
    @test get_seed(mnemonic) === "5b56c417303faa3fcba7e57400e120a0ca83ec5a4fc9ffba757fbe63fbd77a89a1a3be4c67196f57c39a88b76373733891bfaba16ed27a813ceed498804c0570"
    @test get_seed(mnemonic, "passphrase") === "a72c0c6976113d8fff342a96041d68e1a8f79a465ae8aa980aba349339965cb8e068a3945a90e7ee9cda6a5d9b3a1df317afb0a73a9c50c7fbe0a514a6fa651d"
    @test length(get_seed(generate_mnemonic())) == 128
end