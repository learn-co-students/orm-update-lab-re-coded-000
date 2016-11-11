require_relative "../config/environment.rb"

class Student
attr_accessor :name ,:grade
attr_reader :id
def initialize(name,grade)
  @id=nil
  @name=name
  @grade=grade
end
def update
  sql = <<-SQL
    update  students set name=?, grade=?
  SQL
  DB[:conn].execute(sql, self.name, self.grade)
  @id=DB[:conn].execute("SELECT id FROM students desc limit 1")[0][0]
end

def self.find_by_name(name)
    DB[:conn].execute("SELECT * FROM students where name=?",name).map do |row|
      self.new_from_db(row)
    end.first
end
def self.new_from_db(row)
    # create a new Student object given a row from the database
    obj=Student.new(row[1],row[2])
    obj.save

    obj
	end
def self.create_table
   sql = <<-SQL
   CREATE TABLE IF NOT EXISTS students (
     id INTEGER PRIMARY KEY,
     name TEXT,
     grade TEXT
   )
   SQL

   DB[:conn].execute(sql)
 end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end
  def save
    if id==nil
      sql = <<-SQL
        INSERT INTO students (name, grade)
        VALUES (?, ?)
      SQL
    else
      sql = <<-SQL
        update  students set name=?, grade=?
      SQL
    end
      DB[:conn].execute(sql, self.name, self.grade)
      @id=DB[:conn].execute("SELECT id FROM students desc limit 1")[0][0]

  end
  def self.create(name,grade)
   obj=Student.new(name,grade)
   obj.save
   obj
 end

end
