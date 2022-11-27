export generate_mnemonica

using Random
using SHA

VALID_STRENGHTS::Vector{UInt} = [128, 160, 192, 224, 256]

function generate_mnemonic(strength::Int=256, language::String="english")::Vector{String}
    if !(strength in VALID_STRENGHTS)
        throw(ArgumentError("Invalid strength: $strength"))
    end

    wordlist = [word for word in readlines("./src/wordlist/$(language).txt")]

    hex_str::String = randstring(RandomDevice(), ['0':'9'; 'a':'f'], div(strength, 4))
    bytes::Vector{UInt8} = hex2bytes(hex_str)
    h = bytes2hex(sha256(bytes))

    b::String = join([bitstring(b) for b in bytes], "") *
        join([bitstring(b) for b in hex2bytes(h)], "")[1: div(length(bytes) * 8, 32)]

    mnemonic::Vector{String} = Vector{String}(undef, div(length(b), 11))
    for i in 1:div(length(b), 11)
        idx = parse(Int, b[11 * (i - 1) + 1:11 * i], base=2)
        mnemonic[i] = wordlist[idx + 1]
    end

    return mnemonic
end