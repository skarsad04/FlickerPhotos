//
//  LocalDataManager.swift
//  FlickerPhotos
//
//  Created by Alam, Sk on 21/02/2021.
//  Copyright © 2021 AlamShaikh. All rights reserved.
//

import Foundation
import UIKit
import CoreData
class LocalDataManager {
    let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    let context: NSManagedObjectContext!
    init() {
    context = self.appDelegate.persistentContainer.viewContext
    }
    
    func getPhotos(forPage:String)-> [String: Any] {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Photos")
        let predicate = NSPredicate(format: "pages == \(forPage)")
        request.predicate = predicate
        var photosDict = [String: Any]()
        do {
            let result = try self.context.fetch(request)
            for data in result as! [NSManagedObject] {
                let userName = data.value(forKey: "username") as! String
                let pages = data.value(forKey: "pages") as! String
                let photos = data.value(forKey: "photos") as! String
                
                print("User Name is : "+userName+" and pages is : " + pages + "\n\n\nphotos" + photos)
                let photoData = Utility.convertStringToDictionary(text: photos)
                if let photoDta = photoData{
                    photosDict = photoDta
                }
            }
        } catch {
            print("Fetching data Failed")
        }
        
       return photosDict
    }
    func savePhotos(photos: String, pages: String){

        let photosEntity = NSEntityDescription.insertNewObject(forEntityName: "Photos",
                                                               into: self.context) as! Photos
        photosEntity.username = "user"
        photosEntity.pages = pages
        photosEntity.photos = photos
        appDelegate.saveContext()
    }
}
