//
//  ViewController.swift
//  MyCalculator
//
//  Created by Walter Barlet on 11/1/15.
//  Copyright © 2015 BMI Companies. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    @IBOutlet weak var outpuLbl:UILabel!
    
    enum Operation: String {
        case Divide = "/"
        case Multiple = "*"
        case Substract = "-"
        case Add = "+"
        case Empty = "Empty"
        case Decimal = "."
    }
    var btnSound: AVAudioPlayer!
    var blockSound: AVAudioPlayer!
    
    var runningNumber = ""
    var leftValStr = ""
    var rightValStr = ""

    var currentOperation: Operation = Operation.Empty
    var results = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let soundPath = Bundle.main.path(forResource: "btn", ofType: "wav")
        let soundUrl = URL(fileURLWithPath: soundPath!)
        let sound1Path = Bundle.main.path(forResource: "wrong", ofType: "wav")
        let sound1Url = URL(fileURLWithPath: sound1Path!)
        do {
          try btnSound = AVAudioPlayer(contentsOf: soundUrl)
            btnSound.prepareToPlay()
        } catch let error as NSError {
            print(error.debugDescription)
        }
        do {
            try blockSound = AVAudioPlayer(contentsOf: sound1Url)
            blockSound.prepareToPlay()
        } catch let error as NSError {
            print(error.debugDescription)
        }
        
    }

    @IBAction func numberPressed(_ btn: UIButton!) {
        if btn.tag != 10 {
            runningNumber += "\(btn.tag)"
            outpuLbl.text = runningNumber
            playSound()
        } else {
            if let idx = runningNumber.characters.index(of: ".") {
                playErrorSound()
                print("\(idx) previous dot")
            } else {
                runningNumber = "\(runningNumber)."
                playSound()
            }
        }
    }

    @IBAction func onDividedPressed(_ sender: AnyObject) {
        processOperation(Operation.Divide)
    }

    @IBAction func onMultiplePressed(_ sender: AnyObject) {
        processOperation(Operation.Multiple)
    }
    @IBAction func onSubstractPressed(_ sender: AnyObject) {
        processOperation(Operation.Substract)
    }
    @IBAction func onAddPressed(_ sender: AnyObject) {
        processOperation(Operation.Add)
    }
    @IBAction func onEqualPressed(_ sender: AnyObject) {
        processOperation(currentOperation)
    }
    @IBAction func onClearPressed(_ sender: AnyObject) {
        runningNumber = ""
        leftValStr = ""
        rightValStr = ""
        outpuLbl.text = "0"
        currentOperation = Operation.Empty
        results = ""
        playSound()
    }
    
    @IBAction func nClearLastPressed(_ sender: AnyObject) {
        if runningNumber != "" {
            runningNumber = ""
            outpuLbl.text = "0"
            playSound()
        } else {
           playErrorSound()
        }
    }

    
    func processOperation(_ op: Operation) {
        playSound()
        if leftValStr != "" && currentOperation != Operation.Empty {
            if runningNumber != "" {
                rightValStr = runningNumber
                runningNumber = ""
                if currentOperation == Operation.Multiple {
                    results = "\(Double(leftValStr)! * Double(rightValStr)!)"
                } else if currentOperation == Operation.Divide {
                    results = "\(Double(leftValStr)! / Double(rightValStr)!)"
                } else if currentOperation == Operation.Substract {
                    results = "\(Double(leftValStr)! - Double(rightValStr)!)"
                } else if currentOperation == Operation.Add {
                    results = "\(Double(leftValStr)! + Double(rightValStr)!)"
                }
                leftValStr = results
                outpuLbl.text = results
            }
            currentOperation = op
        } else {
            leftValStr = runningNumber
            runningNumber = ""
            currentOperation = op
        }
    }
    
    func playSound() {
        if btnSound.isPlaying {
            btnSound.stop()
        }
        btnSound.play()
    }
    func playErrorSound() {
        if blockSound.isPlaying {
            blockSound.stop()
        }
        blockSound.play()
    }
}

