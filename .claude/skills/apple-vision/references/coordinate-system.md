# Vision Framework — Coordinate System Reference

## The Problem

Vision normalizes all coordinates to [0.0, 1.0] with the **origin at the bottom-left**:

```
(0,1) ─────────────── (1,1)
  │                     │
  │      Vision         │
  │    coordinate       │
  │      space          │
  │                     │
(0,0) ─────────────── (1,0)
  ↑ origin
```

UIKit, Core Graphics, and SwiftUI place origin at **top-left**, so you must flip the Y axis when converting.

---

## UIKit / Core Graphics Conversion

```swift
extension CGRect {
    /// Convert Vision normalized bounding box to UIKit/CoreGraphics pixel rect
    func toUIKitRect(imageSize: CGSize) -> CGRect {
        CGRect(
            x: origin.x * imageSize.width,
            y: (1 - origin.y - height) * imageSize.height, // flip Y
            width: width * imageSize.width,
            height: height * imageSize.height
        )
    }
}

// Usage
let pixelRect = observation.boundingBox.toUIKitRect(imageSize: imageView.image!.size)
let layer = CAShapeLayer()
layer.frame = pixelRect
imageView.layer.addSublayer(layer)
```

---

## SwiftUI Conversion

SwiftUI also uses top-left origin. Use `GeometryReader` to get the rendered image size:

```swift
struct FaceOverlay: View {
    let faces: [FaceObservation]
    
    var body: some View {
        GeometryReader { geo in
            ForEach(Array(faces.enumerated()), id: \.offset) { _, face in
                let box = face.boundingBox
                let rect = CGRect(
                    x: box.origin.x * geo.size.width,
                    y: (1 - box.origin.y - box.height) * geo.size.height,
                    width: box.width * geo.size.width,
                    height: box.height * geo.size.height
                )
                Rectangle()
                    .stroke(Color.yellow, lineWidth: 2)
                    .frame(width: rect.width, height: rect.height)
                    .offset(x: rect.minX, y: rect.minY)
            }
        }
    }
}
```

---

## AVFoundation / Camera Buffer Conversion

Camera preview uses `AVCaptureVideoPreviewLayer` which has its own coordinate transform:

```swift
// Convert Vision bbox → preview layer coordinates
func toPreviewLayerRect(_ box: CGRect,
                        previewLayer: AVCaptureVideoPreviewLayer,
                        bufferSize: CGSize) -> CGRect {
    // Flip Y (Vision → CoreGraphics)
    var flipped = box
    flipped.origin.y = 1 - box.origin.y - box.height
    
    // Scale to buffer pixel coordinates
    let pixelRect = VNImageRectForNormalizedRect(flipped,
                                                Int(bufferSize.width),
                                                Int(bufferSize.height))
    
    // Convert to preview layer
    return previewLayer.layerRectConverted(fromMetadataOutputRect: pixelRect)
}
```

Apple's `VNImageRectForNormalizedRect(_:_:_:)` utility handles the denormalization step.

---

## VNUtils Helper Functions

Apple provides these in the Vision framework:

```swift
// Normalize a pixel rect to Vision coordinates
VNNormalizedRectForImageRect(pixelRect, imageWidth, imageHeight) → CGRect

// Denormalize Vision coordinates to pixel rect
VNImageRectForNormalizedRect(normalizedRect, imageWidth, imageHeight) → CGRect

// Get image coordinates for a point
VNImagePointForNormalizedPoint(normalizedPoint, imageWidth, imageHeight) → CGPoint
```

---

## Face Landmark Coordinates

Face landmarks are in **normalized coordinates relative to the bounding box**, not the image:

```swift
let landmarks = faceObservation.landmarks
let allPoints = faceObservation.landmarks?.allPoints

// Convert to image coordinates
func convert(landmark: VNFaceLandmarkRegion2D,
             boundingBox: CGRect,
             imageSize: CGSize) -> [CGPoint] {
    landmark.normalizedPoints.map { point in
        let imageX = (boundingBox.origin.x + point.x * boundingBox.width) * imageSize.width
        let imageY = (1 - boundingBox.origin.y - point.y * boundingBox.height) * imageSize.height
        return CGPoint(x: imageX, y: imageY)
    }
}
```

---

## Image Orientation

Passing the wrong orientation is the #1 source of rotated/mirrored Vision results.

```swift
// Front camera selfie — usually mirrored
let handler = ImageRequestHandler(cvPixelBuffer: buffer,
                                   orientation: .leftMirrored)

// Rear camera — depends on device orientation
let orientation: CGImagePropertyOrientation
switch UIDevice.current.orientation {
case .portrait:           orientation = .right
case .landscapeLeft:      orientation = .up
case .landscapeRight:     orientation = .down
case .portraitUpsideDown: orientation = .left
default:                  orientation = .right
}

let handler = ImageRequestHandler(cvPixelBuffer: buffer,
                                   orientation: orientation)
```

### EXIF to CGImagePropertyOrientation Mapping

```swift
extension CGImagePropertyOrientation {
    init(_ exif: Int32) {
        self = CGImagePropertyOrientation(rawValue: UInt32(exif)) ?? .up
    }
}

// From photo library
if let exifOrientation = asset.exifOrientation {
    let orientation = CGImagePropertyOrientation(exifOrientation)
    let handler = ImageRequestHandler(cgImage: cgImage, orientation: orientation)
}
```

---

## ARKit + Vision

ARKit passes `ARFrame.capturedImage` (a `CVPixelBuffer`). Vision coordinates map to the captured image, not the ARSCNView screen:

```swift
func session(_ session: ARSession, didUpdate frame: ARFrame) {
    Task {
        let handler = ImageRequestHandler(
            cvPixelBuffer: frame.capturedImage,
            orientation: .right  // standard rear camera portrait
        )
        let faces = try await handler.perform(DetectFaceRectanglesRequest())
        // Project to 3D using frame.camera.projectPoint
    }
}
```
