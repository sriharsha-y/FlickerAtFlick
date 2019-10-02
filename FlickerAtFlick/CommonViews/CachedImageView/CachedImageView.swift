//
//  CachedImageView.swift
//  FlickerAtFlick
//
//  Created by sriharshay on 28/09/19.
//  Copyright © 2019 harsha. All rights reserved.
//

import UIKit

private let imageCache = NSCache<AnyObject, AnyObject>()

class CachedImageView: UIImageView {
    
    private var imageURL: URL?
    private let activityIndicator = UIActivityIndicatorView()
    
    func loadImageWithUrl(_ url: URL) {
        
        // setup activityIndicator...
        self.activityIndicator.color = .white
        self.addSubview(activityIndicator)
        self.activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        self.activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        self.activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        self.imageURL = url
        self.image = nil
        self.activityIndicator.startAnimating()
        
        // retrieves image if already available in cache
        if let imageFromCache = imageCache.object(forKey: url as AnyObject) as? UIImage {
            self.image = imageFromCache
            self.activityIndicator.stopAnimating()
            return
        }
        
        guard let url = self.imageURL else {
            self.activityIndicator.stopAnimating()
            self.setNoImage()
            return
        }
        
        let router = Router()
        router.request(ImagesAPI.downloadImage(url: url)) { (data, response, error) in
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                DispatchQueue.main.async {
                    self.setNoImage()
                }
            }
            if error != nil {
                print(error as Any)
                DispatchQueue.main.async {
                    self.setNoImage()
                }
            }
            DispatchQueue.main.async {
                if let data = data, let imageToCache = UIImage(data: data) {
                    if self.imageURL == url {
                        self.image = imageToCache
                    }
                    imageCache.setObject(imageToCache, forKey: url as AnyObject)
                }
                self.activityIndicator.stopAnimating()
            }
        }
        // image is not available in cache.. so retrieving it from url...
//        Client().requestResource(urlString: imageUrl, dataHandler: {[unowned self] data in
//            if let imageToCache = UIImage(data: data) {
//                if self.imageURL == url {
//                    self.image = imageToCache
//                }
//                imageCache.setObject(imageToCache, forKey: url as AnyObject)
//            }
//            self.activityIndicator.stopAnimating()
//        }, responseHandle: {[unowned self] response in
//            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
//                self.setNoImage()
//            }
//        }) {[unowned self] error in
//            print(error as Any)
//            self.setNoImage()
//        }
//        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
//
//            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
//                DispatchQueue.main.async(execute: {
//                    self.setNoImage()
//                })
//            }
//
//            if error != nil {
//                print(error as Any)
//                DispatchQueue.main.async(execute: {
//                    self.setNoImage()
//                })
//                return
//            }
//
//            DispatchQueue.main.async(execute: {
//                if let unwrappedData = data, let imageToCache = UIImage(data: unwrappedData) {
//                    if self.imageURL == url {
//                        self.image = imageToCache
//                    }
//                    imageCache.setObject(imageToCache, forKey: url as AnyObject)
//                }
//                self.activityIndicator.stopAnimating()
//            })
//        }).resume()
    }
    
    private func setNoImage() {
        self.activityIndicator.stopAnimating()
        self.image = UIImage(named: "noImage")
    }
}
