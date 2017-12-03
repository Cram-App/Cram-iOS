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
import SDWebImage
import Firebase

var friendsInGame = [String]()
var userID = String()
var userName = String()
var userPoints = 0

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UITableViewDelegate, UITableViewDataSource, FBSDKLoginButtonDelegate {
    //@IBOutlet weak var userPointsLabel: UILabel!
    
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
    @IBOutlet weak var mainPointsLabel: UILabel!
    
    @IBOutlet weak var mainTitle: UILabel!
    @IBOutlet weak var mainSubtitle: UILabel!
    @IBOutlet weak var backArrowBtn: UIButton!
    @IBOutlet weak var backArrowImg: UIImageView!
    @IBOutlet weak var mainTitleLeading: NSLayoutConstraint!
    
    // Popup
    @IBOutlet weak var popupBack: UIView!
    @IBOutlet weak var popupImg: UIImageView!
    @IBOutlet weak var popupTitle: UILabel!
    @IBOutlet weak var acceptBtnBack: UIView!
    @IBOutlet weak var denyBtnBack: UIView!
    @IBOutlet weak var popupHeight: NSLayoutConstraint!
    
    var friendLiveCount = 20
    var classCount = 20
    var topicsCount = 20
    var topicsIndex = 0
    var friendsHidden = false
    var purple = UIColor(displayP3Red: 95/255, green: 49/255, blue: 146/255, alpha: 1.0)
    var green = UIColor(displayP3Red: 101/255, green: 195/255, blue: 163/255, alpha: 1.0)
    var lightThemeGrey = UIColor(displayP3Red: 184/255, green: 184/255, blue: 184/255, alpha: 1.0)
    var veryLightGrey = UIColor(displayP3Red: 247/255, green: 247/255, blue: 247/255, alpha: 1.0)
    
    let courseTitles =
    [
        "Introduction to Computing and Programming",
        "Introduction to Computer Science",
        "Mathematical Tools for Computer Science",
        "Discrete Mathematics",
        "Data Structures and Programming Techniques",
        "Introduction to Systems Programming and Computer Organization",
        "Algorithms",
        "Intensive Algorithms",
        
        "Intermediate Microeconomics",
        "Econometrics and Data Analysis",
        "General Chemistry II",
        "Natural Disasters",
        "How To Compare",
        "University Physics for the Life Sciences",
        "Elementary Studies in Analysis and Model Composition"
    ]
    let courseProfessors =
    [
        "Benedict Brown and Natalie Melo",
        "Stephen Slade",
        "James Aspnes",
        "Ross Berkowitz",
        "Staff",
        "Dana Angluin",
        "James Glenn",
        "Daniel Spielman",
        
        "Staff",
        "Staff",
        "Charles Schmuttenmaer",
        "David Bercovici and Maureen Long",
        "Robyn Creswell and Marta",
        "Simon Mochrie and Daisuke Nagai",
        "Staff"
    ]
    let courseTopics =
    [
        ["Algorithms","Data Structures","Encapsulation","Resource Management","Software Security","Software Engineering","Web Development"],
        ["Computer Systems","Algorithm Design","Software Complexity","Artificial Intelligence"],
        ["Propositional Logic","Discrete Mathematics","Linear Algebra"],
        ["Graphs","Binary Trees","Ramsey Theorem","Enumeration","Binomial Coefficients","Stirling Numbers"],
        ["Programming in C","Arrays","Stacks","Software Queues","Heaps","Sorting and Searching Software","Storage Allocation and Management","Data Abstraction","Testing and Debugging","Efficient Programs"],
        ["Machine Architecture","Computer Organization","Systems Programming","Issues in Operating Systems","Software Engineering","Scripting Languages"],
        ["Greedy Algorithms","Divide and Conquer","Dynamic Programming","Network Flow","NP Completeness and Approximation"],
        ["Greedy Algorithms","Divide and Conquer","Dynamic Programming","Network Flow","Approximation Algorithms","Randomized Algorithms"],
        
        ["The Theory of Choice","Consumer and Firm Behavior","Production","Price Determination","Welfare","Market Failure"],
        ["Basic Probability Theory and Statistics","Distribution Theory","Estimation and Inference","Bivariate Regression","Introduction to Multivariate Regression","Statistical Computing"],
        ["Kinetics","Chemical Equilibrium","Acid-Base Chemistry","Free Energy and Entropy","Electrochemistry","Nuclear Chemistry"],
        ["Earthquakes","Volcanoes","Tsunamis","Landslides","Coastal Flooding","Tornadoes","Hurricanes","Meteoritic Impacts","Hazard Mitigation Strategies"],
        ["Theories of Translation","Ekphrasis","Proper Use of Archives","The Paintings of Mantegna","The Paintings of Rembrandt","Arabian Nights"],
        ["Vectors and Kinematics","Newton's Laws","Momentum","Energy","Random Walks","Diffusion","Fluid Mechanics","Mathematical Modeling","Statistical Mechanics"],
        ["Tonal Harmony","Counterpoint","Phrase Rhythm","Motivic Development","model composition"]
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        popupHeight.constant = 0
        popupBack.alpha = 0
        
        friendsCollectionView.delegate = self
        friendsCollectionView.dataSource = self
        classTableView.delegate = self
        classTableView.dataSource = self
        topicsTableView.delegate = self
        topicsTableView.dataSource = self
        
        downView.isHidden = true
        backArrowBtn.isHidden = true
        backArrowImg.isHidden = true
        
        popupImg.layer.cornerRadius = popupImg.frame.size.width / 2
        acceptBtnBack.layer.cornerRadius = acceptBtnBack.frame.size.height / 2
        denyBtnBack.layer.cornerRadius = denyBtnBack.frame.size.height / 2
        popupImg.layer.masksToBounds = true
        
        let maskPath: UIBezierPath = UIBezierPath(roundedRect: self.downView.bounds, byRoundingCorners: ([.bottomLeft, .bottomRight]), cornerRadii: CGSize(6, 6))
        let maskLayer: CAShapeLayer = CAShapeLayer()
        maskLayer.frame = self.downView.bounds
        maskLayer.path = maskPath.cgPath
        self.downView.layer.mask = maskLayer
        
        if (UserDefaults.standard.value(forKey: "friendsInGame") != nil){
            friendsInGame = (UserDefaults.standard.value(forKey: "friendsInGame") as! [String])
        }
        if(UserDefaults.standard.value(forKey: "userID") != nil){
            userID = (UserDefaults.standard.value(forKey: "userID") as! String)
        }
        if(UserDefaults.standard.value(forKey: "userPoints") != nil){
            userPoints = (UserDefaults.standard.value(forKey: "userPoints") as! Int)
        }
        if(UserDefaults.standard.value(forKey: "userName") != nil){
            userName = (UserDefaults.standard.value(forKey: "userName") as! String)
        }
        
        topicsTableView.tableFooterView = UIView()
        classTableView.tableFooterView = UIView()
        
        //Launch Facebook Login
        self.loginToFB()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //Update status
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
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
    
    func loginToFB() {
        
        //Facebook Account Token
        let accessToken = FBSDKAccessToken.current()
        
        if accessToken == nil || userID == ""{
            
            if accessToken == nil{
                let loginButton = FBSDKLoginButton()
                loginButton.delegate = self
                loginButton.loginBehavior = FBSDKLoginBehavior.native
                
                FBSDKLoginManager().logIn(withReadPermissions: ["email", "public_profile", "user_friends"], from: self) { (result, err) in
                    if err != nil {
                        print("Login failed")
                    }
                    print("Login successful")
                    
                    let accessToken = FBSDKAccessToken.current()
                    //                guard let accessTokenString = accessToken?.tokenString else{
                    //                    print("token to string error")
                    //
                    //                    return
                    //                }
                    
                    //let credentials = FacebookAuthProvider.credential(withAccessToken: accessTokenString)
                }
            }
            
            FBSDKGraphRequest(graphPath: "/me", parameters: ["fields": "id, name, email, picture, location, age_range"]).start { (connection, result, err) in
                
                guard let data = result as? [String:Any] else { return }
                
                let _facebookName = data["name"] as! String
                print("Facebook Name", _facebookName)
                let _facebookId = data["id"] as! String
                //let _facebookProfileUrl = "https://graph.facebook.com/\(_facebookId)/picture?type=large"
                
                
                userID = _facebookId
                userName = _facebookName
                print("User Name", _facebookName)
                print("User Id", _facebookId)
                
                saveProfile()
                self.updateDBValues()
                self.observeUserDB()
            }
            
            self.updateFriends()
            
        }
        else{
            self.updateFriends()
            self.observeUserDB()
        }
        
    }
    
    func updateFriends(){
        
        FBSDKGraphRequest(graphPath: "/me/friends", parameters: ["fields": "id"]).start { (connection, result, err) in
            
            guard let data = result as? [String:Any] else { return }
            guard let dataArray = data["data"] as? NSArray else { return }
            for users in dataArray{
                guard var dataArrayValues = users as? [String:Any] else { return }
                
                if friendsInGame.contains(dataArrayValues["id"]! as! String) == false{
                    friendsInGame.append(dataArrayValues["id"]! as! String)
                }
            }
            
            print("User Friends in Game", friendsInGame)
            self.friendsCollectionView.reloadData()
            self.saveFriends()
        }
        
    }
    
    func saveFriends(){
        UserDefaults.standard.setValue(friendsInGame, forKey: "friendsInGame")
    }
    
    func updateDBValues(){
        ref.child("users/\(userID)/name").setValue(userName)
        ref.child("users/\(userID)/points").setValue(userPoints)
        ref.child("users/\(userID)/friendsInGame").setValue(friendsInGame)
    }
    
    // Collection Views
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "friendCell", for: indexPath) as! FriendCell
        cell.friendImg.layer.cornerRadius = cell.friendImg.frame.size.width / 2
        cell.friendImg.layer.masksToBounds = true
        cell.status.layer.cornerRadius = cell.status.frame.size.width / 2
        cell.status.layer.masksToBounds = true
        
        if indexPath.row < friendsInGame.count{
            let picUrl = URL(string: "https://graph.facebook.com/\(friendsInGame[indexPath.row])/picture?type=large")
            cell.friendImg.sd_setImage(with:  picUrl)
        }
        
        if indexPath.row < 4 {
            cell.status.backgroundColor = green
        } else {
            cell.status.backgroundColor = lightThemeGrey
        }
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return friendsInGame.count
    }
    
    // Table Views
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == topicsTableView {
            
            topicsCount = courseTopics[topicsIndex].count
            return topicsCount
            
        } else {
            
            classCount = courseTitles.count
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
            
            let random = GKRandomDistribution(lowestValue: 1, highestValue: 6)
            let x = random.nextInt()
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "topicCell", for: indexPath) as! TopicCell
            
            cell.topicImg.image = UIImage(named: "topic\(x)")
            cell.topicTitle.text = courseTopics[topicsIndex][indexPath.row]
            
            return cell
            
        } else {
            
            let random = GKRandomDistribution(lowestValue: 1, highestValue: 6)
            let x = random.nextInt()
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "classCell", for: indexPath) as! ClassCell
            
            let backgroundView = UIView()
            backgroundView.backgroundColor = UIColor.clear
            cell.selectedBackgroundView = backgroundView
            
            cell.mainImg.image = UIImage(named: "class\(x)")
            cell.title.text = courseTitles[indexPath.row]
            cell.teacher.text = courseProfessors[indexPath.row]
            cell.topicCount.text = "\(courseTopics[indexPath.row].count)"
            
            return cell
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print("CLICKED")
        
        if self.popupHeight.constant > 0 {
            // Close popup while switching pages
            
            self.popupHeight.constant = 0
            
            UIView.animate(withDuration: 0.25) {
                
                self.view.layoutIfNeeded()
                self.popupBack.alpha = 0
                
                let statusBarWindow = UIApplication.shared.value(forKey: "statusBarWindow") as? UIWindow
                statusBarWindow?.alpha = 1.0
                
            }
            
        }
        
        if tableView == classTableView {
            
            topicsIndex = indexPath.row
            topicsTableView.reloadData()
            
            self.friendLineTrailing.constant = view.frame.size.width
            self.friendViewTrailing.constant = view.frame.size.width
            self.downViewTrailing.constant = view.frame.size.width + 15.0
            self.classTableViewTrailing.constant = view.frame.size.width
            
            self.classTableViewLeading.constant = view.frame.size.width
            self.friendLineLeading.constant = view.frame.size.width
            self.friendViewLeading.constant = view.frame.size.width
            
            backArrowBtn.isHidden = false
            backArrowImg.isHidden = false
            
            UIView.animate(withDuration: 0.25) {
                
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
            tableView.deselectRow(at: indexPath, animated: false)
            
        }
        
        if tableView == topicsTableView {
            
            type = "HOST"
            self.createGame()
            
            //Reduntant when creating game
            //self.performSegue(withIdentifier: "goLive", sender: nil)
            
            print(indexPath.row)
            tableView.deselectRow(at: indexPath, animated: false)
            
        }
        
    }
    
    @IBAction func showFriendsClicked(_ sender: Any) {
        
        downView.isHidden = true
        
        self.friendSectionHeight.constant = 100
        self.friendLineHeight.constant = 1
        UIView.animate(withDuration: 0.25) {
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func hideFriendsClicked(_ sender: Any) {
        
        downView.isHidden = false
        
        self.friendSectionHeight.constant = 0
        self.friendLineHeight.constant = 0
        UIView.animate(withDuration: 0.25) {
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
        
        UIView.animate(withDuration: 0.25) {
            
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
    
    func observeUserDB(){
        if userID != ""{
        ref.child("users").child(userID).observe(.value, with: {(snapshot) in
            
            print("User Value Changed")
            if( snapshot.value is NSNull){
                print("No Internet")
            }
                
            else{
                var data  = snapshot.value! as! [String: Any]
                userPoints = data["points"] as! Int
                self.mainPointsLabel.text = "\(userPoints)"
                
                if data["pendingGames"] != nil{
                    
                    //Execute Pending Game
                    //Popup Joining Section
                    print("Invited For Game Session: , pendingGames",data["pendingGames"] as! String)
                    
                    self.popupHeight.constant = 105
                    print("pendinggames link \(data["pendingGames"] as! String)" )
                    gameRef = ref.child("currentGames/\(data["pendingGames"] as! String)")
                    
                    UIView.animate(withDuration: 0.5) {
                        
                        self.view.layoutIfNeeded()
                        self.popupBack.alpha = 1
                        
                        let statusBarWindow = UIApplication.shared.value(forKey: "statusBarWindow") as? UIWindow
                        statusBarWindow?.alpha = 0.0
                        
                    }
                }
                
                saveProfile()
                
            }
        })
        }
    }
    
    //Creates Game Session
    func createGame(){
        gameRef = ref.child("currentGames").childByAutoId()

        gameRef.child("leadboard/\(userID)/name").setValue(userName)
        gameRef.child("leadboard/\(userID)/totalPoints").setValue(userPoints)
        gameRef.child("leadboard/\(userID)/gamePoints").setValue(0)

        for friend in friendsInGame{
            if friend != userID{
                ref.child("users/\(friend)/pendingGames").setValue(gameRef.key)
            }
        }

        self.performSegue(withIdentifier: "goLive", sender: nil)
    }
    
    @IBAction func acceptQuizClicked(_ sender: Any) {
        
        print("joining session")
        print("gamekey", gameRef.key)
        self.joinSession()
        type = "GUEST"
        
        let when = DispatchTime.now() + 1.5
        DispatchQueue.main.asyncAfter(deadline: when) {
            print("going live")
            self.performSegue(withIdentifier: "goLive", sender: nil)
        }
        
    }
    
    @IBAction func denyQuizClicked(_ sender: Any) {
        
        self.denySession()
        
        self.popupHeight.constant = 0
        
        UIView.animate(withDuration: 0.25) {
            self.view.layoutIfNeeded()
            self.popupBack.alpha = 0
            let statusBarWindow = UIApplication.shared.value(forKey: "statusBarWindow") as? UIWindow
            statusBarWindow?.alpha = 1.0
        }
    }
    
    //Joins game if possible
    func joinSession(){
        
        print("Beginning")
        if userID != "", userName != ""{
            gameRef.child("leadboard/\(userID)/name").setValue(userName)
            gameRef.child("leadboard/\(userID)/totalPoints").setValue(userPoints)
            gameRef.child("leadboard/\(userID)/gamePoints").setValue(0)
        }
        else{
            print("failed if statement")
        }
        print("Successfully joining")
    }
    
    func denySession() {
        if userID != ""{
            print("Session Denied")
            ref.child("users/\(userID)/pendingGames").removeValue()
        }
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

func saveProfile(){
    UserDefaults.standard.setValue(userID, forKey: "userID")
    UserDefaults.standard.setValue(userName, forKey: "userName")
    UserDefaults.standard.setValue(userPoints, forKey: "userPoints")
}




