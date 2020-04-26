module sodium.crypto_aead_xchacha20poly1305;
private import sodium.export_ : SODIUM_SIZE_MAX;

extern (C) @nogc @safe:

pure nothrow @trusted
{
        size_t crypto_aead_xchacha20poly1305_ietf_keybytes();
        size_t crypto_aead_xchacha20poly1305_ietf_nsecbytes();
        size_t crypto_aead_xchacha20poly1305_ietf_npubbytes();
        size_t crypto_aead_xchacha20poly1305_ietf_abytes();
        size_t crypto_aead_xchacha20poly1305_ietf_messagebytes_max();
        int crypto_aead_xchacha20poly1305_ietf_encrypt(ubyte* c, ulong* clen_p,
                        const(ubyte)* m, ulong mlen, const(ubyte)* ad, ulong adlen,
                        const(ubyte)* nsec, const(ubyte)* npub, const(ubyte)* k);

        int crypto_aead_xchacha20poly1305_ietf_decrypt(ubyte* m, ulong* mlen_p,
                        ubyte* nsec, const(ubyte)* c, ulong clen, const(ubyte)* ad,
                        ulong adlen, const(ubyte)* npub, const(ubyte)* k);

        int crypto_aead_xchacha20poly1305_ietf_encrypt_detached(ubyte* c, ubyte* mac,
                        ulong* maclen_p, const(ubyte)* m, ulong mlen, const(ubyte)* ad,
                        ulong adlen, const(ubyte)* nsec, const(ubyte)* npub, const(ubyte)* k);

        int crypto_aead_xchacha20poly1305_ietf_decrypt_detached(ubyte* m, ubyte* nsec,
                        const(ubyte)* c, ulong clen, const(ubyte)* mac, const(ubyte)* ad,
                        ulong adlen, const(ubyte)* npub, const(ubyte)* k);

        void crypto_aead_xchacha20poly1305_ietf_keygen(
                        ref ubyte[crypto_aead_xchacha20poly1305_ietf_KEYBYTES] k);

}
private static const enum
{
        crypto_aead_xchacha20poly1305_ietf_NSECBYTES = 0U,
        crypto_aead_xchacha20poly1305_ietf_ABYTES = 16U,
        crypto_aead_xchacha20poly1305_ietf_NPUBBYTES = 24U,
        crypto_aead_xchacha20poly1305_ietf_KEYBYTES = 32U,
        crypto_aead_xchacha20poly1305_ietf_MESSAGEBYTES_MAX
                = SODIUM_SIZE_MAX - crypto_aead_xchacha20poly1305_ietf_ABYTES,
}
/* Aliases */

alias crypto_aead_xchacha20poly1305_IETF_KEYBYTES = crypto_aead_xchacha20poly1305_ietf_KEYBYTES;
alias crypto_aead_xchacha20poly1305_IETF_NSECBYTES = crypto_aead_xchacha20poly1305_ietf_NSECBYTES;
alias crypto_aead_xchacha20poly1305_IETF_NPUBBYTES = crypto_aead_xchacha20poly1305_ietf_NPUBBYTES;
alias crypto_aead_xchacha20poly1305_IETF_ABYTES = crypto_aead_xchacha20poly1305_ietf_ABYTES;
alias crypto_aead_xchacha20poly1305_IETF_MESSAGEBYTES_MAX = crypto_aead_xchacha20poly1305_ietf_MESSAGEBYTES_MAX;
