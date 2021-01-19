# frozen_string_literal: true

require 'find' 
require 'fileutils'
require 'tmpdir'
require "json"

import 'Base/Helpers/BaseHelper.rb'

class AssetsCatalogHelper < BaseHelper
	def initialize(options = {})
    	super
	end
	  
	def organizeResourcesToAssetsCatalog(options)
		addResourcesImagesToAssetsCatalog(options)
		updateAssetsCatalog(options)
	end
	
	def addResourcesImagesToAssetsCatalog(options)
		pp 'Adding images from `Resources` folder to Assets catalog ...'

		assetsCatalog = options[:assets_catalog]
		path = options[:path]
		assetsCatalogPath = "#{path}/#{assetsCatalog}"

		# Create asset catalog file if doesnt exists
		if File.directory?("#{assetsCatalogPath}") == false
			Dir.mkdir("#{assetsCatalogPath}")
		end

		# Fetch all the png files from the project folder
		Dir.glob("#{path}/Resources/*.png").each do |asset|

			assetName = File.basename(asset,'.*')
			fileName = assetName
			if assetName.include? "@" or assetName.include? "~"
				fileName = assetName.split(/[\s@~]/).first
				imageSetName = "#{fileName}.imageset"
			else	
				imageSetName = "#{assetName}.imageset"
			end

			imageSetPath = "#{assetsCatalogPath}/#{imageSetName}"

			#If directory doesnt exists, create new ImageSet directory which holds images
			if File.directory?("#{imageSetPath}") == false
				Dir.mkdir(imageSetPath)
			end

			FileUtils.mv("#{asset}", "#{imageSetPath}/#{assetName}.png")
			
			#Create Json File which needs to be present for every ImageSet
			createJsonfile(
				file_name: fileName,
				path: "#{imageSetPath}/Contents.json",
				platform: options[:platform]
			)
		end
	end
	
	def updateAssetsCatalog(options) 
		pp 'Cleaning unused assets placeholders ...'

		assetsCatalog = options[:assets_catalog]
		path = options[:path]
		platform = options[:platform]

		assetsCatalogPath = "#{path}/#{assetsCatalog}"

		files = Dir["#{assetsCatalogPath}/**/Contents.json"]

		files.each do |file_name|
			file = File.read(file_name)
			parsed = JSON.parse(file)	

			if parsed.keys.include?("images")
				images = parsed["images"]
				file_path = File.dirname(file_name)

				generateUniversalImagesIfNeeded(images, file_path, "universal")
				generateIphoneImagesByIdiomIfNeeded(images, file_path, "iphone") if platform == "ios"
				generateIpadImagesByIdiomIfNeeded(images, file_path, "ipad") if platform == "ios"
				generateAppleTvImagesByIdiomIfNeeded(images, file_path, "tv") if platform == "tvos"

				images.each do |image|
					if fileExists("#{file_path}/#{image["filename"]}") == false
						image.delete("filename")
					end
				end
			end

			File.open("#{file_name}","w") do |f|
				f.write(JSON.pretty_generate(parsed))
			end
		end
	end

	def fileExists(path)
		File.exists?("#{path}")
	end 

	def getAvailableScales(images, file_path, idiom)
		images.map { |image| image["scale"] if image["idiom"] == idiom && fileExists("#{file_path}/#{image["filename"]}") }.compact
	end

	def getFilteredImages(images, idiom)
		images.map { |image| image if image["idiom"] == idiom }.compact
	end

	def generateUniversalImagesIfNeeded(images, file_path, idiom)
		availableScales = getAvailableScales(images, file_path, idiom)
		filteredImages = images.map { |image| image if image["idiom"] == idiom }.compact
		generateUniversalImages(filteredImages, file_path) if availableScales.length == 1 && availableScales.first == "3x"
	end

	def generateIphoneImagesByIdiomIfNeeded(images, file_path, idiom)
		availableScales = getAvailableScales(images, file_path, idiom)
		filteredImages = getFilteredImages(images, idiom)
		generateIphoneImages(filteredImages, file_path) if availableScales.length == 1 && availableScales.first == "3x"
	end

	def selectImageFileName(images, scale)
		images.select { |image| image["scale"] == scale }.first["filename"]
	end

	def getImageWidth(path)
		sh("sips -g pixelWidth #{path} | tail -n1 | cut -d' ' -f4").to_i
	end

	def generateImage(src, width, saveTo)
		sh("sips -Z #{width} #{src} --out #{saveTo}")
	end

	def generateIpadImagesByIdiomIfNeeded(images, file_path, idiom)
		availableScales = getAvailableScales(images, file_path, idiom)
		filteredImages = getFilteredImages(images, idiom)
		generateIpadImages(filteredImages, file_path) if availableScales.length == 1 && availableScales.first == "2x"
	end

	def generateAppleTvImagesByIdiomIfNeeded(images, file_path, idiom)
		availableScales = getAvailableScales(images, file_path, idiom)
		filteredImages = getFilteredImages(images, idiom)
		generateAppleTvImages(filteredImages, file_path) if availableScales.length == 1 && availableScales.first == "2x"
	end

	def generateUniversalImages(images, file_path)
		pp 'Generate missing universal images for x1 and x2 from provided x3'
		x3_filename = selectImageFileName(images, "3x")
		x2_filename = selectImageFileName(images, "2x")
		x1_filename = selectImageFileName(images, "1x")

		src = "#{file_path}/#{x3_filename}"
		width = getImageWidth(src)
		generateImage(src, width/3*2, "#{file_path}/#{x2_filename}")
		generateImage(src, width/3, "#{file_path}/#{x1_filename}")
	end

	def generateIphoneImages(images, file_path)
		pp 'Generate missing iPhone images for 1x and 2x from provided 3x'
		x3_filename = selectImageFileName(images, "3x")
		x2_filename = selectImageFileName(images, "2x")
		x1_filename = selectImageFileName(images, "1x")

		src = "#{file_path}/#{x3_filename}"
		width = getImageWidth(src)
		generateImage(src, width/3*2, "#{file_path}/#{x2_filename}")
		generateImage(src, width/3, "#{file_path}/#{x1_filename}")
	end

	def generateIpadImages(images, file_path)
		pp 'Generate missing ipad image for 1x from provided 2x'
		x2_filename = selectImageFileName(images, "2x")
		x1_filename = selectImageFileName(images, "1x")

		x2_imageWidth = getImageWidth("#{file_path}/#{x2_filename}")
		sh("sips -Z #{x2_imageWidth/2} #{file_path}/#{x2_filename} --out #{file_path}/#{x1_filename}")

		src = "#{file_path}/#{x2_filename}"
		width = getImageWidth(src)
		generateImage(src, width/2, "#{file_path}/#{x1_filename}")
	end

	def generateAppleTvImages(images, file_path)
		pp 'Generate missing AppleTV image for 1x from provided 2x'
		x2_filename = selectImageFileName(images, "2x")
		x1_filename = selectImageFileName(images, "1x")

		src = "#{file_path}/#{x2_filename}"
		width = getImageWidth(src)
		generateImage(src, width/2, "#{file_path}/#{x1_filename}")
	end

	def createJsonfile(options)
		fileName = options[:file_name]
		path = options[:path]
		platform = options[:platform]
		if platform == "tvos"
			content = contentForTvOS(options)
		else
			content = contentForIOS(options)
		end
		File.open(path, "w+") do |f|
			f.write(content)
		end
	end

	def contentForIOS(options)
		fileName = options[:file_name]

		'{
			"images" : [
				{
					"filename" : "'"#{ fileName}"'.png",
					"idiom" : "universal",
					"scale" : "1x"
				},
				{
					"filename" : "'"#{ fileName}"'@2x.png",
					"idiom" : "universal",
					"scale" : "2x"
				},
				{
					"filename" : "'"#{ fileName}"'@3x.png",
					"idiom" : "universal",
					"scale" : "3x"
				},
				{
					"filename" : "'"#{ fileName}"'~iphone.png",
					"idiom" : "iphone",
					"scale" : "1x"
				},
				{
					"filename" : "'"#{ fileName}"'@2x~iphone.png",
					"idiom" : "iphone",
					"scale" : "2x"
				},
				{
					"filename" : "'"#{ fileName}"'@3x~iphone.png",
					"idiom" : "iphone",
					"scale" : "3x"
				},
				{
					"filename" : "'"#{ fileName}"'~ipad.png",
					"idiom" : "ipad",
					"scale" : "1x"
				},
				{
					"filename" : "'"#{ fileName}"'@2x~ipad.png",
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

	def contentForTvOS(options)
		fileName = options[:file_name]

		'{
			"images" : [
				{
					"filename" : "'"#{ fileName}"'.png",
					"idiom" : "universal",
					"scale" : "1x"
				},
				{
					"filename" : "'"#{ fileName}"'@2x.png",
					"idiom" : "universal",
					"scale" : "2x"
				},
				{
					"filename" : "'"#{ fileName}"'@3x.png",
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
