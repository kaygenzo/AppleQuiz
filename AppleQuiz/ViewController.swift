//
//  ViewController.swift
//  AppleQuiz
//
//  Created by Karim Yarboua on 06/03/2019.
//  Copyright © 2019 Karim Yarboua. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    @IBOutlet weak var container: UIView!
    
    var card: CustomCardView?
    var rect = CGRect()
    var buttonYes = CustomButton()
    var buttonNo = CustomButton()
    var scoreLabel = CustomLabel()
    var playButton: CustomButton?
    var isGame = false
    var timer = Timer()
    var availableTime = 0
    var score = 0
    
    let yesSound = Sound(name: "oui", ext: "wav")
    let noSound = Sound(name: "non", ext: "mp3")
    
    var audioPlayer: AVAudioPlayer?
    var soundPlayer : AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        buildView()
    }
    
    func buildView() {
       
        gradient()
        //container.frame = view.bounds
        
        rect = CGRect(x: container.frame.midX - 100, y: container.frame.midY - 100, width: 200, height: 200)

        setupButtons()
        setupLabel()
        setupGame()
    }
    
    func setupLabel() {
        scoreLabel = CustomLabel(frame: CGRect(x: 20, y: 10, width: container.frame.width - 40, height: 60))
        container.addSubview(scoreLabel)
    }
    
    func setupButtons() {
        let third = container.frame.width / 3
        let quarter = container.frame.width / 4
        let height: CGFloat = 50
        let y = container.frame.height - (height * 1.5)
        let size = CGSize(width: third, height: height)
        buttonNo.frame.size = size
        buttonNo.center = CGPoint(x: quarter, y: y)
        buttonNo.setup(string: "NO")
        buttonNo.addTarget(self, action: #selector(noClicked), for: .touchUpInside)
        buttonNo.isHidden = true

        buttonYes.frame.size = size
        buttonYes.center = CGPoint(x: quarter*3, y: y)
        buttonYes.setup(string: "YES")
        buttonYes.addTarget(self, action: #selector(yesClicked), for: .touchUpInside)
        buttonYes.isHidden = true
        
        container.addSubview(buttonNo)
        container.addSubview(buttonYes)
    }
    
    func gradient() {
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor.black.cgColor, UIColor.darkGray.cgColor]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        
        //gradient.frame = view.bounds
        //view.layer.addSublayer(gradient)
        view.bringSubviewToFront(container)
        
        gradient.frame = card?.bounds ?? view.bounds
        //card?.layer.addSublayer(gradient)
    }
    
    func setupGame() {
        if playButton != nil {
            playButton!.removeFromSuperview()
            playButton = nil
        }
        
        if isGame {
            card = CustomCardView(frame: rect)
            container.addSubview(card ?? UIView())
            buttonYes.isHidden = false
            buttonNo.isHidden = false
            let boolRandom = Int.random(in: 0...1) % 2 == 0
            card?.logo = Logo(isAppleImage: boolRandom)
            
            let sound = Sound(name: "tictac", ext: "mp3")
            if let url = Bundle.main.url(forResource: sound.name, withExtension: sound.ext) {
                do {
                    audioPlayer = try AVAudioPlayer(contentsOf: url)
                    audioPlayer?.numberOfLoops = 0
                    audioPlayer?.prepareToPlay()
                    audioPlayer?.play()
                } catch {
                    print(error.localizedDescription)
                }
            }
        } else {
            if(card != nil) {
                card!.removeFromSuperview()
                card = nil
            }
            score = 0
            playButton = CustomButton(frame: CGRect(x: 40, y: container.frame.height / 2 - 30, width: container.frame.width - 80, height: 60))
            playButton?.setup(string: "Play")
            playButton?.addTarget(self, action: #selector(playGame), for: .touchUpInside)
            container.addSubview(playButton ?? UIButton())
            buttonNo.isHidden = true
            buttonYes.isHidden = true
        }
        
    }
    
    func alert() {
        var best = UserDefaults.standard.integer(forKey: "score")
        if(score > best) {
            best = score
            UserDefaults.standard.set(best, forKey: "score")
            UserDefaults.standard.synchronize()
        }
        
        let alert = UIAlertController(title: "End!", message: "Your score is: \(score)\n Best score: \(best)", preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default) { (action) in
            self.playGame()
        }
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first, touch.view == card?.customMask {
            let xPosition = touch.location(in: container).x
            let distance = container.frame.midX - xPosition
            let angle = -distance / 360
            card?.center.x = xPosition
            card?.transform = CGAffineTransform(rotationAngle: angle)
            if distance >= 75 {
                card?.setMaskColor(.no)
            }
            else if(distance <= -75) {
                card?.setMaskColor(.yes)
            }
            else {
                card?.setMaskColor(.maybe)
            }
        }
    }
    
    func rotation() {
        guard card != nil else { return }
        card?.logo = Logo(isAppleImage: Int.random(in: 0...1) % 2 == 0)
        UIView.transition(with: card!, duration: 0.5, options: .transitionFlipFromRight, animations: nil, completion: nil)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first, touch.view == card?.customMask {
            UIView.animate(withDuration: 0.3, animations: {
                self.card?.transform = CGAffineTransform.identity
                self.card?.frame = self.rect
            }) { (success) in
                if self.card?.response != .maybe {
                    if self.card?.response == .yes {
                        self.yesClicked()
                    } else if(self.card?.response == .no) {
                        self.noClicked()
                    }
                }
            }
        }
    }
    
    func playSound(_ sound: Sound) {
        guard let url = Bundle.main.url(forResource: sound.name, withExtension: sound.ext) else { return }
        do {
            soundPlayer = try AVAudioPlayer(contentsOf: url)
            soundPlayer?.prepareToPlay()
            soundPlayer?.play()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    @objc func yesClicked() {
        if self.card?.logo?.isApple == true {
            self.score += 1
            playSound(yesSound)
        }
        else {
            playSound(noSound)
        }
        scoreLabel.updateText(availableTime, score)
        rotation()
    }
    
    @objc func noClicked() {
        if self.card?.logo?.isApple == false {
            self.score += 1
            playSound(yesSound)
        }
        else {
            playSound(noSound)
        }
        scoreLabel.updateText(availableTime, score)
        rotation()
    }
    
    @objc func playGame() {
        isGame = !isGame
        setupGame()
        if isGame {
            availableTime = 30
            launchTimer()
        }
    }
    
    func launchTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (timer) in
            self.availableTime -= 1
            self.scoreLabel.updateText(self.availableTime, self.score)
            if self.availableTime == 0 {
                timer.invalidate()
                self.scoreLabel.updateText(nil, nil)
                self.audioPlayer?.stop()
                self.alert()
            }
        })
    }
}

