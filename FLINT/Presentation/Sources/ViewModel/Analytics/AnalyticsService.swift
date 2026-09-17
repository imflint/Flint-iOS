//
//  AnalyticsService.swift
//  Presentation
//
//  Created by 진소은 on 9/17/26.
//

import Foundation

import AmplitudeSwift

public final class AnalyticsService: @unchecked Sendable {

    public static let shared = AnalyticsService()

    private var amplitude: Amplitude?
    private var onboardingStartAt: Date?

    private init() {}

    public func configure(apiKey: String) {
        amplitude = Amplitude(configuration: Configuration(apiKey: apiKey))
    }

    public func track(_ event: AnalyticsEvent) {
        amplitude?.track(eventType: event.name, eventProperties: event.properties)
    }

    public func setUserId(_ userId: String?) {
        amplitude?.setUserId(userId: userId)
    }

    public func clearUser() {
        amplitude?.setUserId(userId: nil)
        amplitude?.reset()
    }

    public func setUserProperty(_ property: AnalyticsUserProperty) {
        let identify = Identify()
        identify.set(property: property.name, value: property.value)
        amplitude?.identify(identify: identify)
    }

    public func incrementUserProperty(_ name: String, by amount: Int = 1) {
        let identify = Identify()
        identify.add(property: name, value: amount)
        amplitude?.identify(identify: identify)
    }

    public func markOnboardingStart() {
        onboardingStartAt = Date()
    }

    public func onboardingDurationSec() -> Int {
        guard let start = onboardingStartAt else { return 0 }
        return Int(Date().timeIntervalSince(start))
    }

    public func clearOnboardingStart() {
        onboardingStartAt = nil
    }
}
