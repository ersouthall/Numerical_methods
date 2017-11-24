function sinexp(x)
    return sin(exp(x)), cos(exp(x))*exp(x)
end

function finitediff(h, x, func)
    return (4*func(x+h)[1] - 3*func(x)[1] -func(x+2*h)[1])/(2*h)
end

function bandb(a,b,func, exact)
    tol = ((abs(a)+abs(b))/2)*eps()
    Error = Array(Float64, 0)
    while abs(b-a)>tol
        x = (a+b)/2
        if (func(a)[1]*func(x)[1]) < 0
            a = a
            b = x
            push!(Error, abs(b-exact))
        else
            a = x
            b= b
            push!(Error, abs(b-exact))
        end
    end
    return (b, func(b)[1], Error)
end

function newtonraps(func, x, exact)
    tol = 1e-14
    Error = Array(Float64, 0)
    while abs(func(x)[1])>tol
        x_new = (x - (func(x)[1]/func(x)[2]))
        x = x_new
        push!(Error, abs(x-exact))
    end
    return x, func(x)[1], Error
end

function golden(a,b,func, exact)
    tol = ((abs(a) + abs(b))/2)*eps()
    Error = Array(Float64, 0)
    ϕ = (1+sqrt(5))/2
    c = b - (b-a)/ϕ
    x = a + (b-a)/ϕ
    while abs(a-b)>tol

        if func(x)[1]<func(c)[1]
            a = c
            c = x
            b = b
            push!(Error, abs(x-exact))
        else
            a =a
            c= c
            b = x
            push!(Error, abs(x-exact))
        end
        c = b - (b-a)/ϕ
        x = a + (b-a)/ϕ
    end
    return (a,c,b), Error
end
