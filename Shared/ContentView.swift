//
//  ContentView.swift
//  Shared
//
//  Created by Tariq Almazyad on 3/6/21.
import SwiftUI
import CoreImage.CIFilterBuiltins

struct User: Codable {
    let email: String
    let name: String
}

struct ContentView: View {
    @State private (set) var user = User(email: "sample@gmail.com", name: "username")
    var body: some View {
        Image(uiImage: .generateQRCode(from: user,
                                       backgroundColor: .white,
                                       QRCodeColor: .black))
            .resizable()
            .interpolation(.none)
            .scaledToFill()
            .frame(width: 300, height: 300)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


extension UIImage {
    /// to generate QRCode by passing any object that confirms to Codable protocol
    /// - Parameters:
    ///   - anyObject: Any object that confirms to Codable protocol
    ///   - backgroundColor: the background of the QRCode
    ///   - QRCodeColor: the outer color of QRCode
    /// - Returns: UIImage 
    static func generateQRCode<T: Codable>(from anyObject: T,
                                           backgroundColor: CIColor = .clear,
                                           QRCodeColor: CIColor = .white) -> UIImage {
        let context = CIContext()
        let filter = CIFilter.qrCodeGenerator()
        guard let colorFilter: CIFilter = CIFilter(name: "CIFalseColor") else {return UIImage()}
        do {
            let data = try JSONEncoder().encode(anyObject)
            filter.setValue(data, forKey: "inputMessage")
            colorFilter.setValue(filter.outputImage, forKey: "inputImage")
            colorFilter.setValue(QRCodeColor, forKey: "inputColor0")
            colorFilter.setValue(backgroundColor, forKey: "inputColor1")
            if let outputImage = colorFilter.outputImage {
                if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
                    return UIImage(cgImage: cgimg)
                }
            }
        } catch (let error) {
            print(error.localizedDescription)
        }
        return UIImage(systemName: "xmark.circle") ?? UIImage()
    }
}
