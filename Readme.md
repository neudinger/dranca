# Dranca: Branca library for D projects

## Requirement

Compile libsodium with buildsodium.sh</br>
or</br>
Download compiled library

## Running

### library

```sh
dub
dub --config=library-dynamic
dub --config=library-static
```

```sh
dub --config=application
```

## How to use

[Example](./source/example.d)

## Authors

**Barre Kevin** - *Initial work* - [neudinger](https://github.com/neudinger)

## License

This project is licensed under the European Union Public License 1.2 see the :eu: [eupl-1.2](https://choosealicense.com/licenses/eupl-1.2/) file for details.</br>
[European Union Public Licence](https://eupl.eu/)</br>
[:eu: Official EUPL website](https://joinup.ec.europa.eu/collection/eupl/eupl-text-11-12)

## Future work

- [ ] rewite aead_xchacha20poly1305 in D
- [ ] Rewrite basex  with @nogc

## Other tools used and library

- [dstep](https://github.com/jacob-carlborg/dstep) for libsodium c binding
