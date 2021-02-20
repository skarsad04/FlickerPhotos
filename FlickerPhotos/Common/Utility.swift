//
//  Utility.swift
//  FlickerPhotos
//
//  Created by Alam, Sk on 21/02/2021.
//  Copyright © 2021 AlamShaikh. All rights reserved.
//

import Foundation
import UIKit

class Utility {
    
   static func showAlertView(title: String, message: String, toView: UIViewController) {
           let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
           alert.addAction(UIAlertAction(title: "Close", style: UIAlertAction.Style.default, handler: nil))
           toView.present(alert, animated: true, completion: nil)
       }
    
   static func convertStringToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
}
