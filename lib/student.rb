require_relative "../config/environment.rb"

class Student
  attr_accessor :id, :name, :grade
  def initialize(name, grade, id = nil)
    @name = name
    @grade = grade
    @id = id
  end
def self.create_table
  sql = <<-SQL
  CREATE TABLE IF NOT EXISTS students(
    id INTEGER PRIMARY KEY,
    name TEXT,
    grade TEXT
  )
  SQL
  DB[:conn].execute(sql)
end
## drop table ###
def self.drop_table
  sql = <<-SQL
  DROP TABLE students
  SQL
  DB[:conn].execute(sql)
end
### save meth ###
def save
  if self.id then
    self.update
  else
  sql = <<-SQL
  INSERT INTO students (name, grade)
  VALUES (?, ?)
  SQL
  DB[:conn].execute(sql, self.name, self.grade)
  @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
  end
end
### create a ruby obj ###
def self.create(name, grade)
  student = self.new(name, grade)
  student.save
  student
end
### create new ruby obj from db ###
def self.new_from_db(row)
  new_student = self.new(row[1], row[2], row[0])
  new_student
end
### find an obj by its name ###
def self.find_by_name(name)
  sql = "SELECT * FROM students WHERE name = ?"
  result = DB[:conn].execute(sql, name)[0]
  new_from_db(result)
end
### update a db record ###
def update
  sql ="UPDATE students SET name = ?, grade = ? where id = ?"
  DB[:conn].execute(sql, self.name, self.grade, self.id)
end
end
