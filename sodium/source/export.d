module sodium.export_;
import core.stdc.stdint;
import std.algorithm.comparison : min;

alias SODIUM_MIN = min;
// extern (D) auto SODIUM_MIN(T0, T1)(auto ref T0 A, auto ref T1 B)
// {
//     return A < B ? A : B;
// }

static const enum SODIUM_SIZE_MAX = SODIUM_MIN(ulong.max, size_t.max);

