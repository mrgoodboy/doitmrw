module DynamicPagesHelper
  #we want the database to have the function get_average(Content), returns the average weight of the content

  def check_edge(user_id, content_id)
    !!Edge.where(user_id: user_id, content_id: content_id)
  end

  def next_content(category_id) #returns content of the next page
    #Content.order("RAND()").first
    if rand < 0.2
      new_content(category_id)
    else
      old_content(category_id)
    end
  end

  def new_content(category_id)
    if Content.only_new.count.zero?
      content = random_content(category_id)
    else
      content = Content.only_new.order('RANDOM()').first
    end
    
    reset_edges
    content
  end

  def old_content(category_id)
    if (current_user.edges.count.zero?)
      return new_content(category_id)
    end
    edge1 = current_user.random_edge(category_id)

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
      session[:edges] = [edge1,edge2,edge3]
    end
    content2
  end

  def random_content(category_id)
    content = Content.order('RANDOM()').first
    reset_edges
    content
  end

  def adjust_edge_weights(like,category_id,edge4)
    if like
      adjust_like(category_id,edge4)
    else
      adjust_dislike(category_id,edge4)
    end
  end

  def decay_time(category_id, const)
    category_id = get_category_id(category_id)
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
    avgc2 = 0.5 #a bit of a midas touch effect. everything a good piece of content touches turns to gold
    k2 = 0.5
    if session[:edges]
      edge1 = session[:edges][0]
      edge2 = session[:edges][1]
      edge3 = session[:edges][2]
      content = edge3.content


      time_decay_const = 0.99
      decay_time(category_id,time_decay_const)

      average = content.weight_average(category_id) #is average a stored variable in ruby

      edge1.weight = edge1.weight + ucc
      edge1.save

      edge2.weight = edge2.weight + ucc
      edge2.save

      edge3.weight = edge3.weight + avgc*average + k
      edge3.save

      edge4.weight = avgc2 * average + k2
      edge4.save
    else
      edge4.weight = 1
      edge4.save
    end
  end

  def adjust_dislike(category_id, edge4)
    if session[:edges]
      edge1 = session[:edges][0]
      edge2 = session[:edges][1]
      edge3 = session[:edges][2]
      content = edge3.content

      ucc = 0.3
      avgc = 0.1
      k = 0.4

      time_decay_const = 0.99
      decay_time(category_id,time_decay_const)

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

    edge4.weight = 0
    edge4.save
    #content2 = edge4.content
    #if content2.type = new
      #for edge in content2.edges
        #sum++
      #if sum >=3
        #content2.type = old
  end
    
  def reset_edges
    session[:edges] = nil
  end
end

 
