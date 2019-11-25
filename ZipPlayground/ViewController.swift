//
//  ViewController.swift
//  ZipPlayground
//
//  Created by Raphael Berendes (extern) on 25.11.19.
//  Copyright © 2019 Raphael Berendes (extern). All rights reserved.
//

import Combine
import UIKit

class ViewController: UIViewController {
    
    var cancellable: Cancellable?
    
    override func viewDidLoad() {
        
        var cancellables = [URLSession.DataTaskPublisher]()
        
        let url = URL(string: "https://www.w3schools.com/w3css/img_lights.jpg")!
        
        let publisher1 = URLSession.shared.dataTaskPublisher(for: url)
        let publisher2 = URLSession.shared.dataTaskPublisher(for: url)
        let publisher3 = URLSession.shared.dataTaskPublisher(for: url)
        let publisher4 = URLSession.shared.dataTaskPublisher(for: url)
        
        cancellables.append(publisher1)
        cancellables.append(publisher2)
        cancellables.append(publisher3)
        cancellables.append(publisher4)
        
        cancellable = Publishers.MergeMany(cancellables)
            .compactMap { $0.data }
            .compactMap { UIImage(data: $0) }
            .collect()
            .sink(receiveCompletion: { (completion) in
                print(completion)
            }) { (images) in
                print(images)
        }
    }
    
}
