#The Vergenizer™

![img_link](http://i.imgur.com/C9vBi2a.png)

This is a batch watermarking app that I started working on while I was still working as a reporter. I was convinced that we could be more nimble in the field if we could leave our laptops at home --- we just needed a good way to get photos off our cameras, watermarked, and on the site. 

#Running

If you'd like to try it out, just clone the source

`git clone https://github.com/jefflovejapan/vergenizer/git`

open `The Vergenizer™.xcodeproj`, plug in your phone, and build away. Tap the 'Add' button onscreen to start watermarking some photos.

#Status

Known issues with The Vergenizer™:

- Watermark sometimes appears on wrong side of image (ALAssetOrientation / UIImageOrientation yay)
- Memory management
- Autorotated version of VDetailViewController broken
- No iPad version