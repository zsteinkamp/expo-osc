# expo-osc

Open Sound Control support for sending and receiving OSC messages in Expo (React Native)

On the native side:

- [JavaOSC](https://github.com/hoijui/JavaOSC/) for Android
- [SwiftOSC](https://github.com/ExistentialAudio/SwiftOSC) for iOS

## Getting started

```sh
npm i aleruffo/expo-osc
```

## Usage

### Send OSC message (OSC client)

```javascript
import osc from 'expo-osc';

const portOut = 9090;

// OSC server IP address like '192.168.1.80' or 'localhost'
const address = 'localhost';

// Create the client only once
osc.createClient(address, portOut);

// Now you can send OSC messages like this (only after creating a client)
osc.sendMessage('/address/', [1.0, 0.5]);

// Send any combination of integer, float, boolean, and string values
osc.sendMessage('/address/', ['string value", 1, false, 0.5]);
```

### Receive OSC messages (OSC server)

```javascript
import { NativeEventEmitter } from "react-native";

import osc from "expo-osc";

// Create an event emiter sending the native osc module as parameter
const eventEmitter = new NativeEventEmitter(osc);

// Subscribe to GotMessage event to receive OSC messages
eventEmitter.addListener("GotMessage", (oscMessage) => {
  console.log("message: ", oscMessage);
});

const portIn = 9999;

// iOS can listen to specific "/adress/", leave it emtpy to listen to all
const addressToListen = "";

// Start listening to OSC messages on iOS
osc.createServer(addressToListen, portIn);

// Android
osc.createServer(portIn);

// To receive OSC messages your client should be addressing your device IP address
```

## Supported types

i Integer: two’s complement int32.

f Float: IEEE float32.

~~s NULL-terminated ASCII string.~~

~~b Blob, (aka byte array) with size.~~

T True.

F False.

~~N Null: (aka nil, None, etc).~~

~~I Impulse: (aka “bang”).~~
