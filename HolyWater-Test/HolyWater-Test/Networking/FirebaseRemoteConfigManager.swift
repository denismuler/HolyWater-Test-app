//
//  FirebaseRemoteConfigManager.swift
//  HolyWater-Test
//
//  Created by Georgie Muler on 24.02.2024.
//

import Foundation
import FirebaseRemoteConfig

class FirebaseRemoteConfigManager {
    static let shared = FirebaseRemoteConfigManager()

    private init() {
        setupRemoteConfigDefaults()
    }

    private func setupRemoteConfigDefaults() {
        let defaults: [String: NSObject] = [
            "json_data": "JSON data" as NSObject,
            "details_carousel": "JSON data" as NSObject,
        ]

        RemoteConfig.remoteConfig().setDefaults(defaults)
    }

    func fetchRemoteConfig(completion: @escaping (Error?) -> Void) {
        RemoteConfig.remoteConfig().fetch { [weak self] status, error in
            if status == .success {
                RemoteConfig.remoteConfig().activate(completion: nil)
                self?.saveConfigValuesToLocalFiles()
                completion(nil)
            } else {
                completion(error)
            }
        }
    }

    func getConfigValue(forKey key: String) -> String {
        return RemoteConfig.remoteConfig()[key].stringValue ?? ""
    }

    private func saveConfigValuesToLocalFiles() {
        let jsonData = getConfigValue(forKey: "json_data")
        let detailsCarousel = getConfigValue(forKey: "details_carousel")

        saveDataToFile(data: jsonData, fileName: "json_data.json")
        saveDataToFile(data: detailsCarousel, fileName: "details_carousel.json")
    }

    private func saveDataToFile(data: String, fileName: String) {
        if let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = documentsDirectory.appendingPathComponent(fileName)
            do {
                try data.write(to: fileURL, atomically: true, encoding: .utf8)
            } catch {
                print("Error saving data to file: \(error)")
            }
        }
    }
}
