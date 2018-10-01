//
//  DownloadOperation.swift
//  Lib
//
//  Created by Ata Namvari on 2017-05-28.
//  Copyright © 2017 capco. All rights reserved.
//

import Foundation

public protocol DownloadOperationDelegate: class {
    func downloadOperation(_ operation: DownloadOperation, didFinishDownloadTo url: URL)
    func downloadOperation(_ operation: DownloadOperation, didFailWithError error: Error)
}

public class DownloadOperation: ConcurrentOperation {

    public let urlRequest: URLRequest
    public let destinationPath: String
    public var delegate: DownloadOperationDelegate?
    public var downloadCompletionBlock: ((URL) -> Void)?
    public fileprivate(set) var error: Error?

    private let redownloadIfFileExists: Bool

    private lazy var session: URLSession = {
        let session = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: nil)
        return session
    }()
    fileprivate lazy var fileManager: FileManager = {
        return FileManager()
    }()

    public init(urlRequest: URLRequest, destinationPath: String, redownloadIfFileExists: Bool) {
        self.urlRequest = urlRequest
        self.destinationPath = destinationPath
        self.redownloadIfFileExists = redownloadIfFileExists
        super.init()
    }

    public convenience init(urlRequest: URLRequest, destinationPath: String) {
        self.init(urlRequest: urlRequest, destinationPath: destinationPath, redownloadIfFileExists: true)
    }

    public convenience init(url: URL, destinationPath: String) {
        self.init(urlRequest: URLRequest(url: url), destinationPath: destinationPath, redownloadIfFileExists: true)
    }

    public override func execute() {
        if fileManager.fileExists(atPath: destinationPath) {
            if redownloadIfFileExists {
                let url = URL(fileURLWithPath: destinationPath)
                try? fileManager.removeItem(at: url)
            } else {
                finish()
                return
            }
        }

        let downloadTask = session.downloadTask(with: urlRequest)
        downloadTask.resume()

        Log("Download started", data: urlRequest.url?.absoluteString, level: .debug)
    }
}

extension DownloadOperation : URLSessionDownloadDelegate {
    public func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        guard !isCancelled else {
            return
        }

        Log("Download finished", data: urlRequest.url?.absoluteString, level: .debug)

        let destinationURL = URL(fileURLWithPath: destinationPath)

        do {
            try fileManager.moveItem(at: location, to: destinationURL)
            downloadCompletionBlock?(destinationURL)
            delegate?.downloadOperation(self, didFinishDownloadTo: destinationURL)
        } catch {
            Log("Couldn't move file", data: destinationURL, level: .error)
            self.error = error
            delegate?.downloadOperation(self, didFailWithError: error)
        }
    }

    public func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        if isCancelled {
            downloadTask.cancel()
            session.invalidateAndCancel()
            finish()
        }
    }

    public func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        defer {
            session.invalidateAndCancel()
            finish()
        }
        guard let error = error else { return }
        Log("Error downloading file", data: urlRequest.url?.absoluteString, level: .error)
        self.error = error
        delegate?.downloadOperation(self, didFailWithError: self.error!)
    }
}
