import 'dart:io';
import 'dart:typed_data';


import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart';

import '../../../../Reusability/widgets/custom_snack_bar.dart';
import '../../crop_image/views/crop_image_view.dart';

class PhotoSelectController extends GetxController {
  RxBool isAlbumsLoading = true.obs;
  RxBool isPhotosLoading = false.obs;
  RxList<AssetPathEntity> albums = <AssetPathEntity>[].obs;
  RxList<AssetEntity> photos = <AssetEntity>[].obs;
  String? currentFolderName;
  RxInt selectedIndex = 0.obs;
  Rx<XFile> imagePath = XFile('').obs;
  Map<String, List<AssetEntity>> albumPhotos = {};
  var isPermissionDenied = false.obs;
  var isPermissionPermanentlyDenied = false.obs;

  // Define the image cache map
  var imageCache = <String, Uint8List>{}.obs;

  void handleError(String message, {String? details}) {
    debugPrint(message);
    if (details != null) {
      debugPrint(details);
    }
    CustomSnackBar.showCustomToast(
      toastType: ToastType.error,
      message: message,
    );
  }

  Future<void> pickImageFromCamera({required String filterName}) async {
    try {
      final ImagePicker picker = ImagePicker();
      final pickedFile = await picker.pickImage(
        source: ImageSource.camera,
        maxHeight: 700,
        maxWidth: 700,
      );

      if (pickedFile == null) {
        handleError('No image picked, please try again.');
        return;
      }

      final file = File(pickedFile.path);
      final fileSize = await file.length();

      if (fileSize > 10 * 1024 * 1024) {
        handleError('Image file size exceeds 10MB');
        return;
      }

      final bytes = await file.readAsBytes();
      img.Image? image = img.decodeImage(Uint8List.fromList(bytes));

      if (image == null || image.width < 300 || image.height < 300) {
        handleError('Invalid image');
        return;
      }

      Uint8List imageBytes = Uint8List.fromList(bytes);
      Get.to(
        () => CropImageView(
          filterTitle: filterName,
          cropImagePath: imageBytes,
        ),
        transition: Transition.noTransition,
        duration: Duration(milliseconds: 0),
      );
    } catch (e) {
      handleError('An error occurred while picking image from camera', details: e.toString());
    }
  }

  // Function to fetch full-resolution image and cache it.
  Future<void> cacheImage(AssetEntity asset) async {
    final imageBytes = await getFullResolutionImage(asset);
    if (imageBytes != null) {
      imageCache[asset.id] = imageBytes;
    }
  }

  // Fetch the full-resolution image for an asset and return it as Uint8List
  Future<Uint8List?> getFullResolutionImage(AssetEntity asset) async {
    try {
      final File? file = await asset.file;
      if (file == null) {
        return null;
      }

      final Uint8List imageBytes = await file.readAsBytes();
      return imageBytes;
    } catch (e) {
      return null;
    }
  }

  // Load albums from the device.
  Future<void> loadAlbums() async {
    try {
      isAlbumsLoading.value = true;
      final albumsAsset = await PhotoManager.getAssetPathList(type: RequestType.image);
      if (albumsAsset.isNotEmpty) {
        loadPhotosFromFolder(albumsAsset[0]);
      }

      albums.value = albumsAsset;
      selectedIndex.value = 0;
      isAlbumsLoading.value = false;
    } catch (e) {
      handleError('Error loading albums', details: e.toString());
      isAlbumsLoading.value = false;
    }
  }

  // Load photos from a specific album.
  Future<void> loadPhotosFromFolder(AssetPathEntity album) async {
    if (albumPhotos.containsKey(album.id)) {
      // If photos are already loaded for this album, use the cached photos.
      photos.value = albumPhotos[album.id]!;
      return;
    }

    isPhotosLoading.value = true;
    final List<AssetEntity> photosAsset = await album.getAssetListPaged(page: 0, size: 25);
    photos.value = photosAsset;

    // Cache the images
    for (var asset in photosAsset) {
      await cacheImage(asset);
    }

    albumPhotos[album.id] = photosAsset;
    currentFolderName = album.name;
    isPhotosLoading.value = false;
  }

  Future<void> checkPermissions() async {
    bool denied = await Permission.manageExternalStorage.isDenied;
    bool permanentlyDenied = await Permission.manageExternalStorage.isPermanentlyDenied;
    bool granted = await Permission.manageExternalStorage.isGranted;

    isPermissionDenied.value = denied;
    isPermissionPermanentlyDenied.value = permanentlyDenied;

    debugPrint("Permission granted: $granted, Denied: $denied, Permanently Denied: $permanentlyDenied");

    if (granted) {
      await loadAlbums();
    }
  }

  /// Opens the permission settings if permission is denied or permanently denied.
  Future<void> openPermissionSettings() async {
    bool hasPermission = await Permission.manageExternalStorage.isGranted;

    if (!hasPermission) {
      PermissionStatus status = await Permission.manageExternalStorage.request();

      debugPrint("Permission status: $status");

      if (status.isGranted) {
        debugPrint("Manage External Storage permission granted.");
        isPermissionDenied.value = false;
        isPermissionPermanentlyDenied.value = false;
        await loadAlbums();
      } else {
        debugPrint("Manage External Storage permission denied.");
        isPermissionDenied.value = true;
        isPermissionPermanentlyDenied.value = status.isPermanentlyDenied;
        if (status.isPermanentlyDenied) {
          debugPrint("Permission permanently denied. Opening app settings.");
          openAppSettings();
        }
      }
    } else {
      debugPrint("Manage External Storage permission already granted.");
      isPermissionDenied.value = false;
      isPermissionPermanentlyDenied.value = false;
      await loadAlbums();
    }
  }

  /// Converts a Uint8List to an XFile.
  Future<XFile> convertUint8ListToXFile(Uint8List data) async {
    final tempDir = await getTemporaryDirectory();
    final tempFile = File('${tempDir.path}/image_${DateTime.now().millisecondsSinceEpoch}.jpg');
    await tempFile.writeAsBytes(data);
    return XFile(tempFile.path);
  }
}
