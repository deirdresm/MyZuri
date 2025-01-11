# MyZuri

* SwiftUI
* SwiftData
* Document-based app

Right now, it's functionally one table, as I haven't added support for the second table (`ItemColor`) yet or made more than a basic functioning UI.

![App screenshot showing Zuri dress that's Swifty](ReadmeImages/zuri-aerie-screenshot.png "App screenshot showing Zuri dress that's Swifty")

## TODO


### Main view (`ItemListView`)
1. Change the main view to have separate sections based on wishlist vs. purchased items.
2. Fix crash when picking category to sort by (as it's an enum nad the handling of how it gets passed to `Query` is obviously not functional).

### ItemColor (now a little struct)
1. Add `Item` support for the colors.
2. Add UI for editing colors.

### Codable stuff
1. Need to write out images (and read them in) for Codable, making real encoding/decoding more complex.

### Other Platforms
1. Verify it works on iOS (so far, only tested on macOS).

### Other Issues
1. There's no mechanism for preventing duplicates, e.g., on `Decodable` import, partly because I wanted to use iCloud (and the constraints on unique there).
