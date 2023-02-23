class Dog
    atrr_accessor :name, :breed, :id
    def initializer(name:, breed:, id: nill)
        @name = name
        @breed = breed
        @id = id
    end 
    def selt.create_table
        sql = <<. sql
        CREATE TABLE IF NOT EXIST dogs (
            id INTEGER PRIMARY KEY,
            name TEXT,
            breed TEXT
        )
        sql
        DB[:conn].execute(sql)
end
    def self.drop_table
        DB[:conn].execute("DROP TABLE IF EXISTS dogs")
    end
    def save()
        if self.id
            self.update
        else
            sql = <<.SQL
             INSERT INTO dogs
             (name, breed)
             VALUES
             (?,?)
             SQL
             DB [:conn].execute(sql, self.name, self.breed)

             self.id = DB[:conn].execute("SLECT last_insert_rowid()FROM dogs")[0][0]
        end
        self
    end
    def self.create(name:, breed:)
        dog = DOG.new(name: name, breed: breed)
        dog.save
    end
    def self.new_from_db(row)
        self.new(id: row[0], name: row[1], breed: row[2])
    end

    def self.all
        sql = <<-SQL
            SELECT *
            FROM
            dogs
        SQL
        DB[:conn].execute(sql).map do |row|
            self.new_from_db(row)
        end
    end

    def self.find_by_name(name)
        sql = <<-SQL 
            SELECT * 
            FROM dogs
            WHERE
            name = ?
            LIMIT 1
        SQL

        DB[:conn].execute(sql, name).map do |row|
            self.new_from_db(row)
        end.first
    end

    def self.find(id)
        sql = <<-SQL
          SELECT * 
          FROM dogs
          WHERE id = ?
          LIMIT 1
        SQL

        DB[:conn].execute(sql, id).map do |row|
          self.new_from_db(row)
        end.first
    end

    def self.find_or_create_by(name:, breed:)
        sql = <<-SQL
            SELECT *
            FROM dogs
            WHERE name = ?
            AND breed = ?
            LIMIT 1
        SQL

        row = DB[:conn].execute(sql, name, breed).first

        if row
            self.new_from_db(row)
        else
            self.create(name: name, breed: breed)
        end
    end

    def update
        sql = <<-SQL
          UPDATE dogs 
          SET 
            name = ?, 
            breed = ?  
          WHERE id = ?;
        SQL

        DB[:conn].execute(sql, self.name, self.breed, self.id)
    end
end
