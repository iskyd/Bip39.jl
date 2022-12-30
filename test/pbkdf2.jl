@safetestset "pbkdf2" begin
    using Bip39

    key = "army van defense carry jealous true garbage claim echo media make crunch"
    salt = "mnemonic"
    pbkdf2(key, salt, 2048, 64) == "5b56c417303faa3fcba7e57400e120a0ca83ec5a4fc9ffba757fbe63fbd77a89a1a3be4c67196f57c39a88b76373733891bfaba16ed27a813ceed498804c0570"
    pbkdf2(key, salt, 2048, 32) == "5b56c417303faa3fcba7e57400e120a0ca83ec5a4fc9ffba757fbe63fbd77a89"
    pbkdf2(key, salt, 1000, 32) == "62aecee2c0c996403fadca7256ccb03053e4939c97dca481df19dd78"
end