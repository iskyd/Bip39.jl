export pbkdf2

using SHA

function pbkdf2(key::AbstractString, salt::String, iterations::Int, dklen::Int)::Vector{UInt8}
    hlen = trunc(Int, 512 / 8)
    @assert dklen % hlen === 0
    nblocks = convert(Int, round(dklen / hlen))
    derived_key = Matrix{UInt8}(undef, hlen, nblocks)
    salt_bytes = Vector{UInt8}(salt)

    for i in 1:nblocks
        derived_key[:, i] = pbkdf2_block(key, salt_bytes, iterations, i)
    end
    
    derived_key = reshape(derived_key, nblocks * hlen)[1:dklen]
    return derived_key
end

function pbkdf2_block(key::AbstractString, salt::Vector{UInt8}, iterations::Int, i::Int)::Vector{UInt8}
    salt = [salt; zeros(UInt8, 4)]
    salt_tail = view(salt, length(salt) - 3:length(salt))
    salt_tail[:] = reinterpret(UInt8, [UInt32(i)]) |> reverse

    U1 = hmac_sha2_512(Vector{UInt8}(key), salt)
    Un = U1
    for i in 2:iterations
        Un = Un .⊻ hmac_sha2_512(Vector{UInt8}(key), Un)
    end

    return Un
end