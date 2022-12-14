export pbkdf2

using OpenSSL_jll
using Libdl

function pbkdf2(key::AbstractString, salt::AbstractString, iterations::Int=2048, dklen::Int=64)::String
    lc_h = OpenSSL_jll.libcrypto_handle
    evp_sha512_fp = dlsym(lc_h, :EVP_sha512)
    digest = ccall(evp_sha512_fp, Ptr{Cvoid}, ())
    out = zeros(UInt8, dklen)

    res = @ccall libcrypto.PKCS5_PBKDF2_HMAC(key::Cstring, length(key)::Cint, salt::Cstring, length(salt)::Cint, iterations::Cint, digest::Ptr{Cvoid}, dklen::Cint, out::Ptr{Cchar})::Cint
    if res != 1
        throw(ArgumentError("Error in pbkdf2"))
    end

    return bytes2hex(out)
end