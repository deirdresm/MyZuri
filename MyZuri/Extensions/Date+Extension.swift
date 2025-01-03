//
//  Date+Extension.swift
//  MyZuri
//
//  Created by Deirdre Saoirse Moen on 12/29/24.
//


import Foundation

extension Date {
	var year: Int {
		let calendar = Calendar.autoupdatingCurrent

		// Get the year, month, and day from the date
		let components = calendar.dateComponents([.year], from: self)
		return components.year ?? 2023
	}

	init(year: Int, month: Int, day: Int) {
		var dateComponents = DateComponents()
		dateComponents.year = year
		dateComponents.month = month
		dateComponents.day = day
		dateComponents.timeZone = TimeZone(abbreviation: "UTC") // Japan Standard Time
		dateComponents.calendar = Calendar.current
		dateComponents.hour = 0
		dateComponents.minute = 0
		dateComponents.second = 0

		self = Calendar.current.date(from: dateComponents)!
	}
}
