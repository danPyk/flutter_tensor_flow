// import 'Rect.dart';
//
// class CapturedObject {
//   String detectedClass = '';
//   double confidenceInClass = 0.0;
//   Rect rect = Rect(x: 0.0, y: 0.0, w: 0.0, h: 0.0);
//
//   CapturedObject({
//     required this.detectedClass,
//     required this.confidenceInClass,
//     required this.rect,
//   });
//
//   CapturedObject.fromJson(dynamic json) {
//     detectedClass = json['detectedClass'] as String;
//     confidenceInClass = json['confidenceInClass'] as double;
//     rect = (json['rect'] != null ? Rect.fromJson(json['rect']) : null)!;
//   }
//
//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     map['detectedClass'] = detectedClass;
//     map['confidenceInClass'] = confidenceInClass;
//     if (rect != null) {
//       map['rect'] = rect.toJson();
//     }
//     return map;
//   }
// }
