class Document
  attr_reader :name, :path

  def initialize(name, path)
    @name = name
    @path = path
  end

  def show
    puts File.read(path)
  end
end
