//
//  rtViewController.swift
//  FramilyTests
//
//  Created by Varun kumar on 27/06/23.
//

import UIKit
import AVFoundation
class rtViewController: UIViewController {

    @IBOutlet weak var videoLayer: UIView!
    @IBOutlet weak var btn: UIButton!
    @IBOutlet weak var txt: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
       playVideo()
        // Do any additional setup after loading the view.
    }
    
    func playVideo() {
        guard let path = Bundle.main.path(forResource: "intro1", ofType: "mp4") else {
            return
        }
        
        let player = AVPlayer(url: URL(fileURLWithPath: path))
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = self.view.bounds
        playerLayer.videoGravity = .resizeAspectFill
        self.videoLayer.layer.addSublayer(playerLayer)
        
        player.play()
        
        videoLayer.bringSubviewToFront(btn)
        videoLayer.bringSubviewToFront(txt)
       
    }

}
