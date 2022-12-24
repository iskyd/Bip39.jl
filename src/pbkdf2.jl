export pbkdf2

using SHA

function pbkdf2(key::AbstractString, salt::String, iterations::Int, derived_key_length::Int)::Vector{UInt8}
    hlen = trunc(Int, 512 / 8)
    @assert derived_key_length % hlen === 0
    derived_key = zeros(UInt8, derived_key_length)
    nblocks = convert(Int, round(derived_key_length / hlen))
    salt_bytes = Vector{UInt8}(salt)

    for i in 1:nblocks
        dk_block_i = pbkdf2_block(key, salt_bytes, iterations, i)

        offset = (i - 1) * hlen
        for j = 1:hlen
            derived_key[offset + j] = dk_block_i[j]
        end
    end
    
    return derived_key
end

function pbkdf2_block(key::AbstractString, salt::Vector{UInt8}, iterations::Int, i::Int)
    
end