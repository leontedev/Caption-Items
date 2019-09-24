//
//  ViewController.swift
//  Caption Items
//
//  Created by Mihai Leonte on 9/23/19.
//  Copyright © 2019 Mihai Leonte. All rights reserved.
//

import UIKit

class ViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var items: [Item] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Caption Items"
        tableView.backgroundColor = .gray
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewItem))
        
        let defaults = UserDefaults.standard
        if let savedItems = defaults.object(forKey: "items") as? Data {
            let jsonDecoder = JSONDecoder()
            do {
                items = try jsonDecoder.decode([Item].self, from: savedItems)
            } catch {
                print("Failed to load items.")
            }
        }
    }
    
    @objc func addNewItem() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true // the user can crop the picture
        picker.delegate = self
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.sourceType = .camera
        }
        present(picker, animated: true)
    }
    
    // MARK: - ImagePicker Delegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        
        let imageName = UUID().uuidString
        
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)
        
        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            try? jpegData.write(to: imagePath)
        }
        
        dismiss(animated: true)
        
        let ac = UIAlertController(title: "Name", message: nil, preferredStyle: .alert)
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "Cancel", style: .destructive))
        ac.addAction(UIAlertAction(title: "Add", style: .default, handler: { [weak self, weak ac] _ in
            var item: Item
            if let name = ac?.textFields?[0].text {
                item = Item(name: name, image: imageName, views: 0)
            } else {
                item = Item(name: "Unknown", image: imageName, views: 0)
            }
            self?.items.append(item)
            self?.save()
            self?.tableView.reloadData()
        }))
        
        present(ac, animated: true)
    }
    
    
    
    // MARK: - Data Source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell") as? ItemCell {
            cell.imageLabel.text = items[indexPath.row].name
            let path = getDocumentsDirectory().appendingPathComponent(items[indexPath.row].image)
            cell.imageView?.image = UIImage(contentsOfFile: path.path)
            cell.viewsLabel.text = "Views: \(String(items[indexPath.row].views))"
            
            cell.imageView?.layer.borderColor = UIColor(white: 0, alpha: 0.3).cgColor
            cell.imageView?.layer.borderWidth = 2
            cell.imageView?.layer.cornerRadius = 7
            
            return cell
        } else {
            fatalError("Couldn't dequeue cell.")
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let detailVC = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {

            items[indexPath.row].views += 1
            
            let path = getDocumentsDirectory().appendingPathComponent(items[indexPath.row].image)
            detailVC.imagePath = path.path
            detailVC.imageTitle = items[indexPath.row].name
            
            navigationController?.pushViewController(detailVC, animated: true)
        }
    }
    
    // MARK: - Helper Functions
    func getDocumentsDirectory() -> URL {
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return path[0]
    }
    
    func save() {
        let jsonEncoder = JSONEncoder()
        if let savedData = try? jsonEncoder.encode(items) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "items")
        } else {
            print("Failed to save items.")
        }
    }


}

