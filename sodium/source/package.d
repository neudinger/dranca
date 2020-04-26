/*
Written in the D programming language.
For git maintenance (ensure at least one congruent line with originating C header):
#define sodium_H
*/

module sodium;

public:
import sodium.core;
import sodium.utils;
import sodium.export_;
import sodium.crypto_aead_xchacha20poly1305;