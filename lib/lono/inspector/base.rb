class Lono::Inspector::Base
  def initialize(stack_name, options)
    @stack_name = stack_name
    @options = options
    @project_root = options[:project_root] || '.'
  end

  def generate_templates
    Lono::Template::DSL.new(@options.clone).run
  end

  def run
    generate_templates
    perform
  end

  def data
    return @data if @data
    template_path = "#{@project_root}/output/#{@stack_name}.yml"
    check_template_exists(template_path)
    @data = YAML.load(IO.read(template_path))
  end

  # Check if the template exists and print friendly error message.  Exits if it
  # does not exist.
  def check_template_exists(template_path)
    unless File.exist?(template_path)
      puts "The template #{template_path} does not exist. Are you sure you use the right template name?  The template name does not require the extension.".colorize(:red)
      exit 1
    end
  end

end