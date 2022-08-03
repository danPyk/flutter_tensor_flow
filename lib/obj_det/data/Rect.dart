// class Rect {
//   Rect({
//       required this.x,
//       required this.y,
//       required this.w,
//       required this.h,});
//
//   Rect.fromJson(dynamic json) {
//     x = json['x'] as double;
//     y = json['y']as double;
//     w = json['w']as double;
//     h = json['h']as double;
//   }
//   double x = 0.0;
//   double y= 0.0;
//   double w= 0.0;
//   double h= 0.0;
//
//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     map['x'] = x;
//     map['y'] = y;
//     map['w'] = w;
//     map['h'] = h;
//     return map;
//   }
//
// }