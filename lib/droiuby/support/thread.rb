class Object 
  def with_large_stack(stack_size_kb = 64, &block) 
    result = nil 
    t = Thread.with_large_stack(&proc{result = block.call}) 
    t.join 
    result 
  end 
end

class Thread 
  def self.with_large_stack(stack_size_kb = 128, &block)
    runnable = RunnableWrapper.new(block).to_native 
    t = Java::java.lang.Thread.new(nil, runnable, "block with large stack", stack_size_kb * 1024) 
    t.start 
    t 
  end 
end