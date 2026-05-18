//
//  MonetizationConfig.swift
//  Workout__iOS
//

import Foundation

enum MonetizationConfig {
    static let proEntitlementID = "Workout Unlimited"
    static let freePresetLimit = 3
    static let freeGoalLimit = 5
    static let freeRecordLimit = 10

    static var revenueCatAPIKey: String {
        configValue(for: "REVENUECAT_API_KEY")
    }

    static var hasRevenueCatAPIKey: Bool {
        !revenueCatAPIKey.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    private static func configValue(for key: String) -> String {
        let bundleValue = Bundle.main.object(forInfoDictionaryKey: key) as? String
        if let bundleValue, !bundleValue.isEmpty {
            return bundleValue
        }

        return ProcessInfo.processInfo.environment[key] ?? ""
    }
}
