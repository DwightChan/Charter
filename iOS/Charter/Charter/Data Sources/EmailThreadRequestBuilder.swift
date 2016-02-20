//
//  File.swift
//  Charter
//
//  Created by Matthew Palmer on 21/02/2016.
//  Copyright © 2016 Matthew Palmer. All rights reserved.
//

import Foundation

class EmailThreadRequestBuilder {
    var page: Int?
    var pageSize: Int?
    
    var mailingList: String?
    var inReplyTo: Either<String, NSNull>?
    
    /// (fieldName, sortAscending)
    var sort: [(String, Bool)]?
    
    func build() -> EmailThreadRequest {
        let request = EmailThreadRequestImpl(page: page, pageSize: pageSize, mailingList: mailingList, inReplyTo: inReplyTo, sort: sort)
        return request
    }
}

private struct EmailThreadRequestImpl: EmailThreadRequest {
    var page: Int?
    var pageSize: Int?
    
    var mailingList: String?
    var inReplyTo: Either<String, NSNull>?
    
    /// (fieldName, sortAscending)
    var sort: [(String, Bool)]?
    
    var URLRequestQueryParameters: Dictionary<String, String> {
        var dictionary = Dictionary<String, String>()
        
        var filter: Dictionary<String, Either<String, NSNull>> = Dictionary<String, Either<String, NSNull>>()
        if let inReplyTo = inReplyTo {
            filter["inReplyTo"] = inReplyTo
        }
        
        let filterArgs = filter.map { (pair: (String, Either<String, NSNull>)) -> String in
            let key = pair.0
            let either = pair.1
            
            let valueString: String
            switch either {
            case .Left:
                valueString = "'\(either)'"
            case .Right:
                valueString = "null"
            }
            return "\(key): \(valueString)"
        }
        
        let filterValueString = jsonFromEntryStrings(filterArgs)
        
        dictionary["filter"] = filterValueString
        
        let sortArgs = sort?.map { "\($0.0): \($0.1 ? 1 : -1)" } ?? []
        if let _ = sort {
            dictionary["sort"] = jsonFromEntryStrings(sortArgs)
        }
        
        if let pageSize = pageSize {
            dictionary["pagesize"] = "\(pageSize)"
        }
        
        if let page = page {
            dictionary["page"] = "\(page)"
        }
        
        return dictionary
    }
    
    var predicate: NSPredicate {
        return NSPredicate()
    }
}

private func jsonFromEntryStrings(entries: [String]) -> String {
    var str = "{"
    for entry in entries {
        if entry == entries.last {
            str += entry
        } else {
            str += entry + ","
        }
    }
    str += "}"
    return str
}

