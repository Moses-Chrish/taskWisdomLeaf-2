//
//  MainViewModel.swift
//  taskWisdomLeaf
//
//  Created by ilamparithi mayan on 23/06/24.
//

import Foundation

class MainViewModel {
    
    var getphotodatails:[PictureDetails] = []
    var currentPage = 1
    var isLoading = false
    var totalPages = 5
    
   
    
    func fetchphotos(page: Int, completion: @escaping() -> Void) {
        guard let url = URL(string: "https://picsum.photos/v2/list?page=\(page)&limit=20") else {
            print("Invalid URL")
            completion()
            return
        }
        isLoading = true
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self else { return }
            self.isLoading = false
            if let error = error {
                completion()
                print("Error: \(error.localizedDescription)")
                return
            }
            guard let data = data else {
                print("No data received")
                completion()
                return
            }
            do {
                let content = try JSONDecoder().decode([PictureDetails].self, from: data)
                self.getphotodatails += content
                print("is working",self.getphotodatails)
            
                completion()
            } catch {
                completion()
                print("Error decoding JSON: \(error.localizedDescription)")
            }
        }
        task.resume()
    }
    
}
