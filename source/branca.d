module branca;
private import sodium : crypto_aead_xchacha20poly1305_ietf_encrypt,
  crypto_aead_xchacha20poly1305_ietf_decrypt, crypto_aead_xchacha20poly1305_IETF_MESSAGEBYTES_MAX,
  crypto_aead_xchacha20poly1305_IETF_ABYTES, crypto_aead_xchacha20poly1305_IETF_KEYBYTES;

private static immutable enum
{
  crypto_aead_xchacha20poly1305_ietf_HEADERBYTES = 29U,
  HEADERBYTES_EMPTY = (ubyte(0u))
    .repeat(crypto_aead_xchacha20poly1305_ietf_HEADERBYTES)
    .array, KEYBYTES_EMPTY = (ubyte(0u)).repeat(crypto_aead_xchacha20poly1305_IETF_KEYBYTES).array,
    minimumpayload = crypto_aead_xchacha20poly1305_ietf_HEADERBYTES
    + crypto_aead_xchacha20poly1305_IETF_KEYBYTES,
}

private:
import std.array : array;
import std.range : generate, takeExactly, repeat, array;
import std.string : representation;
import std.bitmanip : nativeToBigEndian, bigEndianToNative;
import basex : toBase, fromBase;
import std.random : uniform;
import std.datetime.systime : SysTime, Clock;
import std.datetime.timezone : UTC;
import std.typecons : Tuple;
import std.meta : AliasSeq;

static void purge(const ref Branca branca)
{
  branca.destroy;
}

public:
/// Runtime init parameter
alias DrancaTup = Tuple!(uint, "ttl", string, "key");
/// Compiletime init parameter
alias DrancaSeq = AliasSeq!(uint, string);

class BrokenBrancaException : Exception
{
  this(string msg, string file = __FILE__, size_t line = __LINE__)
  {
    super(msg, file, line);
  }
}

// @safe nothrow pure private
// {
//   Branca
// }
// // Uncomment this to set an expiration (or ttl) of the token (in seconds).
// template Dranca(uint ttl)
// {
//   enum Dranca = mixin(BrancaTTL(ttl));
// }

const struct Branca
{
  // init
  private
  { /// key with 32 bytes
    const ubyte[crypto_aead_xchacha20poly1305_IETF_KEYBYTES] key;
    /// header
    /// Version (byte) || Timestamp ([4]byte) || Nonce ([24]byte)
    const ubyte[crypto_aead_xchacha20poly1305_ietf_HEADERBYTES] header;
    const uint ttl;
  }

  @disable this();
  @disable this(this);

private:
  // debug : /// @property 
  /// token of branca
  /// header ~ ciphertext
  ubyte[] token() const
  {
    // ulong ciphertext_len;
    // ubyte[payload.length + crypto_aead_xchacha20poly1305_IETF_ABYTES] ciphertext;
    // crypto_aead_xchacha20poly1305_ietf_encrypt(ciphertext.ptr, &ciphertext_len,
    //     payload.ptr, payload.length, header.ptr, header.length, null, nonce.ptr, key.ptr);
    return cast(ubyte[]) token;
  }
  // @property 
  /// tokenversion of branca
  ubyte tokenversion() const
  {
    return this.header[0];
  }
  // @property 
  /// timestamp of branca
  ubyte[] timestamp() const
  {
    return cast(ubyte[]) this.header[1 .. 5];
  }
  // @property 
  /// timestamp of branca
  ubyte[] nonce() const
  {
    return cast(ubyte[]) this.header[5 .. $];
  }

public:
   ~this()
  {
  }

  this(uint ttl, string key)
  in
  {
    assert(key.length == crypto_aead_xchacha20poly1305_IETF_KEYBYTES);
  }
  body
  {
    this.key = key.representation;
    this.ttl = ttl;
  }

  this(DrancaTup params)
  in
  {
    assert(params.key.length == crypto_aead_xchacha20poly1305_IETF_KEYBYTES);
  }
  body
  {
    this.key = params.key.representation;
    this.ttl = params.ttl;
  }

  this(ubyte[crypto_aead_xchacha20poly1305_IETF_KEYBYTES] key)
  {
    this.key = key;
    this.header = ubyte(0xBA) ~ nativeToBigEndian!(uint)(
        cast(const(uint))(Clock.currTime(UTC()).toUnixTime)) ~ generate!(
        () => cast(ubyte) uniform(0, 255)).takeExactly(24).array;
  }

  this(string key)
  in
  {
    assert(key.length == crypto_aead_xchacha20poly1305_IETF_KEYBYTES);
  }
  body
  {
    this.key = key.representation;
    this.header = ubyte(0xBA) ~ nativeToBigEndian(cast(uint)(Clock.currTime(UTC())
        .toUnixTime)) ~ generate!(() => cast(ubyte) uniform(0, 255)).takeExactly(24).array;
  }
  /// @property 
  /// data encryted
  string encode(const string data) const
  in
  {
    // Must recreate new token
    assert(this.header != HEADERBYTES_EMPTY);
    assert(this.key != KEYBYTES_EMPTY);
  }
  out
  {
    assert(this.header == HEADERBYTES_EMPTY);
    assert(this.key == KEYBYTES_EMPTY);
  }
  body
  {
    ulong ciphertext_len;
    ubyte[] payload = new ubyte[data.length + crypto_aead_xchacha20poly1305_IETF_ABYTES];
    scope (exit)
    {
      payload.destroy;
      purge(this);
    }
    crypto_aead_xchacha20poly1305_ietf_encrypt(payload.ptr, &ciphertext_len,
        data.representation.ptr, data.length, this.header.ptr,
        this.header.length, null, this.nonce.ptr, this.key.ptr);
    return (header ~ payload).toBase!(string);
  }
  /// return null if ttl is bad
  string decode(const string ciphertext)
  in
  {
    assert(this.key != KEYBYTES_EMPTY, "instantiate with this(uint ttl, string key)");
    // assert(ciphertext.length > crypto_aead_xchacha20poly1305_ietf_HEADERBYTES
    // + crypto_aead_xchacha20poly1305_IETF_KEYBYTES, "Invalid Branca token data");
  }
  body
  {
    if (ciphertext.length < minimumpayload)
    {
      throw new BrokenBrancaException("Invalid Branca token data");
    }

    import std.conv : to;
    import std.algorithm : reverse, map;

    ulong decrypted_len;
    immutable ubyte[] cipher = ciphertext.fromBase.representation;
    immutable ubyte[crypto_aead_xchacha20poly1305_ietf_HEADERBYTES] payload = cipher[0
      .. crypto_aead_xchacha20poly1305_ietf_HEADERBYTES];
    long now = Clock.currTime(UTC()).toUnixTime;
    uint futur = bigEndianToNative!uint(payload[1 .. 5]) + this.ttl;
    if (futur < now)
      return null;
    immutable ubyte[] data = cipher[crypto_aead_xchacha20poly1305_ietf_HEADERBYTES .. $];

    ubyte[] message = new ubyte[ciphertext.length - crypto_aead_xchacha20poly1305_IETF_ABYTES];
    crypto_aead_xchacha20poly1305_ietf_decrypt(message.ptr, &decrypted_len,
        null, data.ptr, data.length, payload.ptr, payload.length,
        payload[5 .. $].ptr, this.key.ptr);
    scope (exit)
    {
      message.destroy;
    }
    return (cast(char[]) message[0 .. decrypted_len]).to!(string);
  }
}
