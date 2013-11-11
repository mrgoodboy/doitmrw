module DynamicPagesHelper
  #we want the database to have the function get_average(Content), returns the average weight of the content

  def check_edge(user_id, content_id)
    Edge.where(user_id: user_id, content_id: content_id).exists?
  end

  def next_content(category_id) #returns content of the next page
    #Content.order("RAND()").first
    if rand < 0.33
      new_content(category_id)
    else
      old_content(category_id)
    end
  end

  def new_content(category_id)
    if Content.only_new.count.zero?
      content = random_content(category_id)
    else
      content = Content.only_new.where(category_id: category_id).order('RANDOM()').first
      if check_edge(content.id,current_user.id)
        content = random_content(category_id)
      end
    end
    reset_edges
    content
  end

  def old_content(category_id)
    if (current_user.edges.count.zero?)
      return new_content(category_id)
    end
    edge1 = current_user.random_edge(category_id)

    if (edge1.nil?)
      # no content!
      return new_content(category_id)
    end

    content1 = edge1.content


    if (content1.edges.count < 2)
      return new_content(category_id)
    end
    edge2 = content1.random_edge(category_id)

    user2 = edge2.user

    if (user2.edges.count < 2)
      return new_content(category_id)
    end

    edge3 = user2.random_edge(category_id)
    
    content2 = edge3.content

    if check_edge(content2.id,current_user.id)
      return new_content(category_id)
    else
      session[:edges] = [edge1.id,edge2.id,edge3.id]
    end
    content2
  end

  def random_content(category_id)
    content = Content.where(category_id: category_id).order('RANDOM()').first
    reset_edges
    content
  end

  def adjust_edge_weights(like,category_id,edge4)
    if like == '1'
      adjust_like(category_id,edge4)
    else
      adjust_dislike(category_id,edge4)
    end
  end

  def decay(category_id, const)
    category_id = category_id
    sql = %Q(
            UPDATE edges
              SET weight = weight * #{const}
                WHERE user_id = #{current_user.id}
                AND category_id = #{category_id};
             )
    User.connection.execute(sql);
  end

  def adjust_like(category_id,edge4)
    ucc = 0.244
    avgc = 0.2
    k = 0.044
    avgc2 = 0.5
    k2 = 0.5
    if session[:edges]
      edge1, edge2, edge3 = Edge.find(session[:edges])
      Rollbar.report_message("Session[:edges] is set", 'info', edges: session[:edges])
      if (edge1 && edge2 && edge3)
        content = edge3.content

        decay_const = 0.975
        decay(category_id,decay_const)

        average = content.weight_average(category_id)

        edge1.weight = edge1.weight + ucc
        edge1.save

        edge2.weight = edge2.weight + ucc
        edge2.save

        edge3.weight = edge3.weight + avgc*average + k
        edge3.save

      else
        average = 1
      end
      edge4.weight = avgc2 * average + k2
      edge4.save
    else
      edge4.weight = 1
      edge4.save
    end
  end

  def adjust_dislike(category_id, edge4)
    if session[:edges]
      edge1, edge2, edge3 = Edge.find(session[:edges])
      if (edge1 && edge2 && edge3)
        content = edge3.content

        ucc = 0.3
        avgc = 0.1
        k = 0.4

        decay_const = 0.975
        decay(category_id,decay_const)

        average = content.weight_average(category_id)

        edge1.weight = edge1.weight - ucc
        if edge1.weight < 0
          edge1.weight = 0
        end
        edge1.save

        edge2.weight = edge2.weight - ucc
        if edge2.weight < 0
          edge2.weight = 0
        end
        edge2.save

        edge3.weight = edge3.weight + avgc*average - k
        if edge3.weight < 0
          edge3.weight = 0
        end
        edge3.save
      end
    end

    edge4.weight = 0
    edge4.save
    content2 = edge4.content
    if content2.new
      if content2.edges.where(weight: 0).count >= 2
        content2.new = false
        content2.save
      end
    end
  end
    
  def reset_edges
    session[:edges] = nil
  end
end

 
