using StaticArrays

Vec3 = SVector{3,Float64}

length_squared(v::Vec3) = norm(v)^2
