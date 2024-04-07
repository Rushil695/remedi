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
    @Published var url: URL? = nil
    @Published var results: Bool = false
    
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
                // Handle error...
                return
            }
            
            // Handle response...
        }
        task.resume()
    }
    
    
    func requestPresignedURL(fileName: String, fileType: String, completion: @escaping (URL?) -> Void) {
        let urlString = "https://yourbackend.com/generate-presigned-url?file_name=\(fileName)&file_type=\(fileType)"
        guard let url = URL(string: urlString) else { return }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Error requesting presigned URL: \(String(describing: error))")
                completion(nil)
                return
            }
            
            do {
                if let jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let presignedURLString = jsonObject["url"] as? String,
                   let presignedURL = URL(string: presignedURLString) {
                    completion(presignedURL)
                } else {
                    print("Invalid response")
                    completion(nil)
                }
            } catch {
                print("Failed to parse JSON: \(error)")
                completion(nil)
            }
        }
        
        task.resume()
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
//
    
    
}
