// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gelato_flutter_challenge/blocs/images/images_bloc.dart';
import 'package:gelato_flutter_challenge/test_keys.dart';
import 'package:gelato_flutter_challenge/ui/pages/image_list_page/image_list_page_presentation.dart';

void main() {
  testWidgets(
      'ImageListPagePresentation - Error message displayed in error state',
      (WidgetTester tester) async {
    const String errorText = 'Error has happened';

    await tester.pumpWidget(
      MaterialApp(
        home: ImageListPagePresentation(
          state: const ImagesState(
            status: ImagesStatus.Error,
            errorText: errorText,
          ),
          scrollController: ScrollController(),
          crossAxisCount: 3,
          loadImages: () {},
        ),
      ),
    );
    final Finder errorFinder =
        find.text(errorText + ' Please tap here to try again.');

    final Finder loadingSpinnerFinder = find.byKey(loadingSpinnerKey);

    expect(errorFinder, findsOneWidget,
        reason: 'Should display $errorText Please tap here to try again.');

    expect(
      loadingSpinnerFinder,
      findsNothing,
      reason: 'Should not show loading spinner.',
    );
  });

  testWidgets(
      'ImageListPagePresentation - Loading spinner displayed in loading state',
      (WidgetTester tester) async {
    const String errorText = 'Error has happened';

    await tester.pumpWidget(
      MaterialApp(
        home: ImageListPagePresentation(
          state: const ImagesState(
            status: ImagesStatus.Loading,
            errorText: errorText,
          ),
          scrollController: ScrollController(),
          crossAxisCount: 3,
          loadImages: () {},
        ),
      ),
    );
    final Finder errorFinder =
        find.text(errorText + ' Please tap here to try again.');

    final Finder loadingSpinnerFinder = find.byKey(loadingSpinnerKey);

    expect(
      errorFinder,
      findsNothing,
      reason: 'Should not display $errorText Please tap here to try again.',
    );

    expect(
      loadingSpinnerFinder,
      findsOneWidget,
      reason: 'Should show loading spinner.',
    );
  });

  testWidgets(
      'ImageListPagePresentation - No Loading spinner or error displayed in success state',
      (WidgetTester tester) async {
    const String errorText = 'Error has happened';

    await tester.pumpWidget(
      MaterialApp(
        home: ImageListPagePresentation(
          state: const ImagesState(
            status: ImagesStatus.Success,
            errorText: errorText,
          ),
          scrollController: ScrollController(),
          crossAxisCount: 3,
          loadImages: () {},
        ),
      ),
    );
    final Finder errorFinder =
        find.text(errorText + ' Please tap here to try again.');

    final Finder loadingSpinnerFinder = find.byKey(loadingSpinnerKey);

    expect(
      errorFinder,
      findsNothing,
      reason: 'Should not display $errorText Please tap here to try again.',
    );

    expect(
      loadingSpinnerFinder,
      findsNothing,
      reason: 'Should not show loading spinner.',
    );
  });
}
