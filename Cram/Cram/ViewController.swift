//
//  ViewController.swift
//  Cram
//
//  Created by Brian De Souza on 12/2/17.
//  Copyright © 2017 Cram. All rights reserved.
//

import UIKit
import GameKit
import FBSDKCoreKit
import FBSDKLoginKit
import FBSDKShareKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UITableViewDelegate, UITableViewDataSource, FBSDKLoginButtonDelegate {
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        
        if error == nil {
            
            //profileImgVIew.image = UIImage(named: "face")
            //personName.text = "Robert Hernandez"
            
        }
        
        return
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        
        return
    }
    
    func loginToFB(){
        
        //Facebook Account Token
        let accessToken = FBSDKAccessToken.current()
        
        if accessToken == nil{
            let loginButton = FBSDKLoginButton()
            loginButton.delegate = self
            loginButton.loginBehavior = FBSDKLoginBehavior.native
            
            FBSDKLoginManager().logIn(withReadPermissions: ["email", "public_profile", "user_friends"], from: self) { (result, err) in
                if err != nil {
                    print("Login failed")
                }
                print("Login successful")
            }
        }
    }
    

    @IBOutlet weak var friendView: UIView!
    @IBOutlet weak var friendsCollectionView: UICollectionView!
    @IBOutlet weak var classTableView: UITableView!
    @IBOutlet weak var friendSectionHeight: NSLayoutConstraint!
    @IBOutlet weak var friendLine: UIView!
    @IBOutlet weak var friendLineHeight: NSLayoutConstraint!
    @IBOutlet weak var downView: UIView!
    @IBOutlet weak var topicsTableView: UITableView!
    
    @IBOutlet weak var classTableViewTrailing: NSLayoutConstraint!
    @IBOutlet weak var friendLineTrailing: NSLayoutConstraint!
    @IBOutlet weak var downViewTrailing: NSLayoutConstraint!
    @IBOutlet weak var friendViewTrailing: NSLayoutConstraint!
    @IBOutlet weak var classTableViewLeading: NSLayoutConstraint!
    @IBOutlet weak var friendLineLeading: NSLayoutConstraint!
    @IBOutlet weak var friendViewLeading: NSLayoutConstraint!
    
    @IBOutlet weak var mainTitle: UILabel!
    @IBOutlet weak var mainSubtitle: UILabel!
    @IBOutlet weak var backArrowBtn: UIButton!
    @IBOutlet weak var backArrowImg: UIImageView!
    @IBOutlet weak var mainTitleLeading: NSLayoutConstraint!
    
    var friendLiveCount = 20
    var classCount = 20
    var topicsCount = 20
    var friendsHidden = false
    var purple = UIColor(displayP3Red: 95/255, green: 49/255, blue: 146/255, alpha: 1.0)
    var green = UIColor(displayP3Red: 101/255, green: 195/255, blue: 163/255, alpha: 1.0)
    var lightThemeGrey = UIColor(displayP3Red: 184/255, green: 184/255, blue: 184/255, alpha: 1.0)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        friendsCollectionView.delegate = self
        friendsCollectionView.dataSource = self
        classTableView.delegate = self
        classTableView.dataSource = self
        topicsTableView.delegate = self
        topicsTableView.dataSource = self
        
        downView.isHidden = true
        backArrowBtn.isHidden = true
        backArrowImg.isHidden = true
        
        let maskPath: UIBezierPath = UIBezierPath(roundedRect: self.downView.bounds, byRoundingCorners: ([.bottomLeft, .bottomRight]), cornerRadii: CGSize(6, 6))
        let maskLayer: CAShapeLayer = CAShapeLayer()
        maskLayer.frame = self.downView.bounds
        maskLayer.path = maskPath.cgPath
        self.downView.layer.mask = maskLayer
        // Do any additional setup loading the view, typically from a nib.
        
        //Launch Facebook Login
        self.loginToFB()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Collection Views
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "friendCell", for: indexPath) as! FriendCell
        cell.friendImg.layer.cornerRadius = cell.friendImg.frame.size.width / 2
        cell.friendImg.layer.masksToBounds = true
        cell.status.layer.cornerRadius = cell.status.frame.size.width / 2
        cell.status.layer.masksToBounds = true
        
        if indexPath.row < 4 {
            cell.status.backgroundColor = green
        } else {
            cell.status.backgroundColor = lightThemeGrey
        }
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return friendLiveCount
    }
    
    // Table Views
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == topicsTableView {
            
            return topicsCount
            
        } else {
            
            return classCount
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if tableView == topicsTableView {
            
            return 60
            
        } else {
            
            return 100
            
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == topicsTableView {
            
            let random = GKRandomDistribution(lowestValue: 1, highestValue: 4)
            let x = random.nextInt()
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "topicCell", for: indexPath) as! TopicCell
            
            cell.topicImg.image = UIImage(named: "topic\(x)")
            
            return cell
            
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "classCell", for: indexPath) as! ClassCell
            
            cell.mainImg.image = UIImage(named: "class")
            
            let backgroundView = UIView()
            backgroundView.backgroundColor = UIColor.clear
            cell.selectedBackgroundView = backgroundView
            
            return cell
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == classTableView {
            
            self.friendLineTrailing.constant = view.frame.size.width
            self.friendViewTrailing.constant = view.frame.size.width
            self.downViewTrailing.constant = view.frame.size.width + 15.0
            self.classTableViewTrailing.constant = view.frame.size.width
            
            self.classTableViewLeading.constant = view.frame.size.width
            self.friendLineLeading.constant = view.frame.size.width
            self.friendViewLeading.constant = view.frame.size.width
            
            backArrowBtn.isHidden = false
            backArrowImg.isHidden = false
            
            UIView.animate(withDuration: 0.5) {
                
                self.view.layoutIfNeeded()
                self.friendLine.alpha = 0
                self.friendView.alpha = 0
                self.classTableView.alpha = 0
                self.downView.alpha = 0
                self.mainTitleLeading.constant = 35
                
            }
            
            mainTitle.fadeOut()
            mainSubtitle.fadeOut()
            mainTitle.text = "Topics"
            mainSubtitle.text = "in Data Structures"
            mainTitle.fadeIn()
            mainSubtitle.fadeIn()
            
            print(indexPath.row)
            
        }
        
    }
    
    @IBAction func showFriendsClicked(_ sender: Any) {
        
        downView.isHidden = true
        
        self.friendSectionHeight.constant = 100
        self.friendLineHeight.constant = 1
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func hideFriendsClicked(_ sender: Any) {
        
        downView.isHidden = false
        
        self.friendSectionHeight.constant = 0
        self.friendLineHeight.constant = 0
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }

    }
    
    @IBAction func backBtnClicked(_ sender: Any) {
        
        self.friendLineTrailing.constant = 0
        self.friendViewTrailing.constant = 0
        self.downViewTrailing.constant = 15.0
        self.classTableViewTrailing.constant = 0
        
        self.classTableViewLeading.constant = 0
        self.friendLineLeading.constant = 0
        self.friendViewLeading.constant = 0
        
        backArrowBtn.isHidden = true
        backArrowImg.isHidden = true
        
        UIView.animate(withDuration: 0.5) {
            
            self.view.layoutIfNeeded()
            self.friendLine.alpha = 1
            self.friendView.alpha = 1
            self.classTableView.alpha = 1
            self.downView.alpha = 1
            self.mainTitleLeading.constant = 15
        }
        
        mainTitle.fadeOut()
        mainSubtitle.fadeOut()
        mainTitle.text = "Courses"
        mainSubtitle.text = "in Yale Computer Science"
        mainTitle.fadeIn()
        mainSubtitle.fadeIn()
        
    }
}

extension CGSize {
    
    init(_ width:CGFloat,_ height:CGFloat) {
        self.init(width:width,height:height)
    }
}

extension UIView {
    
    func fadeIn(duration: TimeInterval = 0.2, delay: TimeInterval = 0.0, completion: @escaping ((Bool) -> Void) = {(finished: Bool) -> Void in}) {
        UIView.animate(withDuration: duration, delay: delay, options: UIViewAnimationOptions.curveLinear, animations: {
            self.alpha = 1.0
        }, completion: completion)  }
    
    func fadeOut(duration: TimeInterval = 0.2, delay: TimeInterval = 0.0, completion: @escaping (Bool) -> Void = {(finished: Bool) -> Void in}) {
        UIView.animate(withDuration: duration, delay: delay, options: UIViewAnimationOptions.curveLinear, animations: {
            self.alpha = 0.0
        }, completion: completion)
    }
}

