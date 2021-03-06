module Lono::Configset::S3File
  class Build < Lono::AbstractBase
    include Lono::Utils::Rsync
    include Lono::Utils::Item::Zip

    def run
      Lono::Configset::S3File::Registry.items.each do |item|
        build(item)
      end
    end

    def build(item)
      copy_to_output(item)
      compress_output
    end

    def copy_to_output(item)
      src = "#{item.root}/lib/files/#{item.name}"
      dest = "#{Lono.config.output_path}/#{@blueprint}/configsets/#{item.configset}/files/#{item.name}"
      rsync(src, dest)
    end

    def compress_output
      Registry.items.each do |item|
        if item.exist?
          zip(item)
        else
          puts "WARN: #{item.src_path} does not exist. Double check that the path is correct in the s3_key call.".color(:yellow)
        end
      end
    end
  end
end
