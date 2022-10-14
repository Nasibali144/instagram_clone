import 'dart:io';

import 'package:equatable/equatable.dart';

class StorePostParams extends Equatable {
  final File image;
  final String caption;

  const StorePostParams({
    required this.image,
    required this.caption,
  });

  @override
  List<Object?> get props => [image, caption];
}