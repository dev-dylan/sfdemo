//
//  LoginVC.swift
//  SensorsFocus
//
//  Created by 彭远洋 on 2019/9/27.
//  Copyright © 2019 Sensors Data Inc. All rights reserved.
//

import Foundation
import UIKit
import SensorsAnalyticsSDK

protocol LoginSuccessDelegate: NSObjectProtocol {
    func loginSuccess()
}

class LoginVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var submit: UIButton!
    @IBOutlet weak var usernameIndicator: UIView!
    @IBOutlet weak var passwordIndicator: UIView!
    weak var delegate: LoginSuccessDelegate?

    static func showLogin(_ viewController: UINavigationController, delegate: LoginSuccessDelegate) {
        let login = LoginVC.init()
        login.delegate = delegate
        OperationQueue.main.addOperation {
            viewController.present(login, animated: true, completion: nil)
        }
    }

    init() {
        super.init(nibName: "LoginVC", bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        username.delegate = self
        password.delegate = self
        username.keyboardType = .default
        password.keyboardType = .numberPad
        password.isSecureTextEntry = true
        username.clearButtonMode = .whileEditing
        password.clearButtonMode = .whileEditing
        usernameIndicator.backgroundColor = .init(hexString: "DFDFDF")
        passwordIndicator.backgroundColor = .init(hexString: "DFDFDF")
        submit.layer.cornerRadius = 5
        submit.layer.masksToBounds = true
        print("登录页面 didLoad")
    }

    @IBAction func submitAction(_ sender: Any) {

        if username.text!.isEmpty {
            return
        }

        if password.text!.isEmpty {
            return
        }

        let name = username.text!
        SensorsAnalyticsSDK.sharedInstance()?.track("RegisterResult", withProperties: ["account": name, "is_success": true])
        UserDefaults.standard.set(name, forKey: "username")
        UserDefaults.standard.synchronize()
        self.dismiss(animated: true) {
            self.delegate?.loginSuccess()
        }
    }

    @IBAction func closeAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        submit.isEnabled = false
        usernameIndicator.backgroundColor = .init(hexString: "DFDFDF")
        passwordIndicator.backgroundColor = .init(hexString: "DFDFDF")
        if textField == username {
            usernameIndicator.backgroundColor = .red
        }
        if textField == password {
            passwordIndicator.backgroundColor = .red
        }
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        submit.isEnabled = true
        usernameIndicator.backgroundColor = .init(hexString: "DFDFDF")
        passwordIndicator.backgroundColor = .init(hexString: "DFDFDF")

        let hightlight = !username.text!.isEmpty && !password.text!.isEmpty
        if hightlight {
            submit.gradientColor(.init(hexString: "E5281A"), to: .init(hexString: "FF6751"))
        } else {
            submit.gradientColor(.init(hexString: "E9F0F7"), to: .init(hexString: "E9F0F7"))
        }
        submit.setTitleColor( hightlight ? .white : .lightGray, for: .normal)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        username.resignFirstResponder()
        password.resignFirstResponder()
    }
}
