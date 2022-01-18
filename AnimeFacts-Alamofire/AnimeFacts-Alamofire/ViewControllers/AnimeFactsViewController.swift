//
//  AnimeFactsViewController.swift
//  AnimeFacts-Alamofire
//
//  Created by Малиль Дугулюбгов on 18.01.2022.
//

import UIKit
import Alamofire

private let reuseIdentifier = "animeFactCell"

class AnimeFactsViewController: UIViewController {

    //MARK: - Properties
    private var currentAnimeFactsURL = ""
    private var animeFacts = [AnimeFact]()
    
    //MARK: - View
    var image: UIImage?
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var animeFactsTableView: UITableView!
    @IBOutlet weak var factsLoadingIndicatorView: UIActivityIndicatorView!
    
    //MARK: - View Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        
        setupFactsTableView()
        
        if let image = image {
            backgroundImageView.image = image
        }
        factsLoadingIndicatorView.startAnimating()
        
        factsLoadingIndicatorView.hidesWhenStopped = true
        
        animeFactsTableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
    }
    
    //MARK: - IBAtions
    @IBAction func refreshDataTapped(_ sender: UIBarButtonItem) {
        print("REFRESHING DATA")
        factsLoadingIndicatorView.startAnimating()
        animeFacts = []
        animeFactsTableView.reloadData()
        fetchFacts(from: currentAnimeFactsURL)
    }
    
    //MARK: - Methods
    func fetchFacts(from factsURL: String) {
        currentAnimeFactsURL = factsURL
        let request = AF.request(currentAnimeFactsURL, method: .get)
        request.validate()
        request.responseDecodable(of: AnimeFacts.self) { dataResponse in
            switch dataResponse.result {
            case .success(let value):
                guard let data = value.data else { return }
                self.animeFacts = data
                DispatchQueue.main.async { [weak self] in
                    self?.factsLoadingIndicatorView.stopAnimating()
                    self?.animeFactsTableView.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
                DispatchQueue.main.async { [weak self] in
                    self?.showAlert(with: "Data loading error", and: "Data cannot be uploaded")
                }
            }
        }
    }
}

//MARK: - Table view data source
extension AnimeFactsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return animeFacts.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        if !animeFacts.isEmpty {
            var configuration = cell.defaultContentConfiguration()
            configuration.text = animeFacts[indexPath.section].fact
            cell.contentConfiguration = configuration
        }
        return cell
    }
}


//MARK: -Table view delegate
extension AnimeFactsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Fact #\(section + 1)"
    }
}

//MARK: - Private methods
extension AnimeFactsViewController {
    private func setupFactsTableView() {
        animeFactsTableView.allowsSelection = false
        animeFactsTableView.dataSource = self
        animeFactsTableView.delegate = self
    }
    
    private func checkConnection() {
        if !NetworkMonitor.shared.isConnected {
            showAlert(with: "Something wrong with your internet connection", and: "Please connect to the network or try again later")
        }
    }
    
    private func showAlert(with title: String, and message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertOKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(alertOKAction)
        self.present(alert, animated: true) { [factsLoadingIndicatorView] in
            factsLoadingIndicatorView?.stopAnimating()
        }
    }
}
