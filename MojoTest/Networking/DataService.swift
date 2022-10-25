//
//  DataService.swift
//  MojoTest
//
//  Created by Nano Anderson on 10/24/22.
//

import Foundation

private actor DataServiceStore {
    private var loadedBigJSON = [String: Any]()
    private var url: URL {
        // swiftlint:disable:next force_unwrapping
        urlComponents.url!
    }

    private var urlComponents: URLComponents {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "takehome-assets.s3.us-east-2.amazonaws.com"
        components.path = "/takehome_mobile_data.json"
        return components
    }

    /// This is meant to fetch the über-JSON that contains portfolio data
    /// (positions, wallet info) as well as the detailed data on one specific
    /// player, Tom Brady, best quarterback of all time.
    ///
    /// Since it's not normalized, or at least the schema doesn't make a ton
    /// of sense to me, I'm running it through multiple decoders to turn it
    /// into Swift struct instances, rather than one nested-data-understanding
    /// decoder.
    func load() async throws -> [String: Any] {
        let (data, response) = try await URLSession.shared.data(from: url)
        guard
            let httpResponse = response as? HTTPURLResponse,
                httpResponse.statusCode == 200
        else {
            throw DataServiceError.statusNetworkingError
        }
        guard let bigJSON = try JSONSerialization.jsonObject(with: data) as? [String: Any]
            else { throw DataServiceError.undecodedJsonError }
        loadedBigJSON = bigJSON
        return loadedBigJSON
    }
}

enum DataServiceError: Error {
    case statusNetworkingError
    case undecodedJsonError
    case decoderError
}
