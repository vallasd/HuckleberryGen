//
//  HGFileQuery.swift
//  HuckleberryGen
//
//  Created by David Vallas on 9/1/15.
//  Copyright © 2015 Phoenix Labs. All rights reserved.
//

import Foundation

class HGFileQuery {
    
    static let shared = HGFileQuery()

    func importFiles(forPath path: String, completion: (importFiles: [ImportFile]) -> Void)  {
        let mdq = NSMetadataQuery()
        addQueryCompleteObserver(mdq: mdq, completion: completion)
        queryXCODEmodels(mdq: mdq, path: path)
    }
    
    private func queryXCODEmodels(mdq mdq: NSMetadataQuery, path: String) {
        mdq.searchScopes = [path]
        let fileExtension = "*.xcdatamodeld"
        mdq.predicate = NSPredicate(format: "%K like %@", NSMetadataItemFSNameKey, fileExtension)
        mdq.sortDescriptors = [NSSortDescriptor(key: NSMetadataItemContentModificationDateKey, ascending: false)]
        mdq.startQuery()
    }
    
    private func addQueryCompleteObserver(mdq mdq: NSMetadataQuery, completion: (importFiles: [ImportFile]) -> Void) {
        let queue = NSOperationQueue()
        queue.qualityOfService = .UserInitiated
        NSNotificationCenter.defaultCenter().addObserverForName(NSMetadataQueryDidFinishGatheringNotification, object: nil, queue: queue) { [weak self] (NSMetadataQueryDidFinishGatheringNotification) -> Void in
            var importFiles: [ImportFile] = []
            let lastUpdate = NSDate()
            for item in mdq.results {
                guard let displayName = item.valueForAttribute(NSMetadataItemDisplayNameKey) as? String else { break }
                guard let modificationDate = item.valueForAttribute(NSMetadataItemContentModificationDateKey) as? NSDate else { break }
                guard let creationDate = item.valueForAttribute(NSMetadataItemContentCreationDateKey) as? NSDate else { break }
                guard let pathKey = item.valueForAttribute(NSMetadataItemPathKey) as? String else { break }
                let name = displayName.stringByDeletingPathExtension
                let path = "\(pathKey)/\(name).xcdatamodel/contents"
                if NSFileManager.defaultManager().fileExistsAtPath(path) == false { break }
                let importFile = ImportFile(name: name, lastUpdate: lastUpdate, modificationDate: modificationDate, creationDate: creationDate, path: path, type: .XCODE_XML)
                importFiles.append(importFile)
            }
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                if self != nil { NSNotificationCenter.defaultCenter().removeObserver(self!) }
                mdq.stopQuery()
                completion(importFiles: importFiles)
            })
        }
    }
    
    
    
    private func displayShortItem(item item: NSMetadataItem) {
        
        guard let DisplayName = item.valueForAttribute(NSMetadataItemDisplayNameKey) else { print("Error Returning kMDItemDisplayName"); return }
        guard let ContentModificationDate = item.valueForAttribute(NSMetadataItemContentModificationDateKey) else { print("Error Returning kMDItemContentModificationDate"); return }
        guard let ContentCreationDate = item.valueForAttribute(NSMetadataItemContentCreationDateKey) else { print("Error Returning kMDItemContentCreationDate"); return }
        
        print(" DisplayName - \(DisplayName) \n ContentModificationDate - \(ContentModificationDate) \n ContentCreationDate - \(ContentCreationDate) \n")
    }
    
    private func displayItem(item item: NSMetadataItem) {
        guard let ContentTypeTree = item.valueForAttribute("kMDItemContentTypeTree") else { print("Error Returning kMDItemContentTypeTree"); return }
        guard let ContentType = item.valueForAttribute("kMDItemContentType") else { print("Error Returning kMDItemContentType"); return }
        guard let PhysicalSize = item.valueForAttribute("kMDItemPhysicalSize") else { print("Error Returning kMDItemPhysicalSize"); return }
        guard let DisplayName = item.valueForAttribute("kMDItemDisplayName") else { print("Error Returning kMDItemDisplayName"); return }
        guard let Kind = item.valueForAttribute("kMDItemKind") else { print("Error Returning kMDItemKind"); return }
        guard let DateAdded = item.valueForAttribute("kMDItemDateAdded") else { print("Error Returning kMDItemDateAdded"); return }
        guard let ContentModificationDate = item.valueForAttribute("kMDItemContentModificationDate") else { print("Error Returning kMDItemContentModificationDate"); return }
        guard let ContentCreationDate = item.valueForAttribute("kMDItemContentCreationDate") else { print("Error Returning kMDItemContentCreationDate"); return }
        guard let FSName = item.valueForAttribute("kMDItemFSName") else { print("Error Returning kMDItemFSName"); return }
        guard let FSOwnerUserID = item.valueForAttribute("kMDItemFSOwnerUserID") else { print("Error Returning kMDItemFSOwnerUserID"); return }
        guard let FSLabel = item.valueForAttribute("kMDItemFSLabel") else { print("Error Returning kMDItemFSLabel"); return }
        
        print("ContentTypeTree - \(ContentTypeTree) \n ContentType - \(ContentType) \n PhysicalSize - \(PhysicalSize) \n DisplayName - \(DisplayName) \n Kind - \(Kind) \n DateAdded - \(DateAdded) \n ContentModificationDate - \(ContentModificationDate) \n ContentCreationDate - \(ContentCreationDate) \n FSName - \(FSName) \n FSOwnerUserID - \(FSOwnerUserID) \n FSLabel - \(FSLabel) \n ")
    }
}