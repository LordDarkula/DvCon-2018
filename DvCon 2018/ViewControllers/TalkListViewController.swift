//
//  TalkListViewController.swift
//  DvCon
//
//  Created by Aubhro Sengupta on 1/25/17.
//  Copyright © 2017 Aubhro Sengupta. All rights reserved.
//

import UIKit
import Firebase

class TalkListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var dayControl: UISegmentedControl!
    @IBOutlet var tableView: UITableView!
    
    var dates: [String]?
    var times: [String]?
    var talks: [[String: String]]?
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableView.delegate = self
        tableView.dataSource = self
        
        let dateRef = DBConstants.rootRef.child(DBConstants.dateKey)
        dateRef.observe(.value, with: { (snapshot) in
            
            if let actualDates = snapshot.value as? [String] {
                self.dates = actualDates
                self.dayControl.removeSegment(at: 1, animated: true)
                self.dayControl.setTitle(self.dates?[0], forSegmentAt: 0)
                
                for i in 1..<self.dates!.count {
                    let day = self.dates![i]
                    self.dayControl.insertSegment(withTitle: day, at: (self.dates?.endIndex)!, animated: true)
                }
                self.fetchTimes()
            }
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fetchTimes()
    }
    
    @IBAction func onDayControlSegmentChange(_ sender: Any) {
        fetchTimes()
    }
    
    func fetchTimes() {
        
        let currentDate = String(dayControl.selectedSegmentIndex)
        let timeRef = DBConstants.rootRef.child(DBConstants.timeKey).child(currentDate)
        print(timeRef)
        timeRef.observe(.value, with: { (snapshot) in
            self.times = snapshot.value as? [String] ?? []
            self.populateFields()
        })
    }
    
    func populateFields() {
        
        let currentDate = String(dayControl.selectedSegmentIndex)
        let talkRef = DBConstants.rootRef.child(DBConstants.talkKey).child(currentDate)
        talkRef.observe(.value, with: { (snapshot) in
            print("Fetching data")
            self.talks = []
            let rawEvents = snapshot.value as? [String: NSDictionary]
            for time in self.times! {
                print("Current time \(self.times!) on day \(currentDate)")
                
                if let event = rawEvents![time] {
                    let eventDictList = event["events"] as? [String: NSDictionary]
                    for (title, eventDict) in eventDictList! {
                        
                        if let actualEventDict = eventDict as? [String: Any?] {
                            
                            let papers = actualEventDict["papers"] as? [[String: String]] ?? [["title": ""]]
                            var paperString = ""
                            for paper in papers {
                                paperString += paper["title"] ?? ""
                                paperString += ", "
                            }
                            
                            let talkDict: [String: String] = ["title": title,
                                                              "description": actualEventDict["description"] as? String ?? "",
                                                              "papers": paperString,
                                                              "room": actualEventDict["room"] as? String ?? "",
                                                              "time": time,
                                                              "date": self.dates?[self.dayControl.selectedSegmentIndex] ?? ""]
                            
                            self.talks?.append(talkDict)
                        }
                    }
                }
                }
                
            self.tableView.reloadData()
        })
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // TODO: Update with data from Firebase
        print("length changed \(self.talks?.count ?? 0)")
        return self.talks?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: TalkListTableViewCell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.talkList) as! TalkListTableViewCell
        
        if let talk = talks?[indexPath.row] {
            cell.timeLabel.text = talk["time"] ?? ""
            cell.titleLabel.text = talk["title"] ?? ""
            cell.locationLabel.text = talk["room"] ?? ""
        }
        
        cell.awakeFromNib()
        cell.sizeToFit()

        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetails" {
            let eventDetailViewController: EventDetailViewController = segue.destination as! EventDetailViewController
            
            let myIndexPath = self.tableView.indexPathForSelectedRow
            let row = myIndexPath?.row
            
            
            //eventDetailViewController.info = [[NSArray alloc] init];
            eventDetailViewController.talk = talks?[row!]
        }
    }
    
}

