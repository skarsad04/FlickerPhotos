//
//  ReachabilityManager.swift
//  FlickerPhotos
//
//  Created by Alam, Sk on 21/02/2021.
//  Copyright © 2021 AlamShaikh. All rights reserved.
//

import Foundation
import Alamofire

class ReachabilityManager:NSObject {
    
    static func isConnected()-> Bool {
        return NetworkReachabilityManager()!.isReachable
    }

}
