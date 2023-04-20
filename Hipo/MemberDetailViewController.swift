//
//  MemberDetailViewController.swift
//  Hipo
//
//  Created by ahmet kardesseven on 19.04.2023.
//

import UIKit

class MemberDetailViewController: UIViewController {
    
    
    var selectedMember: Members? // selected member passed from previous view controller
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var followersLabel: UILabel!
    
    @IBOutlet weak var followingLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Name"
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = UIColor(named: "title")
        appearance.titleTextAttributes = [.foregroundColor:UIColor(named: "writeColor")!,.font:UIFont(name: "Pacifico-Regular", size: 22)!]
        navigationController?.navigationBar.barStyle = .black
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        if let username = selectedMember?.github {
            let baseURL = "https://api.github.com/users/"
            guard let url = URL(string: baseURL + username) else {
                print("Invalid URL for username: \(username)")
                return
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                    return
                }
                
                guard let data = data else {
                    print("Data is nil for username: \(username)")
                    return
                }
                
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        let name = json["name"] as? String ?? "Salih Karasuluoglu"
                        let followers = json["followers"] as? Int ?? 0
                        let following = json["following"] as? Int ?? 0
                        let avatarURL = json["avatar_url"] as? String ?? ""
                        
                        DispatchQueue.main.async {
                            self.nameLabel.text = name
                            self.followersLabel.text = "\(followers)"
                            self.followingLabel.text = "\(following)"
                            if let url = URL(string: avatarURL) {
                                do {
                                    let data = try Data(contentsOf: url)
                                    self.avatarImageView.image = UIImage(data: data)
                                } catch {
                                    print("Error loading image from URL: \(error.localizedDescription)")
                                }
                            }
                        }
                    }
                } catch {
                    print("Error parsing JSON for username: \(username)")
                }
            }
            
            task.resume()
        }
        
    }
}



