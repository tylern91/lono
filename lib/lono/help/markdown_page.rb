require 'thor'

module Lono::Help
  # Override stdout as an @io object so we can grab the text written normally
  # outputted to the shell.
  class Shell < Thor::Shell::Basic
    def stdout
      @io ||= StringIO.new
    end
  end

  class MarkdownMaker
    def self.make_all(command_class)
      new(command_class).make_all
    end

    def initialize(command_class)
      @command_class = command_class
    end

    def make_all
      create_index

      @command_class.commands.keys.each do |command_name|
        page = MarkdownPage.new(@command_class, command_name)
        create_page(page)
        # if markdown.subcommand?
        #   puts "subcommand: #{command_name}"
        # else
        #   puts "regular: #{command_name}"
        #   puts "markdown.filename #{markdown.filename}"
        # end
      end
    end

    def create_page(markdown)
      puts "Creating #{markdown.path}..."
      FileUtils.mkdir_p(File.dirname(markdown.path))
      IO.write(markdown.path, markdown.doc)
    end

    def create_index
      page = MarkdownIndex.new(@command_class)
      FileUtils.mkdir_p(File.dirname(page.path))
      puts "Creating #{page.path}"
      IO.write(page.path, page.doc)
    end
  end

  class MarkdownIndex
    def initialize(command_class)
      @command_class = command_class
    end

    def path
      "docs/reference.md"
    end

    def command_list
      @command_class.commands.keys.sort.map.each do |command_name|
        page = MarkdownPage.new(@command_class, command_name)
        link = page.path.sub("docs/", "")
        # Example: [lono cfn]({% link _reference/lono-cfn.md %})
        "* [lono #{command_name}]({% link #{link} %})"
      end.join("\n")
    end

    def summary
      <<-EOL
Lono is a CloudFormation framework tool that helps you manage your templates. Lono handles the entire CloudFormation lifecycle. It starts with helping you develop your templates and helps you all the way to the infrastructure provisioning step.
EOL
    end

    def doc
      <<-EOL
---
title: Lono Reference
---
#{summary}
#{command_list}
EOL
    end
  end

  class MarkdownPage
    def initialize(command_class, command_name)
      @command_class = command_class
      @command_name = command_name
      @command = @command_class.commands[@command_name]
    end

    def cli_name
      "lono"
    end

    def path
      "docs/_reference/#{cli_name}-#{@command_name}.md"
    end

    def subcommand?
      @command_class.subcommands.include?(@command_name)
    end

    def usage
      banner = @command_class.send(:banner, @command) # banner is protected method
      invoking_command = File.basename($0) # could be rspec, etc
      banner.sub(invoking_command, cli_name)
    end

    # Use command's description as summary
    def summary
      @command.description
    end

    def options
      shell = Lono::Help::Shell.new
      @command_class.send(:class_options_help, shell, nil => @command.options.values)
      text = shell.stdout.string
      return "" if text.empty? # there are no options

      lines = text.split("\n")[1..-1] # remove first line wihth "Options: "
      lines.map! do |line|
        # remove 2 leading spaces
        line.sub(/^  /, '')
      end
      lines.join("\n")
    end

    # Use command's long description as many description
    def description
      text = @command.long_description
      return "" if text.nil? # empty description

      lines = text.split("\n")
      lines.map do |line|
        # In the CLI help, we use 2 spaces to designate commands
        # In Markdown we need 4 spaces.
        line.sub(/^  \b/, '    ')
      end.join("\n")
    end

    def subcommand_list
      return '' unless subcommand?

      @command_class.subcommand_classes[@command_name]
    end

    # require './lib/lono'
    # shell = Thor::Shell::Basic.new
    # Lono::CLI.help(shell, "generate") # works
    # Lono::CLI.help(shell, "cfn") # doesnt works

    # Lono::CLI.subcommand_classes["cfn"].help(shell, true) # works - subcommand top-level help
    # Lono::Cfn.help(shell, true) # same as above

    # # to get another level deep
    # Lono::Cfn.command_help(shell, "create") # works - help for each subcommand command help
    def doc
      puts "HI"
      shell = Lono::Help::Shell.new
      # puts @command_class.send(:class_options_help, shell, nil => @command.options.values)

      @subcommand_class = Lono::CLI.subcommand_classes[@command_name]
      @subcommand_class.help(shell, true)
      text = shell.stdout.string
      puts text
      return

      # @command_class.send(:subcommand_help, "cfn")

      <<-EOL
---
title: #{usage}
---

## Usage

    #{usage}

## Summary

#{summary}
#{options_doc}
#{desc_doc}
#{subcommand_list}
EOL
    end

    # handles blank options
    def options_doc
      return '' if options.empty?

      <<-EOL
## Options

```
#{options}
```
EOL
    end

    # handles blank description
    def desc_doc
      return '' if description.empty?

      <<-EOL
## Description

#{description}
EOL
    end

  end
end
