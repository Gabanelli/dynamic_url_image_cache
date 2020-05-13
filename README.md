# dynamic_url_image_cache

A image widget that caches the image with an ID, useful for images with dynamic urls, like S3 images.

## Usage

```dart
DynamicUrlImageCache(
  imageId: 'testIdImage124',
  imageUrl: 'https://picsum.photos/200/300',
  height: 300,
  width: 300,
),
```

## How it works

When the widget is rendered, it fetch a file that her name matches with the imageId, else it will get the image from web and download into the temporary folder. You can customize the loader, the error placeholder and can use an error callback.

PL are welcomed! :smile: