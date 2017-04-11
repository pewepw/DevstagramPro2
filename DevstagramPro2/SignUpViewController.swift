//
//  SignUpViewController.swift
//  DevstagramPro2
//
//  Created by Harry Ng on 13/03/2017.
//  Copyright © 2017 DevConcept. All rights reserved.
//

import UIKit
import SVProgressHUD

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    
    var selectedImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        signUpButton.setTitleColor(UIColor.lightText, for: .normal)
        signUpButton.isEnabled = false
        
        usernameTextField.backgroundColor = UIColor.clear
        usernameTextField.tintColor = .white
        usernameTextField.textColor = .white
        usernameTextField.attributedPlaceholder = NSAttributedString(string: usernameTextField.placeholder!, attributes: [NSForegroundColorAttributeName: UIColor(white: 1.0, alpha: 0.6)])
        let bottomLayer = CALayer()
        bottomLayer.frame = CGRect(x: 0, y: 29, width: 1000, height: 0.6)
        bottomLayer.backgroundColor = UIColor(red: 50/255, green: 50/255, blue: 25/255, alpha: 1).cgColor
        usernameTextField.layer.addSublayer(bottomLayer)
        
        
        emailTextField.backgroundColor = UIColor.clear
        emailTextField.tintColor = .white
        emailTextField.textColor = .white
        emailTextField.attributedPlaceholder = NSAttributedString(string: emailTextField.placeholder!, attributes: [NSForegroundColorAttributeName: UIColor(white: 1.0, alpha: 0.6)])
        let bottomLayer2 = CALayer()
        bottomLayer2.frame = CGRect(x: 0, y: 29, width: 1000, height: 0.6)
        bottomLayer2.backgroundColor = UIColor(red: 50/255, green: 50/255, blue: 25/255, alpha: 1).cgColor
        emailTextField.layer.addSublayer(bottomLayer2)
        
        
        passwordTextField.backgroundColor = UIColor.clear
        passwordTextField.tintColor = .white
        passwordTextField.textColor = .white
        passwordTextField.attributedPlaceholder = NSAttributedString(string: passwordTextField.placeholder!, attributes: [NSForegroundColorAttributeName: UIColor(white: 1.0, alpha: 0.6)])
        let bottomLayer3 = CALayer()
        bottomLayer3.frame = CGRect(x: 0, y: 29, width: 1000, height: 0.6)
        bottomLayer3.backgroundColor = UIColor(red: 50/255, green: 50/255, blue: 25/255, alpha: 1).cgColor
        passwordTextField.layer.addSublayer(bottomLayer3)
        
        
        profileImage.layer.cornerRadius = profileImage.frame.size.width / 2
        profileImage.clipsToBounds = true
        
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(SignUpViewController.handleSelectProfileImageView))
        profileImage.addGestureRecognizer(tapGesture)
        profileImage.isUserInteractionEnabled = true
        
        handleTextField()
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func handleTextField() {
        usernameTextField.addTarget(self, action: #selector(self.textFieldDidChange), for: .editingChanged)
        emailTextField.addTarget(self, action: #selector(self.textFieldDidChange), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(self.textFieldDidChange), for: .editingChanged)
    }
    
    func textFieldDidChange() {
        guard let username = usernameTextField.text, !username.isEmpty, let email = emailTextField.text, !email.isEmpty, let password = passwordTextField.text, !password.isEmpty else {
            
            signUpButton.setTitleColor(UIColor.lightText, for: .normal)
            signUpButton.isEnabled = false
            return
        }
        
        signUpButton.setTitleColor(UIColor.white, for: .normal)
        signUpButton.isEnabled = true
    }
    
    
    func handleSelectProfileImageView() {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        present(pickerController, animated: true, completion: nil)
    }
    
    @IBAction func dismissOnClick(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func signUpBtn_TouchUpInside(_ sender: Any) {
        
        view.endEditing(true)
        
        SVProgressHUD.show()
        
        if let profileImg = self.selectedImage, let imageData = UIImageJPEGRepresentation(profileImg, 0.1) {
            AuthService.signUp(username: usernameTextField.text!, email: emailTextField.text!, password: passwordTextField.text!, imageData: imageData, onSuccess: {
                //SVProgressHUD.showSuccess(withStatus: "Success")
                self.performSegue(withIdentifier: "signUpToTabbarVC", sender: nil)
                
            }, onError: { (errorString) in
                SVProgressHUD.showError(withStatus: errorString)
            })
        } else {
            SVProgressHUD.showError(withStatus: "Profile image can't be empty")
        }
    }
}

extension SignUpViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            profileImage.image = image
            selectedImage = image
        }
        
        dismiss(animated: true, completion: nil)
    }
    
}
