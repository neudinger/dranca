module basex;
private import std.ascii;
private import std.typecons : RefCounted;
private import std.traits : isIntegral, isSomeString;

/// 0 .. 9A .. Za .. z
private static immutable BASE62 = digits ~ letters;

@trusted pure T encodeNbToBase(NB = ushort, T = char[])(immutable(NB) number = 0,
        immutable ushort base = BASE62.length)
        if (isIntegral!(NB) && isSomeString!(T))
in
{
    import std.exception : enforce;

    enforce(base >= 2 && base <= 62, "Base must be between 2 and 62");
    assert(number >= 0, "Number cannot be negative!");
}
body
{
    // pragma(msg, "NB  ... ", NB);

    if (number == 0)
        return ['0'];
    T output;
    NB nb = number;
    NB rem = 0;
    while (nb != 0)
    {
        rem = nb % base;
        nb /= base;
        if (rem < 0)
        {
            nb++;
            rem -= base;
        }
        output ~= BASE62[rem];
        rem = 0;
    }

    import std.algorithm : reverse;

    static if (is(T == string))
        return output.dup.reverse;
    else
        return output.reverse;
}

NB decodeCharBase(NB = uint, T = string)(T encoded, immutable(ushort) base = BASE62.length)
        if (isIntegral!(NB) && isSomeString!(T))
body
{
    if (encoded == "0" || encoded == "")
        return 0;

    NB decoded = 0;
    NB step = 1;
    foreach_reverse (const ref car; encoded)
    {
        foreach (const index, const ref value; BASE62)
        {
            if (car == value)
            {
                decoded += index * step;
                step *= base;
                break;
            }
        }
    }
    return decoded;
}

T fromBase(T = string, String = string)(scope immutable String digest,
        scope immutable ubyte lenBase = BASE62.length)
{
    import std.conv : to;
    import std.container : Array;
    import std.traits : Unqual;
    import std.range.primitives : ElementEncodingType;
    import std.string : indexOf;
    alias CHAR = Unqual!(ElementEncodingType!String); // char, wchar or dchar

    Array!ubyte digits;
    scope (exit)
        digits.clear();
    ulong val = 0;
    foreach (const ref car; digest)
    {
        static if (is(T == string))
            val = BASE62.indexOf(car);
        else
            val = countUntil(BASE62, car);
        foreach (ref digit; digits)
        {
            val += digit * lenBase;
            digit = cast(byte)(val & 0xff);
            val >>= 8;
        }
        while (val)
        {
            digits ~= cast(byte)(val & 0xff);
            val >>= 8;
        }
    }
    import std.algorithm : reverse, map;

    return digits[].reverse
        .map!(bits => bits.to!CHAR)
        .to!T;
}

/// toBase String or char[] wchar[] dchar[]
@trusted pure T toBase(T = char[])(ubyte[] digest, immutable(byte) lenBase = BASE62
        .length) if (isSomeString!(T))
{
    import std.conv : to;
    import std.container : Array;

    Array!int digits;
    scope (exit)
        digits.clear();
    int carry = 0;
    foreach (const ref octet; digest)
    {
        carry = octet;
        foreach (ref digit; digits)
        {
            carry += digit << 8;
            digit = carry % lenBase;
            carry /= lenBase;
        }
        while (carry > 0)
        {
            digits ~= carry % lenBase;
            carry /= lenBase;
        }
    }
    import std.algorithm : reverse, map, reduce;

    return digits[].reverse
        .map!(bits => bits.encodeNbToBase(lenBase))
        .reduce!((o, k) => o ~ k)
        .to!T;
}
