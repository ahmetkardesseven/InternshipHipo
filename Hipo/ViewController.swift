//
//  ViewController.swift
//  Hipo
//
//  Created by ahmet kardesseven on 19.04.2023.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
        
        var members: [Members] = []
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            tableView.delegate = self
            tableView.dataSource = self
            
            if let path = Bundle.main.path(forResource: "hipo", ofType: "json") {
                do {
                    let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                    let decoder = JSONDecoder()
                    let hipoJson = try decoder.decode(HipoJson.self, from: data)
                    members = hipoJson.members
                    tableView.reloadData()
                } catch {
                    print("Error: \(error.localizedDescription)")
                }
            }
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return members.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            let member = members[indexPath.row]
            cell.textLabel?.text = member.name
            return cell
        }


}

