require 'find' 
require 'fileutils'
require 'tmpdir'
require "json"

class AssetsCatalogHelper
	def organizeResourcesToAssetsCatalog(options)
		addResourcesImagesToAssetsCatalog(options)
		cleanupAssetsCatalog(options)
	end
	
	def addResourcesImagesToAssetsCatalog(options)
		puts 'Adding images from `Resources` folder to Assets catalog ...'

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
				path: "#{imageSetPath}/Contents.json"
			)
		end
	end
	
	def cleanupAssetsCatalog(options) 
		puts 'Cleaning unused assets placeholders ...'

		assetsCatalog = options[:assets_catalog]
		path = options[:path]
		assetsCatalogPath = "#{path}/#{assetsCatalog}"

		files = Dir["#{assetsCatalogPath}/**/Contents.json"]

		files.each do |file_name|
			file = File.read(file_name)
			parsed = JSON.parse(file)	

			if parsed.keys.include?("images")
				parsed["images"].each do |image|
					if File.exists?("#{File.dirname(file_name)}/#{image["filename"]}") == false
						image.delete("filename")
					end
				end
			end

			File.open("#{file_name}","w") do |f|
				f.write(JSON.pretty_generate(parsed))
			end
		end
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
