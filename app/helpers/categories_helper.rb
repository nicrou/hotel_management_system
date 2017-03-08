module CategoriesHelper
  def split_tags(tags)
    return tags.split(',')
  end

  def wrap_tags(tags)
    wrap_tags = ''
    tags.each do |tag|
      wrap_tags += '<label class="tag">' + tag + '</label>'
    end
    return wrap_tags
  end

  def create_categories_directory
    directory = File.join('public','files','categories')
    unless File.directory?(directory)
      FileUtils.mkdir_p(directory)
    end
  end

  def set_name(title)
    directory_name = title.squish.downcase.tr(" ", "_")
    directory = File.join('files', 'categories', directory_name)
    return directory
  end

  def create_directory(title)
    create_categories_directory

    directory_name = title.squish.downcase.tr(" ", "_")
    directory = File.join('public', 'files', 'categories', directory_name)

    unless File.directory?(directory)
      FileUtils.mkdir_p(directory)
    end
    return directory
  end
end
