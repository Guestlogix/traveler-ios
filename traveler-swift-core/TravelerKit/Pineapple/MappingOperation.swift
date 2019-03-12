//
//  MappingOperation.swift
//  Cardinal
//
//  Created by Ata Namvari on 2017-05-07.
//  Copyright © 2017 capco. All rights reserved.
//

import Foundation

public class MappingOperation<T> : Operation where T : Decodable {

    public var data: Data?
    public private(set) var mappedResource: T?
    public private(set) var error: Error?
    public var resourceBlock: ((T) -> Void)?

    convenience public init(resourceBlock: ((T) -> Void)?) {
        self.init()
        self.resourceBlock = resourceBlock
    }

    override public func main() {
        guard !isCancelled, let data = data else {
            return
        }
        
        Log("Mapping...", data: type(of: mappedResource), level: .debug)
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        do {
            mappedResource = try decoder.decode(T.self, from: data)
            
            Log("Mapped Resource: ", data: type(of: mappedResource), level: .debug)
        } catch {
            self.error = error
            
            Log(error.localizedDescription, data: String(data: data, encoding: .utf8), level: .error)
        }
    }
}
