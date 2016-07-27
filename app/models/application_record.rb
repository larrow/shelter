class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def union_to_sql(relations)
    fragments = ActiveRecord::Base.connection.unprepared_statement do
      relations.map do |rel|
        rel.reorder(nil).to_sql
      end
    end

    fragments.join("\nUNION\n")
  end
end
