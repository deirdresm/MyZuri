//
//  ImageDropView.swift
//  MyZuri
//
//  Created by Deirdre Saoirse Moen on 12/30/24.
//

import SwiftUI
import UniformTypeIdentifiers

// excluded PDF as it requires special handling.
let imageDropTypes: [UTType] = [.heic, .heif, .png, .gif, .jpeg, .webP, .tiff, .bmp, .svg, .rawImage]

// https://github.com/liamrosenfeld/Iconology/blob/main/Iconology/Main/SelectionModels/ImageRetriever.swift

struct ImageDropView: View {
	@Binding var imageData: Data?

	var body: some View {
		VStack {
			if let imageData = imageData,
				let platformImage = PlatformImage(data: imageData) {
				Image(image: platformImage)
					.resizable()
					.aspectRatio(contentMode: .fit)
					.frame(maxWidth: 500, maxHeight: 500)
			} else {
				Text("Drag and drop an image here.")
					.font(.headline)
					.padding()
					.frame(maxWidth: 500, maxHeight: 500)
					.background(Color.gray.opacity(0.3))
			}
		}
		.onDrop(of: imageDropTypes, isTargeted: nil) { (items) -> Bool in
			if let item = items.first {
				if let identifier = item.registeredTypeIdentifiers.first {
					print("onDrop with identifier = \(identifier)")

					item.loadDataRepresentation(forTypeIdentifier: identifier) { data, _ in
						if let data {
							imageData = data
						}
					}
//					if identifier == "public.url" || identifier == "public.file-url" {
//						item.loadItem(forTypeIdentifier: identifier, options: nil) { (urlData, error) in
//							DispatchQueue.main.async {
//								if let urlData = urlData as? Data {
//								  self.imageData = urlData
//								}
//							}
//						}
//					}
				}
				return true
			} else { print("item not here"); return false }
		}
	}

}


/*

 var body: some View {
	 VStack {
		 if let imageData = imageData,
			 let platformImage = PlatformImage(data: imageData) {
			 Image(image: platformImage)
				 .resizable()
				 .aspectRatio(contentMode: .fit)
				 .frame(maxWidth: .infinity, maxHeight: .infinity)
		 } else {
			 Text("Drag and drop an image here.")
				 .font(.headline)
				 .padding()
				 .frame(maxWidth: .infinity, maxHeight: .infinity)
				 .background(Color.gray.opacity(0.3))
		 }
	 }
	 .onDrop(of: imageDropTypes, delegate: self)
 }

 /// Required for conformance to `DropDelegate`
 func performDrop(info: DropInfo) -> Bool {

	 // Get the first item that conforms to the list of types.
	 if let provider = info.itemProviders(for: imageDropTypes).first {
		 // Process the first item provider that conforms to the specified types
		 provider.loadObject(ofClass: NSURL.self) { object, error in
			 if let error = error {
				 print("Error loading dropped item: \(error.localizedDescription)")
			 } else if let url = object as? URL, let data = try? Data(contentsOf: url) {
				 DispatchQueue.main.async {
					 self.imageData = data
				 }
			 }
		 }
		 return true
	 }

	 // If there are no items conforming to the specified types, check for file promise receivers in the pasteboard
	 let pasteboard = NSPasteboard(name: .drag)
	 guard let filePromises = pasteboard.readObjects(forClasses: [NSFilePromiseReceiver.self], options: nil),
		   let receiver = filePromises.first as? NSFilePromiseReceiver else {
		 return false
	 }

	 // Process the first file promise receiver
	 let queue = OperationQueue()
	 receiver.receivePromisedFiles(atDestination: URL.temporaryDirectory, operationQueue: queue) { (url, error) in
		 if let error = error {
			 print("Error loading dropped item from pasteboard: \(error.localizedDescription)")
		 } else if let data = try? Data(contentsOf: url) {
			 DispatchQueue.main.async {
				 self.imageData = data
			 }
		 }
	 }

	 return true
 }

 */
