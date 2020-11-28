#  ImagePicker

## Mục đích
- Lấy ảnh từ thư viện trên thiết bị
- Chụp ảnh bằng camera

## Chỉnh sửa file info.plist

- Edit trong source code (file xml)

```
<key>NSCameraUsageDescription</key>
<string>My App cần truy cập máy ảnh của bạn. Ảnh của bạn sẽ không được chia sẻ khi chưa được phép của bạn.</string>
<key>NSMicrophoneUsageDescription</key>
<string>My App cần truy cập microphone của bạn. Microphone của bạn sẽ không được chia sẻ khi chưa được phép của bạn.</string>
<key>NSPhotoLibraryUsageDescription</key>
<string>My App cần truy cập thư viện của bạn. Ảnh của bạn sẽ không được chia sẻ khi chưa được phép của bạn.</string>
```
- Hoặc edit trong Properties List
<img src="images/Screen Shot 2020-11-28 at 10.34.46.png"/>

## Run

- Lưu ý khi sử dụng máy ảo simulator, sẽ không test được camera
