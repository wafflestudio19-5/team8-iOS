//
//  CachedImageLoader.swift
//  WaffleMarket
//
//  Created by 안재우 on 2022/01/08.
//

import Foundation
import UIKit
class CachedImageLoader{
    private static var imageCache: NSCache<NSString, UIImage> = NSCache()
    private var task: URLSessionDataTask?
    private let taskQueue = DispatchQueue(label:"imageDownload")
    func load(path: String?, putOn: UIImageView, completion: ((UIImageView, _ usedCache:Bool)->Void)? = nil) {
        guard let path = path else {
            putOn.image = nil
            completion?(putOn, false)
            return
        }
        taskQueue.async {
            if let image = CachedImageLoader.imageCache.object(forKey: path as NSString) {
                DispatchQueue.main.async {
                    putOn.image = image
                }
                completion?(putOn, true)
                return
            }
            let url = URL(string: path)
            
            self.task = URLSession.shared.dataTask(with: url!) { data, response, error in
                guard let statusCode = ((response as? HTTPURLResponse)?.statusCode) else {return}
                if statusCode != 200 {
                    print("Error while loading image. Status Code: \(statusCode)" )
                    return
                }
                if let data = data, let image = UIImage(data: data){
                    DispatchQueue.main.async {
                        CachedImageLoader.imageCache.setObject(image, forKey: path as NSString)
                        putOn.image = image
                    }
                    completion?(putOn, false)
                }
            }
            self.task?.resume()
        }
    }
    func cancel(){
        task?.cancel()
    }
}
