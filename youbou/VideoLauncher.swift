//
//  videoLauncher.swift
//  youbou
//
//  Created by Hans Yonathan on 4/11/2016.
//  Copyright © 2016 Hans Yonathan. All rights reserved.
//

import UIKit
import AVFoundation

class VideoPlayerView: UIView {
    
    let activityIndicatorView: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        aiv.translatesAutoresizingMaskIntoConstraints = false
        aiv.startAnimating()
        return aiv
    }()
    
    lazy var pausePlayButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("paused", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .white
        button.isHidden = true
        button.addTarget(self, action: #selector(handlePause), for: .touchUpInside)
        return button
    }()
    
    func handlePause(){
        if isPlaying {
            print("pause")
            player?.pause()
            pausePlayButton.setTitle("play", for: .normal)

        }else{
            print("play")
            player?.play()
            pausePlayButton.setTitle("pause", for: .normal)
        }
    }
    
    let controlsContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white:0, alpha:1)
        return view
    }()
    
    let videoLengthLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "00:00"
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 13)
        label.textAlignment = .right
        return label
    }()
    
    let currentTimeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "00:00"
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 13)
        return label
    }()
    
    lazy var videoSlider : UISlider = {
        let slider = UISlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.minimumTrackTintColor = .red
        slider.maximumTrackTintColor = .white
        //to set the thumb of the slider
        //slider.setThumbImage(UIImage(named:"thumb"), for: .normal)
        slider.addTarget(self, action: #selector(handleSliderChange), for: .valueChanged)
        return slider
    }()
    
    func handleSliderChange(){
        print(videoSlider.value)
        
        if let duration = player?.currentItem?.duration {
            let totalSeconds = CMTimeGetSeconds(duration)
            let value = Float64(videoSlider.value) * totalSeconds
            let seekTime = CMTime(value: Int64(value), timescale: 1)
            player?.seek(to: seekTime, completionHandler: { (completedSeek) in
                
            })
        }
    }
    
    var isPlaying = false
    
    override init(frame: CGRect){
        super.init(frame: frame)
        setupPlayerView()
        setupGradientLayer()
        controlsContainerView.frame = frame
        addSubview(controlsContainerView)
        controlsContainerView.addSubview(activityIndicatorView)
        activityIndicatorView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        activityIndicatorView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        controlsContainerView.addSubview(pausePlayButton)
        pausePlayButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        pausePlayButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        pausePlayButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        pausePlayButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        controlsContainerView.addSubview(videoLengthLabel)
        videoLengthLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -8).isActive = true
        videoLengthLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -2).isActive = true
        videoLengthLabel.widthAnchor.constraint(equalToConstant: 50).isActive = true
        videoLengthLabel.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        controlsContainerView.addSubview(currentTimeLabel)
        currentTimeLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 8).isActive = true
        currentTimeLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -2).isActive = true
        currentTimeLabel.widthAnchor.constraint(equalToConstant: 50).isActive = true
        currentTimeLabel.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        controlsContainerView.addSubview(videoSlider)
        videoSlider.rightAnchor.constraint(equalTo: videoLengthLabel.leftAnchor).isActive = true
        videoSlider.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        videoSlider.leftAnchor.constraint(equalTo: currentTimeLabel.rightAnchor).isActive = true
        videoSlider.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        backgroundColor = .black
    }
    
    var player: AVPlayer?
    
    func setupPlayerView(){
        let urlString = "http://qthttp.apple.com.edgesuite.net/1010qwoeiuryfg/0640/06401.ts"
        //let urlString = ""
        if let url = URL(string: urlString){
            player = AVPlayer(url: url)
            let playerLayer = AVPlayerLayer(player: player)
            self.layer.addSublayer(playerLayer)
            playerLayer.frame = self.frame
            player?.play()
            print("yiha")
            player?.addObserver(self, forKeyPath: "currentItem.loadedTimeRanges", options: .new, context: nil)
            
            //track player progress
            let interval = CMTime(value: 1, timescale: 2)

            player?.addPeriodicTimeObserver(forInterval: interval, queue: DispatchQueue.main, using: { (progressTime) in
                let seconds = CMTimeGetSeconds(progressTime)
                let secondsString = String(format: "%02d", Int(remainder(seconds, 60)))
                let minutesString = String(format: "%02d", Int(seconds / 60))
                self.currentTimeLabel.text = "\(minutesString):\(secondsString)"
                //print(seconds)
                //lets move the sliderThumb
                if let duration = self.player?.currentItem?.duration{
                    let durationSeconds = CMTimeGetSeconds(duration)
                    self.videoSlider.value = Float(seconds / durationSeconds)
                }
            })
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        //this is when player is ready and rendering frames
        if keyPath == "currentItem.loadedTimeRanges" {
            print(change)
            activityIndicatorView.stopAnimating()
            controlsContainerView.backgroundColor = .clear
            pausePlayButton.isHidden = false
            isPlaying = true
            if let duration = player?.currentItem?.duration{
                let seconds = CMTimeGetSeconds(duration)
                let secondsText = remainder(seconds, 60)
                let minuteText = String(format: "%02d", Int(seconds)/60)
                videoLengthLabel.text = "\(minuteText):\(secondsText)"
            }
        }
    }
    
    private func setupGradientLayer(){
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        gradientLayer.locations = [0.7, 1.2]
        controlsContainerView.layer.addSublayer(gradientLayer)
    }
    
    required init?(coder aDecoder: NSCoder){
        fatalError("init(coder:) has not been implemented")
    }
}

class VideoLauncher: NSObject {
    
    func showVideoPlayer(){
        print("Showing Video Player animation...")
        if let keyWindow = UIApplication.shared.keyWindow{
            let view = UIView(frame: keyWindow.frame)
            view.backgroundColor = .white
            view.frame = CGRect(x: keyWindow.frame.width - 10, y: keyWindow.frame.height, width: 10, height: 10)
            
            //16*9 is the aspect ratio of all HD videos
            let height = keyWindow.frame.width * 9 / 16
            let videoPlayerFrame = CGRect(x: 0, y: 0, width: keyWindow.frame.width, height: height)
            let videoPlayerView = VideoPlayerView(frame: videoPlayerFrame)
            view.addSubview(videoPlayerView)
            keyWindow.addSubview(view)
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                view.frame = keyWindow.frame
                }, completion: { (completedAnimation) in
                    UIApplication.shared.isStatusBarHidden = true
            })
        }
    }
    
}
