//
//  OauthManager.swift
//  FlickerPhotos
//
//  Created by Alam, Sk on 21/02/2021.
//  Copyright © 2021 AlamShaikh. All rights reserved.
//

import Foundation
import OAuthSwift
internal class OuathManager {
    
   static let sharedInstance = OuathManager()
    var currentOAuth:OAuth1Swift!
}
