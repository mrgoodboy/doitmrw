module DynamicPagesHelper
  def adjust_edge_weights(edges, like)

  end

  def next_content(category)
    Content.order("RANDOM()").first
  end
end
