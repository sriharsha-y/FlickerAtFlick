//
//  FlickerImageSearchViewModel.swift
//  FlickerAtFlick
//
//  Created by sriharshay on 28/09/19.
//  Copyright © 2019 harsha. All rights reserved.
//

import Foundation

class FlickerImageSearchViewModel<T: NetworkRouter> {
    
    
    // Private Properties
    private lazy var _flickerImageSearchModel = {
        return FlickerImageSearchModel(photos: FlickerImageSearchModel.FlickerImageSearchPageModel(page: 1, pages: 0, perpage: 0, total: "0", photo: []))
    }()
    private var imageToSearch: String = "" {
        didSet {
            self.resetFLickerImageSearchModel()
            self.notifyCollectionReload?()
        }
    }
    private var router: T!
    
    // Public Properties
    var flickerImageSearchModel: FlickerImageSearchModel {
        return _flickerImageSearchModel
    }
    
    
    // Callbacks
    var notifyCollectionReload:(()->())?
    var notifyErrors: ((String) -> ())?
    
    
    init(router: T) {
        self.router = router
    }
    
    
    func searchFor(image: String?) {
        guard let imageString = image else {
            self.notifyErrors?("Please use proper search term.")
            return
        }
        self.imageToSearch = imageString
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
        self.router.request(ImagesAPI.searchImage(text: self.imageToSearch, pageNumber: pageNumber)) {[weak self] (data, response, error) in
            guard let weakSelf = self else {return}
            if error != nil {}
            guard let data = data, let model = try? JSONDecoder().decode(FlickerImageSearchModel.self, from: data) else {return}
            DispatchQueue.main.async {
                weakSelf.appendNewResults(model: model)
            }
        }
    }
    
    private func appendNewResults(model: FlickerImageSearchModel) {
        var photosArray = self._flickerImageSearchModel.photos.photo
        photosArray.append(contentsOf: model.photos.photo)
        self._flickerImageSearchModel = FlickerImageSearchModel(photos: FlickerImageSearchModel.FlickerImageSearchPageModel(page: model.photos.page, pages: model.photos.pages, perpage: model.photos.perpage, total: model.photos.total, photo: photosArray))
        self.notifyCollectionReload?()
        if self.flickerImageSearchModel.photos.total == "0" {
            self.notifyErrors?("No images found. Try another search term.")
        }
    }
    
    private func resetFLickerImageSearchModel() {
        self._flickerImageSearchModel = FlickerImageSearchModel(photos: FlickerImageSearchModel.FlickerImageSearchPageModel(page: 1, pages: 0, perpage: 0, total: "0", photo: []))
    }
}
