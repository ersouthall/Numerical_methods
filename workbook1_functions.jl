function recursive_fp(type_precision)
    a_seq = zeros(type_precision, 80)
    a_seq[1] = 1
    a_seq[2] = type_precision(2)/type_precision(3)
    for i = 2:79
        a_seq[i+1] = 2*a_seq[i] - (type_precision(8)/type_precision(9))*a_seq[i-1]
    end
    return a_seq
end

function mergepresorted(A::Array{Int64,1}, B::Array{Int64,1})
    if length(A) == 0
        return B
    elseif length(B) == 0
        return A
    elseif A[1] < B[1]
        return vcat([A[1]], mergepresorted(A[2:end], B))
    else
        return vcat([B[1]], mergepresorted(A, B[2:end]))
    end
end

function sortarray(A::Array{Int64,1})
    if length(A) == 1
        return A
    else
        Into_two = Int(0.5*length(A))
        a = sortarray(A[1:Into_two])
        b = sortarray(A[(Into_two+1):end])
        return mergepresorted(a,b)
    end
end
