//
//  DetailsViewController.swift
//  assignment
//
//  Created by Sreekanth Gudisi on 03/12/19.
//  Copyright © 2019 Manjunath. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {
    
    static func storeImage(urlstring: String, img: UIImage) {
        
        let path = NSTemporaryDirectory().appending(UUID().uuidString)
        let url = URL(fileURLWithPath: path)
        let data = img.jpegData(compressionQuality: 0.7)
        try? data?.write(to: url)
        
        var dict = UserDefaults.standard.object(forKey: "ImageCache") as? [String : String]
        if dict == nil {
            dict = [ String: String]()
        }
        dict![urlstring] = path
        UserDefaults.standard.set(dict, forKey: "ImageCache")
    }
    
    // IBOutlets
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userEmailLabel: UILabel!
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var followersLabel: UILabel!
    @IBOutlet weak var activictityIndicator: UIActivityIndicatorView!
    
    // Class Variables
    private let defaultAvatarImage = UIImage(named: "UserImage")
    private let imageCache = NSCache<NSString, UIImage>()
    var username =  String()
    private var items = [Items]()
    
    // ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        // Load In ViewDidload Method
        loadViewDidloadMethod()
    }
    
    // viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        

        // Calling Service
        getListOfFollowers()
    }
}

//MARK:- UITableView
extension DetailsViewController: UITableViewDelegate, UITableViewDataSource {
    

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 64
    }

    func numberOfSectionsInTableView(tableView: UITableView!) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var numOfSection: NSInteger = 0
        if items.count > 0{
            // If items data is there
            tableview.separatorStyle = .singleLine
            self.tableview.backgroundView = nil
            numOfSection = items.count
        }else{
            // If items data isn't there
            let noDataLabel: UILabel = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: self.tableview.frame.size.width, height: self.tableview.frame.size.height))
            tableview.separatorStyle  = .none
            let user : String = userNameLabel.text!.description
            noDataLabel.text = "\(user) doesn't have followers"
            noDataLabel.textColor = UIColor(red: 22.0/255.0, green: 106.0/255.0, blue: 176.0/255.0, alpha: 1.0)
            noDataLabel.textAlignment = NSTextAlignment.center
            self.tableview.backgroundView = noDataLabel
        }
        return numOfSection
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Make Cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailsTableViewCell", for: indexPath as IndexPath) as! DetailsTableViewCell
        // Get Data
        let tableViewData = items[indexPath.row]
        // Load Followers Name into Label
        cell.followersNameLabel.text = tableViewData.login
        // Load Followers Image into Image
        cell.followersImageView.image = defaultAvatarImage
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        let tableViewData = items[indexPath.row]
        let url = URL(string: tableViewData.avatar_url!.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
        // Checking Cache
        if let dict = UserDefaults.standard.object(forKey: "ImageCache") as? [String:String]{
            if let path = dict[(url!.absoluteString as NSString) as String] {
                if let data = try? Data(contentsOf: URL(fileURLWithPath: path)) {
                    let img = UIImage(data: data)
                    // If cache is there, Loading into cell from Cache
                    (cell as? DetailsTableViewCell)?.followersImageView.image = img
                    return
                }
            }
        }
        //lazy loading
        let session = URLSession.shared
        let task = session.dataTask(with: url!) { (data, response, error) in
            guard error == nil else {
                return
            }
            DispatchQueue.main.async {
                NSLog("cell number \(indexPath.row)")
                if let image = UIImage(data: data!) {
                    // calling from API
                    (cell as? DetailsTableViewCell)?.followersImageView.image = image
                    // Storinginto into Cache
                    DetailsViewController.storeImage(urlstring: (url!.absoluteString as NSString) as String, img: image)
                }
            }
        }
        task.resume()
    }
}

//MARK:- Creating Service Call
extension DetailsViewController {
    
    func getListOfFollowers() {
        
        // Show Activity Indicator
        showActivityIndicator()
        if username.count == 0 {
            // Hide Activity Indicator
            hideActivityIndicator()
            return
        }
        let userName = username
        //create the urlString with String
        let urlString: String = "https://api.github.com/search/users?q=\(userName)+repos:>100+followers:>100"
        //create the url with NSURL
        let url = NSURL(string: urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
        print(url as Any)
        // Create the Request with URLRequest
        let request = URLRequest(url: url! as URL)
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
                // Using Decoder
                let decode = JSONDecoder()
                let response = try decode.decode(SerachResponse.self, from: data)
                // Creating DispatchGroup
                let group = DispatchGroup()
                group.enter()
                DispatchQueue.main.async {
                    SharedInformation.instance().serachResponse = response
                    self.items.removeAll()
                    self.items = (SharedInformation.instance().serachResponse?.items)!
                    self.followersLabel.text = "Followers :-  " + self.items.count.description
                    self.tableview.reloadData()
                    group.leave()
                }
                group.enter()
                DispatchQueue.main.async {
                    // Hide Activity Indicator
                    self.hideActivityIndicator()
                    group.leave()
                }
            } catch {
                print("error:", error)
            }
        })
        task.resume()
    }
}

//MARK:- Functions
extension DetailsViewController {
    
    func loadViewDidloadMethod() {
        
        // Navigation Title
        navigationItem.title = "User Details"
        
        // Tableview Set Delegate And DataSource
        tableview.delegate = self
        tableview.dataSource = self
        
        // Hide Activity Indicator
        hideActivityIndicator()
        
        // Update UI like Labels and Images
        userNameLabel.text = SharedInformation.instance().userResponse?.name ?? SharedInformation.instance().userResponse?.login ?? "Not Available Username"
        userEmailLabel.text = SharedInformation.instance().userResponse?.email ?? "Not Available User Email"
        let urlString = SharedInformation.instance().userResponse?.avatar_url
        print(urlString as Any)
        if urlString?.count == nil {
            
            userImage.image = UIImage(named: "UserImage")
        }else {
            
            let url = URL(string: urlString!.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
            let data = try? Data(contentsOf: url!)
            if let imageData = data {
                let image = UIImage(data: imageData)
                userImage.image = image
            }else {
                
            }
        }
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


