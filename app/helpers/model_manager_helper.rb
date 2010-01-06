module ModelManagerHelper
  def default_columns
    ["id", "created_at", "updated_at"]
  end

  def selected_columns(klass)
    klass.columns.find_all {|c| !default_columns.include?(c.name) }[0..2]
  end

  def human_name(klass)
    klass.to_s.underscore.humanize
  end

  def plural_human_name(klass)
    klass.to_s.underscore.humanize.pluralize
  end

  def index_path(klass)
    self.send("#{klass.to_s.underscore.pluralize}_path")
  end

  def new_path(klass)
    self.send("new_#{klass.to_s.underscore}_path")
  end

  def edit_path(current_object)
    self.send("edit_#{current_object.class.to_s.underscore}_path", current_object)
  end

  def object_path(current_object)
    self.send("#{current_object.class.to_s.underscore}_path", current_object)
  end

  def render_edit_column(form, column, object)
    case column.type
    when :integer, :decimal, :long, :string
      form.text_field(column.name)
    when :datetime
      form.datetime_select(column.name)
    when :date
      form.date_select(column.name)
    when :boolean
      form.select(column.name, [['true', true], ['false',false]])
    when :text
      form.text_area(column.name)
    when :binary
      "binary column"
    else
      column.type
    end
  end

  def render_column(column, object)
    value = object[column.name]

    case column.type
    when :integer
      if column.name =~ /(.*)_id$/
        link_to (value.nil? ? "" : value), :table => $1, :id => object[column.name]
      else
        value
      end
    when :datetime, :date
      value.to_formatted_s(:short)
    when :boolean, :text, :binary, :decimal, :long
      value
    when :text, :string
      truncate(value) unless value.nil?
    when :binary
      link_to "binary"
    else
      column.type
    end
  end
end