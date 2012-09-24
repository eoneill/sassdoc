require 'fileutils'
require 'json'

module Sassdoc
  @docs = {}
  def self.parse(read)
    if File.exist? read
      if File.directory? read and Dir.chdir(read)
        # loop through each scss file in the directory
        Dir.glob('**/*.s[ac]ss').each do |f|
          self.parse_docs(f)
        end
      else
        self.parse_docs(read)
      end
    end
    return @docs
  end

  def self.init(read, options)
    pwd = FileUtils.pwd()
    json = self.parse(ARGV[0] || '.').to_json
    if options[:stdout]
      puts json
    else
      Dir.chdir(pwd)
      @json_filename = 'sassdoc.json'
      dir = options[:destination]
      FileUtils.mkdir_p dir
      json_file = File.join(dir, @json_filename)
      FileUtils.touch json_file
      File.open(json_file, "w") {|file| file.puts json}
      if options[:viewer]
        # copy over viewer files
        puts File.join(File.dirname(__FILE__), '..', 'viewer', '.')
        puts dir
        FileUtils.cp_r(File.join(File.dirname(__FILE__), '..', 'viewer', '.'), dir)
        settings = {}
        settings[:viewer] = options[:scm] if options[:scm]
        settings[:docs] = @json_filename
        settings = settings.to_json
        %w(index.html tmpl/view.tmpl).each do |src|
          src = File.join(dir, src)
          text = File.read(src)
          File.open(src, "w") {|file| file.puts text.gsub(/\{SASSDOC_TITLE\}/, options[:name]).gsub(/\{SASSDOC_SETTINGS\}/, settings)}
        end
      end
    end
  end

private
  def self.parse_doc(description)
    data = {}
    name_matcher = /^\$([a-zA-Z0-9\-\_]+)/
    type_matcher = /^\{([a-zA-Z0-9\|\*]+)\}/
    # get the name
    name = description.match(name_matcher)
    description = description.sub(name_matcher, '').lstrip
    data[:name] = name[0] if name
    # get the type
    type = description.match(type_matcher)
    description = description.sub(type_matcher, '').lstrip
    data[:type] = type[1] if type
    # if it had a name or a type, then set description as a child, otherwise it's the value
    if name or type
      data[:description] = description
    else
      data = description
    end
    data
  end

  def self.parse_block(block)
    data = {}
    tag_matcher = /^\@([a-zA-Z0-9]+)/
    tag = 'overview'
    block.each do |doc|
      tmp = doc.match(tag_matcher)
      if tmp
        # need to strip off the new tag
        tag = tmp[1]
        doc = self.parse_doc doc.sub(tag_matcher, '').strip
      end
      if data[tag]
        data[tag].push(doc)
      else
        data[tag] = [doc]
      end
    end
    if data and (data['function'] or data['mixin'])
      return {
        :method => (data['function'] || data['mixin'])[0],
        :data   => data
      }
    else
      if data and data['category']
        return data
      end
      return nil
    end
  end

  # self.parse
  def self.parse_docs(file)
    doc = false
    first_block = true
    doc_block = []
    linenum = nil
    ln = 0
    category = nil
    IO.foreach(file) do |block|
      ln = ln + 1
      # we're only interested in lines that are using Sass comments, so ignore the others
      if block.start_with? '//'
        doc = true
        linenum = ln unless linenum
        doc_block.push block.gsub(/^(\/)*/, '').strip
      else
        if doc
          tmp = self.parse_block(doc_block)
          if tmp
            if tmp['category']
              category = tmp['category'][0]
            else
              # store the source
              tmp[:data][:source] = file.to_s
              # store the line number
              tmp[:data][:linenum] = linenum
              # get the category
              cat = tmp[:data]['category'] || category || file.to_s.gsub(/\.s[ac]ss/,'').gsub('_','')
              tmp[:data]['category'] = cat unless tmp[:data]['category']
              # push it onto docs
              @docs[cat] = {} unless @docs[cat]
              @docs[cat][tmp[:method]] = tmp[:data]
            end
          end
          doc_block = []
        end
        linenum = nil
        doc = false
      end
    end
  end
end
