module MathHelper

  def mean(array)
	  array.reduce(0) { |sum, x| sum += x } / array.size.to_f
	end

  def median(array, already_sorted=false)
	  return nil if array.empty?
	  array = array.sort unless already_sorted
	  m_pos = array.size / 2
	  return array.size % 2 == 1 ? array[m_pos] : mean(array[m_pos-1..m_pos])
	end

  def max(array)
    return array.max
  end

  def sample_variance(array)
    m = mean(array)
    sum = array.inject(0){|accum, i| accum +(i-m)**2 }
    sum/(array.length - 1).to_f
  end

  def standard_deviation(array)
    Math.sqrt(sample_variance(array))
  end

end
