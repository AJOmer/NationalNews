//
//  APICaller.swift
//  NationalNews
//
//  Created by Islam omer on 6/22/22.


import Foundation

final class APICaller {
    
    static let shared = APICaller()
    
    //create constants, in this instance data
    struct Constants {
        
        static let topHeadlinesURL = URL(string: "https://newsapi.org/v2/top-headlines?country=us&apiKey=1b9b36da311b44a0aeaa662ce0b9dbb5")
    }
    //private initializer
    private init(){}
    
    // functions to call for performance on retrieving stories/data
    public func getTopStories(completion: @escaping (Result<[Article], Error>) -> Void){
        // unwrap the url to tap into headlines properties
        guard let url = Constants.topHeadlinesURL else {
            return
        }
        
        // performs the task, returns either a response with data or an error
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
            }
            else if let data = data {
                do {
                    //Input the APIResponse carrying the article  as target source of information
                    let result = try JSONDecoder().decode(APIResponse.self, from: data)
                    completion(.success(result.articles))
                }
                catch{
                    completion(.failure(error))
                }
            }
        }
        // once task created, make sure you resume task
        task.resume()
    }
}

// Models

struct APIResponse: Codable{
    let articles: [Article]
}

// If property is not working or you are getting error, put question mark at end (?) to make it an optional element
struct Article: Codable{
    let source: Source
    let title: String
    let description: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: String?
}

struct Source: Codable{
    let name: String
}
