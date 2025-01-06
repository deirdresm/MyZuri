//
//  PlatformImage.swift
//  MyZuri
//
//  Created by Deirdre Saoirse Moen on 12/31/24.
//

import SwiftUI

extension Image {
#if os(macOS)
	init(image: NSImage) {
		self.init(nsImage: image)
	}
#else
	init(image: UIImage) {
		self.init(uiImage: image)
	}
#endif
}

#if os(macOS)
typealias PlatformImage = NSImage
#else
typealias PlatformImage = UIImage
#endif

#if os(macOS)
extension PlatformImage {

}
#endif
