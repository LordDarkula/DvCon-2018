//
//  SponsorsViewController.swift
//  DvCon
//
//  Created by Aubhro Sengupta on 2/14/17.
//  Copyright © 2017 Aubhro Sengupta. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage

class SponsorsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var tableView: UITableView!
    
    var images: [UIImage]?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.images = []
        
        let sponsorsRef = DBConstants.rootRef.child(DBConstants.sponsorsKey)
        
        sponsorsRef.observe(.value, with: { (snapshot) in
            let imageNames = snapshot.value as? NSDictionary ?? [:]
            self.fetchImages(with: imageNames)
        })
    }
    
    
    func fetchImages(with names: NSDictionary) {
        let storageRef = Storage.storage().reference(withPath: "/DVCon 2018/sponsors/")
        let maxSize: Int64 = 3 * 1024 * 1024
        
        var images: [UIImage] = []
        
        for (_, name) in names {
            let imageRef = storageRef.child("\(name)")
            imageRef.getData(maxSize: maxSize, completion: {(data, error)  in
                images.append(UIImage(data: data!)!)
                self.images = images
                self.tableView.reloadData()
            })
        }
        
    }
    
    // MARK: - TableView Setup

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(images?.count ?? 0)
        return images?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SponsorTableViewCell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.sponsors) as! SponsorTableViewCell
        
        cell.sponsorImage.image = images![indexPath.row]
        
        return cell
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
