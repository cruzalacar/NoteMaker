//
//  ViewController.swift
//  NoteMaker
//
//  Created by Murtaza on 2019-12-06.
//  Copyright © 2019 Murtaza. All rights reserved.
//

import UIKit
import AVFoundation


class ViewController: UIViewController {


    //slider and audio player
    @IBOutlet var volSlider : UISlider!
    var soundPlayer : AVAudioPlayer!
    
    @IBAction func unwindtoMainViewController (segue : UIStoryboardSegue)
          {
              
          }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    
    //event handler for audio player
    //Created By Murtaza Saleem
    @IBAction func volumeDidChange(sender : UISlider){
        soundPlayer?.volume = volSlider.value
    }
    override func viewWillAppear(_ animated: Bool) {
        //sound url becomes a string to be passed
        let soundURL = Bundle.main.path(forResource: "golden", ofType: "mp3")
        
        let url = URL(fileURLWithPath: soundURL!)
        //initialize audio
        soundPlayer = try! AVAudioPlayer.init(contentsOf: url)
        //set volume config
        soundPlayer?.currentTime = 0
        soundPlayer?.volume = volSlider.value
        soundPlayer?.play()
    }
    
    //stop music after leaving the screen
    override func viewDidDisappear(_ animated: Bool) {
        soundPlayer?.stop()
    }

}

