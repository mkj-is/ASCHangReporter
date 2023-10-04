# ASCHangReporter

App Store Hang diagnostic logs reporter. A CLI tool to export all hang visible
in Xcode Organizer using the App Store Connect API.

## Installation

1. Clone this repository.
2. Run `swift build -c release`.
3. Use binary in `.build/release` folder.

## Usage

```
./ASCHangReporter <keyID> <issuerID> <privateKey> [<bundleIdentifier>]
```

### Parameters

- **keyID**: The key ID, required for API authentication.
- **issuerID**: The issuer ID, required for API authentication.
- **privateKey**: The private key, required for API authentication. Private key is a string inside the .p8 file without the header and footer.
- **bundleIdentifier**: The bundle identifier of the app you want to fetch
  the hang reports for. This is an optional parameter. If no bundle identifier is provided the first app will be used.

## Output

The tool will print out hang reports in the following format:

```
- Signature: <signature>
- Weight: <weight> %
- App version: <version>
- Bundle ID: <bundleID>
- Hang ID: <hangID>
```

Additionally, it will write the hang logs to a JSON file in the current directory. The filename will be the hang ID with a `.json` extension.

## Contributing

All contributions are welcome.

Project was created by [Matěj Kašpar Jirásek](https://iosdev.space/@mkj).

Project is licensed under [MIT license](LICENSE).
