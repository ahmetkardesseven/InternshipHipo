//
//  MemberDetailViewController.swift
//  Hipo
//
//  Created by ahmet kardesseven on 19.04.2023.
//

import UIKit

class MemberDetailViewController: UIViewController {
    
    var selectedMember: Members?
    var repos: [[String: Any]] = []
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var followersLabel: UILabel!
    @IBOutlet weak var followingLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        self.navigationItem.title = "Name"
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = UIColor(named: "title")
        appearance.titleTextAttributes = [.foregroundColor:UIColor(named: "writeColor")!,.font:UIFont(name: "Pacifico-Regular", size: 22)!]
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
        if let username = selectedMember?.github {
            let baseURL = "https://api.github.com/users/"
            guard let url = URL(string: baseURL + username + "/repos") else {
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
                    if let jsonArray = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
                        self.repos = jsonArray
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
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
//MARK: TableView

extension MemberDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RepoCell", for: indexPath) as! RepoTableViewCell
        
        let repo = repos[indexPath.row]
        cell.repoName.text = repo["name"] as? String ?? "-"
        cell.languageLabel.text = repo["language"] as? String ?? "-"
        cell.stargazersCountLabel.text = "\(repo["stargazers_count"] as? Int ?? 0)"
        cell.updatedAtLabel.text = repo["updated_at"] as? String ?? "-"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
}




