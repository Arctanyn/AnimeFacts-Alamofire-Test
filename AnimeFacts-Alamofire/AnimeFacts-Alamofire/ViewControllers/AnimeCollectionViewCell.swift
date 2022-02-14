//
//  AnimeCollectionViewCell.swift
//  AnimeFacts-Alamofire
//
//  Created by Малиль Дугулюбгов on 18.01.2022.
//

import UIKit
import Alamofire

class AnimeCollectionViewCell: UICollectionViewCell {
    
    //MARK: - View
    @IBOutlet weak var animeCoverImageView: UIImageView!
    @IBOutlet weak var animeTitleLabel: UILabel!
    
    
    //MARK: - Public methods
    func updateView(with anime: AnimeExample) {
        animeTitleLabel.text = correctAnimeTitle(anime.anime_name ?? "")
        loadImage(with: anime.anime_img ?? "")
    }
    
}

//MARK: - Private methods
extension AnimeCollectionViewCell {
    private func correctAnimeTitle(_ title: String) -> String {
        var newTitle = ""
        let separatedTitle = Array(title.capitalized)
        for letter in separatedTitle {
            switch letter {
            case "_":
                newTitle += " "
            default:
                newTitle.append(letter)
            }
        }
        return newTitle
    }
    
    private func loadImage(with url: String) {
        guard let url = URL(string: url) else { return }
        let request = AF.request(url)
        request.validate()
        request.responseData { dataResponse in
            switch dataResponse.result {
            case .success(let data):
                guard let image = UIImage(data: data) else { return }
                DispatchQueue.main.async { [weak self] in
                    self?.animeCoverImageView.image = image
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
