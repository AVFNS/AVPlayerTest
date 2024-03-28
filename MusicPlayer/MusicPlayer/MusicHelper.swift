import AVFoundation

class MusicHelper {
    static let sharedHelper = MusicHelper()
    var audioPlayer: AVAudioPlayer?
    
    func playBackgroundMusic(songName: String) {
        let aSound = NSURL(fileURLWithPath: Bundle.main.path(forResource: "\(songName)", ofType: "mp3")!)
        do {
            audioPlayer = try AVAudioPlayer(contentsOf:aSound as URL)
            audioPlayer!.numberOfLoops = -1
            audioPlayer!.prepareToPlay()
            audioPlayer!.play()
        }
        catch {
            print("Cannot play the file")
        }
    }
}
