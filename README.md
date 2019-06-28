# Canvasify 👩‍🎨

A small ruby script that creates 3D models of canvas art from flat 2D images.


## Requirements

1. Install obj2gltf (for converting to glb)

```
npm install -g obj2gltf
```

2. MiniMagick for image processing

3. usdz tools from Apple: https://developer.apple.com/go/?id=python-usd-library (for converting to usdz)

```
bundle install
```

## Instructions

1. Go to the canvasify directory in terminal

```
cd /path/to/canvasify
```

2. Run the script and pass in the file path of the image you want to convert

```
ruby canvasify.rb /path/to/artwork.jpg
```

3. The usdz and glb models will appear in the outputs folder



## How it works

1. The script loads a 3D model of a 24x30 canvas.


2. It applies the artwork onto the texture of it.


3. It outputs a glb file and usdz of it.



## File types
GLB is used for many online 3D viewers, including Shopify's. It is also used on Android devices to view 



## Limitations

Currently this only works for prints that are 24x30. The 3D model that is used to place the artwork on it is that size.
The script is also hardcoded to 2k textures.

If you want to support different canvas types and sizes, you'll need to modify the script as well as get 3D models of different size canvas.