//
//  Subscription.swift
//  Framily
//
//  Created by Tharun kumar on 30/06/23.
//

import Foundation
import StoreKit

class PeriodFormatter {
    static var componentFormatter: DateComponentsFormatter {
        let formatter = DateComponentsFormatter()
        formatter.maximumUnitCount = 1
        formatter.unitsStyle = .full
        formatter.zeroFormattingBehavior = .dropAll
        return formatter
    }

    static func formatSubscriptionPeriod(unit: SKProduct.PeriodUnit, numberOfUnits: Int) -> String? {
        var dateComponents = DateComponents()
        dateComponents.calendar = Calendar.current
        componentFormatter.allowedUnits = [unit.toCalendarUnit()]
        
        switch unit {
        case .day:
            dateComponents.setValue(numberOfUnits, for: .day)
        case .week:
            dateComponents.setValue(numberOfUnits, for: .weekOfMonth)
        case .month:
            dateComponents.setValue(numberOfUnits, for: .month)
        case .year:
            dateComponents.setValue(numberOfUnits, for: .year)
        @unknown default:
            return nil
        }
        
        return componentFormatter.string(from: dateComponents)
    }
}

extension SKProduct.PeriodUnit {
    func toCalendarUnit() -> NSCalendar.Unit {
        switch self {
        case .day:
            return .day
        case .week:
            return .weekOfMonth
        case .month:
            return .month
        case .year:
            return .year
        @unknown default:
            debugPrint("Unknown period unit")
            return .day
        }
    }
}
