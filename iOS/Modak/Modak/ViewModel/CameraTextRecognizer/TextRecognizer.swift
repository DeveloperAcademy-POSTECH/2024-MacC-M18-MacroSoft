//
//  TextRecognizer.swift
//  Modak
//
//  Created by kimjihee on 10/31/24.
//


import Vision
import SwiftUI

class TextRecognizer {
    enum TextRecognizerError: Error {
        case imageProcessingFailed
        case recognitionFailed
    }
    
    func recognizeText(in image: UIImage) async throws -> String {
        guard let cgImage = image.cgImage else {
            throw TextRecognizerError.imageProcessingFailed
        }
        
        let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        let request = VNRecognizeTextRequest()
        request.recognitionLanguages = ["ko-KR"]
        request.recognitionLevel = .accurate
        
        try requestHandler.perform([request])
        
        guard let observations = request.results else {
            throw TextRecognizerError.recognitionFailed
        }
        
        let recognizedStrings = observations.compactMap { $0.topCandidates(1).first?.string }
        return recognizedStrings.joined(separator: "\n")
    }
}
