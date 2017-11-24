function keyvaluepairs(List::Nullable{LList})
    while(isnull(List) == false)
        println((get(List).data))
        List = get(List).next
    end
end

function search(List::Nullable{LList}, k::Int64)
    if isnull(List) == true
        return Nullable{KVPair}
    elseif get(List).data.key == k
        return get(List).data
    else
        search(get(List).next, k)
    end
end

function intervalmembership(list::Nullable{LList}, x::Float64)
    if isnull(list) == true
        return Nullable{KVPair}
    elseif get(list).data.value >= x
        return get(list).data
    else
        intervalmembership(get(list).next, x)
    end
end

function intervalmembership1(FT::Nullable{FTree}, x::Float64)
    if isnull(get(FT).left) && isnull(get(FT).right)
        return get(FT).data
    elseif get(get(FT).left).data.value >= x
        intervalmembership1(get(FT).left, x)
    else
        intervalmembership1(get(FT).right, (x-get(get(FT).left).data.value))
    end
end
