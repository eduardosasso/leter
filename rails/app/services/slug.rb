class Slug
  def initialize(name)
    @name = name
  end

  # translate stuff like my_blog_post.md to my-blog-post/index.html
  # for pretty urls
  def to_s
    [folder, slug].reject(&:blank?).join('')
  end
  
  private

  def slug
    index = index_file? ? '.html' : '/index.html'
    basename.humanize.parameterize + index
  end

  def folder
    filename = File.basename(@name)
    @name.gsub(filename, '')
  end

  def basename
    File.basename(@name, '.*')
  end

  def index_file?
    basename == 'index'
  end
end
