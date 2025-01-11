# MyZuri

* SwiftUI
* SwiftData
* Document-based app

Right now, it's functionally one table, as I haven't added support for the second table (`ItemColor`) yet or made more than a basic functioning UI.

![App screenshot showing Zuri dress that's Swifty](ReadmeImages/zuri-aerie-screenshot.png "App screenshot showing Zuri dress that's Swifty")

## TODO


### Main view (`ItemGalleryView`)
1. Change the main view to have separate sections based on wishlist vs. purchased items. It turns out that SwiftData can't use SortDescriptors on enum fields, so the solution here is to add a separate column for the value. *heavy sigh* If I use an `Int` value instead of a raw one, I can also fix another annoyance: adding a new item adds it into the middle when sorting by name, but now I can give it a "floats to the top" integer value by making that integer -1 or something.
2. Fix crash when picking category to sort by (as it's an enum and the handling of how it gets passed to `Query` is obviously not functional). - probably the same fix as above.

### ItemColor (now a little struct)

1. Add `Item` support for the colors.
2. Add UI for editing colors.

### Codable stuff
1. Need to write out images (and read them in) for Codable, making real encoding/decoding more complex.

### Other Platforms
1. Verify it works on iOS (so far, only tested on macOS).

### Other Issues
1. There's no mechanism for preventing duplicates, e.g., on `Decodable` import, partly because I wanted to use iCloud (and the constraints on unique there).
2. Fix bug in spelling of "sleeveless" in enum when more awake.
3. Fix cause of following error: "It's not legal to call -layoutSubtreeIfNeeded on a view which is already being laid out.  If you are implementing the view's -layout method, you can call -[super layout] instead.  Break on void _NSDetectedLayoutRecursion(void) to debug.  This will be logged only once.  This may break in the future."
