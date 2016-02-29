# iOS OpenDHT Dependencies

These scripts build several fat libraries for iOS and the iPhone Simulator, which can then in turn be used to build [OpenDHT](https://github.com/savoirfairelinux/opendht/) for iOS.

The following libraries will be built:

- libgmp
- libgnutls
- libgnutlsxx
- libhogweed
- libmsgpackc
- libnettle
- libtasn1

By default, all iOS architectures will be included:

- armv7
- armv7s
- arm64
- i386 (simulator)
- x86_64 (simulator)

## Requirements

libmsgpack-c requires autoconf, automake and libtool. If you don't have them installed, first run:

```
$ brew install autoconf
$ brew install automake
$ brew install libtool
```

## Usage

To build all libraries and architectures, use `build-all.sh`

```
$ ./build-all.sh
```

The build will take quite a while; depending on your system, as long as 30 minutes.

## Related projects

These scripts are based heavily on [a4tech](https://github.com/a4tech)'s [GnuTLS-GMP-Nettle-for-iOS](https://github.com/a4tech/GnuTLS-GMP-Nettle-for-iOS). Thanks, a4tech!

* <https://github.com/a4tech/GnuTLS-GMP-Nettle-for-iOS>
* <https://github.com/yep/gnutls-gpg-gpgme-for-ios>
* <https://github.com/x2on/GnuTLS-for-iOS>
* <https://gist.github.com/morgant/1753095>
