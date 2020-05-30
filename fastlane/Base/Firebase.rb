
import "Base/Base.rb"

def firebase_add_configuration_file(configuration)
    base_folder = "#{project_path}/#{project_name}"

    filepath = "#{base_folder}/.firebase/#{configuration}/GoogleService-Info.plist"
    if File.exist? filepath
    FileUtils.cp(filepath, base_folder)
    File.delete(filepath)
    end
end