//
//  main.swift
//  tara-lets
//
//  Created by d&a-m-pro  on 28/9/23.
//

import Foundation

struct apiStruct: Codable {
    let page: Int?
    let data: [Authors]
}
struct Authors: Codable {
    let story_id: Int?
    let title: String
    let story_title: String?
}

let group = DispatchGroup()

func callAPI() {
    let authorTest:String = "epaga"
    var apiFinalData:apiStruct? = nil

    group.enter()
    getResults(author: authorTest) { apiData in
        apiFinalData = apiData
        group.leave()
    }

    //To Wait all background process
    //group.wait()
    group.notify(queue: DispatchQueue.main, execute: {
        print("All is done")
        print(apiFinalData!)
        print(apiFinalData!.data[0])
        exit(EXIT_SUCCESS)
    })
}

func getResults(author:String, page:Int? = 1, perPage:Int? = 1, completion: @escaping ((apiStruct)->Void )) {
    guard let url = URL(string: "https://jsonmock.hackerrank.com/api/articles?author=\(author)&page=\(String(describing: page))")
    else { return }
    
    let task = URLSession.shared.dataTask(with: url) {
        data, response, error in
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        if let data = data {
            do {
                let authors = try decoder.decode(apiStruct.self, from: data)
                completion(authors)
            } catch {
                print(error)
            }
        } else {
            //TODO: Error
        }
    }
    task.resume()
}

callAPI()
print("Hello, World!")

dispatchMain()

//Using swift concurrency async and await
/*
 do {
 guard let url = URL(string: "https://jsonmock.hackerrank.com/api/articles?author=epaga&page=1") else {
 throw URLError(.badURL)
 }
 
 let (data, _) = try await URLSession.shared.data(from: url)
 if let string = String(data: data, encoding: .utf8) {
 print(string)
 } else {
 print("Unable to generate string representation")
 }
 } catch {
 print(error)
 }
 */

//Dispatch group syntax
/*
let dispatchGroup = DispatchGroup()

 Add a task to the group
dispatchGroup.enter()
DispatchQueue.global().async {
    print("Dongski2")
    dispatchGroup.leave()
}

 Add another task to the group
dispatchGroup.enter()
DispatchQueue.global().async {
    print("Dongski3")
    dispatchGroup.leave()
}

 Wait for all tasks to complete
dispatchGroup.wait()

try getResults(author: "epaga") { test in
    print("wew")
    print(test)
}
 */

//Swift concurency optimized request API
/*
 let (data, _) = try await URLSession.shared.data(from: url)
 let apiStruct = try JSONDecoder().decode(apiStruct.self, from: data)
 completion(apiStruct)
 */
