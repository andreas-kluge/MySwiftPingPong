//
//  ArenaViewModel.swift
//  PingPong
//
//  Created by Andreas Kluge on 02.01.25.
//

import Foundation
import SwiftUI

class ArenaViewModel: ObservableObject {
    //Game
    @Published var isGameRunning: Bool = false
    @Published var gameOverMessage: String = ""
    @Published var scoreLeft: Int = 0
    @Published var scoreRight: Int = 0
    private var maxScore: Int = 5
    
    @Published var arenaWidth: CGFloat = 0.0
    @Published var arenaHeight: CGFloat = 0.0
    
    // Left Padel
    @Published var leftPadelx: CGFloat = 0.0
    @Published var leftPadely: CGFloat = 0.0
    @Published var leftPadelWidth: CGFloat = 20.0
    @Published var leftPadelHeight: CGFloat = 100.0
    
    // Right Padel
    @Published var rightPadelx: CGFloat = 0.0
    @Published var rightPadely: CGFloat = 0.0
    @Published var rightPadelWidth: CGFloat = 20.0
    @Published var rightPadelHeight: CGFloat = 100.0
    
    // Ball
    @Published var ballx: CGFloat = 0.0
    @Published var bally: CGFloat = 0.0
    @Published var ballSize: CGFloat = 20.0
    @Published var ballSpeed: CGFloat = 0.03
    @Published var moveXpositiv: Bool = true
    @Published var moveYpositiv: Bool = true
    
    private var ballMoveDistance: CGFloat = 10.0
    private var moveBallTimer: Timer?
    
    
    //Constructor
    init(){
    }
    
    func setDimension(width: CGFloat, height: CGFloat){
        //print("width: \(width), height: \(height)")
        self.arenaHeight = height
        self.arenaWidth = width
        
        leftPadelx = 0.0
        leftPadely = (arenaHeight / 2) //- (ballSize / 2)
        rightPadelx = arenaWidth
        rightPadely = (arenaHeight / 2) //- (ballSize / 2)
    }
    
    func startBall(){
        //print("startBall")
        isGameRunning = true
        //Reset score
        scoreLeft = 0
        scoreRight = 0
        //Start timer
        moveBallTimer = Timer.scheduledTimer(timeInterval: ballSpeed, target: self, selector: #selector(moveBallTimerCallback), userInfo: nil, repeats: true)
    }
    
    func stopBall(){
        //print("stopBall")
        isGameRunning = false
        //Center Ball
        ballx = arenaWidth / 2
        bally = arenaHeight / 2
        //MoveBall Direction
        moveXpositiv = true
        moveYpositiv = true
        
        moveBallTimer?.invalidate()
    }
    
    
    @objc func moveBallTimerCallback(){
        
        //Move the ball
        self.moveBall()
        
    }
    
    func moveBall(){
        //print("X: \(ballx) Y: \(bally)")
        
        // X Movement
        //Runs over the maxwidth
        if((moveXpositiv == true) && (ballx + ballMoveDistance > arenaWidth)){
            //print("Out Right Check")
            //Check for out of field
            self.checkOutOfField(ballX: ballx, ballY: bally)
            moveXpositiv = false
        }
        //Comes back and underruns the left frame of the arena
        if(!moveXpositiv && (ballx - ballMoveDistance < 0.0)){
            //print("Out Left Check")
            //Check for out of field
            self.checkOutOfField(ballX: ballx, ballY: bally)
            moveXpositiv = true
        }
        //Move the ball
        if(moveXpositiv){
            ballx += ballMoveDistance
        }else{
            ballx -= ballMoveDistance
        }
        
        // Y Movement
        //Runs over the maxheigth
        if(moveYpositiv && (bally + ballMoveDistance > arenaHeight)){
            moveYpositiv = false
        }
        //Comes back and underruns the bottom frame of the arena
        if(!moveYpositiv && (bally - ballMoveDistance < 0.0)){
            moveYpositiv = true
        }
        //Move the ball
        if(moveYpositiv){
            bally += ballMoveDistance
        }else{
            bally -= ballMoveDistance
        }
    }
    
    func checkOutOfField(ballX: Double, ballY: Double){
        //print("BallX: \(ballX) BallY: \(ballY)")
        if ballX <= arenaWidth/2 {
            //Left side
            //print("LeftpaddelY: \(leftPadely)")
            //Check wether the left paddle was there or not
            if (ballY <= leftPadely+leftPadelHeight/2+ballSize && ballY >= leftPadely-leftPadelHeight/2-ballSize){
                //print("CATCH")
            } else {
                //print("OUT LEFT")
                let generator = UINotificationFeedbackGenerator()
                generator.notificationOccurred(.error)
                self.scoreRight += 1
                
                if self.scoreRight == maxScore {
                    self.stopBall()
                    self.gameOverMessage = " Right Player Wins! "
                }
            }
        } else {
            //Right side
            //print("RPT: \(rightPadely+rightPadelHeight/2) BY: \(ballY) RPB: \(rightPadely-rightPadelHeight/2)")
            //Check wether the right paddle was there or not
            if (ballY <= rightPadely+rightPadelHeight/2+ballSize && ballY >= rightPadely-rightPadelHeight/2-ballSize){
                //print("Catch")
            } else {
                //print("OUT RIGHT")
                let generator = UINotificationFeedbackGenerator()
                generator.notificationOccurred(.error)
                self.scoreLeft += 1
                
                
                if self.scoreLeft == maxScore {
                    self.stopBall()
                    self.gameOverMessage = " Left Player Wins! "
                }
            }
        }
    }
    
}
