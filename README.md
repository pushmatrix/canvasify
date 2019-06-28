# Canvasify 👩‍🎨

A small ruby script that creates 3D models of canvas art from flat 2D images.


## Requirements

1. Install obj2gltf (for converting to glb)

```
npm install -g obj2gltf
```

2. MiniMagick for image processing

```
bundle install
```

3. usdz tools from Apple: https://developer.apple.com/go/?id=python-usd-library (for converting to usdz)


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

### 1. The script loads a 3D model of a 24x30 canvas.

The 3D model is in .obj format. It comes with textures for:

base color: (the canvas material texture + wood)
metalness: specifies where things are metallic, like the staples on the canvas
roughness: how rough the model is in various parts. Ex: wood behaves differently than the canvas
normal: provides extra details like makes it look like the staples have volume to them


### 2. It applies the artwork onto the texture of it.

Here is the base texture:
<img src="https://user-images.githubusercontent.com/190692/60318034-6c459680-993f-11e9-890d-d7159d5a8a82.jpg" width="60%">

We then apply the artwork onto it:

<img src="https://user-images.githubusercontent.com/190692/60318037-710a4a80-993f-11e9-8702-65ed7a3d72eb.jpg" width="40%">

Notice how we stretch out the sides so they wrap around the sides of the canvas. We also perform a "multiply" of the artwork onto the base texture, so that the texturing in the canvas material appears through the artwork. It is more convincing.

### 3. It outputs a glb file and usdz of it.

GLB is used for many online 3D viewers, including Shopify's. It is also used on Android devices to view it in AR.
Note that Shopify expects only the glb to be uploaded. Shopify then converts it to usdz for iOS devices.


## Limitations

- Currently this only works for prints that are 18x24. The 3D model that is used to place the artwork on it is that size.
The script is also hardcoded to 2k textures.

- If you want to support different canvas types and sizes, you'll need to modify the script as well as get 3D models of different size canvases. You get get a 3D expert to make you models here: https://experts.shopify.com/services/visual-content-and-branding/create-3d-models-ar.

- This is a ruby script that calls out to shell scripts. It would be rad to have a gltf exporter right from within ruby. Alternatively, this could be converted to node. You would also be able to rewrite this in javascript so that you can do all this from a browser. That way someone could just drag a photo into the webpage, and a 3d model could be displayed / downloaded.
