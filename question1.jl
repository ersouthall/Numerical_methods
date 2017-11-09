function recursive_fp(type_precision)
    a_seq = zeros(type_precision, 80)
    a_seq[1] = 1
    a_seq[2] = 2/3
    for i = 2:79
        a_seq[i+1] = 2*a_seq[i] - (8/9)*a_seq[i-1]
    end
    return a_seq
end
           
