//
//  MainVM.swift
//  remedi
//
//  Created by Rushil Madhu on 4/6/24.
//

import Foundation
import AVFoundation
import UIKit
import SwiftUI
import PhotosUI

class MainVM: ObservableObject {
    @Published var textPrompt: String = ""
    @Published var image: UIImage? = nil
    
    @Published var response: String = ""
    
    @Published var s3url: URL = URL(string: "https://yours3bucket.com")!
    @Published var results: Bool = false
    
    @Published var messages: [String] = []
    
    var audioRecorder: AVAudioRecorder? = AudioRecorderManager.
    var audioLevelTimer: Timer?

    
    var backendURL =  URL(string: "https://d43d-158-103-2-10.ngrok-free.app")!
    private let networkService = NetworkService()

    
    
    
    // MARK: - image and text
    
    func sendDataToServer(imageLink: String, textData: String) async throws -> String {
        print("senddatato server called")
//        guard let encodedImageLink = imageLink.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
//              let encodedTextData = textData.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
//            completion(false, "Error encoding URL parameters.")
//            return
//        }
        let encodedImageLink = ""
        let encodedTextData = textData.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        guard let encodedTextDataString = encodedTextData else {
            print("Encoding failed.")
            return ""
        }
        print(encodedTextDataString)
        
        let urlString = backendURL.absoluteString + "/callback?image_link=\(encodedImageLink)&text_data=\(encodedTextDataString)"
        
        print(urlString)
        
        let urlS = URL(string: urlString)!
        
        let (data, response) = try await URLSession.shared.data(from: urlS)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            return ""
        }
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(String.self, from: data)
        } catch {
            throw error
        }
        
    }



    func uploadImageToS3(url: URL, image: UIImage) {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            print("Could not get JPEG representation of UIImage")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("image/jpeg", forHTTPHeaderField: "Content-Type")
        request.httpBody = imageData
        
        let task = URLSession.shared.uploadTask(with: request, from: imageData) { data, response, error in
            if let error = error {
                print("Error uploading image: \(error)")
                return
            }
            print("Image uploaded successfully")
        }
        
        task.resume()
    }
    
    
    // MARK: - audio
    
    func sendAudioToServer(fileUrl: URL) {
        let url = URL(string: "http://127.0.0.1:5000/callback?image=https%3A%2F%2Fi0.wp.com%2Fpost.healthline.com%2Fwp-content%2Fuploads%2F2022%2F03%2FContact-dermatitis-of-the-arm-body19.jpg%3Fw%3D1155%26h%3D1528&text=I%20Have%20Itching%20On%20My%20Arm")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var data = Data()
        data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"file\"; filename=\"recording.m4a\"\r\n".data(using: .utf8)!)
        data.append("Content-Type: audio/m4a\r\n\r\n".data(using: .utf8)!)
        data.append(try! Data(contentsOf: fileUrl))
        data.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
        
        let task = URLSession.shared.uploadTask(with: request, from: data) { data, response, error in
            if let error = error {
                print(error)
                // Handle error...
                return
            }
            
            // Handle response...
        }
        task.resume()
    }
    
    // MARK: - fetching the questions

    
    func fetchQuestion() {
            let url = backendURL.appendingPathComponent("/callback2")
            networkService.postRequest(url: url, body: ["data": "initial data"]) { data, _, _ in
                guard let data = data,
                      let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []),
                      let dictionary = jsonObject as? [String: Any],
                      let question = dictionary["question"] as? String else { return }
                
                DispatchQueue.main.async {
                    self.messages.append(question)
                }
            }
        }
    
    func sendResponse(_ answer: String) {
        let url = backendURL.appendingPathComponent("/callback3")
        networkService.postRequest(url: url, body: ["answer": answer]) { data, _, _ in
            guard let data = data,
                  let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []),
                  let dictionary = jsonObject as? [String: Any],
                  let response = dictionary["response"] as? String else { return }
            
            DispatchQueue.main.async {
                self.response = response
                
            }
        }
    }
}
    
class NetworkService {
    func postRequest(url: URL, body: [String: Any], completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let data = try? JSONSerialization.data(withJSONObject: body, options: [])
        request.httpBody = data
        URLSession.shared.dataTask(with: request, completionHandler: completion).resume()
    }
    
}
