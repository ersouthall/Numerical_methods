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

function gillelist(N, Nx, L, mean, time)
  dx = (2.0*L)/(Nx-1)
  X = dx.*(-(Nx-1)/2:(Nx-1)/2)
  Y =zeros(Int64,N) #initially all particles are at 0, this will be filled with their states (integers)
  t=0.0
  rate = randexp(N)
  Rate_2 = vcat(rate, rate)*(mean/(2*((dx)^2))) #vcat as rate of going forward is equal to the rate of going back
  totalRate = sum(Rate_2)
  dt = 1.0/(totalRate)
  RR = cumsum(Rate_2) #cumulative frequency to use the intervalmembership on lists algorithm
  value_r = Array{KVPair}(2*N)
  for k = 1:2*N
      value_r[k] = KVPair(k,RR[k])
  end
  Llist_rates = Nullable{LList}()
  Llist_rates= buildLList(value_r)
  while t < time
      K = totalRate*rand() #choose event/rate
      interval = intervalmembership(Llist_rates, K)
      particle = interval.key #key returns which particle will be moved
      if particle<=N
          hop = 1
          particleId = particle
      else
          hop = -1
          particleId=particle-N
      end
      Y[particleId]+=hop
      t+=dt
  end
  P =zeros(Float64,length(X))
  for i in 1:length(Y)
      P[Y[i]+Int64((Nx-1)/2)+1]+=1/(N * dx)
  end
  return X, P
end

function hetergenousdiffusion(x,d,t) #hetergeneous difussion problem
    return ((1.0/sqrt(2*d*t))*exp(-(sqrt(2/(d*t)))*abs(x)))
end

function fenwick_gillespie(N, Nx, L, mean, time)
  dx = (2.0*L)/(Nx-1)
  X = dx.*(-(Nx-1)/2:(Nx-1)/2)
  Y =zeros(Int64,N) #initially all particles are at 0, this will be filled with their states (integers)
  t=0.0
  rate =randexp(N)
  Rate_2 = vcat(rate, rate)*(mean/(2*((dx)^2)))
  totalRate = sum(Rate_2)
  dt = 1.0/(totalRate)
  value_r = Array{KVPair}(2*N)
  for k = 1:2*N
      value_r[k] = KVPair(k,Rate_2[k])
  end
  tTree = Nullable{FTree}(FTree(KVPair(0,0.0)))
  tTree=buildFTree(tTree, value_r)
  while t < time
      # Pick an event
      K = totalRate*rand() #choose event
      interval = intervalmembership1(tTree, K)
      particle = interval.key
      if particle<=N
          hop = 1
          particleId = particle
      else
          hop = -1
          particleId=particle-N
      end
      Y[particleId]+=hop
      t+=dt
  end
  # Calculate the estimated density of particles
  P =zeros(Float64,length(X))
  for i in 1:length(Y)
      P[Y[i]+Int64((Nx-1)/2)+1]+=1/(N * dx)
  end
  return X,P
end
