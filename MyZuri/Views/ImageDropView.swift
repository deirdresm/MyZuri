//
//  ImageDropView.swift
//  MyZuri
//
//  Created by Deirdre Saoirse Moen on 12/30/24.
//

import SwiftUI

struct ImageDropView: View {
	@Binding private var image: Image

	var body: some View {
		image
			.resizable()
			.scaledToFit()
			.frame(width: 300, height: 300)
			.dropDestination(for: Data.self) { items, location in
				guard let item = items.first else { return false }
				guard let platformImage = PlatformImage(data: item) else { return false }
				image = Image(image: platformImage)
				return true
			}

	}
}
