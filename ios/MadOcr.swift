import Vision
import VisionKit





@available(iOS 13.0, *)
@objc(MadOcr)
class MadOcr: NSObject {
    private var ocrRequest = VNRecognizeTextRequest(completionHandler: nil)
    private var knownTags = [String]()
    
    
    // export
    @objc(textRecognition:withResolver:withRejecter:)
    func textRecognition(imageUri: String, resolve:@escaping RCTPromiseResolveBlock,reject:@escaping  RCTPromiseRejectBlock) -> Void {
        
        configureOCRText(resolve: resolve, reject: reject)
        processImage(imageUri, reject: reject)

    }
    
    
    @objc(tagRecognition:withResolver:withRejecter:)
    func tagRecognition(imageUri: String, resolve:@escaping RCTPromiseResolveBlock,reject:@escaping  RCTPromiseRejectBlock) -> Void {
        
        configureOCRTag(resolve: resolve, reject: reject)
        processImage(imageUri, reject: reject)

    }
    
    @objc(setKnownTags:withResolver:withRejecter:)
    func setKnownTags(tags: [String], resolve:@escaping RCTPromiseResolveBlock,reject:@escaping  RCTPromiseRejectBlock) -> Void {
        
        self.knownTags = tags
        resolve(nil)
    }
    
    private func processImage(_ imageUri: String, reject:@escaping  RCTPromiseRejectBlock) {
        let url = URL(string: imageUri)
        
        do {
            let data = try Data(contentsOf: url!)
               
            guard let image = UIImage(data: data),
            let cgImage = image.cgImage  else { return }
           
            let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
            do {
               try requestHandler.perform([self.ocrRequest])
            } catch {
                print(error)
                reject("Vision", "Unable to send request to vision", error)
            }
        } catch {
            print(error)
            reject("File", "Unable to open file", error)
        }
   
    }
    
    
    private func configureOCRText(resolve: @escaping RCTPromiseResolveBlock,reject: @escaping RCTPromiseRejectBlock) {
        ocrRequest = VNRecognizeTextRequest { (request, error) in
            guard let observations = request.results as? [VNRecognizedTextObservation] else { return }
            
            var ocrText = [String]()
            for observation in observations {
                guard let topCandidate = observation.topCandidates(1).first else { return }
                
                ocrText.append(topCandidate.string)
            }
            
            DispatchQueue.main.async {
                resolve(ocrText)
            }
        }
        
        ocrRequest.recognitionLevel = .accurate
        ocrRequest.recognitionLanguages = ["en-US", "en-GB"]
        ocrRequest.usesLanguageCorrection = true
    }
    
    private func configureOCRTag(resolve: @escaping RCTPromiseResolveBlock,reject: @escaping RCTPromiseRejectBlock) {
        ocrRequest = VNRecognizeTextRequest { (request, error) in
            guard let observations = request.results as? [VNRecognizedTextObservation] else { return }
            
            var ocrText = [String]()
            for observation in observations {
                guard let topCandidate = observation.topCandidates(1).first else { return }
                
                ocrText.append(topCandidate.string)
            }
            var result = ocrText
            
            result = ShortTextStrategy().extractTags(tags: result)
            result = RemoveDublicateStrategy().extractTags(tags: result)
            result = ToUpperCommonOcrErrorStrategy().extractTags(tags: result)
            result = RegexStrategy().extractTags(tags: result)
            result = FilterCharUniqStrategy().extractTags(tags: result)
            result = LevenshteinDistanceStrategy(knownTags: self.knownTags).extractTags(tags: result)
            
            result = RemoveDublicateStrategy().extractTags(tags: result)

            
            
            DispatchQueue.main.async {
                resolve(result)
            }
        }
        
        ocrRequest.recognitionLevel = .accurate
        ocrRequest.recognitionLanguages = ["en-US", "en-GB", "no-NB"]
        ocrRequest.usesLanguageCorrection = true
    }

}


