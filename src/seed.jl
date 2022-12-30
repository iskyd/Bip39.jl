using Bip39

export get_seed

function get_seed(mnemonic::Vector{String}, passphrase::Union{String, Nothing}=nothing)::String
    if !Bip39.check_mnemonic(mnemonic)
        throw(ArgumentError("Invalid mnemonic provided"))
    end

    salt = "mnemonic" * (passphrase !== nothing ? passphrase : "")
    seed = Bip39.pbkdf2(join(mnemonic, " "), salt, 2048, 64)

    return seed
end