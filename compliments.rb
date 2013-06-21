# a very hacky way of persisting the compliment data between requests
class Compliments
  @@compliments = {}

  def self.add_compliment_order(twitter_handle, compliment)
    compliment_id = rand(9999999)
    @@compliments[compliment_id] = OpenStruct.new(twitter_handle: twitter_handle, compliment: compliment)
    return compliment_id
  end

  def self.get_compliment_from_order_id(order_id)
    @@compliments[order_id.to_i]
  end

end