require_relative "../config/environment.rb"

class Student
  attr_accessor :name, :grade
  attr_reader :id

  def initialize(id=nil,name,grade)
    @name =name
    @grade =grade
    @id = id
  end

  def self.create_table
    new_table = <<-SQL
       CREATE TABLE IF NOT EXISTS students(
         id INTEGER PRIMARY KEY,
         name TEXT,
         grade INTEGER
       )
    SQL

    DB[:conn].execute(new_table)
  end

  def self.drop_table
    drop_table= <<-SQL
       DROP TABLE students;
    SQL

    DB[:conn].execute(drop_table)
  end

  def update
    update_data = <<-SQL
       UPDATE students SET name=? ,grade=?
       WHERE id= ?
    SQL

    DB[:conn].execute(update_data,self.name,self.grade,self.id)
  end

  def save
    if self.id
      self.update
    else
      save_data =<<-SQL
         INSERT INTO students (name,grade)
         VALUES (?,?)
      SQL
      DB[:conn].execute(save_data,self.name,self.grade)
      @id = DB[:conn].execute("SELECT id FROM students")[0][0]
    end
  end

  def self.create(name,grade)
    student =Student.new(name,grade)
    student.save
    student
  end

  def self.new_from_db(row)
    id =row[0]
    name=row[1]
    grade=row[2]
    self.new(id,name,grade)
  end

  def self.find_by_name(name)
    find_name =<<-SQL
      SELECT * FROM students
      WHERE name =?
    SQL

    DB[:conn].execute(find_name,name).map do |row|
      self.new_from_db(row)
    end.first

  end
  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]


end
