//
//  HPlusService.swift
//  Lynda_RequestingDataHTTP
//
//  Created by Antonakakis Nikolaos on 18.06.19.
//  Copyright © 2019 Antonakakis Nikolaos. All rights reserved.
//

import Foundation

protocol HPlusService {
    typealias ProductCompletion = (PagedResult<Product>) -> Void
    func products(page: Int, resultsPerPage: Int, completion: @escaping ProductCompletion)
}

class HPlusWebService: HPlusService {
    func products(page: Int, resultsPerPage: Int, completion: @escaping (PagedResult<Product>) -> Void) {
        //        self.products = fakeProducts()
        guard let url = URL(string: "https://hplussport.com/api/products/page/\(page)/qty/\(resultsPerPage)") else { return }
        //        guard let url = URL(string: "https://hplussport.com/api/products/format/xml") else { return }
        let task = session.dataTask(with: url) { (data, response, error) in
            print("Data received: \(String(describing: data))")
            guard let data = data else { return }
            do {
                try validate(response)
                let products: [Product] = try parse(data)
                let productPage = PagedResult(pageNumber: page, results: products)
                completion(productPage)
            } catch {
                print("JSONParsing Error: \(error)")
            }
        }
        task.resume()

    }
    
    
}
