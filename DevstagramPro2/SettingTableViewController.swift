//
//  SettingTableViewController.swift
//  DevstagramPro2
//
//  Created by Harry Ng on 02/04/2017.
//  Copyright © 2017 DevConcept. All rights reserved.
//

import UIKit
import SVProgressHUD
protocol SettingTableViewControllerDelegate {
    func updateUserInfo()
}

class SettingTableViewController: UITableViewController {
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var profileImage: UIImageView!
    
    var delegate: SettingTableViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Edit Profile"
        usernameTextField.delegate = self
        emailTextField.delegate = self
        
        fetchCurrentUser()
        
    }
    
    func fetchCurrentUser() {
        Api.User.observeCurrentUser { (user) in
            self.usernameTextField.text = user.username
            self.emailTextField.text = user.email
            if let profileUrl = URL(string: user.profileImageUrl!) {
                self.profileImage.sd_setImage(with: profileUrl)
            }
        }
    }
    
    @IBAction func saveBtn_TouchUpInside(_ sender: Any) {
        if let profileImg = self.profileImage.image, let imageData = UIImageJPEGRepresentation(profileImg, 0.1) {
            SVProgressHUD.show(withStatus: "Saving...")
            AuthService.updateUserInfo(username: usernameTextField.text!, email: emailTextField.text!, imageData: imageData, onSuccess: {
                SVProgressHUD.showSuccess(withStatus: "Success")
                self.delegate?.updateUserInfo()
            }, onError: { (errorMessage) in
                SVProgressHUD.showError(withStatus: errorMessage)
            })
        }
    }
    
    @IBAction func logoutBtn_TouchUpInside(_ sender: Any) {
        AuthService.logout(onSuccess: {
            let storyboard = UIStoryboard(name: "Start", bundle: nil)
            let SignInVC = storyboard.instantiateViewController(withIdentifier: "SignInViewController")
            self.present(SignInVC, animated: true, completion: nil)
            
        }) { (errorMessage) in
            SVProgressHUD.showError(withStatus: errorMessage)
        }
    }
    
    @IBAction func changeProfileBtn_TouchUpInside(_ sender: Any) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        present(pickerController, animated: true, completion: nil)
    }
}

extension SettingTableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            profileImage.image = image
        }
        dismiss(animated: true, completion: nil)
    }
    
}

extension SettingTableViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
