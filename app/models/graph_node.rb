module GraphNode
  include DynamicPagesHelper

  def self.edge_column
    'id'
  end
  
  def random_edge(category_id)
    # THIS SQL IS CRAZY
    # it selects a random edge given the edge weights



    conditions = "#{self.class.edge_column} = #{id} AND category_id = #{category_id}"

    sql = %Q(
SELECT id, 
       date, 
       amount, 
       running_total
FROM (
    SELECT id,
           date,
           amount,
           SUM(amount) OVER (ORDER BY date ASC) AS running_total
    FROM transactions
) t)
    edge_id = User.connection.select_value(sql)
    Edge.find_by_id(edge_id)
  end

  def edge_count
    edges.count
  end

  def weight_sum
    edges.sum(:weight)
  end

  def weight_average
    edges.average(:weight)
  end
end