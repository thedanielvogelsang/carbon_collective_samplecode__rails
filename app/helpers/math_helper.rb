module MathHelper

  def mean(array, already_sorted=false)
    array = array.sort unless already_sorted
	  array.reduce(0) { |sum, x| sum += x } / array.size.to_f
	end

  def median(array, already_sorted=false)
	  return nil if array.empty?
	  array = array.sort unless already_sorted
	  m_pos = array.size / 2
	  return array.size % 2 == 1 ? array[m_pos] : mean(array[m_pos-1..m_pos], true)
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

  def find_q1_q3(array)
    if !array.empty? && array.length % 2 == 0
      return array.each_slice(array.length / 2)
       .to_a.map do |subArr|
         median(subArr)
       end
    elsif !array.empty?
      i = array.length / 2
      a = median(array[0..i])
      b = median(array[i..-1])
      return [a, b]
    end
  end

  def find_max(array, already_sorted=false)
    array = array.sort unless already_sorted
    q1q3 = find_q1_q3(array)
    iqr = q1q3[1] - q1q3[0]
    max = 1.5*(iqr) + q1q3[1]
  end

  def find_max_monthly(array)
    return find_max(array) * 29.53
  end

  def rounded(num)
    return num.to_f.round(2)
  end

end
