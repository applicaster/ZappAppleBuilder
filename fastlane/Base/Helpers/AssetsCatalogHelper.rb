require 'find' 
require 'fileutils'
require 'tmpdir'
require "json"

class AssetsCatalogHelper
	def moveResourceImagesToAssetsCatalog(options)
		addResourcesImagesToAssetCatalog(options)
		cleanupAssetsCatalog(options)
	end
	
	def addResourcesImagesToAssetsCatalog(options)
		puts 'Adding images from `Resources` folder to Assets catalog ...'

		assetsCatalog = options[:assets_catalog]
		path = options[:path]

		# Create asset catalog file if doesnt exists
		if File.directory?("#{assetsCatalog}") == false
			Dir.mkdir(assetsCatalog)
		end

		# Fetch all the png files from the project folder
		Dir.glob("#{path}/**/Resources/*.png").each do |asset|

			#Jump into asset catalog folder
			Dir.chdir(assetsCatalog)
			
			assetName = File.basename(asset,'.*')
			filename = assetName
			if assetName.include? "@" or assetName.include? "~"
				filename = assetName.split(/[\s@~]/).first
				imageSetName = "#{ filename }.imageset"
			else	
				imageSetName = "#{ assetName }.imageset"
			end

			#If directory doesnt exists, create new ImageSet directory which holds images
			if File.directory?("#{imageSetName}") == false
				Dir.mkdir(imageSetName)
			end

			#Jump into ImageSet directory
			Dir.chdir(imageSetName)
			FileUtils.mv("#{asset}", "#{assetName}.png")
			
			#Create Json File which needs to be present for every ImageSet
			createJsonfile(filename)
			
			#Jump back to parent directory
			Dir.chdir(projectFolderName) 
		end
	end
	
	def cleanupAssetsCatalog(options) 
		puts 'Cleaning unused assets placeholders ...'

		assetsCatalog = options[:assets_catalog]
		base_path = options[:path]

		files = Dir["#{path}/#{assetsCatalog}/**/Contents.json"]

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

	def createJsonfile(fileName)
		content = '{
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
		target  = "Contents.json"

		File.open(target, "w+") do |f|
			f.write(content)
		end
	end
end
