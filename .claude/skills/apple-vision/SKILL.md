---
name: apple-vision-framework
description: >
  Use this skill whenever working with Apple's Vision framework in iOS, macOS, iPadOS, tvOS, or visionOS apps.
  Covers the full Vision API surface: request/observation architecture, Swift concurrency (iOS 18 new API),
  all 33 built-in request types (as of WWDC25), coordinate normalization, Core ML integration, AVFoundation
  live-camera pipelines, and platform-specific gotchas. Trigger this skill for any task involving:
  face detection/landmarks, text recognition (OCR), barcode/QR scanning, body/hand/animal pose tracking,
  image saliency, background removal, rectangle detection, image aesthetics scoring, document recognition,
  lens smudge detection, trajectory analysis, optical flow, image registration, contour detection, or
  CoreML model integration via Vision. Also trigger when the user asks about migrating from the VN-prefixed
  (pre-iOS 18) API to the new Swift-native Vision API, or any debugging/performance issue with Vision requests.
---

# Apple Vision Framework Skill

## Overview

Vision is Apple's on-device computer vision framework (iOS 11+). All processing happens locally — no network, no external SDK. Available on iOS, macOS, iPadOS, tvOS, and visionOS.

**Key property: every API runs on the Neural Engine on supported devices**, giving performance comparable to cloud APIs with zero latency and full privacy.

As of WWDC25 (iOS 26 / macOS 26), Vision has **33 built-in request types**.

---

## Architecture: Request → Observation

All Vision usage follows one pattern:

```
ImageRequestHandler  ──perform──▶  Request  ──▶  [Observation]
```

1. **Request** — describes what to detect (e.g., `DetectFaceRectanglesRequest`)
2. **ImageRequestHandler** — wraps the image source and executes one or more requests
3. **Observation** — typed results (e.g., `FaceObservation` with bounding boxes, landmarks, etc.)

---

## API Versions

### iOS 18+ (New Swift API — Preferred)

Introduced at WWDC24. Redesigned for Swift Concurrency and Swift 6.

```swift
import Vision

// Step 1: Create request
var request = DetectBarcodesRequest()
request.symbologies = [.ean13, .qr]

// Step 2: Create handler and perform (async/await)
let handler = ImageRequestHandler(url)
let observations = try await handler.perform(request)

// Step 3: Use results
for barcode in observations {
    print(barcode.payloadString ?? "")
    print(barcode.boundingBox) // normalized [0,1], origin bottom-left
}
```

**Key differences from old API:**
- No `VN` prefix — `VNDetectBarcodesRequest` → `DetectBarcodesRequest`
- No completion handlers — pure `async/await`
- Batch requests with parameter pack syntax:
  ```swift
  let (barcodes, text) = try await handler.perform(barcodesRequest, textRequest)
  ```
- Neural Engine compute device is preferred; CPU/GPU removed for some requests on NE-capable devices

### Pre-iOS 18 (VN-prefixed API — Legacy)

```swift
import Vision

let request = VNDetectBarcodesRequest { request, error in
    guard let results = request.results as? [VNBarcodeObservation] else { return }
    for barcode in results {
        print(barcode.payloadStringValue ?? "")
    }
}

let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
try? handler.perform([request])
```

**Migration rule:** Remove `VN` prefix, adopt async/await, replace completion handler with returned observation array.

---

## Coordinate System ⚠️

Vision uses **normalized coordinates** — always between `0.0` and `1.0`.

- **Origin is bottom-left** (unlike UIKit/SwiftUI which is top-left)
- `boundingBox.origin.y` must be flipped for UIKit/Core Graphics overlay

```swift
// Flip for UIKit layer overlay
func convert(_ box: CGRect, to imageSize: CGSize) -> CGRect {
    let x = box.origin.x * imageSize.width
    let y = (1 - box.origin.y - box.height) * imageSize.height
    return CGRect(x: x, y: y,
                  width: box.width * imageSize.width,
                  height: box.height * imageSize.height)
}

// SwiftUI's .overlay uses top-left — also flip
// VisionKit's DataScannerViewController handles this automatically
```

---

## All Request Types (iOS 26 / WWDC25)

See `references/requests-catalog.md` for full API signatures and observations for each type.

### Face & Person
| Request | Observation | Notes |
|---|---|---|
| `DetectFaceRectanglesRequest` | `FaceObservation` | Bounding boxes only |
| `DetectFaceLandmarksRequest` | `FaceObservation` | Eyes, nose, mouth contours |
| `DetectFaceCaptureQualityRequest` | `FaceObservation` | Quality score 0–1 |
| `DetectHumanRectanglesRequest` | `HumanObservation` | Full body or upper-body |
| `RecognizeAnimalsRequest` | `RecognizedObjectObservation` | Dog/cat labels |

### Text & Documents
| Request | Observation | Notes |
|---|---|---|
| `RecognizeTextRequest` | `RecognizedTextObservation` | OCR, 18+ languages |
| `DetectTextRectanglesRequest` | `TextObservation` | Bounding boxes without recognition |
| `RecognizeDocumentsRequest` *(iOS 26)* | `DocumentObservation` | Structured: tables, lists, paragraphs |

### Barcodes & Symbols
| Request | Observation | Notes |
|---|---|---|
| `DetectBarcodesRequest` | `BarcodeObservation` | QR, EAN, PDF417, DataMatrix, etc. |

### Body & Pose Tracking
| Request | Observation | Notes |
|---|---|---|
| `DetectHumanBodyPoseRequest` | `HumanBodyPoseObservation` | 19 joints |
| `DetectHumanBodyPose3DRequest` | `HumanBodyPose3DObservation` | 3D pose (iOS 17+) |
| `DetectHumanHandPoseRequest` | `HandPoseObservation` | 21 joints per hand, updated model iOS 26 |
| `DetectAnimalBodyPoseRequest` | `AnimalBodyPoseObservation` | Cats, dogs (iOS 17+) |
| `DetectTrajectoriesRequest` | `TrajectoryObservation` | Object trajectory tracking |
| `AnalyzeImageAestheticsRequest` | `ImageAestheticsObservation` | Holistic body pose included (iOS 18) |

### Image Analysis & Saliency
| Request | Observation | Notes |
|---|---|---|
| `GenerateObjectnessBasedSaliencyImageRequest` | `SaliencyImageObservation` | What objects stand out |
| `GenerateAttentionBasedSaliencyImageRequest` | `SaliencyImageObservation` | Human attention heatmap |
| `GeneratePersonSegmentationRequest` | `PixelBufferObservation` | Background removal |
| `GeneratePersonInstanceMaskRequest` | `InstanceMaskObservation` | Per-person masks (iOS 17+) |
| `DetectDocumentSegmentationRequest` | `RectangleObservation` | Document boundaries |

### Image Quality & Aesthetics
| Request | Observation | Notes |
|---|---|---|
| `CalculateImageAestheticsScoresRequest` | `ImageAestheticsObservation` | Aesthetic score + utility detection |
| `DetectCameraLensSmudgeRequest` *(iOS 26)* | `CameraLensSmudgeObservation` | Smudged lens detection |

### Object Detection & Tracking
| Request | Observation | Notes |
|---|---|---|
| `DetectRectanglesRequest` | `RectangleObservation` | Quadrilateral detection |
| `DetectContoursRequest` | `ContoursObservation` | Edge/contour detection |
| `TrackRectangleRequest` | `RectangleObservation` | Track across video frames |
| `TrackObjectRequest` | `DetectedObjectObservation` | Generic object tracking |
| `TrackTranslationalImageRegistrationRequest` | `ImageTranslationAlignmentObservation` | Frame stabilization |
| `TrackHomographicImageRegistrationRequest` | `ImageHomographicAlignmentObservation` | Perspective-corrected alignment |

### Optical Flow
| Request | Observation | Notes |
|---|---|---|
| `TrackOpticalFlowRequest` | `OpticalFlowObservation` | Per-pixel motion vectors |

### Core ML Integration
| Request | Observation | Notes |
|---|---|---|
| `CoreMLRequest` | `ClassificationObservation` / `PixelBufferObservation` / `CoreMLFeatureValueObservation` | Wrap any `.mlmodel` |

### Horizon & Image Alignment
| Request | Observation | Notes |
|---|---|---|
| `DetectHorizonRequest` | `HorizonObservation` | Horizon angle |
| `TranslationalImageRegistrationRequest` | `ImageTranslationAlignmentObservation` | Align two images |
| `HomographicImageRegistrationRequest` | `ImageHomographicAlignmentObservation` | Perspective alignment |

---

## Image Sources

```swift
// From URL (async API)
let handler = ImageRequestHandler(url)

// From CGImage
let handler = ImageRequestHandler(cgImage: cgImage)

// From CIImage
let handler = ImageRequestHandler(ciImage: ciImage)

// From CVPixelBuffer (camera frames)
let handler = ImageRequestHandler(cvPixelBuffer: pixelBuffer,
                                   orientation: .right)

// Legacy VN API equivalents
VNImageRequestHandler(url: url, options: [:])
VNImageRequestHandler(cgImage: cgImage, options: [:])
```

---

## Live Camera Pipeline (AVFoundation + Vision)

```swift
// 1. Set up AVCaptureSession with a video output
class CameraProcessor: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    func captureOutput(_ output: AVCaptureOutput,
                       didOutput sampleBuffer: CMSampleBuffer,
                       from connection: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        
        // 2. Perform Vision request on each frame
        Task {
            let handler = ImageRequestHandler(cvPixelBuffer: pixelBuffer,
                                               orientation: .right) // adjust for device
            do {
                var request = DetectFaceRectanglesRequest()
                let faces = try await handler.perform(request)
                await updateUI(with: faces)
            } catch {
                print("Vision error: \(error)")
            }
        }
    }
}
```

**Performance tips for real-time:**
- Use `DetectFaceRectanglesRequest` before `DetectFaceLandmarksRequest` — run landmarks only on confirmed faces
- Drop frames if the previous request hasn't finished (use a flag)
- Target 30fps cap; Vision is fast but not always frame-synchronous

---

## Text Recognition Deep Dive

```swift
var request = RecognizeTextRequest()
request.recognitionLevel = .accurate          // vs .fast
request.usesLanguageCorrection = true
request.recognitionLanguages = [Locale(identifier: "en-US"),
                                 Locale(identifier: "id-ID")]

let handler = ImageRequestHandler(cgImage: cgImage)
let observations = try await handler.perform(request)

for obs in observations {
    let candidates = obs.topCandidates(3)       // confidence-ranked
    if let best = candidates.first {
        print(best.string)                       // recognized string
        print(best.confidence)                   // 0.0 – 1.0
        let box = obs.boundingBox                // normalized, flip for UIKit
    }
}
```

**Language support (iOS 18):** English, Chinese (Simplified/Traditional), French, Italian, German, Spanish, Portuguese, Japanese, Korean, Russian, Ukrainian, Thai, Vietnamese, Arabic, and more.

---

## Document Recognition (iOS 26 / WWDC25)

New `RecognizeDocumentsRequest` replaces manual table parsing with `RecognizeTextRequest`.

```swift
let request = RecognizeDocumentsRequest()
let handler = ImageRequestHandler(cgImage: cgImage)
let observations = try await handler.perform(request)

if let doc = observations.first {
    for table in doc.tables {
        for row in table.rows {
            for cell in row.cells {
                print(cell.text)
            }
        }
    }
    for paragraph in doc.paragraphs {
        print(paragraph.text)
    }
}
```

Use when: scanning tables, structured forms, receipts with line items, or any document where layout context matters.

---

## Body & Hand Pose

```swift
// Body pose — 19 joints
var bodyRequest = DetectHumanBodyPoseRequest()
let handler = ImageRequestHandler(cgImage: cgImage)
let poses = try await handler.perform(bodyRequest)

for pose in poses {
    let leftWrist = try pose.recognizedPoint(.leftWrist)
    let rightElbow = try pose.recognizedPoint(.rightElbow)
    // Point has .location (normalized), .confidence
}

// Hand pose — 21 joints, up to 2 hands
var handRequest = DetectHumanHandPoseRequest()
handRequest.maximumHandCount = 2
let hands = try await handler.perform(handRequest)

for hand in hands {
    let indexTip = try hand.recognizedPoint(.indexTip)
}
```

**iOS 26 note:** Hand-pose model updated — improved accuracy, lower memory, lower latency. **Joints not backward compatible** — retrain any CreateML hand classifier.

---

## CoreML Integration

```swift
// Load model
let model = try MyCustomModel(configuration: MLModelConfiguration())
let visionModel = try VNCoreMLModel(for: model.model)

// New API wraps CoreML
var request = CoreMLRequest(model: visionModel)
let handler = ImageRequestHandler(cgImage: cgImage)
let results = try await handler.perform(request)

for result in results {
    if let classification = result as? ClassificationObservation {
        print("\(classification.identifier): \(classification.confidence)")
    }
}
```

---

## Compute Device Selection

```swift
// Check supported compute devices
let supportedDevices = try DetectFaceRectanglesRequest().supportedComputeDevices()
// Returns: [.neuralEngine, .cpu, .gpu] or subset

// Force CPU for debugging
var request = DetectFaceRectanglesRequest()
request.computeDevice = .cpu
```

⚠️ On Neural Engine devices (A12+), Apple removed CPU/GPU support for several requests. Always check `supportedComputeDevices()` rather than hardcoding.

---

## Common Patterns & Gotchas

### Coordinate Flip
Always flip Y when converting to UIKit/CoreGraphics. SwiftUI `GeometryReader` also needs flip.

### Orientation
Pass the correct `CGImagePropertyOrientation` to the handler, especially for camera output:
```swift
let exifOrientation = CGImagePropertyOrientation(rawValue: ...)
let handler = ImageRequestHandler(cgImage: cgImage, orientation: exifOrientation)
```

### Multiple Requests in One Pass
Batch requests on the same handler for efficiency — the image is decoded once:
```swift
let (faces, text) = try await handler.perform(faceRequest, textRequest)
```

### Confidence Thresholding
Always filter by `.confidence` — Vision returns observations even at low confidence:
```swift
let reliableFaces = observations.filter { $0.confidence > 0.85 }
```

### Error Types
```swift
do {
    let results = try await handler.perform(request)
} catch let error as VNError {
    switch error.code {
    case .requestCancelled: break
    case .invalidImage: break
    default: print(error.localizedDescription)
    }
}
```

---

## Platform Availability

| Feature | iOS | macOS | tvOS | visionOS |
|---|---|---|---|---|
| Face detection | 11+ | 10.13+ | 11+ | 1+ |
| Text recognition | 13+ | 10.15+ | 13+ | 1+ |
| Body pose | 14+ | 11+ | 14+ | 1+ |
| Hand pose | 14+ | 11+ | — | 1+ |
| 3D body pose | 17+ | 14+ | — | 1+ |
| Person segmentation | 15+ | 12+ | 15+ | 1+ |
| New Swift API | 18+ | 15+ | 18+ | 2+ |
| RecognizeDocumentsRequest | 26+ | 26+ | — | 3+ |
| DetectCameraLensSmudgeRequest | 26+ | 26+ | — | 3+ |

---

## Related Frameworks

- **VisionKit** — Higher-level scanning UI (`DataScannerViewController`, `ImageAnalyzer`) — use when you want a pre-built camera UI
- **Core ML** — Custom model inference; plug into Vision via `VNCoreMLModel`
- **Create ML** — Train hand pose classifiers, object detection models
- **AVFoundation** — Camera capture pipeline for real-time Vision
- **RealityKit** — Combine Vision body pose results with AR anchors

---

## Reference Files

- `references/requests-catalog.md` — Full table of all 33 request types with signatures and observation properties
- `references/coordinate-system.md` — Detailed coordinate conversion examples for UIKit, SwiftUI, and ARKit

---

## Quick Decision Guide

| Use case | Recommended |
|---|---|
| Scan text from camera | `RecognizeTextRequest` + AVFoundation |
| Scan barcodes/QR | `DetectBarcodesRequest` or `DataScannerViewController` (VisionKit) |
| Detect faces in photo | `DetectFaceRectanglesRequest` |
| Face landmarks (eyes, mouth) | `DetectFaceLandmarksRequest` |
| Remove background | `GeneratePersonSegmentationRequest` |
| Parse table from photo | `RecognizeDocumentsRequest` (iOS 26+) or `RecognizeTextRequest` + spatial grouping |
| Real-time hand gesture | `DetectHumanHandPoseRequest` + CreateML classifier |
| Fitness app body tracking | `DetectHumanBodyPoseRequest` or `DetectHumanBodyPose3DRequest` |
| Custom object detection | `CoreMLRequest` with Create ML model |
| Image smart crop | `GenerateAttentionBasedSaliencyImageRequest` |
| Photo quality score | `CalculateImageAestheticsScoresRequest` |
