require 'yaml'
require 'tempfile'
require_relative 'document'

class Template
  attr_reader :path, :clauses, :sections

  # @param [String] path -> path of the template
  # @param [Array] clauses -> array of hashes
  # @param [Array] sections -> array of hashes
  def initialize(path, clauses, sections)
    @path = path
    @clauses = clauses
    @sections = sections
  end

  def generate_document
    template = read_template
    template = replace_clauses(template)
    template = replace_sections(template)
    # TODO: Check if any tag(clause or section) not replaced in the template as the
    # dataset doesn't have the clause_id or section_id
    temp_file = Tempfile.new
    temp_file.write(template)
    temp_file.close
    Document.new(temp_file.path.split('/').last, temp_file.path)
  end

  private

  def read_template
    # TODO: File too large to load in main memory
    File.read(path)
  end

  def replace_clauses(template)
    clauses.each do |clause|
      replace_pattern = "[CLAUSE-#{clause['id']}]"
      replacing_text = clause['text']
      template = template.gsub(replace_pattern, replacing_text)
    end
    template
  end

  def replace_sections(template)
    sections.each do |section|
      replace_pattern = "[SECTION-#{section['id']}]"
      section_clauses = clauses.select { |clause| section['clauses_ids'].include?(clause['id']) }
      replacing_text = section_clauses.map { |clause| clause['text'] }.join(';')
      template = template.gsub(replace_pattern, replacing_text)
    end
    template
  end
end

puts "Hurray!\n\nYou have just launched the T & C Generator.\nPlease enter the template path."
path = gets.chomp
if File.readable?(path)
  puts 'Enter the number of clauses'
  no_of_clauses = gets.chomp.to_i
  clauses = []
  sections = []
  no_of_clauses.times do |clause_id|
    puts "Enter the clause: #{clause_id + 1} with keys -> id and text"
    clause = gets.chomp
    clauses << YAML.load(clause)
  end
  puts 'Enter the number of sections'
  no_of_sections = gets.chomp.to_i
  no_of_sections.times do |sec_id|
    puts "Enter the section: #{sec_id + 1} with keys -> id and clauses_ids"
    section = gets.chomp
    sections << YAML.load(section)
  end
  document = Template.new(path, clauses, sections).generate_document
  puts "Below is the document generated for the given template\n"
  document.show
else
  puts 'Sorry, the path you entered is not readable.'
end
