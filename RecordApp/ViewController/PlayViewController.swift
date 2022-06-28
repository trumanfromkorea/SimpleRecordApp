//
//  PlayViewController.swift
//  RecordApp
//
//  Created by 장재훈 on 2022/06/27.
//

import AVFoundation
import FirebaseStorage
import UIKit

class PlayViewController: UIViewController, AVAudioPlayerDelegate {
    static let identifier = "PlayViewController"
    static let storyboard = "Main"

    var audioPlayer = AVPlayer()
    var audioItem: AudioCellItem!
    var fileName = ""

    @IBOutlet var playButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        playButton.isEnabled = false

        let split = audioItem.duration.split(separator: ":").map { Int($0)! }
        let duration = split[0] * 60 + split[1]

        fileName = "\(audioItem.title)+\(duration).m4a"

        getData()
    }

    @IBAction func onTappedPlayButton(_ sender: Any) {
        audioPlayer.play()
    }

    private func getData() {
        let storageReference = Storage.storage().reference().child("audio/\(fileName)")

        storageReference.downloadURL { url, _ in

            guard let downloadURL = url else {
                print("download failed")
                return
            }

            let playerItem = AVPlayerItem(url: downloadURL)
            self.audioPlayer.replaceCurrentItem(with: playerItem)

            self.playButton.isEnabled = true
        }
    }
}
