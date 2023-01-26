//
//  ExportAllEffectViewController.swift
//  MTTransitionsDemo
//
//  Created by Dmitry Nuzhin on 18.01.2023.
//  Copyright © 2023 xu.shuifeng. All rights reserved.
//

import UIKit
import AVFoundation
import MTTransitions
import Photos

class ExportAllEffectViewController: UIViewController {
    
    private var exportButton: UIBarButtonItem!
    
    private var effects: [MTTransition.Effect] = MTTransition.Effect.allCases
    
    private let videoTransition = MTVideoTransition()
    private var clips: [AVAsset] = []
    private var exporter: MTVideoExporter?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupNavigationBar()
        setupVideoPlaybacks()
    }
    
    private func setupNavigationBar() {
        exportButton = UIBarButtonItem(title: "Export", style: .plain, target: self, action: #selector(handleExportButtonClicked))
        
        navigationItem.rightBarButtonItem = exportButton
    }
    
    private func setupVideoPlaybacks() {
        guard let clip1 = loadVideoAsset(named: "ExportVideo1"),
            let clip2 = loadVideoAsset(named: "ExportVideo2") else {
            return
        }
        clips = [clip1, clip2]
    }
        
    @objc private func handleExportButtonClicked() {
        exportAllExamples()
    }
    

    private func exportAllExamples() {
        print("=== EXPORT ALL START. COUNT = \(effects.count)")
        let group = DispatchGroup()
        for (index, effect) in effects.enumerated() {
            group.enter()
            let duration = CMTimeMakeWithSeconds(1.0, preferredTimescale: 600)
            createAndSave(videos: clips,
                          index: index,
                          effect: effect,
                          duration: duration) { result in
                if result {
                    print("[\(index)]. Expor complete")
                } else {
                    print("[\(index)]. Export error")
                }
                group.leave()
            }
        }
        
        group.notify(queue: DispatchQueue.main) {
            print("=== EXPORT ALL COMPLETE")
        }
    }
    
    private func exportSingleExample() {
        let duration = CMTimeMakeWithSeconds(1.0, preferredTimescale: 600)
        createAndSave(videos: clips,
                      index: 0,
                      effect: .angular,
                      duration: duration) { result in
            if result {
                print("Expor complete")
            } else {
                print("Export error")
            }
        }
        
    }
 
    
    private func createAndSave(videos: [AVAsset],
                               index: Int,
                               effect: MTTransition.Effect,
                               duration: CMTime,
                               completion: ((Bool) -> ())?) {
//        let name: String = String(format: "%03d_", index) + effect.description
        let name = effect.description
        try? videoTransition.merge(videos,
                                   effect: effect,
                                   transitionDuration: duration) { [weak self] result in
            guard let self = self else { return }
            self.export(result,
                        name: name,
                        completion: completion)
        }
    }
    
    private func export(_ result: MTVideoTransitionResult,
                        name: String,
                        completion: ((Bool) -> ())?) {
        exporter = try? MTVideoExporter(transitionResult: result)
        let filename = name + ".mp4"
        let fileURL = URL(fileURLWithPath: NSTemporaryDirectory().appending(filename))
        exporter?.export(to: fileURL, completion: { error in
            if let error = error {
                print("Export error:\(error)")
                completion?(false)
            } else {
                DispatchQueue.main.async {
                    self.saveVideo(fileURL: fileURL,
                                   completion: completion)
                }
            }
        })
    }
    
    private func saveVideo(fileURL: URL, completion: ((Bool) -> ())? ) {
        PHPhotoLibrary.requestAuthorization { status in
            switch status {
            case .authorized:
                PHPhotoLibrary.shared().performChanges({
                    let options = PHAssetResourceCreationOptions()
                    options.shouldMoveFile = true
                    let creationRequest = PHAssetCreationRequest.forAsset()
                    creationRequest.addResource(with: .video, fileURL: fileURL, options: options)
                }) { (success, error) in
                    DispatchQueue.main.async {
                        if success {
                            completion?(true)
                        } else {
                            completion?(false)
                        }
                    }
                }
            default:
                print("PhotoLibrary not authorized")
                completion?(false)
                break
            }
        }
    }
}


// MARK: - Helper
extension ExportAllEffectViewController {
    
    private func loadVideoAsset(named: String, withExtension ext: String = "mp4") -> AVURLAsset? {
        guard let url = Bundle.main.url(forResource: named, withExtension: ext) else {
            return nil
        }
        return AVURLAsset(url: url)
    }
}
