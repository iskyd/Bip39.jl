export generate_mnemonic, check_mnemonic, detect_language

using Random
using SHA

VALID_STRENGHTS::Vector{UInt} = [128, 160, 192, 224, 256]

struct MnemonicWords
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

    wordlist = [word for word in readlines("./src/wordlist/$(language).txt")]

    hex_str::String = randstring(RandomDevice(), ['0':'9'; 'a':'f'], div(strength, 4))
    bytes::Vector{UInt8} = hex2bytes(hex_str)
    h = bytes2hex(sha256(bytes))

    b::String = join([  (b) for b in bytes], "") *
        join([bitstring(b) for b in hex2bytes(h)], "")[1: div(length(bytes) * 8, 32)]

    mnemonic::Vector{String} = Vector{String}(undef, div(length(b), 11))
    for i in 1:div(length(b), 11)
        idx = parse(Int, b[11 * (i - 1) + 1:11 * i], base=2)
        mnemonic[i] = wordlist[idx + 1]
    end

    return mnemonic
end

function check_mnemonic(mnemonic::Vector{String}, language::String="english")::Bool
    if !(length(mnemonic) in [12, 15, 18, 21, 24]) return false end

    wordlist::Array{String} = [word for word in readlines("./src/wordlist/$(language).txt")]
    binary_str::String = ""

    for word in mnemonic
        idx = findfirst(w -> w == word, wordlist)
        if idx === nothing return false end
    
        binary_idx = digits(idx, base=2, pad=11) |> reverse
        binary_str *= join(binary_idx)
    end

    print(binary_str)

    l = length(binary_str)
    d = b[1:div(l, 33) * 32]
    h = b[length(b) + div(-l, 33) + 1:end]
    nd = parse(BigInt, d, base=2)
end

function detect_language(mnemonic::Vector{String})::String
    unique_words::Vector{String} = unique(mnemonic)
    languages::Vector{String} = list_available_languages()

    mnemonic_words::Vector{MnemonicWords} = []
    for language in languages
        wordlist = [word for word in readlines("./src/wordlist/$(language).txt")]
        push!(mnemonic_words, MnemonicWords(language, wordlist))
    end

    for word in unique_words
        mnemonic_words = [mnemonic_word for mnemonic_word in mnemonic_words if word in mnemonic_word.wordlist]

        if length(mnemonic_words) === 0 throw(DetectLanguageError("Language for mnemonic not found: $(join(mnemonic, ','))")) end
    end

    if length(mnemonic_words) === 1 return mnemonic_words[1].language end

    throw(DetectLanguageError("Language ambigous for mnemonic: $(join(mnemonic))"))
end