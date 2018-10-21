require_relative "../config/environment.rb"

class Student
  attr_reader :id
  attr_accessor :name, :grade
  def initialize(name, grade, id = nil)
    @name = name
    @grade = grade
    @id = id
  end

  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
    id INTEGER PRIMARY KEY,
    name TEXT,
    grade TEXT);
    SQL
    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = 'DROP TABLE IF EXISTS students;'
    DB[:conn].execute(sql)
  end

  def self.create(name, grade)
    student = Student.new(name, grade)
    student.save
  end

  def self.new_from_db(row)
    s_id = row[0]
    s_name = row[1]
    s_grade = row[2]
    student = Student.new(s_name, s_grade, s_id)
  end

  def self.find_by_name(name)
    sql = 'SELECT * FROM students WHERE name = ?'
    db = DB[:conn].execute(sql, name)
    id = db[0][0]
    name = db[0][1]
    grade = db[0][2]
    student = Student.new(name, grade, id)
  end

  def save
    if self.id == nil
      sql = 'INSERT INTO students (name, grade) VALUES (?,?);'
      DB[:conn].execute(sql, self.name, self.grade)
      @id = DB[:conn].execute('SELECT last_insert_rowid() FROM students;')[0][0]
    else
      self.update
    end
  end

  def update
    updater = 'UPDATE students SET name = ?, grade = ? WHERE id = ?;'
    DB[:conn].execute(updater, self.name, self.grade, self.id)
  end



end
