//
//  ViewController.swift
//  Hipo
//
//  Created by ahmet kardesseven on 19.04.2023.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
  
    @IBOutlet weak var tableView: UITableView!
        
    @IBOutlet weak var searchMembers: UISearchBar!
    
        
        var members: [Members] = []
        var filteredMembers: [Members] = [] // filtered members list
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            tableView.delegate = self
            tableView.dataSource = self
            searchMembers.delegate = self
            
            if let path = Bundle.main.path(forResource: "hipo", ofType: "json") {
                do {
                    let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                    let decoder = JSONDecoder()
                    let hipoJson = try decoder.decode(HipoJson.self, from: data)
                    members = hipoJson.members
                    filteredMembers = members // set the filtered members list with all members initially
                    tableView.reloadData()
                } catch {
                    print("Error: \(error.localizedDescription)")
                }
            }
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return filteredMembers.count // display the count of filtered members list
        }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        let member = filteredMembers[indexPath.row] // use the filtered members list instead of members
        cell.nameLabel.text = member.name
           cell.positionLabel.text = member.hipo.position
        return cell
    }
        
      
        
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            filteredMembers = searchText.isEmpty ? members : members.filter({(member: Members) -> Bool in
                return member.name.lowercased().contains(searchText.lowercased()) || member.hipo.position.lowercased().contains(searchText.lowercased())
            })
            tableView.reloadData() // reload the table with filtered results
        }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let member = filteredMembers[indexPath.row]
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let memberDetailVC = storyboard.instantiateViewController(withIdentifier: "MemberDetailViewController") as! MemberDetailViewController
        memberDetailVC.selectedMember = member
        self.navigationController?.pushViewController(memberDetailVC, animated: true)
    }
}

