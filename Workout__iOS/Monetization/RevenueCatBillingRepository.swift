//
//  RevenueCatBillingRepository.swift
//  Workout__iOS
//

import Foundation
import RevenueCat

final class RevenueCatBillingRepository {
    private let defaults: UserDefaults
    private let confirmedProKey = "confirmed_pro_from_purchase"

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    var isConfigured: Bool {
        Purchases.isConfigured
    }

    var isConfirmedProFromPurchase: Bool {
        defaults.bool(forKey: confirmedProKey)
    }

    func setConfirmedProFromPurchase(_ value: Bool) {
        defaults.set(value, forKey: confirmedProKey)
    }

    func getCustomerInfo() async throws -> CustomerInfo? {
        guard isConfigured else { return nil }
        return try await Purchases.shared.customerInfo()
    }

    func restorePurchases() async throws -> CustomerInfo? {
        guard isConfigured else { return nil }
        return try await Purchases.shared.restorePurchases()
    }

    func isProFromCustomerInfo(_ customerInfo: CustomerInfo?) -> Bool {
        customerInfo?
            .entitlements[MonetizationConfig.proEntitlementID]?
            .isActive == true
    }

    func isPro(customerInfo: CustomerInfo?) -> Bool {
        return isProFromCustomerInfo(customerInfo)
    }

    func errorMessage(_ error: Error) -> String {
        error.localizedDescription
    }
}
