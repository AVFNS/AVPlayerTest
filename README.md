# AVPlayerTest

https://github.com/AVFNS/AVPlayerTest/assets/102890390/caab834f-d715-48c1-9f9b-5beb13db809f

## 기능

### 음악을 나오게 하는 방법

```swift
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
```
- setCategory를 활용해서 앱 외부에서도 음악이 제생되도록 playback를 사용했습니다.

### 노래 멈추기
```swift
    @objc func didTapPlayPauseButton() {
        guard let player = player else { return }
        
        if player.isPlaying {
            player.pause()
            playPauseButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
            timer?.invalidate()
        } else {
            player.play()
            playPauseButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
            startSliderTimer()
        }
    }
```
- AVAudioPlayer를 사용해서 isPlaying을 사용해서 시작과 멈춤을 개발합니다.
- 이미지를 바꾸는 작업도 구현되어있습니다.

### 노래 넘기기와 전으로 돌아가기
```swift
    @objc func didTapBackButton() {
        if position > 0 {
            position -= 1
            player?.stop()
            configure()
            elapsedTime = 0
            startSliderTimer()
            
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
            startSliderTimer()
            
            let newSong = songs[position]
            configureUI(with: newSong)
            slider.value = 0
        }
    }
```
- 위 코드에서 배열로 받은 값을 넘기고 전으로 가는 로직을 구현합니다.
- 그리고 노래를 넘기면 다시 0초로 바뀌는 작업을 합니다.
- 곡을 넘기거나 돌아가면 작가과 앨범 표지가 나옵니다.

### 노래 시간 정하기
```swift
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] timer in
            guard let self = self else { return }
            self.elapsedTime += 1
            self.slider.value = Float(self.elapsedTime)
            
            if self.slider.value >= self.slider.maximumValue {
                self.didTapNextButton()
            }
        }
```
- 위 코드에서 model에서 노래 시간을 받아오고 정해진 시간만큼 지나가는 기능 구현
- Slider가 다 움직이면 노래가 다음으로 돌아가는 기능 구현

### 이슈
- 노래의 재생바를 옮겨서 노래를 넘길 수 없다는 단점이 있습니다.
   - 현재 Slider를 막음으로써 이슈를 막았습니다.
