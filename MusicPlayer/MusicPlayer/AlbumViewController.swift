import UIKit
import Then
import SnapKit
import RxSwift
import RxCocoa
import PinLayout

class AlbumViewController: UIViewController {

    var tableView = UITableView().then {
        $0.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    var songs = [Song]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureSongs()
        tableView.delegate = self
        tableView.dataSource = self
        
        view.addSubview(tableView)
        tableView.pin.all()
        
        print("실행중")
    }
    
    func configureSongs() {
        songs.append(Song(name: "꿈과 책과 힘과 벽",
                          albumName: "전설",
                          artistName: "잔나비",
                          imageName: "사진",
                          trackName: "song1",
                          duration: 297))
        songs.append(Song(name: "조이풀 조이풀",
                          albumName: "전설",
                          artistName: "잔나비",
                          imageName: "사진",
                          trackName: "song2",
                          duration: 243))
        songs.append(Song(name: "투게더",
                          albumName: "전설",
                          artistName: "잔나비",
                          imageName: "사진",
                          trackName: "song3",
                          duration: 186))
        songs.append(Song(name: "꿈과 책과 힘과 벽",
                          albumName: "전설",
                          artistName: "잔나비",
                          imageName: "사진",
                          trackName: "song1",
                          duration: 297))
        songs.append(Song(name: "조이풀 조이풀",
                          albumName: "전설",
                          artistName: "잔나비",
                          imageName: "사진",
                          trackName: "song2",
                          duration: 243))
        songs.append(Song(name: "투게더",
                          albumName: "전설",
                          artistName: "잔나비",
                          imageName: "사진",
                          trackName: "song3",
                          duration: 186))
        songs.append(Song(name: "꿈과 책과 힘과 벽",
                          albumName: "전설",
                          artistName: "잔나비",
                          imageName: "사진",
                          trackName: "song1",
                          duration: 297))
        songs.append(Song(name: "조이풀 조이풀",
                          albumName: "전설",
                          artistName: "잔나비",
                          imageName: "사진",
                          trackName: "song2",
                          duration: 243))
        songs.append(Song(name: "투게더",
                          albumName: "전설",
                          artistName: "잔나비",
                          imageName: "사진",
                          trackName: "song3",
                          duration: 186))
    }
}

extension AlbumViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let position = indexPath.row

        let vc = PlayerViewController()
        vc.configureUI(with: songs[indexPath.row])
        vc.songs = songs
        
        vc.position = position
        print("songs: \(songs), position: \(position)")
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension AlbumViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songs.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let song = songs[indexPath.row]

        cell.textLabel?.text = song.name
        cell.detailTextLabel?.text = song.albumName
        cell.accessoryType = .disclosureIndicator
        cell.imageView?.image = UIImage(named: song.imageName)
        cell.textLabel?.font = UIFont.systemFont(ofSize: 18)
        cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 16)

        return cell
    }
}
