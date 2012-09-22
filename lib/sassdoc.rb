module Sassdoc
  @docs = {}
  def self.parse(read)
    if File.exist? read
      if File.directory? read and Dir.chdir(read)
        # loop through each scss file in the directory
        Dir.glob('**/_*.scss').each do |f|
          self.parse_docs(f)
        end
      else
        self.parse_docs(read)
      end
    end
    return @docs
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
              cat = tmp[:data]['category'] || category || file.to_s.gsub('.scss','').gsub('_','')
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
