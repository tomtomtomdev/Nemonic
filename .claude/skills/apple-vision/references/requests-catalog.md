# Vision Framework — Complete Requests Catalog (iOS 26 / WWDC25)

33 built-in request types as of WWDC25. All run on-device.

---

## Face & Person Detection

### `DetectFaceRectanglesRequest`
- **Result:** `[FaceObservation]`
- **Key properties:** `.boundingBox`, `.confidence`
- **Use:** Fast face presence detection; run before landmarks for performance

### `DetectFaceLandmarksRequest`
- **Result:** `[FaceObservation]`
- **Key properties:** `.landmarks` (eyes, nose, mouth, chin contours as `VNFaceLandmarkRegion2D`)
- **Use:** Filters, AR face masks, liveness detection

### `DetectFaceCaptureQualityRequest`
- **Result:** `[FaceObservation]`
- **Key properties:** `.faceCaptureQuality` (Float 0–1)
- **Use:** Select best frame in burst, profile photo validation

### `DetectHumanRectanglesRequest`
- **Result:** `[HumanObservation]`
- **Key properties:** `.boundingBox`, `.upperBodyOnly`
- **Note:** `upperBodyOnly = true` for desk/webcam scenarios

### `RecognizeAnimalsRequest`
- **Result:** `[RecognizedObjectObservation]`
- **Key properties:** `.labels` (dog, cat with confidence)
- **Supports:** Dogs and cats

---

## Text & Document

### `RecognizeTextRequest`
- **Result:** `[RecognizedTextObservation]`
- **Key properties:** `.topCandidates(n)` → `[RecognizedText]` with `.string`, `.confidence`, `.boundingBox(for:)`
- **Config:** `.recognitionLevel` (.accurate / .fast), `.recognitionLanguages`, `.usesLanguageCorrection`, `.customWords`
- **Languages (iOS 18):** 18+ including EN, ZH, JA, KO, AR, HI, TH, VI, and European languages
- **Use:** OCR for documents, receipts, screenshots, camera feeds

### `DetectTextRectanglesRequest`
- **Result:** `[TextObservation]`
- **Key properties:** `.boundingBox`, `.characterBoxes` (optional per-char bounding boxes)
- **Use:** Detect text presence/location without reading content; faster than `RecognizeTextRequest`
- **Config:** `reportCharacterBoxes = true`

### `RecognizeDocumentsRequest` *(iOS 26 / WWDC25 — NEW)*
- **Result:** `[DocumentObservation]`
- **Key properties:**
  - `.tables` → `[DocumentObservation.Container.Table]` → `.rows` → `.cells` → `.text`
  - `.paragraphs` → `[DocumentObservation.Container.Paragraph]`
  - `.lists` → `[DocumentObservation.Container.List]`
- **Use:** Structured document parsing — tables, forms, receipts with layout context

---

## Barcodes & Symbols

### `DetectBarcodesRequest`
- **Result:** `[BarcodeObservation]`
- **Key properties:** `.payloadString`, `.symbology`, `.boundingBox`, `.corners`
- **Symbologies:** QR, Aztec, EAN-8, EAN-13, UPC-A, UPC-E, Code39, Code93, Code128, DataMatrix, PDF417, ITF, GS1DataBar
- **Config:** `.symbologies = [.qr, .ean13]` (limit for performance)

---

## Body & Pose Tracking

### `DetectHumanBodyPoseRequest`
- **Result:** `[HumanBodyPoseObservation]`
- **Joints (19):** nose, leftEye, rightEye, leftEar, rightEar, leftShoulder, rightShoulder, neck, leftElbow, rightElbow, leftWrist, rightWrist, leftHip, rightHip, root, leftKnee, rightKnee, leftAnkle, rightAnkle
- **Access:** `try observation.recognizedPoint(.leftWrist)` → `.location`, `.confidence`

### `DetectHumanBodyPose3DRequest` *(iOS 17+)*
- **Result:** `[HumanBodyPose3DObservation]`
- **Key properties:** `.recognizedPoint3D(.leftWrist)` → `simd_float4x4` transform
- **Use:** Fitness apps needing depth; works best with LiDAR devices

### `DetectHumanHandPoseRequest`
- **Result:** `[HandPoseObservation]`
- **Joints (21):** wrist + 4 per finger (tip, DIP, PIP, MCP) + thumb (tip, IP, MP, CMC)
- **Config:** `.maximumHandCount = 2`
- **iOS 26:** Updated model — improved accuracy, less memory, retrain CreateML classifiers
- **Use:** Gesture recognition, sign language, UI interaction without touch

### `DetectAnimalBodyPoseRequest` *(iOS 17+)*
- **Result:** `[AnimalBodyPoseObservation]`
- **Animals:** Dogs and cats
- **Key joints:** head, neck, leftFrontPaw, rightFrontPaw, leftBackPaw, rightBackPaw, tail

### `DetectTrajectoriesRequest`
- **Result:** `[TrajectoryObservation]`
- **Key properties:** `.detectedPoints`, `.projectedPoints`, `.equationCoefficients`
- **Use:** Ball tracking, sports analysis, object path prediction

---

## Image Analysis & Saliency

### `GenerateObjectnessBasedSaliencyImageRequest`
- **Result:** `[SaliencyImageObservation]`
- **Key properties:** `.salientObjects` (array of `RectangleObservation`), `.pixelBuffer` (heatmap)
- **Use:** Smart cropping, content-aware thumbnail generation

### `GenerateAttentionBasedSaliencyImageRequest`
- **Result:** `[SaliencyImageObservation]`
- **Key properties:** `.salientObjects`, `.pixelBuffer`
- **Use:** Human visual attention prediction; good for focal point detection

### `GeneratePersonSegmentationRequest`
- **Result:** `[PixelBufferObservation]`
- **Key properties:** `.pixelBuffer` (mask buffer, 0=background, 255=person)
- **Config:** `.qualityLevel` (.fast / .balanced / .accurate)
- **Use:** Background removal, green screen replacement

### `GeneratePersonInstanceMaskRequest` *(iOS 17+)*
- **Result:** `[InstanceMaskObservation]`
- **Key properties:** `.allInstances`, `.generateMaskedImage(ofInstances:from:croppedToInstancesExtent:)`
- **Use:** Multiple people, individual masking

### `DetectDocumentSegmentationRequest`
- **Result:** `[RectangleObservation]`
- **Key properties:** `.topLeft`, `.topRight`, `.bottomLeft`, `.bottomRight` (normalized)
- **Use:** Document scanning — detect and perspective-correct document corners

---

## Image Quality & Aesthetics

### `CalculateImageAestheticsScoresRequest` *(iOS 18+)*
- **Result:** `[ImageAestheticsObservation]`
- **Key properties:** `.overallScore` (Float), `.isUtility` (Bool — receipts, screenshots, etc.)
- **Use:** Photo library curation, camera shot selection

### `DetectCameraLensSmudgeRequest` *(iOS 26 / WWDC25 — NEW)*
- **Result:** `[CameraLensSmudgeObservation]`
- **Key properties:** `.hasSmudge` (Bool), `.smudgeRegions` ([RectangleObservation])
- **Use:** Warn users about dirty camera lens before taking important photos

---

## Object Detection & Geometry

### `DetectRectanglesRequest`
- **Result:** `[RectangleObservation]`
- **Config:** `.minimumAspectRatio`, `.maximumAspectRatio`, `.minimumSize`, `.maximumObservations`, `.quadratureTolerance`
- **Use:** Business card, document, whiteboard detection

### `DetectContoursRequest`
- **Result:** `[ContoursObservation]`
- **Key properties:** `.contourCount`, `.topLevelContours`, `.contour(at:)`
- **Config:** `.contrastAdjustment`, `.detectsDarkOnLight`
- **Use:** Shape recognition, edge-based segmentation

### `TrackRectangleRequest`
- **Result:** `[RectangleObservation]`
- **Input:** Requires existing `RectangleObservation` from previous frame as `inputObservation`
- **Use:** Track a detected rectangle across video frames

### `TrackObjectRequest`
- **Result:** `[DetectedObjectObservation]`
- **Input:** Requires seed observation from previous frame
- **Use:** Generic object tracking across frames

---

## Image Registration & Optical Flow

### `TranslationalImageRegistrationRequest`
- **Result:** `[ImageTranslationAlignmentObservation]`
- **Key properties:** `.alignmentTransform` (CGAffineTransform — translation only)
- **Use:** Stabilize video, stitch panoramas

### `HomographicImageRegistrationRequest`
- **Result:** `[ImageHomographicAlignmentObservation]`
- **Key properties:** `.warpTransform` (simd_float3x3)
- **Use:** Perspective-aware image alignment

### `TrackTranslationalImageRegistrationRequest`
- **Result:** `[ImageTranslationAlignmentObservation]`
- **Use:** Frame-to-frame translation tracking

### `TrackHomographicImageRegistrationRequest`
- **Result:** `[ImageHomographicAlignmentObservation]`
- **Use:** Frame-to-frame perspective tracking

### `TrackOpticalFlowRequest`
- **Result:** `[OpticalFlowObservation]`
- **Key properties:** `.pixelBuffer` (2-channel Float32 buffer with x,y motion vectors)
- **Use:** Motion estimation, video effects, scene understanding

---

## Horizon Detection

### `DetectHorizonRequest`
- **Result:** `[HorizonObservation]`
- **Key properties:** `.angle` (radians), `.transform()`, `.boundingBox`
- **Use:** Auto-rotate landscape photos, level detection

---

## Core ML Integration

### `CoreMLRequest`
- **Result:** `[ClassificationObservation]` | `[PixelBufferObservation]` | `[CoreMLFeatureValueObservation]`
- **Init:** `CoreMLRequest(model: VNCoreMLModel)` where model wraps any `.mlmodel`
- **Use:** Custom object detection, image classification, segmentation with trained models

---

## Observation Base Properties

All observations inherit from `VNObservation`:
- `.confidence` — Float 0–1
- `.boundingBox` — `CGRect` (normalized, origin bottom-left, may be `.zero` for non-spatial)
- `.timeRange` — For video observations

Spatial observations additionally provide:
- `.boundingBox` — Primary region
- Subclasses may add `.corners`, `.boundingBoxOnScreen(for:)`, `.toNormalizedRects()`, etc.
