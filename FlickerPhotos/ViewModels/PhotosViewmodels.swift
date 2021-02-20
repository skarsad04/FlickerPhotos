//
//  PhotosViewmodels.swift
//  FlickerPhotos
//
//  Created by Alam, Sk on 21/02/2021.
//  Copyright © 2021 AlamShaikh. All rights reserved.
//

import Foundation
import OAuthSwift
import SDWebImage
class PhotosViewModel: NSObject {
    let viewController : viewController?
    var arrPhotos:[[String: Any]]?
    var placeholderImage: UIImage!
     init(delegate: viewController) {
        placeholderImage = UIImage(named: "placeholder.png")
        self.viewController = delegate
        arrPhotos = [[String: Any]]()
    }
    func getPhotos(){
        // check if internet is there , then call the api
        if(ReachabilityManager.isConnected()){
            print("Getting Online Data")
            self.getUserPhotos(OuathManager.sharedInstance.currentOAuth, consumerKey: URLConstants.consumerKey)

        } else {
            // No Internet , call the local storage to get all photos if any
            print("Getting Offline Data")

            self.getSavedPhotos(pages: "1")
        }
        
    }
    func getUserPhotos(_ oauthswift: OAuth1Swift, consumerKey: String) {
           let url :String = "https://api.flickr.com/services/rest/"
           let parameters :Dictionary = [
               "method"         : "flickr.photos.search",
               "api_key"        : consumerKey,
               "user_id"        : "me",//"192174276@N04",
               "format"         : "json",
               "nojsoncallback" : "1",
               "extras"         : "url_q,url_z"
           ]
           let _ = oauthswift.client.get(url, parameters: parameters) { result in
               switch result {
               case .success(let response):
                let jsonDict = try? response.jsonObject() as? NSDictionary
                   let jsonData = try! JSONSerialization.data(withJSONObject: jsonDict, options: [])
                   let decoded = String(data: jsonData, encoding: .utf8)!
                   if let photos = jsonDict?["photos"] as? NSDictionary  {
                    if let _ = photos["photo"],let pages =  photos["pages"] as? NSNumber {
                        let strPages = pages.stringValue
                        self.showThePhotos(photos: photos, pages: strPages)
                        self.savePhotos(photos: photos, pages: strPages)

                    }
                   }
                   print(decoded)
               case .failure(let error):
                self.viewController?.showAlert(message: error.description)
                   print(error)
               }
           }
       }
    func showThePhotos(photos:NSDictionary, pages:String) {
        if(pages == "1"){
            self.arrPhotos?.removeAll()
        }
        if let arrPhoto = photos["photo"] as? [[String:Any]] {
            self.arrPhotos?.append(contentsOf: arrPhoto)
            if(self.arrPhotos?.count == 0){
                DispatchQueue.main.async {
                    self.viewController?.showAlert(message: "You dont have any photos.")
                }
            }else {
                DispatchQueue.main.async {
                    self.viewController?.reloadTheTableview()
                }
            }
            
        } else {
            DispatchQueue.main.async {
                               self.viewController?.showAlert(message: "You dont have any photos.")
                           }
        }

    }
    func getSavedPhotos(pages:String){
        DispatchQueue.main.async {
            let localDB = LocalDataManager()
            let photos = localDB.getPhotos(forPage: pages)
            self.showThePhotos(photos: photos as NSDictionary, pages: pages)

        }

    }
    func savePhotos(photos:NSDictionary, pages:String){
        let jsonData = try! JSONSerialization.data(withJSONObject: photos, options: [])
        let decoded = String(data: jsonData, encoding: .utf8)!

        let localDB = LocalDataManager()
        localDB.savePhotos(photos: decoded, pages: pages)
    }
   
}
extension PhotosViewModel: FlickerLoginViewModelDelegate {
    func didLoginSuccess() {
    }
    func didLoginFailed() {
        // Show alert in view controller
    }
    
}
extension PhotosViewModel : UITableViewDataSource,UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrPhotos?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PhotosTableViewCell", for: indexPath) as! PhotosTableViewCell
        let photo = self.arrPhotos?[indexPath.row] as NSDictionary?
        if let photo = photo {
            cell.imgView.sd_setImage(with: URL(string: photo["url_q"] as! String), placeholderImage:self.placeholderImage)
            cell.imgTitle.text =  photo["title"] as? String
        }

        return cell
    }
}
