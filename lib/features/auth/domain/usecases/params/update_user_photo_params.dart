import 'dart:io';

import 'package:equatable/equatable.dart';

class UpdateUserPhotoParams extends Equatable {
  final File image;

  const UpdateUserPhotoParams({
    required this.image,
  });

  @override
  List<Object?> get props => [image];
}