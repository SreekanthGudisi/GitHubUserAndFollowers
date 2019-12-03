//
//  ViewController.swift
//  assignment
//
//  Created by Sreekanth Gudisi on 03/12/19.
//  Copyright © 2019 Manjunath. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    // IBOutlets
    @IBOutlet weak var searchTextFileld: UITextField!
    @IBOutlet weak var textFieldUIView: UIView!
    @IBOutlet weak var activictityIndicator: UIActivityIndicatorView!
    
    // Class Variables
    var activeTextField: UITextField?
    
    // ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        // Load In ViewDidload Method
        loadViewDidloadMethod()
    }
    
    // viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        activeTextField = searchTextFileld
        moveTextField(textfield: activeTextField!, moveDistance: -100, up: true)
    }
}

//MARK:- Creating Service Call
extension ViewController {
    
    func searchByUsername() {
        
        // Show Activity Indicator
        showActivityIndicator()
        searchTextFileld?.resignFirstResponder()
        let username = searchTextFileld.text!
        if username.count == 0 {
            // Hide Activity Indicator
            hideActivityIndicator()
            self.showAlert(title: "", message: "Please search by Username")
            return
        }
        //create the urlString with String
        let urlString: String = "https://api.github.com/users/\(username)"
        //create the url with NSURL
        let url = URL(string: urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
        print(url as Any)
        // Create the Request with URLRequest
        let request = URLRequest(url: url!)
        //create the session object
        let session = URLSession.shared
        //create dataTask using the session object to send data to the server
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            // Error
            if let error = error {
                print("error:", error)
                // Hide Activity Indicator
                self.hideActivityIndicator()
                return
            }
            // Response Status with HTTPURLResponse
            let responseStatus = response as? HTTPURLResponse
            print("responseStatus Code", responseStatus as Any)
            do {
                guard let data = data else {
                    // Hide Activity Indicator
                    self.hideActivityIndicator()
                    return
                }
                let decode = JSONDecoder()
                let response = try decode.decode(UserResponse.self, from: data)
                DispatchQueue.main.async {
                    print(response)
                    // Hide Activity Indicator
                    self.hideActivityIndicator()
                    SharedInformation.instance().userResponse = response
                    if SharedInformation.instance().userResponse?.message == "Not Found" {
                        
                        // Showing An Alert
                        self.showAlert(title: "Oops!", message: "User not found")
                    } else if SharedInformation.instance().userResponse?.documentation_url == "https://developer.github.com/v3/#rate-limiting" {
                        
                        // Showing An Alert
                        let message = "API rate limit exceeded for current IP Address"
                        self.showAlert(title: "", message: message)
                    }else {
                        
                        // Hiding Indicator and Textfield
                        self.activeTextField = self.searchTextFileld
                        self.moveTextField(textfield: self.activeTextField!, moveDistance: -100, up: false)
                        // Go to next VC
                        self.performSegue(withIdentifier:
                            "DetailsViewController", sender: self)
                    }
                }
            } catch {
                print("error:", error)
            }
        })
        task.resume()
    }
}

//MARK:- UITextfield Delegate
extension ViewController {
    
    // After clicking search button
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        // Calling Service
        searchByUsername()
        return true
    }
    
    // Before clicking search button
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        activeTextField = textField
        moveTextField(textfield: activeTextField!, moveDistance: -100, up: true)
    }
    
    // After clicking search button
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        activeTextField = textField
        moveTextField(textfield: activeTextField!, moveDistance: -100, up: false)
    }
    
    // Logic for text up and down
    func moveTextField(textfield: UITextField, moveDistance: Int, up: Bool) {
        
        let moveDuration = 0.3
        let movement: CGFloat = CGFloat(up ? moveDistance: -moveDistance)
        UIView.beginAnimations("animateTextField", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(moveDuration)
        self.textFieldUIView.frame = self.textFieldUIView.frame.offsetBy(dx: 0, dy: movement)
        UIView.commitAnimations()
    }
}

//MARK:- Segue
extension ViewController {
    
    // Prepare Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "DetailsViewController") {
            
            let vc = segue.destination as! DetailsViewController
            vc.username = searchTextFileld.text!
        }
    }
}

//MARK:- Creating Alert
extension ViewController {
    
    public func showAlert(title: String, message: String?,_ handler: ((UIAlertAction) -> Swift.Void)? = nil) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: handler))
        self.present(alert, animated: true, completion: nil)
    }
}

//MARK:- Functions
extension ViewController {
    
    func loadViewDidloadMethod() {
        
        // Navigation Title
        navigationItem.title = "Assignment"
        
        // Textfield Set Delegate
        activeTextField = searchTextFileld
        searchTextFileld.delegate = self
        
        // ActivictityIndicator
        hideActivityIndicator()
    }
    
    // Show Activity Indicator
    func showActivityIndicator() {
        
        activictityIndicator.isHidden = false
        activictityIndicator.startAnimating()
    }
    
    // Hide Activity Indicator
    func hideActivityIndicator() {
        
        activictityIndicator.isHidden = true
        activictityIndicator.stopAnimating()
    }
}

