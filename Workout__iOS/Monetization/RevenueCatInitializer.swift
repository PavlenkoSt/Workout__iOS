//
//  RevenueCatInitializer.swift
//  Workout__iOS
//

import Foundation
import RevenueCat

enum RevenueCatInitializer {
    @discardableResult
    static func configure() -> Bool {
        let apiKey = MonetizationConfig.revenueCatAPIKey.trimmingCharacters(
            in: .whitespacesAndNewlines
        )
        guard !apiKey.isEmpty else { return false }
        guard !Purchases.isConfigured else { return true }

        #if DEBUG
            Purchases.logLevel = .debug
        #endif

        Purchases.configure(withAPIKey: apiKey, appUserID: nil)
        return Purchases.isConfigured
    }
}
