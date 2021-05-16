import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gelato_flutter_challenge/api/picsum_api.dart';
import 'package:gelato_flutter_challenge/hive_keys.dart';
import 'package:gelato_flutter_challenge/models/picsum_api_error.dart';
import 'package:gelato_flutter_challenge/models/picsum_image_data.dart';
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

import '../../models/picsum_image_data.dart';

part 'images_bloc.g.dart';
part 'images_event.dart';
part 'images_state.dart';

class ImagesBloc extends Bloc<ImagesEvent, ImagesState> {
  ImagesBloc() : super(const ImagesState());

  @override
  Stream<ImagesState> mapEventToState(
    ImagesEvent event,
  ) async* {
    if (event is ImagesStart) {
      yield* _mapImagesStartToState(event);
    }
    if (event is ImagesNext) {
      yield* _mapImagesNextToState(event, state);
    }
  }

  Stream<ImagesState> _mapImagesStartToState(
    ImagesStart event,
  ) async* {
    final Box<String> box = await Hive.openBox<String>(HiveKeys.box);

    final String fromStorage = box.get(HiveKeys.imagesState, defaultValue: '');

    if (fromStorage != null && fromStorage.isNotEmpty) {
      final Map<String, dynamic> json =
          jsonDecode(fromStorage) as Map<String, dynamic>;

      yield ImagesState.fromJson(json);
    }
  }

  Stream<ImagesState> _mapImagesNextToState(
    ImagesNext event,
    ImagesState state,
  ) async* {
    try {
      yield state.copyWith(
        status: ImagesStatus.Loading,
      );

      final int currentPage = state.currentPage + 1;

      final List<PicsumImageData> images =
          await PicsumApi.getPhotosList(page: currentPage);

      final ImagesState updatedState = state.copyWith(
        status: ImagesStatus.Success,
        images: <PicsumImageData>[
          ...state.images,
          ...images,
        ],
        currentPage: currentPage,
      );

      final Box<String> box = await Hive.openBox<String>(HiveKeys.box);

      box.put(HiveKeys.imagesState, jsonEncode(updatedState.toJson()));

      yield updatedState;
    } on PicsumApiError catch (error) {
      yield state.copyWith(
        status: ImagesStatus.Error,
        errorText: error.message,
      );
    } on SocketException {
      yield state.copyWith(
        status: ImagesStatus.Error,
        errorText: 'Could not reach the server.',
      );
    }
  }
}
