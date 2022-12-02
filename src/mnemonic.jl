export generate_mnemonic, detect_language, DetectLanguageError

using Random
using SHA

VALID_STRENGHTS::Vector{UInt} = [128, 160, 192, 224, 256]

struct LanguageWordlist
    language::String
    wordlist::Vector{String} 
end

struct DetectLanguageError <: Exception
    msg::AbstractString
end

function list_available_languages()::Vector{String}
    return ["english", "french", "italian", "spanish"]
end

function generate_mnemonic(strength::Int=256, language::String="english")::Vector{String}
    if !(strength in VALID_STRENGHTS)
        throw(ArgumentError("Invalid strength: $strength"))
    end

    wordlist = [word for word in readlines(joinpath(@__DIR__, "wordlist", "$(language).txt"))]

    hex_str::String = randstring(RandomDevice(), ['0':'9'; 'a':'f'], div(strength, 4))
    bytes::Vector{UInt8} = hex2bytes(hex_str)
    sha = sha256(bytes)

    b::String = join([bitstring(b) for b in bytes], "") *
        join([bitstring(b) for b in sha], "")[1: div(length(bytes) * 8, 32)]

    mnemonic::Vector{String} = Vector{String}(undef, div(length(b), 11))
    for i in 1:div(length(b), 11)
        idx = parse(Int, b[11 * (i - 1) + 1:11 * i], base=2)
        mnemonic[i] = wordlist[idx + 1]
    end

    return mnemonic
end

function check_mnemonic(mnemonic::Vector{String}, language::String="english")::Bool
    if !(length(mnemonic) in [12, 15, 18, 21, 24])
        return false
    end

    wordlist::Array{String} = [word for word in readlines(joinpath(@__DIR__, "wordlist", "$(language).txt"))]
    b::String = ""

    for word in mnemonic
        idx = findfirst(w -> w == word, wordlist)
        if idx === nothing
            return false
        end

        binary_idx = digits(idx - 1, base=2, pad=11) |> reverse
        b *= join(binary_idx)
    end

    d = b[1:div(length(b), 33)*32]
    nd = reverse(digits(UInt8, parse(BigInt, d, base=2), base=256))
    h = b[length(b)+div(-length(b), 33)+1:end]

    return join([bitstring(b) for b in sha256(nd)], "")[1:div(length(nd) * 8, 32)] == h
end

function detect_language(mnemonic::Vector{String})::String
    unique_words::Vector{String} = unique(mnemonic)
    languages::Vector{String} = list_available_languages()

    possible::Vector{LanguageWordlist} = []
    for language in languages
        wordlist = [word for word in readlines(joinpath(@__DIR__, "wordlist", "$(language).txt"))]
        push!(possible, LanguageWordlist(language, wordlist))
    end

    for word in unique_words
        possible = [p for p in possible if word in p.wordlist]

        if length(possible) === 0 throw(DetectLanguageError("Language for mnemonic not found: $(join(mnemonic, ','))")) end
    end

    if length(possible) === 1 return possible[1].language end

    throw(DetectLanguageError("Language ambigous for mnemonic: $(join(mnemonic))"))
end