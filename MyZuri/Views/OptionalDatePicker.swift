//
//  OptionalDateBinding.swift
//  MyZuri
//
//  Created by Deirdre Saoirse Moen on 12/29/24.
//

import SwiftUI

struct OptionalDatePicker: View {
	@Binding var date: Date?
	let title: String
	let removeTitle: String
	let addTitle: String

	var body: some View {
		if let optionalDateBinding = Binding($date) {
			DatePicker( title,
					   selection: optionalDateBinding,
					   displayedComponents: .date)
			Button(removeTitle) { date = nil }
		} else {
			Button(addTitle) { date = Date() }
		}
	}
}
