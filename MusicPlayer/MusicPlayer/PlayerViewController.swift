import AVFoundation
import UIKit
import SnapKit
import Then

class PlayerViewController: UIViewController {
    
    public var position: Int = 0
    public var songs: [Song] = []
    
    var player: AVAudioPlayer?
    
    public lazy var albumImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
    }
    
    public lazy var songNameLabel = UILabel().then {
        $0.textAlignment = .center
        $0.numberOfLines = 0
    }
    
    public lazy var artistNameLabel = UILabel().then {
        $0.textAlignment = .center
        $0.numberOfLines = 0
    }
    
    public lazy var albumNameLabel = UILabel().then {
        $0.textAlignment = .center
        $0.numberOfLines = 0
    }
    
    private lazy var playPauseButton = UIButton().then {
        $0.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        $0.tintColor = .black
    }
    
    private lazy var backButton = UIButton().then {
        $0.setImage(UIImage(systemName: "backward.fill"), for: .normal)
        $0.tintColor = .black
    }
    
    private lazy var nextButton = UIButton().then {
        $0.setImage(UIImage(systemName: "forward.fill"), for: .normal)
        $0.tintColor = .black
    }
    
    private let slider = SliderView().then {
        $0.value = 0.0
        $0.thumbTintColor = .clear
    }
    
    private var songDuration: Int = 0
    private var elapsedTime: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        configureUI()
//        startSliderTimer()
        
        player?.delegate = self
        
        view.backgroundColor = .white
    }
//    
//    private func startSliderTimer() {
//        guard songDuration > 0 else { return }
//        
//        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] timer in
//            guard let self = self else { return }
//            
//            self.elapsedTime += 1
//            
//            self.slider.value = Float(self.elapsedTime) / Float(self.songDuration)
//            
//            if self.elapsedTime >= self.songDuration {
//                timer.invalidate()
//            }
//        }
//    }
    
    func configureUI(with song: Song) {
        albumImageView.image = UIImage(named: song.imageName)
        songNameLabel.text = song.name
        albumNameLabel.text = song.albumName
        artistNameLabel.text = song.artistName
        
        slider.maximumValue = 1.0
    }
    
    func configureUI() {
        view.addSubview(albumImageView)
        albumImageView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
            $0.height.equalTo(view.snp.width).offset(-20)
        }
        
        view.addSubview(songNameLabel)
        songNameLabel.snp.makeConstraints {
            $0.top.equalTo(albumImageView.snp.bottom).offset(10)
            $0.left.right.equalToSuperview().inset(10)
            $0.height.equalTo(70)
        }
        
        view.addSubview(albumNameLabel)
        albumNameLabel.snp.makeConstraints {
            $0.top.equalTo(songNameLabel.snp.bottom).offset(10)
            $0.left.right.equalToSuperview().inset(10)
            $0.height.equalTo(70)
        }
        
        view.addSubview(artistNameLabel)
        artistNameLabel.snp.makeConstraints {
            $0.top.equalTo(albumNameLabel.snp.bottom).offset(10)
            $0.left.right.equalToSuperview().inset(10)
            $0.height.equalTo(70)
        }
        
        let size: CGFloat = 70
        
        view.addSubview(playPauseButton)
        playPauseButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(artistNameLabel.snp.bottom).offset(20)
            $0.size.equalTo(size)
        }
        
        view.addSubview(backButton)
        backButton.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.top.equalTo(artistNameLabel.snp.bottom).offset(20)
            $0.size.equalTo(size)
        }
        
        view.addSubview(nextButton)
        nextButton.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-20)
            $0.top.equalTo(artistNameLabel.snp.bottom).offset(20)
            $0.size.equalTo(size)
        }
        
        view.addSubview(slider)
        slider.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-60)
        }
        
        playPauseButton.addTarget(self, action: #selector(didTapPlayPauseButton), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(didTapNextButton), for: .touchUpInside)
        backButton.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        slider.addTarget(self, action: #selector(didSlideSlider(_:)), for: .valueChanged)
    }
    
    func configure() {
        let song = songs[position]
        
        let urlString = Bundle.main.path(forResource: song.trackName, ofType: "mp3")
        
        do {
            try AVAudioSession.sharedInstance().setMode(.default)
            try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
            
            guard let urlString = urlString else {
                print("urlstring is nil")
                return
            }
            
            player = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: urlString))
            
            guard let player = player else {
                print("player is nil")
                return
            }
            player.volume = 0.5
            
            player.play()
            songDuration = Int(player.duration)
        }
        catch {
            print("error occurred")
        }
    }

    @objc func didTapBackButton() {
        if position > 0 {
            position -= 1
            player?.stop()
            configure()
            elapsedTime = 0
    //        startSliderTimer()
            
            let newSong = songs[position]
            configureUI(with: newSong)
            slider.value = 0
        }
    }

    @objc func didTapNextButton() {
        if position < (songs.count - 1) {
            position += 1
            player?.stop()
            configure()
            elapsedTime = 0
    //        startSliderTimer()
            
            let newSong = songs[position]
            configureUI(with: newSong)
            slider.value = 0
        }
    }
    
    @objc func didTapPlayPauseButton() {
        guard let player = player else { return }
        
        if player.isPlaying {
            player.pause()
            playPauseButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
        } else {
            player.play()
            playPauseButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        }
    }

    @objc func didSlideSlider(_ slider: UISlider) {
        guard let player = player else { return }
        let newPosition = Double(slider.value) * Double(player.duration)
        player.currentTime = newPosition
        elapsedTime = Int(newPosition)

        player.play()
    }
    
    override func viewWillDisappear(_ animated:Bool) {
        super.viewWillDisappear(animated)
        player?.stop()
    }
}

extension PlayerViewController: AVAudioPlayerDelegate {
    func audioPlayer(_ player: AVAudioPlayer, didUpdateCurrentTime currentTime: TimeInterval) {
        let newPosition = Float(currentTime) / Float(songDuration)
        slider.value = newPosition
    }
}
