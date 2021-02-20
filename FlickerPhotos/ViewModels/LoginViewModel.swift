//
//  LoginViewModel.swift
//  FlickerPhotos
//
//  Created by Alam, Sk on 21/02/2021.
//  Copyright © 2021 AlamShaikh. All rights reserved.
//

import Foundation
import OAuthSwift

class FlickerLoginViewModel {
    
var oauthswift: OAuthSwift?
    let delegate: FlickerLoginViewModelDelegate?
    
    init(delegate:FlickerLoginViewModelDelegate) {
        self.delegate = delegate
}


func doFlickrLogin(){
    
    if(ReachabilityManager.isConnected()){
        print("OnlineData")

            let oauthswift = OAuth1Swift(
                consumerKey:    URLConstants.consumerKey,
                consumerSecret: URLConstants.consumerSecret,
                requestTokenUrl: URLConstants.requestTokenUrl,
                authorizeUrl:    URLConstants.authorizeUrl,
                accessTokenUrl:  URLConstants.accessTokenUrl
            )
            self.oauthswift = oauthswift
            oauthswift.authorizeURLHandler = getURLHandler()
            let _ = oauthswift.authorize(
            withCallbackURL: URL(string: "oauth-swift://oauth-callback/flickr")!) { result in
                switch result {
                case .success(let (credential, _, _)):
                    //self.showTokenAlert(name: serviceParameters["name"], credential: credential)
                    OuathManager.sharedInstance.currentOAuth = oauthswift
                    self.delegate?.didLoginSuccess()
        //            self.getUserPhotos(oauthswift, consumerKey: URLConstants.consumerKey)
                case .failure(let error):
                    print(error.description)
                    self.delegate?.didLoginFailed()

                }
            }
           
    } else {
        // Show offline Data
        print("Offline Data")
         self.delegate?.didLoginSuccess()
    }
    

}
func getURLHandler() -> OAuthSwiftURLHandlerType {
          return OAuthSwiftOpenURLExternally.sharedInstance
      }
}
