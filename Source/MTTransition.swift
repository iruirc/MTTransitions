//
//  MTTransition.swift
//  MTTransitions
//
//  Created by alexiscn on 2019/1/24.
//

import Foundation
import MetalPetal

/// The callback when transition updated
public typealias MTTransitionUpdater = (_ image: MTIImage) -> Void

/// The callback when transition completed
public typealias MTTransitionCompletion = (_ finished: Bool) -> Void

public class MTTransition: NSObject, MTIUnaryFilter {
    
    public static let context = try? MTIContext(device: MTLCreateSystemDefaultDevice()!)
    
    public override init() { }

    public var inputImage: MTIImage?

    public var destImage: MTIImage?
    
    public var outputPixelFormat: MTLPixelFormat = .invalid
    
    public var progress: Float = 0.0
    
    /// The duration of the transition. 1.2 second by default.
    public var duration: TimeInterval = 1.2
    
    var completion: MTTransitionCompletion?
    
    private var updater: MTTransitionUpdater?
    #if canImport(UIKit)
    private weak var driver: CADisplayLink?
    #endif
    private var startTime: TimeInterval?
    
    // Subclasses must provide fragmentName
    var fragmentName: String { return "" }
    var parameters: [String: Any] { return [:] }
    var samplers: [String: String] { return [:] }
    
    public var outputImage: MTIImage? {
        guard let input = inputImage, let dest = destImage else {
            return inputImage
        }
        var images: [MTIImage] = [input, dest]
        let outputDescriptors = [ MTIRenderPassOutputDescriptor(dimensions: MTITextureDimensions(cgSize: input.size), pixelFormat: outputPixelFormat)]
        
        for key in samplers.keys {
            if let name = samplers[key], let samplerImage = samplerImage(name: name) {
                images.append(samplerImage)
            }
        }
        
        var params = parameters
        params["ratio"] = Float(input.size.width / input.size.height)
        params["progress"] = progress
        
        let output = kernel.apply(to: images, parameters: params, outputDescriptors: outputDescriptors).first
        return output
    }
    
    var kernel: MTIRenderPipelineKernel {
        let vertexDescriptor = MTIFunctionDescriptor(name: MTIFilterPassthroughVertexFunctionName)
        
        var libraryURL: URL? = nil
        
        // Try to find default.metallib inside the MTTransitions.framework bundle
        if let frameworkURL = MTIDefaultLibraryURLForBundle(Bundle(for: MTTransition.self)) {
            // Check if the file exists
            if FileManager.default.fileExists(atPath: frameworkURL.path) {
                // Use this URL if the file exists
                libraryURL = frameworkURL
            }
        }
        
        // If not found in framework bundle, try the main app bundle
        if libraryURL == nil {
            // Look for default.metallib inside Bundle.main
            if let mainURL = MTIDefaultLibraryURLForBundle(Bundle.main) {
                // Check if the file exists
                if FileManager.default.fileExists(atPath: mainURL.path) {
                    // Use this URL if the file exists
                    libraryURL = mainURL
                }
            }
            // If still not found, libraryURL remains nil
        }
        
        let fragmentDescriptor = MTIFunctionDescriptor(name: fragmentName, libraryURL: libraryURL)
        let kernel = MTIRenderPipelineKernel(vertexFunctionDescriptor: vertexDescriptor, fragmentFunctionDescriptor: fragmentDescriptor)
        return kernel
    }
    
    private func samplerImage(name: String) -> MTIImage? {
        let bundle = Bundle(for: MTTransition.self)
        guard let bundleUrl = bundle.url(forResource: "Assets", withExtension: "bundle"),
            let resourceBundle = Bundle(url: bundleUrl) else {
            return nil
        }
        
        if let imageUrl = resourceBundle.url(forResource: name, withExtension: nil) {
            let ciImage = CIImage(contentsOf: imageUrl)
            return MTIImage(ciImage: ciImage!, isOpaque: true)
        }
        return nil
    }
    
    public func transition(from fromImage: MTIImage, to toImage: MTIImage, updater: @escaping MTTransitionUpdater, completion: MTTransitionCompletion?) {
        self.inputImage = fromImage
        self.destImage = toImage
        self.updater = updater
        self.completion = completion
        self.startTime = nil
        #if canImport(UIKit)
        let driver = CADisplayLink(target: self, selector: #selector(render(sender:)))
        driver.add(to: .main, forMode: .common)
        self.driver = driver
        #else
        // macOS: no CADisplayLink-driven live preview loop.
        // Emit final frame immediately and complete — VSDC uses the offline
        // MTVideoTransitionRenderer path, this interactive API is not used.
        self.progress = 1.0
        if let image = outputImage {
            updater(image)
        }
        completion?(true)
        self.completion = nil
        #endif
    }
    
    #if canImport(UIKit)
    @objc private func render(sender: CADisplayLink) {
        let startTime: CFTimeInterval
        if let time = self.startTime {
            startTime = time
        } else {
            startTime = sender.timestamp
            self.startTime = startTime
        }
        
        let progress = (sender.timestamp - startTime) / duration
        if progress > 1 {
            self.progress = 1.0
            if let image = outputImage {
                self.updater?(image)
            }
            self.driver?.invalidate()
            self.driver = nil
            self.updater = nil
            self.completion?(true)
            self.completion = nil
            return
        }
        
        self.progress = Float(progress)
        if let image = outputImage {
            self.updater?(image)
        }
    }
    #endif
    
    public func cancel() {
        self.completion?(false)
    }
}
