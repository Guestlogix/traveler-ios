//
//  Guest.swift
//  Traveler
//
//  Created by Ata Namvari on 2019-03-26.
//  Copyright © 2019 GuestLogix. All rights reserved.
//

import Foundation
import TravelerKit
import GoogleSignIn

class Guest {
    private static let shared = Guest()

    private let queue = OperationQueue()

    static func fetchProfile(_ user: GIDGoogleUser, completion: @escaping (Profile?, Error?) -> Void) {
        let fetchOperation = RemoteFetchOperation<Profile>(route: GuestRoute.login(user.authentication.idToken))
        let blockOperation = BlockOperation { [unowned fetchOperation] in
            completion(fetchOperation.resource, fetchOperation.error)
        }

        blockOperation.addDependency(fetchOperation)

        shared.queue.addOperation(fetchOperation)
        OperationQueue.main.addOperation(blockOperation)
    }

    static func logOut() {
        GIDSignIn.sharedInstance().signOut()
        UserDefaults.standard.removeObject(forKey: profileKey)
    }
}
