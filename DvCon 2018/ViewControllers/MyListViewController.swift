//
//  MyListViewController.swift
//  DvCon
//
//  Created by Aubhro Sengupta on 1/25/17.
//  Copyright © 2017 Aubhro Sengupta. All rights reserved.
//

import UIKit
import FirebaseDatabase

class MyListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var tableView: UITableView!
    
    var dates: [String]?
    var talks2d: [[[String: String]]]?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableView.delegate = self
        tableView.dataSource = self

        let dateRef = DBConstants.rootRef.child(DBConstants.dateKey)
        
        dateRef.observe(.value, with: { (snapshot) in
            
            if let actualDates = snapshot.value as? [String] {
                self.dates = actualDates
                self.fetchDates()
            }
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.fetchDates()
    }
    
    func fetchDates() {
        let defaults = UserDefaults.standard
        
        self.talks2d = []
        for date in self.dates ?? [] {
            self.talks2d?.append(defaults.array(forKey: date) as? [[String: String]] ?? [])
        }

        self.tableView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dates?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.dates?[section] ?? ""
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.talks2d?[section].count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: TalkListTableViewCell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.myList) as! TalkListTableViewCell
        
        cell.titleLabel.text = talks2d?[indexPath.section][indexPath.row]["title"] ?? ""
        cell.timeLabel.text = talks2d?[indexPath.section][indexPath.row]["time"] ?? ""
        cell.locationLabel.text = talks2d?[indexPath.section][indexPath.row]["room"] ?? ""
        
        cell.awakeFromNib()
        cell.sizeToFit()

        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MyListDetails" {
            let eventDetailViewController: EventDetailViewController = segue.destination as! EventDetailViewController
            let indexPath = self.tableView.indexPathForSelectedRow!
            
            eventDetailViewController.talk = talks2d?[indexPath.section][indexPath.row]
        }
    }
}

