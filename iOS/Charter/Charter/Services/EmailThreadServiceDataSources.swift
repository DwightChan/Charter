//
//  EmailThreadDataSources.swift
//  Charter
//
//  Created by Matthew Palmer on 20/02/2016.
//  Copyright © 2016 Matthew Palmer. All rights reserved.
//

import Foundation

protocol EmailThreadCacheDataSource: class {
    func getThreads() -> [Email]
    func cacheThreads(threads: [Email], completion: Void -> Void)
}

protocol EmailThreadNetworkDataSource: class {
    func getThreads(completion: [Email] -> Void)
}
