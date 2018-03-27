//
//  Extension+Error.swift
//  WeatherForecast
//
//  Created by yangpc on 2018. 3. 27..
//  Copyright © 2018년 yang hee jung. All rights reserved.
//

import Foundation
import MapKit

extension CLError: LocalizedError {

    public var localizedDescription: String {
        return self.errorDescription!
    }

    public var errorDescription: String? {
        switch self.code {
        case .locationUnknown:
            return NSLocalizedString("Location Unknown", comment: "")
        case .denied:
            return NSLocalizedString("Authorization Denied", comment: "")
        case .headingFailure:
            return NSLocalizedString("Heading Failure", comment: "")
        case .network:
            return NSLocalizedString("Network Problem", comment: "")
        case .regionMonitoringDenied:
            return NSLocalizedString("Denied Region Monitoring", comment: "")
        case .regionMonitoringFailure:
            return NSLocalizedString("Failed Region Monitoring", comment: "")
        case .regionMonitoringSetupDelayed:
            return NSLocalizedString("Delayed Setup Region Monitoring", comment: "")
        case .regionMonitoringResponseDelayed:
            return NSLocalizedString("Delayed Response Region Monitoring", comment: "")
        case .geocodeFoundNoResult:
            return NSLocalizedString("No Result Compatible", comment: "")
        case .geocodeFoundPartialResult:
            return NSLocalizedString("Partial Result Compatible", comment: "")
        case .geocodeCanceled:
            return NSLocalizedString("Canceled Compatible", comment: "")
        case .deferredFailed:
            return NSLocalizedString("Deferred Failed", comment: "")
        case .deferredNotUpdatingLocation:
            return NSLocalizedString("Deferred Not Updating Location", comment: "")
        case .deferredAccuracyTooLow:
            return NSLocalizedString("Deferred Accuracy Too Low", comment: "")
        case .deferredDistanceFiltered:
            return NSLocalizedString("Deferred Distance Filtered", comment: "")
        case .deferredCanceled:
            return NSLocalizedString("Deferred Canceled", comment: "")
        case .rangingUnavailable:
            return NSLocalizedString("Ranging Unavailable", comment: "")
        case .rangingFailure:
            return NSLocalizedString("Ranging Failure", comment: "")
        }
    }
}

extension MKError: LocalizedError {

    public var localizedDescription: String {
        return self.errorDescription!
    }

    public var errorDescription: String? {
        switch self.code {
        case .unknown:
            return NSLocalizedString("Unknown Error", comment: "")
        case .serverFailure:
            return NSLocalizedString("Server Failure", comment: "")
        case .loadingThrottled:
            return NSLocalizedString("Loading Throttled", comment: "")
        case .placemarkNotFound:
            return NSLocalizedString("Placemark Not Found", comment: "")
        case .directionsNotFound:
            return NSLocalizedString("Directions Not Found", comment: "")
        }
    }
}
