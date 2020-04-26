module dranca.example;
private import basex : toBase;
private import branca : Branca, BrokenBrancaException, DrancaTup, DrancaSeq;
import std.stdio;
import core.thread : Thread, seconds;
import core.exception : AssertError;
import std.typecons : Tuple;
import std.meta : AliasSeq;

// unittest
// {
//     assert(-(-1) == 1);
//     assert(0+(1)  == 1, "marche pas"); 
// }

void main(string[] args)
{
  Branca branca = "supersecretkeyyoushouldnotcommit";
  string encoded = branca.encode("data ecrypted");
  writeln(encoded);
  Branca dranca = Branca(2, "supersecretkeyyoushouldnotcommit");
  // // Thread.sleep(2.seconds);
  writeln(dranca.decode(encoded));


  /// Compiletime
  DrancaSeq params;
  params[0] = 1_000_000;
  params[1] = "supersecretkeyyoushouldnotcommit";
  Branca ddranca = params;
  // Branca ddranca = Branca(params);

  alias Brancaparam = AliasSeq!(10_000, "supersecretkeyyoushouldnotcommit");
  // Branca ddranca = Branca(Brancaparam);
  // Branca ddranca = Brancaparam;

  /// Runtime
  /// init with Tuple setup
  // DrancaTup params;
  // params.ttl = 10;
  // params.key = "supersecretkeyyoushouldnotcommit";
  /// init with Tuple one line
  // DrancaTup paramsp = DrancaTup(1000, "supersecretkeyyoushouldnotcommit");
  // Branca ddranca = Branca(paramsp);
  // Branca ddranca = paramsp;

  try
  {
    writeln("decode ", encoded);
    writeln("decoded : ", ddranca.decode(encoded));
    writeln("decode old data: ", ddranca.decode("KCCAHowZ1TXGo9RhtD1ATWVlwRfheLY49lDkIdXYqfUlMRnsjjs63gajVtuV9w"));
  }
  catch (BrokenBrancaException ae)
  {
    writeln(ae.msg);
  }
}
