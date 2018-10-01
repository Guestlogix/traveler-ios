//
//  UploadOperation.swift
//  Lib
//
//  Created by Ata Namvari on 2017-10-20.
//  Copyright © 2017 capco. All rights reserved.
//

import Foundation

public protocol UploadOperationDelegate: class {
    func uploadOperation(_ operation: UploadOperation, didFinishWithData data: Data?, urlResponse: HTTPURLResponse?)
    func uploadOperation(_ operation: UploadOperation, didFailWith error: Error)
}

public class UploadOperation: ConcurrentOperation {
    let urlRequest: URLRequest
    let fileURL: URL

    public internal(set) var data: Data?
    public internal(set) var response: HTTPURLResponse?
    public internal(set) var error: Error?
    public var dataCompletionBlock:((Data) -> Void)?
    public weak var delegate: UploadOperationDelegate?

    public init(urlRequest: URLRequest, fileURL: URL) {
        self.urlRequest = urlRequest
        self.fileURL = fileURL
        super.init()
    }

    public convenience init(urlRequst: URLRequest, fileURL: URL, dataCompletionBlock: ((Data?) -> Void)?) {
        self.init(urlRequest: urlRequst, fileURL: fileURL)
        self.dataCompletionBlock = dataCompletionBlock
    }

    private lazy var session: URLSession = {
        let session = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: nil)
        return session
    }()

    override public func execute() {
        let uploadTask = session.uploadTask(with: urlRequest, fromFile: fileURL) { (data, response, error) in
            defer {
                self.finish()
            }

            if self.isCancelled {
                return
            }

            let response = response as? HTTPURLResponse

            self.error = error ?? response.flatMap({ NetworkError(data: data, response: $0) })
            self.data = data
            self.response = response

            data.flatMap { self.dataCompletionBlock?($0) }

            switch error {
            case let error as NetworkError:
                Log(error.localizedDescription, data: error.data, level: error.logLevel)
                self.delegate?.uploadOperation(self, didFailWith: error)
            case .some(let error):
                Log("Error: \(error.localizedDescription)", data: data.flatMap({ String(data: $0, encoding: .utf8) }), level: .error)
                self.delegate?.uploadOperation(self, didFailWith: error)
            case .none:
                Log("Successful", data: "\(response?.statusCode ?? 0) - \(response?.url?.absoluteString ?? "[URL]")", level: .debug)
                self.delegate?.uploadOperation(self, didFinishWithData: data, urlResponse: response)
            }
        }

        uploadTask.resume()

        Log("Upload started", data: fileURL, level: .debug)
    }
}

extension UploadOperation: URLSessionTaskDelegate {
    public func urlSession(_ session: URLSession, task: URLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
        if isCancelled {
            task.cancel()
            session.invalidateAndCancel()
            finish()
        }
    }
}
