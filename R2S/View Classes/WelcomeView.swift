//
//  WelcomeView.swift
//  R2S
//
//  Created by Earth Maniebo on 18/3/17.
//  Copyright © 2017 Total Integrated Resources. All rights reserved.
//

import UIKit

protocol WelcomeViewDelegate: class {
    func loginButtonPressed(sender: AnyObject)
    func signupButtonPressed(sender: AnyObject)
}

class WelcomeView: BaseUIView {
    weak var delegate: WelcomeViewDelegate?

    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    
    @IBAction func loginButtonPressed(_ sender: AnyObject) {
        delegate?.loginButtonPressed(sender: sender)
    }

    @IBAction func signupButtonPressed(_ sender: AnyObject) {
        delegate?.signupButtonPressed(sender: sender)
    }
    
}
