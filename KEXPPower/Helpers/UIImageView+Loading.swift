//
//  UIImageView+Loading.swift
//  KEXPPower
//
//  Created by Dustin Bergman on 7/16/19.
//  Copyright © 2019 KEXP. All rights reserved.
//

import UIKit

private let imageCache = NSCache<NSString, UIImage>()

extension UIImageView {
    public typealias ImageCompletion = (_ image: UIImage?) -> Void
    
    public func fromURL(_ imageURL: URL?, placeHolder: UIImage? = nil, completion: ImageCompletion? = nil) {
        guard let imageURL = imageURL else {
            image = placeHolder
            completion?(placeHolder)
            
            return
        }
        
        image = nil
        
        if let cachedImage = imageCache.object(forKey: imageURL.absoluteString as NSString) {
            image = cachedImage
            
            completion?(image)
            
            return
        }
        
        URLSession.shared.dataTask(with: imageURL, completionHandler: { data, response, error in
            if error != nil {
                DispatchQueue.main.async {
                    self.image = placeHolder
                    completion?(placeHolder)
                }
                
                return
            }
            
            DispatchQueue.main.async {
                guard
                    let data = data,
                    let downloadedImage = UIImage(data: data)
                else {
                    completion?(placeHolder)
                    return
                }
                
                imageCache.setObject(downloadedImage, forKey: imageURL.absoluteString as NSString)
                self.image = downloadedImage
                completion?(self.image)
            }
        }).resume()
    }
}
