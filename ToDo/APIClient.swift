//
// Created by Niklas Rammerstorfer on 06.02.18.
// Copyright (c) 2018 Niklas Rammerstorfer. All rights reserved.
//

import Foundation

class APIClient {
    lazy var session: SessionProtocol = URLSession.shared

    func loginUser(withName username: String, password: String, completion: @escaping (Token?, Error?) -> ()) {

        let query = "username=\(username.percentEncoded)&password=\(password.percentEncoded)"

        guard let url = URL(string: "https://awesometodos.com/login?\(query)") else{
            fatalError()
        }

        let task = session.dataTask(with: url){
            (data, response, error) in

            guard error == nil else{
                completion(nil, error)
                return
            }

            guard let data = data else {
                completion(nil, WebserviceError.dataEmptyError)
                return
            }

            do {
                let dict = try JSONSerialization.jsonObject(with: data) as? [String: String]

                let token: Token?
                if let tokenString = dict?["token"] {
                    token = Token(id: tokenString)
                } else {
                    token = nil
                }

                completion(token, nil)
            }
            catch{
                completion(nil, error)
            }
        }

        task.resume()
    }
}

protocol SessionProtocol {
    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}

extension URLSession: SessionProtocol{}

extension String{
    var percentEncoded: String{

        let allowedCharacters = CharacterSet(
                charactersIn:
                "/%&=?$#+-~@<>|\\*,.()[]{}^!").inverted

        guard let encoded = self.addingPercentEncoding(withAllowedCharacters: allowedCharacters) else{
            fatalError()
        }

        return encoded
    }
}

enum WebserviceError: Error{
    case dataEmptyError
}
