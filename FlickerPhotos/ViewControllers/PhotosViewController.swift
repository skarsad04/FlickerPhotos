//
//  PhotosViewController.swift
//  FlickerPhotos
//
//  Created by Alam, Sk on 21/02/2021.
//  Copyright © 2021 AlamShaikh. All rights reserved.
//

import UIKit
protocol viewController {
  func reloadTheTableview ()
    func showAlert(message: String)
}
class PhotosViewController: UIViewController {

    @IBOutlet weak var tblPhotos: UITableView!
    var photoViewModel: PhotosViewModel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Photos"
        photoViewModel = PhotosViewModel(delegate: self)
        tblPhotos.register(UINib(nibName: "PhotosTableViewCell", bundle: nil), forCellReuseIdentifier: "PhotosTableViewCell")
        self.tblPhotos.delegate = photoViewModel
        self.tblPhotos.dataSource = photoViewModel
        // Do any additional setup after loading the view.
        DispatchQueue.global().async {
        self.getUserPhotos()
            }
    }
   
       
func getUserPhotos()  {
    photoViewModel.getPhotos()
}

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension PhotosViewController : viewController {
    
    func showAlert(message: String) {
        Utility.showAlertView(title: "Sorry!", message:message , toView: self)
    }
    
      // This method is used to call from viewModel to reload the table
    func reloadTheTableview(){
          self.tblPhotos.reloadData()
      }

}
