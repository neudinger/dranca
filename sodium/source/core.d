module sodium.core;

extern (C) @nogc nothrow @trusted:

int sodium_init ();

/* ---- */

int sodium_set_misuse_handler (void function () handler);

void sodium_misuse ();

