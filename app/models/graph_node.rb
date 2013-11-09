module GraphNode
  def self.edge_column
    'id'
  end
  
  def random_edge(category)
    # THIS SQL IS CRAZY
    # it selects a random edge given the edge weights

    if category.is_a? Integer
      category_id = category
    else
      category_id = category.id
    end

    conditions = "#{self.class.edge_column} = #{id} AND category_id = #{category.id}"

    sql = %Q(
SET @edge_id = 0;
SET @weight_sum = (SELECT SUM(weight) FROM edges WHERE #{condition});
SET @rand = RAND();
SET @weight_point = ROUND(((@weight_sum - 1) * @rand + 1), 0);
SET @weight_pos = @weight_point;
SELECT t.edge_id FROM (
SELECT
    weight,
    @edge_id:=CASE
        WHEN @weight_pos < 0 THEN @edge_id
        ELSE edge_id
    END AS edge_id,
    (@weight_pos:=(@weight_pos - weight)) AS curr_weight,
    @weight_point,
    #@edge_id,
    @weight_pos,
    @rand,
    @weight_sum
FROM
    edges
WHERE #{conditions}

) AS t

WHERE
    t.curr_weight < 0
LIMIT
    1;)
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