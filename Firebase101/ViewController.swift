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
    @IBOutlet weak var numberOfCustomers: UILabel!
    
    let db = Database.database().reference()
    var customers: [Customer] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateLabel()
        
//        saveBasicTypes()
//        saveCustomers()
//        readCustomers()
        
//        updateBasicTypes()
//        deleteBasicTypes()
    }
    
    func updateLabel() {
        db.child("firstData").observeSingleEvent(of: .value) { snapshot in
            print("---\(snapshot)")
            let value = snapshot.value as? String ?? ""
            
            DispatchQueue.main.async {
                self.dataLabel.text = value
            }
        }
    }
    
    @IBAction func createCutomer(_ sender: Any) {
        saveCustomers()
    }
    
    @IBAction func readCutomer(_ sender: Any) {
        readCustomers()
    }
    
    func updateCustomers() {
        guard customers.isEmpty == false else { return }
        customers[0].name = "JANG"
        
        let dictionary = customers.map { $0.toDictionary }
        db.updateChildValues(["Customers" : dictionary])
    }
    
    @IBAction func updateCutomer(_ sender: Any) {
        updateCustomers()
    }
    
    func deleteCustomers() {
        db.child("Customers").removeValue()
    }
    
    @IBAction func deleteCutomer(_ sender: Any) {
        deleteCustomers()
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

extension ViewController {
    func readCustomers() {
        db.child("Customers").observeSingleEvent(of: .value) { snapshot in
            print("---\(snapshot.value)")
            
            do {
                let data = try JSONSerialization.data(withJSONObject: snapshot.value, options: [])
                let decoder = JSONDecoder()
                let customers: [Customer] = try decoder.decode([Customer].self, from: data)
                self.customers = customers
                
                DispatchQueue.main.async {
                    self.numberOfCustomers.text = "# of Customers: \(customers.count)"
                }
                
            } catch let error {
                print("error : \(error.localizedDescription)")
            }
        }
    }
}

extension ViewController {
    func updateBasicTypes() {
        db.updateChildValues(["int" : 999])
        db.updateChildValues(["dou" : 3333.33])
        db.updateChildValues(["str" : "ㅎㅎㅎㅎ"])

//        db.child("int").setValue(1000)
//        db.child("dou").setValue(5.5)
//        db.child("str").setValue("ㅋㅋㅋㅋㅋ")
    }
    
    func deleteBasicTypes() {
        db.child("int").removeValue()
        db.child("dou").removeValue()
        db.child("str").removeValue()
    }
}

struct Customer: Codable {
    let id: String
    var name: String
    let books: [Book]
    
    var toDictionary: [String : Any] {
        let booksArray = books.map { $0.toDictionary }
        let dict: [String : Any] = ["id" : id, "name" : name, "books" : booksArray]
        return dict
    }
    
    static var id: Int = 0
}

struct Book: Codable{
    let title: String
    let author: String
    
    var toDictionary: [String : Any] {
        let dict: [String : Any] = ["title" : title, "author" : author]
        return dict
    }
}
