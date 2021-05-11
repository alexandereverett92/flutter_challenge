import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'images_event.dart';
part 'images_state.dart';

class ImagesBloc extends Bloc<ImagesEvent, ImagesState> {
  ImagesBloc() : super(ImagesLoading());

  @override
  Stream<ImagesState> mapEventToState(
    ImagesEvent event,
  ) async* {
    if (event is ImagesStart) {
      yield* _mapImagesStartToState(event, state);
    }

    if (event is ImagesNext) {
      yield* _mapImagesNextToState(event, state);
    }
  }

  Stream<ImagesState> _mapImagesStartToState(
    ImagesStart event,
    ImagesState state,
  ) async* {
    try {
      yield const ImagesLoaded();
    } on Exception {
      yield const ImagesLoaded();
    }
  }

  Stream<ImagesState> _mapImagesNextToState(
    ImagesNext event,
    ImagesState state,
  ) async* {
    try {
      yield const ImagesError();
    } on Exception {
      yield const ImagesError();
    }
  }
}
