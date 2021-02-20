//
//  ViewController.swift
//  FlickerPhotos
//
//  Created by Alam, Sk on 21/02/2021.
//  Copyright © 2021 AlamShaikh. All rights reserved.
//

import UIKit
protocol FlickerLoginViewModelDelegate {
    func didLoginSuccess()
    func didLoginFailed()
}

class ViewController: UIViewController {
    @IBOutlet weak var lblConnectionStatus: UILabel!
    @IBOutlet weak var btnLogin: UIButton!
    var photosViewModel: PhotosViewModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        self.updateConnectionStatus()
    }
    func updateConnectionStatus() {
        var strInternetStatus = "You are online"
        lblConnectionStatus.textColor = .green
        btnLogin.setTitle("Login with Flickr", for: .normal)
        if(!ReachabilityManager.isConnected()){
            strInternetStatus = "You are offline"
            lblConnectionStatus.textColor = .red
            btnLogin.setTitle("Get Local Photos", for: .normal)

        }
        lblConnectionStatus.text = strInternetStatus

    }
    @IBAction func btnLoginWithFlickerClicked(_ sender: UIButton) {
        let loginModel = FlickerLoginViewModel(delegate: self)
        loginModel.doFlickrLogin()
    }
    
}
extension ViewController: FlickerLoginViewModelDelegate {
    func didLoginSuccess() {
        self.performSegue(withIdentifier: "showPhotos", sender: nil)
//        let photosVC = PhotosViewController()
//        self.navigationController?.pushViewController(photosVC, animated: true)
//        self.getUserPhotos(OuathManager.sharedInstance.currentOAuth, consumerKey: URLConstants.consumerKey)
    }
    func didLoginFailed() {
        // Show alert in view controller
    }
    
}

