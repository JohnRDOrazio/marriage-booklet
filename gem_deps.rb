require 'bundler'
require 'json'

    def add_to_dep(dep,top_level)
      exists = top_level.key?(dep.name.to_s)
      if !exists
        top_level.merge!(dep.name.to_s => dep.requirement.requirements.join.to_s)
      end  
    end


    deps = Bundler::Definition.build('Gemfile',nil,nil).
       dependencies.each_with_object(Hash.new { |h,k| h[k] = {} }) do |dep,obj| 
         dep.groups.each do |g|
           add_to_dep(dep,obj[g])
         end
    end

ruby_version = File.open(".ruby-version").readlines.map(&:chomp)[0]
deps.merge!("engines" => { :ruby => ruby_version.to_s })

File.write("gemfile.json", JSON.pretty_generate(deps)+"\n")
