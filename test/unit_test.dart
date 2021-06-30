import 'package:gelato_flutter_challenge/blocs/images/images_bloc.dart';
import 'package:gelato_flutter_challenge/ui/pages/image_list_page/image_list_page_service.dart';
import 'package:test/test.dart';

void main() {
  group('Image List Page - getAxisCountForScreenWidth', () {
    test('Can not get result lower than the minimum (3)', () {
      expect(
        ImageListPageService.getAxisCountForScreenWidth(0),
        ImageListPageService.minImagesPerRow,
        reason: 'Result was not the minimum value set',
      );
    });

    test('Three images per row for iphone 12 portrait', () {
      expect(
        ImageListPageService.getAxisCountForScreenWidth(428),
        3,
      );
    });

    test('Five images per row for iphone 12 landscape', () {
      expect(
        ImageListPageService.getAxisCountForScreenWidth(926),
        5,
      );
    });

    test('Five images per row for ipad air 4th Gen portrait', () {
      expect(
        ImageListPageService.getAxisCountForScreenWidth(820),
        5,
      );
    });

    test('Six images per row for ipad air 4th Gen landscape', () {
      expect(
        ImageListPageService.getAxisCountForScreenWidth(1180),
        6,
      );
    });
  });

  group('Image List Page - shouldLoadImages', () {
    test('Should not load when in a state other than success', () {
      expect(
        ImageListPageService.shouldLoadImages(
            const ScrollControllerData(),
            const ImagesState(
              status: ImagesStatus.Error,
            )),
        false,
        reason: 'Error state should not allow loading',
      );

      expect(
        ImageListPageService.shouldLoadImages(
            const ScrollControllerData(),
            const ImagesState(
              status: ImagesStatus.Loading,
            )),
        false,
        reason: 'Loading state should not allow loading',
      );

      expect(
        ImageListPageService.shouldLoadImages(
            const ScrollControllerData(),
            const ImagesState(
              status: null,
            )),
        false,
        reason: 'null state should not allow loading',
      );

      expect(
        ImageListPageService.shouldLoadImages(
            const ScrollControllerData(
              hasClients: true,
              maxScrollExtent: 100,
              viewportDimension: 100,
              offset: 200,
            ),
            const ImagesState(
              status: ImagesStatus.Success,
            )),
        true,
        reason: 'Loading should have been allowed in success state',
      );
    });

    test(
        'Should not load before scroll controller has attached to a scroll view',
        () {
      expect(
        ImageListPageService.shouldLoadImages(
            const ScrollControllerData(
              hasClients: false,
              maxScrollExtent: 100,
              viewportDimension: 100,
              offset: 200,
            ),
            const ImagesState(
              status: ImagesStatus.Success,
            )),
        false,
        reason: 'Should have prevented loading',
      );

      expect(
        ImageListPageService.shouldLoadImages(
            const ScrollControllerData(
              hasClients: true,
              maxScrollExtent: 100,
              viewportDimension: 100,
              offset: 200,
            ),
            const ImagesState(
              status: ImagesStatus.Success,
            )),
        true,
        reason: 'Should have allowed loading',
      );
    });

    test(
        'Only load when scroll is more than two viewports from the end of the scroll',
        () {
      expect(
        ImageListPageService.shouldLoadImages(
            const ScrollControllerData(
              hasClients: true,
              maxScrollExtent: 300,
              viewportDimension: 100,
              offset: 0,
            ),
            const ImagesState(
              status: ImagesStatus.Success,
            )),
        false,
        reason: 'Should have prevented loading',
      );

      expect(
        ImageListPageService.shouldLoadImages(
            const ScrollControllerData(
              hasClients: true,
              maxScrollExtent: 300,
              viewportDimension: 100,
              offset: 100,
            ),
            const ImagesState(
              status: ImagesStatus.Success,
            )),
        false,
        reason: 'Should have prevented loading',
      );

      expect(
        ImageListPageService.shouldLoadImages(
            const ScrollControllerData(
              hasClients: true,
              maxScrollExtent: 300,
              viewportDimension: 100,
              offset: 101,
            ),
            const ImagesState(
              status: ImagesStatus.Success,
            )),
        true,
        reason: 'Should allow loading',
      );

      expect(
        ImageListPageService.shouldLoadImages(
            const ScrollControllerData(
              hasClients: true,
              maxScrollExtent: 100,
              viewportDimension: 100,
              offset: 0,
            ),
            const ImagesState(
              status: ImagesStatus.Success,
            )),
        true,
        reason: 'Should allow loading in initial position',
      );
    });
  });
}
