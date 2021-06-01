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
        saveBasicTypes()
        saveCustomers()
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

extension ViewController {
    func saveBasicTypes() {
        db.child("int").setValue(1000)
        db.child("dou").setValue(5.5)
        db.child("str").setValue("ㅋㅋㅋㅋㅋ")
        db.child("arr").setValue([1, 2, 3])
        db.child("dic").setValue(["id" : "123", "age" : 29, "city" : "Seoul"])
    }
    
    func saveCustomers() {
        let books = [Book(title: "apple", author: "banana"), Book(title: "bus", author: "car")]
        
        let customer1 = Customer(id: "\(Customer.id)", name: "jang", books: books)
        Customer.id += 1
        let customer2 = Customer(id: "\(Customer.id)", name: "ki", books: books)
        Customer.id += 1
        let customer3 = Customer(id: "\(Customer.id)", name: "hwa", books: books)
        Customer.id += 1
        
        db.child("Customers").child(customer1.id).setValue(customer1.toDictionary)
        db.child("Customers").child(customer2.id).setValue(customer2.toDictionary)
        db.child("Customers").child(customer3.id).setValue(customer3.toDictionary)
    }
}

struct Customer {
    let id: String
    let name: String
    let books: [Book]
    
    var toDictionary: [String : Any] {
        let booksArray = books.map { $0.toDictionary }
        let dict: [String : Any] = ["id" : id, "name" : name, "books" : booksArray]
        return dict
    }
    
    static var id: Int = 0
}

struct Book {
    let title: String
    let author: String
    
    var toDictionary: [String : Any] {
        let dict: [String : Any] = ["title" : title, "author" : author]
        return dict
    }
}
