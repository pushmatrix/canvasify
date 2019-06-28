require 'tmpdir'
require 'erb'
require 'mini_magick'


# Top left corner of where the artwork gets placed on the base texture
START_X = 158
START_Y = 128

# Size of the artwork when it's on the base texture
WIDTH = 1218
HEIGHT = 1778

# Size of each side that bleeds over the side of the canvas
SIDE_SIZE = 68 

# How many pixels to take from the sides to stretch around the side of the canvas
SIDE_STRETCH = 10

OUTPUT_DIR_NAME = 'outputs'


def path_for_sourcefile(name)
  File.join('assets', name)
end


# This is a helper to stretch part of the image to one of the sides on the canvas.
# It takes a small section of the artwork and stretches over the left, top, bottom, and right side.
def add_side_texture(base_image, image_to_crop, crop_area, new_size, position)
  side = MiniMagick::Image.open image_to_crop.path
  side.resize "#{WIDTH}x#{HEIGHT}!"
  side.crop crop_area
  side.resize new_size

  base_image.composite(side) do |c|
     c.compose "Multiply"
     c.geometry position
  end
end



ARGV.each do |path|
  img_to_apply = MiniMagick::Image.open(path)
  img_to_apply.resize "#{WIDTH}x#{HEIGHT}!"

  blank_template = MiniMagick::Image.open(File.join('assets', 'blank.jpg'))

  result = blank_template.composite(img_to_apply) do |c|
    c.compose "Multiply"
    c.geometry "+#{START_X}+#{START_Y}" 
  end

  # left
  result = add_side_texture(result, img_to_apply, "#{SIDE_STRETCH}x#{HEIGHT}+0+0", "#{SIDE_SIZE}x#{HEIGHT}!", "+#{START_X-SIDE_SIZE}+#{START_Y}")

  # right
  result = add_side_texture(result, img_to_apply, "#{SIDE_STRETCH}x#{HEIGHT}+#{WIDTH-SIDE_STRETCH}+0", "#{SIDE_SIZE}x#{HEIGHT}!", "+#{START_X+WIDTH}+#{START_Y}")

  # top 
  result = add_side_texture(result, img_to_apply, "#{WIDTH}x#{SIDE_STRETCH}+0+0", "#{WIDTH}x#{SIDE_SIZE}!", "+#{START_X}+#{START_Y-SIDE_SIZE}")

  # bottom
  result = add_side_texture(result, img_to_apply, "#{HEIGHT}x10+#{SIDE_SIZE}+#{HEIGHT - SIDE_STRETCH}", "#{WIDTH}x#{SIDE_SIZE}!", "+#{START_X}+#{START_Y + HEIGHT}" )


  Dir.mktmpdir do |tmp_dir|
    tmp_dir = "/Users/daniel/Desktop/temper"
    diffuse_path = File.join(tmp_dir, "diffuse.jpg")
    result.write(diffuse_path)

    usdz_name = File.basename(path, ".*") + ".usdz"

    # Creates output directories for usdz and glb
    Dir.mkdir(OUTPUT_DIR_NAME) unless File.exists?(OUTPUT_DIR_NAME)
    Dir.mkdir(File.join(OUTPUT_DIR_NAME, 'usdz')) unless File.exists?(File.join(OUTPUT_DIR_NAME, 'usdz'))
    Dir.mkdir(File.join(OUTPUT_DIR_NAME, 'glb')) unless File.exists?(File.join(OUTPUT_DIR_NAME, 'glb'))


    system("usdzconvert #{path_for_sourcefile('canvas.obj')} #{File.join(OUTPUT_DIR_NAME, 'usdz', usdz_name)} -m Canvas -diffuseColor #{diffuse_path} -normal #{path_for_sourcefile('normal.jpg')} -metallic #{path_for_sourcefile('metalness.jpg')} -roughness #{path_for_sourcefile('roughness.jpg')}")
    system("obj2gltf -i #{path_for_sourcefile('canvas.obj')} -o #{File.join(OUTPUT_DIR_NAME, 'glb', File.basename(path, ".*") + ".glb")} --baseColorTexture=#{diffuse_path} --normalTexture=#{path_for_sourcefile('normal.jpg')} --metallicRoughnessOcclusionTexture #{path_for_sourcefile('metalRoughnessOcclusion.jpg')}")
  end

end