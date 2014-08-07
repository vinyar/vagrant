require 'json'

def loadConfig()

    config = {}
    config["override"] = {}
    config["override"]["servers"] = {}
    config["default"] = {}

    if File.exists?( File.expand_path "./config.json" )
        config["override"] = JSON.parse(File.read("config.json"))
    end

    if File.exists?( File.expand_path "./config.default.json" )
        config["default"] = JSON.parse(File.read("config.default.json"))
    end

    result = config["default"]

    config["override"]["servers"].each do |key, value|
        value.each do |server_key, server_value|
            result["servers"][key][server_key] = server_value
        end
    end

    config["override"].each do |key, value|
        if !key.eql?("servers")
            result[key] = value;
        end
    end

    if !result["provider"]
        result["provider"] = "virtualbox"
    end

    ENV["VAGRANT_DEFAULT_PROVIDER"] = result["provider"]

    # puts JSON.pretty_generate(result)
    # exit()

    return result

end
