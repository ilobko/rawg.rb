class LinkedList
  class Node
    attr_accessor :value, :next_node

    def initialize(value, next_node)
      @value = value
      @next_node = next_node
    end
  end

  def initialize(value)
    @head = Node.new(value, nil)
  end

  def add(value)
    current_node = @head
    while current_node.next_node != nil
      current_node = current_node.next_node
    end
    current_node.next_node = Node.new(value, nil)
  end

  def print
    current_node = @head
    until current_node.next_node.nil?
      puts current_node.value
    end
  end

  def to_a
    res = []
    current_node = @head
    until current_node.next_node.nil?
      puts current_node.value
    end
    res
  end
end
