//
//  LiveVC.swift
//  Cram
//
//  Created by Pablo Garces on 12/2/17.
//  Copyright © 2017 Cram. All rights reserved.
//

import UIKit

class LiveVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var liveCollectionView: UICollectionView!
    @IBOutlet weak var pullTab: UIView!
    @IBOutlet weak var questionBack: UIView!
    @IBOutlet weak var btnBack1: UIView!
    @IBOutlet weak var btnText1: UILabel!
    @IBOutlet weak var btnBack2: UIView!
    @IBOutlet weak var btnText2: UILabel!
    @IBOutlet weak var btnBack3: UIView!
    @IBOutlet weak var btnText3: UILabel!
    @IBOutlet weak var btnBack4: UIView!
    @IBOutlet weak var btnText4: UILabel!
    @IBOutlet weak var leadImg: UIImageView!
    @IBOutlet weak var leadPoints: UILabel!
    @IBOutlet weak var leadBack: UIView!
    @IBOutlet weak var timerBack: UIView!
    @IBOutlet weak var leadText: UILabel!
    @IBOutlet weak var questionCountText: UILabel!
    @IBOutlet weak var questionText: UILabel!
    @IBOutlet weak var timer: KDCircularProgress!
    
    @IBOutlet weak var waitingRoomTableView: UITableView!
    @IBOutlet weak var waitingMessage: UILabel!
    @IBOutlet weak var waitingBtnBack: UIView!
    @IBOutlet weak var waitingRoomBackView: UIView!
    @IBOutlet weak var countdownLabel: UILabel!
    
    var totalSecondsCountDown = 10.0
    var gameTimer: Timer!
    var friendGameCount = 1
    
    var friendLiveCount = 10
    let questions =
    [
        "This is a question that was generated automatically from a course video lecture! ONE",
        "This is a question that was generated automatically from a course video lecture! TWO",
        "This is a question that was generated automatically from a course video lecture! THREE",
        "This is a question that was generated automatically from a course video lecture! FOUR"
    ]
    var friendsInGame =
    [
        "You"
    ]
    var friendsInGamePics =
    [
        "testface"
    ]
    var friendsInGamePoints =
    [
        125
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        waitingRoomBackView.isHidden = false
        countdownLabel.isHidden = true
        
        liveCollectionView.dataSource = self
        liveCollectionView.delegate = self
        waitingRoomTableView.dataSource = self
        waitingRoomTableView.delegate = self
        
        pullTab.layer.cornerRadius = pullTab.frame.size.height / 2
        questionBack.layer.cornerRadius = 6
        
        leadBack.layer.cornerRadius = leadBack.frame.size.height / 2
        leadBack.layer.masksToBounds = true
        leadImg.layer.cornerRadius = leadImg.frame.size.height / 2
        leadImg.layer.masksToBounds = true
        timerBack.layer.cornerRadius = timerBack.frame.size.height / 2
        timerBack.layer.masksToBounds = true
        
        timer.angle = 360
        waitingBtnBack.layer.cornerRadius = waitingBtnBack.frame.size.height / 2
        waitingBtnBack.layer.masksToBounds = true
        
        let headerHeight: CGFloat =  CGFloat(Int(waitingRoomTableView.rowHeight) * waitingRoomTableView.numberOfRows(inSection: 0)) / 2
        waitingRoomTableView.contentInset = UIEdgeInsetsMake(headerHeight, 0, -headerHeight, 0)
        
        // DEMO ADDING A PERSON
        let when = DispatchTime.now() + 3
        DispatchQueue.main.asyncAfter(deadline: when) {
            
            // THIS CRASHES
            self.addFriend(name: "Brian", pic: "testface", points: 34)
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        btnBack1.layer.cornerRadius = btnBack1.frame.size.height / 2
        btnBack2.layer.cornerRadius = btnBack1.frame.size.height / 2
        btnBack3.layer.cornerRadius = btnBack1.frame.size.height / 2
        btnBack4.layer.cornerRadius = btnBack1.frame.size.height / 2
        
        //questionText.alpha = 0.0
    }
    
    func addFriend(name: String, pic: String, points: Int) {
        
        waitingRoomTableView.beginUpdates()
        
        let indexPath = IndexPath(row: friendsInGame.count, section: 0)
        waitingRoomTableView.insertRows(at: [indexPath], with: .bottom)
        
        friendsInGame.append(name)
        friendsInGamePics.append(pic)
        friendsInGamePoints.append(points)
        
        waitingRoomTableView.endUpdates()
        
    }
    
    // Live Collection View
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "liveCell", for: indexPath) as! LiveCell
        cell.cellImg.image = UIImage(named: "zucc")
        cell.cellBack.layer.masksToBounds = true
        cell.cellImg.layer.masksToBounds = true
        cell.cellBack.layer.cornerRadius = 6
        cell.cellImg.layer.cornerRadius = 6

        cell.pointsBack.layer.masksToBounds = true
        cell.pointsBack.layer.cornerRadius = cell.pointsBack.frame.size.height / 2
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return friendLiveCount
    }
    
    func inGame(index: Int) {
        
        if index == questions.count {
            return
        }
        
        //Fade In
        self.questionText.fadeIn()
        self.questionCountText.fadeIn()
        self.btnText1.fadeIn()
        self.btnText2.fadeIn()
        self.btnText3.fadeIn()
        self.btnText4.fadeIn()
        
        questionCountText.text = "\(index + 1)/\(questions.count)"
        questionText.text = questions[index]
        startCountDownTimer()
        
        let when = DispatchTime.now() + 15
        DispatchQueue.main.asyncAfter(deadline: when) {
            
            self.timer.animate(fromAngle: self.timer.angle, toAngle: 0.0, duration: 1.0, completion: nil)
            self.totalSecondsCountDown = 10.0 + 1.0
            
            //Fadeout
            self.questionText.fadeOut()
            self.questionCountText.fadeOut()
            self.btnText1.fadeOut()
            self.btnText2.fadeOut()
            self.btnText3.fadeOut()
            self.btnText4.fadeOut()
            
            self.inGame(index: index + 1)
            
        }
        
    }
    
    @IBAction func startGameBtnClicked(_ sender: Any) {
        
        // Starts game
        // waitingRoomBackView.isHidden = true
        
        for subview in waitingRoomBackView.subviews {
            subview.isHidden = true
        }
        
        countdownLabel.isHidden = false
        
        var bounds = countdownLabel.bounds
        countdownLabel.font = countdownLabel.font.withSize(200)
        bounds.size = countdownLabel.intrinsicContentSize
        countdownLabel.bounds = bounds
        let scaleX = CGFloat(0.25)
        let scaleY = CGFloat(0.25)
        countdownLabel.transform = CGAffineTransform(scaleX: scaleX, y: scaleY)
        
        UIView.animate(withDuration: 1.0) {
            self.countdownLabel.transform = .identity
        }
        
        //self.inGame(index: 0)
    }

    @IBAction func cancelGameBtnClicked(_ sender: Any) {
        // Do Stuff
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func updateTimer() {
        
        if self.totalSecondsCountDown > 0 {
            self.totalSecondsCountDown = self.totalSecondsCountDown - 1
            print("Timer countdown: \(self.totalSecondsCountDown) + \(timer.angle)")
            
            //timer.angle = 360.0 * (10.0 / Double(totalSecondsCountDown))
            timer.animate(fromAngle: timer.angle, toAngle: 360.0 * (Double(totalSecondsCountDown) / 10.0), duration: 1, completion: nil)
            
        } else {
            self.stopCountDownTimer();
            print("Timer stops...")
            
        }
        
    }
    
    func startCountDownTimer() {
        
        if self.gameTimer != nil {
            self.gameTimer.invalidate()
            self.gameTimer = nil
        }
        
        if self.totalSecondsCountDown > 0 {
            self.gameTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
            RunLoop.current.add(self.gameTimer, forMode: RunLoopMode.commonModes)
            self.gameTimer.fire()
        }
        
    }
    
    func stopCountDownTimer() {
        if self.gameTimer != nil {
            self.gameTimer.invalidate()
            self.gameTimer = nil
        }
        
    }
    
    // Table view
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "joinedFriend", for: indexPath) as! JoinedFriend
        cell.backgroundColor = UIColor.white
        cell.friendName.text = "\(friendsInGame[indexPath.row]) joined!"
        cell.friendImg.image = UIImage(named: friendsInGamePics[indexPath.row])
        cell.friendPoints.text = "\(friendsInGamePoints[indexPath.row])"
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 60
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return friendsInGame.count
        
    }

}
