//
//  TableViewController.swift
//  ZipPlayground
//
//  Created by Raphael Berendes (extern) on 25.11.19.
//  Copyright © 2019 Raphael Berendes (extern). All rights reserved.
//

import Combine
import UIKit

class TableViewController: UITableViewController {
    
    var images = [UIImage]()
    var imageLoader: Cancellable?
    let count = 100
    
    override func viewDidLoad() {
        
        var cancellables = [URLSession.DataTaskPublisher]()
        
        let url = URL(string: "https://www.w3schools.com/w3css/img_lights.jpg")!
        
        for _ in 1...count {
            let publisher = URLSession(configuration: .default).dataTaskPublisher(for: url)
            cancellables.append(publisher)
        }
        
        imageLoader = Publishers.MergeMany(cancellables)
            .compactMap { UIImage(data: $0.data) }
            .collect()
            .sink(receiveCompletion: { completion in
                let diff = CFAbsoluteTimeGetCurrent() - AppDelegate.appStartTime
                print(completion)
                print("Took \(diff) seconds")
            }) { [weak self] images in
                self?.images = images
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        "\(section + 1)"
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        images.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ImageCell.self), for: indexPath) as! ImageCell
        cell.setup(with: images[indexPath.row])
        
        return cell
    }
    
}

class ImageCell: UITableViewCell {
    
    @IBOutlet weak var cellImageView: UIImageView!
    
    func setup(with image: UIImage) {
        
        cellImageView.image = image
    }
}
