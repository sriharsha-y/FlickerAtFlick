//
//  FlickerImageSearchViewModel.swift
//  FlickerAtFlick
//
//  Created by sriharshay on 28/09/19.
//  Copyright © 2019 harsha. All rights reserved.
//

import Foundation

class FlickerImageSearchViewModel {
    
    
    private var _flickerImageSearchModel = FlickerImageSearchModel(photos: FlickerImageSearchModel.FlickerImageSearchPageModel(page: 1, pages: 0, perpage: 0, total: "0", photo: []))
    
    var flickerImageSearchModel: FlickerImageSearchModel {
        return _flickerImageSearchModel
    }
    
    var notifyCollectionReload:(()->())?
    
    init() {
        self.requestNextPage()
    }
    
    func requestNextPage() {
        if self.flickerImageSearchModel.photos.page == self.flickerImageSearchModel.photos.pages {return}
        if self.flickerImageSearchModel.photos.page < self.flickerImageSearchModel.photos.pages {
            self.requestImages(pageNumber: self.flickerImageSearchModel.photos.page + 1)
            return
        }
        self.requestImages(pageNumber: self.flickerImageSearchModel.photos.page)
    }
    
    private func requestImages(pageNumber: Int) {
        Client().requestResource(urlString: "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=3e7cc266ae2b0e0d78e279ce8e361736&%20format=json&nojsoncallback=1&safe_search=1&text=kittens&page=\(pageNumber)", dataHandler: { (data) in
            if let model = try? JSONDecoder().decode(FlickerImageSearchModel.self, from: data) {
                self.appendNewResults(model: model)
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    private func appendNewResults(model: FlickerImageSearchModel) {
        var photosArray = self._flickerImageSearchModel.photos.photo
        photosArray.append(contentsOf: model.photos.photo)
        print(photosArray.count)
        self._flickerImageSearchModel = FlickerImageSearchModel(photos: FlickerImageSearchModel.FlickerImageSearchPageModel(page: model.photos.page, pages: model.photos.pages, perpage: model.photos.perpage, total: model.photos.total, photo: photosArray))
        self.notifyCollectionReload?()
    }
}
