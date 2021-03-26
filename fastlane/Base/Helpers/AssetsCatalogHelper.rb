# frozen_string_literal: true

require 'find'
require 'fileutils'
require 'tmpdir'
require 'json'

import 'Base/Helpers/BaseHelper.rb'

class AssetsCatalogHelper < BaseHelper
  def initialize(options = {})
    super
  end

  def organize_resources_to_assets_catalog(options)
    add_resources_images_to_assets_catalog(options)
    update_assets_catalog(options)
  end

  def add_resources_images_to_assets_catalog(options)
    pp 'Adding images from `Resources` folder to Assets catalog ...'

    assets_catalog = options[:assets_catalog]
    path = options[:path]
    assets_catalog_path = "#{path}/#{assets_catalog}"

    # Create asset catalog file if doesnt exists
    Dir.mkdir(assets_catalog_path.to_s) if File.directory?(assets_catalog_path.to_s) == false

    # Fetch all the png files from the project folder
    Dir.glob("#{path}/Resources/*.png").each do |asset|
      asset_name = File.basename(asset, '.*')
      file_name = asset_name
      if asset_name.include?('@') || asset_name.include?('~')
        file_name = asset_name.split(/[\s@~]/).first
        imageset_name = "#{file_name}.imageset"
      else
        imageset_name = "#{asset_name}.imageset"
      end

      imageset_path = "#{assets_catalog_path}/#{imageset_name}"

      # If directory doesnt exists, create new ImageSet directory which holds images
      Dir.mkdir(imageset_path) if File.directory?(imageset_path.to_s) == false

      FileUtils.mv(asset.to_s, "#{imageset_path}/#{asset_name}.png")

      # Create Json File which needs to be present for every ImageSet
      create_json_file(
        file_name: file_name,
        path: "#{imageset_path}/Contents.json",
        platform: options[:platform]
      )
    end
  end

  def update_assets_catalog(options)
    pp 'Cleaning unused assets placeholders ...'

    assets_catalog = options[:assets_catalog]
    path = options[:path]
    platform = options[:platform]

    assets_catalog_path = "#{path}/#{assets_catalog}"

    files = Dir["#{assets_catalog_path}/**/Contents.json"]

    files.each do |file_name|
      file = File.read(file_name)
      parsed = JSON.parse(file)

      if parsed.keys.include?('images')
        images = parsed['images']
        file_path = File.dirname(file_name)

        generate_universal_images_if_needed(images, file_path, 'universal')
        generate_iphone_images_by_idiom_if_needed(images, file_path, 'iphone') if platform == 'ios'
        generate_ipad_images_by_idiom_if_needed(images, file_path, 'ipad') if platform == 'ios'
        generate_apple_tv_images_by_idiom_if_needed(images, file_path, 'tv') if platform == 'tvos'

        images.each do |image|
          image.delete('filename') if file_exists("#{file_path}/#{image['filename']}") == false
        end
      end

      File.open(file_name.to_s, 'w') do |f|
        f.write(JSON.pretty_generate(parsed))
      end
    end
  end

  def file_exists(path)
    File.exist?(path.to_s)
  end

  def get_available_scales(images, file_path, idiom)
    images.map do |image|
      image['scale'] if image['idiom'] == idiom && file_exists("#{file_path}/#{image['filename']}")
    end.compact
  end

  def get_filtered_images(images, idiom)
    images.map { |image| image if image['idiom'] == idiom }.compact
  end

  def generate_universal_images_if_needed(images, file_path, idiom)
    available_scales = get_available_scales(images, file_path, idiom)
    filtered_images = images.map { |image| image if image['idiom'] == idiom }.compact
    if available_scales.length == 1 && available_scales.first == '3x'
      generate_universal_images(filtered_images,
                                file_path)
    end
  end

  def generate_iphone_images_by_idiom_if_needed(images, file_path, idiom)
    available_scales = get_available_scales(images, file_path, idiom)
    filtered_images = get_filtered_images(images, idiom)
    generate_iphone_images(filtered_images, file_path) if available_scales.length == 1 && available_scales.first == '3x'
  end

  def select_image_filename(images, scale)
    images.select { |image| image['scale'] == scale }.first['filename']
  end

  def get_image_width(path)
    sh("sips -g pixelWidth #{path} | tail -n1 | cut -d' ' -f4").to_i
  end

  def generate_image(src, width, save_to)
    sh("sips -Z #{width} #{src} --out #{save_to}")
  end

  def generate_ipad_images_by_idiom_if_needed(images, file_path, idiom)
    available_scales = get_available_scales(images, file_path, idiom)
    filtered_images = get_filtered_images(images, idiom)
    generate_ipad_images(filtered_images, file_path) if available_scales.length == 1 && available_scales.first == '2x'
  end

  def generate_apple_tv_images_by_idiom_if_needed(images, file_path, idiom)
    available_scales = get_available_scales(images, file_path, idiom)
    filtered_images = get_filtered_images(images, idiom)
    if available_scales.length == 1 && available_scales.first == '2x'
      generate_apple_tv_images(filtered_images,
                               file_path)
    end
  end

  def generate_universal_images(images, file_path)
    pp 'Generate missing universal images for x1 and x2 from provided x3'
    x3_filename = select_image_filename(images, '3x')
    x2_filename = select_image_filename(images, '2x')
    x1_filename = select_image_filename(images, '1x')

    src = "#{file_path}/#{x3_filename}"
    width = get_image_width(src)
    generate_image(src, width / 3 * 2, "#{file_path}/#{x2_filename}")
    generate_image(src, width / 3, "#{file_path}/#{x1_filename}")
  end

  def generate_iphone_images(images, file_path)
    pp 'Generate missing iPhone images for 1x and 2x from provided 3x'
    x3_filename = select_image_filename(images, '3x')
    x2_filename = select_image_filename(images, '2x')
    x1_filename = select_image_filename(images, '1x')

    src = "#{file_path}/#{x3_filename}"
    width = get_image_width(src)
    generate_image(src, width / 3 * 2, "#{file_path}/#{x2_filename}")
    generate_image(src, width / 3, "#{file_path}/#{x1_filename}")
  end

  def generate_ipad_images(images, file_path)
    pp 'Generate missing ipad image for 1x from provided 2x'
    x2_filename = select_image_filename(images, '2x')
    x1_filename = select_image_filename(images, '1x')

    x2_image_width = get_image_width("#{file_path}/#{x2_filename}")
    sh("sips -Z #{x2_image_width / 2} #{file_path}/#{x2_filename} --out #{file_path}/#{x1_filename}")

    src = "#{file_path}/#{x2_filename}"
    width = get_image_width(src)
    generate_image(src, width / 2, "#{file_path}/#{x1_filename}")
  end

  def generate_apple_tv_images(images, file_path)
    pp 'Generate missing AppleTV image for 1x from provided 2x'
    x2_filename = select_image_filename(images, '2x')
    x1_filename = select_image_filename(images, '1x')

    src = "#{file_path}/#{x2_filename}"
    width = get_image_width(src)
    generate_image(src, width / 2, "#{file_path}/#{x1_filename}")
  end

  def create_json_file(options)
    file_name = options[:file_name]
    path = options[:path]
    platform = options[:platform]
    content = if platform == 'tvos'
                content_for_tvos(options)
              else
                content_for_ios(options)
              end
    File.open(path, 'w+') do |f|
      f.write(content)
    end
  end

  def content_for_ios(options)
    file_name = options[:file_name]

    '{
			"images" : [
				{
					"filename" : "'"#{file_name}"'.png",
					"idiom" : "universal",
					"scale" : "1x"
				},
				{
					"filename" : "'"#{file_name}"'@2x.png",
					"idiom" : "universal",
					"scale" : "2x"
				},
				{
					"filename" : "'"#{file_name}"'@3x.png",
					"idiom" : "universal",
					"scale" : "3x"
				},
				{
					"filename" : "'"#{file_name}"'~iphone.png",
					"idiom" : "iphone",
					"scale" : "1x"
				},
				{
					"filename" : "'"#{file_name}"'@2x~iphone.png",
					"idiom" : "iphone",
					"scale" : "2x"
				},
				{
					"filename" : "'"#{file_name}"'@3x~iphone.png",
					"idiom" : "iphone",
					"scale" : "3x"
				},
				{
					"filename" : "'"#{file_name}"'~ipad.png",
					"idiom" : "ipad",
					"scale" : "1x"
				},
				{
					"filename" : "'"#{file_name}"'@2x~ipad.png",
					"idiom" : "ipad",
					"scale" : "2x"
				}
			],
				"info" : {
				"author" : "xcode",
				"version" : 1
			}
		}'
  end

  def content_for_tvos(options)
    file_name = options[:file_name]

    '{
			"images" : [
				{
					"filename" : "'"#{file_name}"'.png",
					"idiom" : "universal",
					"scale" : "1x"
				},
				{
					"filename" : "'"#{file_name}"'@2x.png",
					"idiom" : "universal",
					"scale" : "2x"
				},
				{
					"filename" : "'"#{file_name}"'@3x.png",
					"idiom" : "universal",
					"scale" : "3x"
				}
			],
				"info" : {
				"author" : "xcode",
				"version" : 1
			}
		}'
  end
end
