//
//  ViewController.swift
//  Firebase101
//
//  Created by 장기화 on 2021/05/31.
//

import UIKit
import Firebase

class ViewController: UIViewController {
    
    @IBOutlet weak var dataLabel: UILabel!
    
    let db = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateLabel()
    }
    
    func updateLabel() {
        db.child("firstData").observe(.value) { snapshot in
            print("---\(snapshot)")
            let value = snapshot.value as? String ?? ""
            
            DispatchQueue.main.async {
                self.dataLabel.text = value
            }
        }
    }
}

