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
        self.navigationItem.title = "members"
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = UIColor(named: "title")
        appearance.titleTextAttributes = [.foregroundColor:UIColor(named: "writeColor")!,.font:UIFont(name: "Pacifico-Regular", size: 22)!]
        navigationController?.navigationBar.barStyle = .black
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        
        tableView.delegate = self
        tableView.dataSource = self
        searchMembers.delegate = self
        searchMembers.placeholder = "Search"
        
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
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            members.remove(at: indexPath.row)
            filteredMembers = members
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
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
    
    @IBAction func AddButtonü(_ sender: Any) {
        let alertController = UIAlertController(title: "Add Member", message: nil, preferredStyle: .alert)
        alertController.addTextField { (textField) in
            textField.placeholder = "Name"
        }
        alertController.addTextField { (textField) in
            textField.placeholder = "Position"
        }
        alertController.addTextField { (textField) in
            textField.placeholder = "Github"
        }
        let addAction = UIAlertAction(title: "Add", style: .default) { [weak self] (_) in
            guard let self = self,
                  let name = alertController.textFields?[0].text,
                  let position = alertController.textFields?[1].text,
                  let github = alertController.textFields?[2].text
            else { return }
            let newMember = Members(name: name, github: github, hipo: Hipo(position: position, years_in_hipo: nil))
            self.members.append(newMember)
            self.filteredMembers = self.members
            self.tableView.reloadData()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(addAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
        
        
    }
}

