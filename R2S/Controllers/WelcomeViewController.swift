//
//  WelcomeViewController.swift
//  R2S
//
//  Created by Earth Maniebo on 18/3/17.
//  Copyright © 2017 Total Integrated Resources. All rights reserved.
//

import UIKit

class WelcomeViewController: BaseViewController {
    
    var welcomeView = WelcomeView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initUILayout()
        if UserManager.sharedInstance.isLoggedIn! {
            self.performSegue(withIdentifier: Constants.segue.welcomeToHome, sender: self)
        }

        // Do any additional setup after loading the view.
//        self.performSegue(withIdentifier: Constants.segue.welcomeToLogin, sender: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.configureNavBar()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Private Functions
    private func initUILayout() {
        self.welcomeView = self.loadFromNibNamed(nibNamed: Constants.xib.welcome) as! WelcomeView
//        self.view.addSubview(self.welcomeView)
        self.view = self.welcomeView
        self.welcomeView.delegate = self
    }

    private func configureNavBar() {
        self.navigationItem.hidesBackButton = true
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
}

extension WelcomeViewController: WelcomeViewDelegate {
    func loginButtonPressed(sender: AnyObject) {
        self.performSegue(withIdentifier: Constants.segue.welcomeToLogin, sender: self)
    }
    
    func signupButtonPressed(sender: AnyObject) {
        self.performSegue(withIdentifier: Constants.segue.welcomeToRegister, sender: self)
    }
}
