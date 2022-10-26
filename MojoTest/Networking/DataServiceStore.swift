//
//  DataService.swift
//  MojoTest
//
//  Created by Nano Anderson on 10/24/22.
//

import Foundation

internal actor DataServiceStore {
    private var loadedFlatData: FlatData?
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
    func load() async throws -> FlatData {
        let (data, response) = try await URLSession.shared.data(from: url)
        guard
            let httpResponse = response as? HTTPURLResponse,
                httpResponse.statusCode == 200
        else {
            throw DataServiceError.statusNetworkingError
        }
        var flatData: FlatData?
        do {
        flatData = try JSONDecoder().decode(FlatData.self, from: data)
        } catch let DecodingError.dataCorrupted(context) {
            print(context)
        } catch let DecodingError.keyNotFound(key, context) {
            print("Key '\(key)' not found:", context.debugDescription)
            print("codingPath:", context.codingPath)
        } catch let DecodingError.valueNotFound(value, context) {
            print("Value '\(value)' not found:", context.debugDescription)
            print("codingPath:", context.codingPath)
        } catch let DecodingError.typeMismatch(type, context)  {
            print("Type '\(type)' mismatch:", context.debugDescription)
            print("codingPath:", context.codingPath)
        } catch {
            print("error: ", error)
        }
        
        loadedFlatData = flatData!
        return loadedFlatData!
    }
}
