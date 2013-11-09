module GraphNode
  include DynamicPagesHelper

  def self.edge_column
    'id'
  end
  
  def random_edge(category_id)
    # THIS SQL IS CRAZY
    # it selects a random edge given the edge weights

    conditions = "#{self.class.edge_column} = #{id} AND category_id = #{category_id}"

    random = rand * weight_sum(category_id)

    sql = %Q(
SELECT id
FROM (
    SELECT id,
           weight,
           SUM(weight) OVER (ORDER BY id ASC) AS running_total
    FROM edges
) t WHERE running_total > #{random} LIMIT 1)
    edge_id = User.connection.select_value(sql)
    Edge.find_by_id(edge_id)
  end

  def edge_count
    if category_id
      edges.where(category_id: category_id).count
    else
      edges.count
    end
  end

  def weight_sum(category_id)
    if category_id
      edges.where(category_id: category_id).sum(:weight)
    else
      edges.sum(:weight)
    end
  end

  def weight_average(category_id)
    if category_id
      edges.where(category_id: category_id).average(:weight)
    else
      edges.average(:weight)
    end
  end
end