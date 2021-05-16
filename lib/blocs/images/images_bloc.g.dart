// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'images_bloc.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ImagesState _$ImagesStateFromJson(Map<String, dynamic> json) {
  return ImagesState(
    status: _$enumDecodeNullable(_$ImagesStatusEnumMap, json['status']),
    images: (json['images'] as List)
        ?.map((e) => e == null
            ? null
            : PicsumImageData.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    currentPage: json['currentPage'] as int,
    errorText: json['errorText'] as String,
  );
}

Map<String, dynamic> _$ImagesStateToJson(ImagesState instance) =>
    <String, dynamic>{
      'status': _$ImagesStatusEnumMap[instance.status],
      'images': instance.images?.map((e) => e?.toJson())?.toList(),
      'currentPage': instance.currentPage,
      'errorText': instance.errorText,
    };

T _$enumDecode<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    throw ArgumentError('A value must be provided. Supported values: '
        '${enumValues.values.join(', ')}');
  }

  final value = enumValues.entries
      .singleWhere((e) => e.value == source, orElse: () => null)
      ?.key;

  if (value == null && unknownValue == null) {
    throw ArgumentError('`$source` is not one of the supported values: '
        '${enumValues.values.join(', ')}');
  }
  return value ?? unknownValue;
}

T _$enumDecodeNullable<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<T>(enumValues, source, unknownValue: unknownValue);
}

const _$ImagesStatusEnumMap = {
  ImagesStatus.Loading: 'Loading',
  ImagesStatus.Error: 'Error',
  ImagesStatus.Success: 'Success',
};
