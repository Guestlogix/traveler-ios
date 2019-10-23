//
//  MockAPI.swift
//  TravelerKitTests
//
//  Created by Omar Padierna on 2019-10-26.
//  Copyright © 2019 Ata Namvari. All rights reserved.
//

import Foundation

struct MockAPI {
    init() {
        registerProtocol()
    }

    func registerProtocol() {
        URLProtocol.registerClass(MockNetwork.self)
    }

    func loadURLs(for section: APISection) {
        let urls = section.urls

        switch section {
        case .authenticate(_):
            urls.forEach({ (url) in
                MockNetwork.mockResponses[url] = .success(DataResponses.authData())
            })
        case .flights(_ , _):
            urls.forEach({ (url) in
                MockNetwork.mockResponses[url] = .success(DataResponses.flightData())
            })
        case .catalog(_):
            urls.forEach { (url) in
                MockNetwork.mockResponses[url] = .success(DataResponses.catalogData())
            }
        }
    }
}
