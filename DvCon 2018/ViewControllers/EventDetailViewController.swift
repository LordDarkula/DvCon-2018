//
//  EventDetailViewController.swift
//  DvCon
//
//  Created by Aubhro Sengupta on 1/25/17.
//  Copyright © 2017 Aubhro Sengupta. All rights reserved.
//

import UIKit

class EventDetailViewController: UIViewController {
    
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var descriptionField: UITextView!
    @IBOutlet var bookmarkButton: UIBarButtonItem!
    
    var talk: [String: String]?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = talk?["title"] ?? ""
        self.timeLabel.text = talk?["time"] ?? ""
        self.locationLabel.text = talk?["room"] ?? ""
        
        var description = talk?["description"] ?? ""
        if (talk?["papers"] ?? "") != "" && (talk?["papers"] ?? "") != ", " {
            print(talk?["papers"] ?? "")
            description += "\n\nPapers: " + (talk?["papers"] ?? "")
        }
        
        let defaults = UserDefaults.standard
        var talks = defaults.array(forKey: self.talk!["date"]!) as? [[String: String]] ?? []
        
        for i in 0..<talks.count {
            if talks[i]["title"] == self.talk!["title"] {
                self.bookmarkButton.title = "Bookmarked"
                break
            }
        }
        
        self.descriptionField.text = description
    }    

    @IBAction func bookmark(_ sender: UIBarButtonItem) {
        let defaults = UserDefaults.standard
        var talks = defaults.array(forKey: self.talk!["date"]!) as? [[String: String]] ?? []
        
        if sender.title == "Bookmark" {
            self.bookmarkButton.title = "Bookmarked"
            
            talks.append(self.talk!)
            
        } else {
            self.bookmarkButton.title = "Bookmark"
            
            for i in 0..<talks.count {
                if talks[i]["title"] == self.talk!["title"]{
                    talks.remove(at: i)
                    break
                }
            }
        }
        defaults.set(talks, forKey: self.talk!["date"]!)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
