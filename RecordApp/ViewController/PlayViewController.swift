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

    var audioPlayer: AVAudioPlayer!
    var audioItem: AudioCellItem!
    var audioURL: URL!
    var fileName = ""

    @IBOutlet var playButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        playButton.isEnabled = false

        let split = audioItem.duration.split(separator: ":").map { Int($0)! }
        let duration = split[0] * 60 + split[1]

        fileName = "\(audioItem.title)+\(duration).m4a"
        print(fileName)

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

            self.initPlayer(downloadURL)
            print(downloadURL)
            self.playButton.isEnabled = true
        }
    }

    private func initPlayer(_ url: URL) {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
        } catch let error {
            print("init player error \(error)")
            return
        }

        audioPlayer.delegate = self
        audioPlayer.prepareToPlay()
    }
}
