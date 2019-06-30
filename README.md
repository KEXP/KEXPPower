# KEXPPower

A lightweight swift library that is used to communicate with the KEXP serivces to retrieve play and show information.

## Requirements
- iOS 10.0+ / tvOS 10.0+
- Xcode 10.2+
- Swift 5+

## Installation
KEXPPower is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following lines to your Podfile:

### iOS/tvOS/macOS

```ruby
pod 'KEXPPower'
```

## Usage

```swift
import KEXPPower
```

- [Setup](#setup)
- [NetworkManager](#networkManager)
- [Contribute](#contribute)

### Setup

Setup:
To configure `KEXPPower`, call the KEXPPower `setup` method in your application's `AppDelegate`.

```swift
KEXPPower.setup(
    legacyBaseURL: legacyBaseURL,
    configurationURL: configurationURL,
    availableStreams: [AvailableStream(streamName: "Default Stream", streamURL: thirtyTwoBitURL), ...],
    defaultStreamIndex: 0,
    backupStreamIndex: 1
)
```

### NetworkManager

NetworkManager:
Use the NetworkManager to communicate with the KEXP serivces to retrieve play and show information.

```swift
let networkManager = NetworkManager()
networkManager.getShow() {result, showResult in
	print("Network request result.")
}
```

###Contribute/Usage
If you want to use and/or contribute to this library, please reach out and I can provide setup parameters for `KEXPPowerExample` 

## Author
dustin.bergman@gmail.com

## License

This library belongs to _KEXP_.

KEXPPower is available under the MIT license. See the LICENSE file for more info.


