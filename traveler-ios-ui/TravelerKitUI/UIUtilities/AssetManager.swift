//
//  AssetManager.swift
//  PassengerKit
//
//  Created by Ata Namvari on 2018-10-04.
//  Copyright © 2018 Ata Namvari. All rights reserved.
//

import UIKit
import TravelerKit

// TODO: Make internal

fileprivate struct ImageRoute: Route {
    let url: URL

    var urlRequest: URLRequest {
        return URLRequest(url: url)
    }
}

public class AssetManager {
    public static let shared = AssetManager()

    private let cache = NSCache<NSString, UIImage>()
    private let queue = OperationQueue()

    public func loadImage(with url: URL, completion: @escaping ((UIImage) -> Void)) {
        let cacheKey = url.absoluteString as NSString

        // Check in cache first

        if let image = cache.object(forKey: cacheKey) {
            completion(image)
            return
        }

        // Download image

        let networkOperation = NetworkOperation(route: ImageRoute(url: url))
        let imageOperation = BlockOperation { [unowned networkOperation, unowned self] in
            guard let data = networkOperation.data, let image = UIImage(data: data) else {
                return
            }

            DispatchQueue.main.async {
                completion(image)
            }

            // Cache image

            self.cache.setObject(image, forKey: cacheKey)
        }

        imageOperation.addDependency(networkOperation)

        queue.addOperation(networkOperation)
        queue.addOperation(imageOperation)
    }
}


