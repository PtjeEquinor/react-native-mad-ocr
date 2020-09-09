import Vision
import VisionKit





@available(iOS 13.0, *)
@objc(MadOcr)
class MadOcr: NSObject {
    private var ocrRequest = VNRecognizeTextRequest(completionHandler: nil)
    private var knownTags = [String]()
    
    
    // export
    @objc(multiply:withResolver:withRejecter:)
    func multiply(imageUri: String, resolve:@escaping RCTPromiseResolveBlock,reject:@escaping  RCTPromiseRejectBlock) -> Void {
        
        configureOCR(resolve: resolve, reject: reject)
        processImage(imageUri, reject: reject)

    }
    
    @objc(setKnownTags:withResolver:withRejecter:)
    func setKnownTags(tags: [String], resolve:@escaping RCTPromiseResolveBlock,reject:@escaping  RCTPromiseRejectBlock) -> Void {
        
        self.knownTags = tags
//        let g = LevenshteinDistanceStrategy(knownTags: ["test222", "test444"])
//
//        let r = g.extractTags(tags: ["test123"])
//
        resolve("jadda")
//        configureOCR(resolve: resolve, reject: reject)
//        processImage(imageUri, reject: reject)

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
    
    
    private func configureOCR(resolve: @escaping RCTPromiseResolveBlock,reject: @escaping RCTPromiseRejectBlock) {
        ocrRequest = VNRecognizeTextRequest { (request, error) in
            guard let observations = request.results as? [VNRecognizedTextObservation] else { return }
            
            var ocrText = [String]()
            for observation in observations {
                guard let topCandidate = observation.topCandidates(1).first else { return }
                
                ocrText.append(topCandidate.string)
            }
            
            let lev = LevenshteinDistanceStrategy(knownTags: self.knownTags)
            
            var result = ocrText
            
            result = lev.extractTags(tags: result)
            
            
            DispatchQueue.main.async {
                resolve(result)
            }
        }
        
        ocrRequest.recognitionLevel = .accurate
        ocrRequest.recognitionLanguages = ["en-US", "en-GB"]
        ocrRequest.usesLanguageCorrection = true
    }

}


