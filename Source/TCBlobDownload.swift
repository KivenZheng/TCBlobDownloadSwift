//
//  TCBlobDownload.swift
//  TCBlobDownloadSwift
//
//  Created by Thibault Charbonnier on 30/12/14.
//  Copyright (c) 2014 thibaultcha. All rights reserved.
//

import Foundation

public class TCBlobDownload {
    // The underlaying session download task
    let downloadTask: NSURLSessionDownloadTask

    // An optional delegate to get notified of events
    weak var delegate: TCBlobDownloadDelegate?
    
    // An optional file name. If nil, a suggested file name is used
    let fileName: String?
    
    // An optional destination path for the file. If nil, the file will be downloaded in the current user temporary directory
    let destinationPath: String?
    
    // A computed destinationURL depending on the destinationPath, fileName, and suggestedFileName from the underlying NSURLResponse
    var destinationURL: NSURL? {
        let destinationPath = self.destinationPath ?? NSTemporaryDirectory()
        let fileName = self.fileName ?? self.downloadTask.response?.suggestedFilename
                
        return NSURL(string: fileName!, relativeToURL: NSURL(fileURLWithPath: destinationPath!, isDirectory: true))
    }
    
    init(downloadTask: NSURLSessionDownloadTask, fileName: String?, destinationPath: String?, delegate: TCBlobDownloadDelegate?) {
        self.downloadTask = downloadTask
        self.delegate = delegate
        self.fileName = fileName
        self.destinationPath = destinationPath
    }
    
    // TODO: closures
    // TODO: cancel, resume, suspend, state
    // TODO: remaining time
}

// MARK: - Printable

extension TCBlobDownload: Printable {
    public var description: String {
        var parts: [String] = []
        var state: String
        
        switch self.downloadTask.state {
            case .Running: state = "running"
            case .Completed: state = "completed"
            case .Canceling: state = "canceling"
            case .Suspended: state = "suspended"
        }
        
        parts.append("TCBlobDownload")
        parts.append("URL: \(self.downloadTask.originalRequest.URL.absoluteString!)")
        parts.append("Download task state: \(state)")
        parts.append("destinationPath: \(self.destinationPath)")
        parts.append("fileName: \(self.fileName)")
        
        return join(" | ", parts)
    }
}