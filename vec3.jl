using StaticArrays

Vec3 = SVector{3,Float64}

length_squared(v::Vec3) = norm(v)^2

function random_in_unit_sphere()
    while true
        p = convert(Vec3, rand(-1:eps():1, 3))
        if length_squared(p) < 1
            return p
        end
    end
end

function random_unit_vector()
    a = rand(0:eps():2pi)
    z = rand(-1:eps():1)
    r = sqrt(1 - z * z)
    Vec3(r * cos(a), r * sin(a), z)
end

function random_in_hemisphere(normal::Vec3)
    in_unit_sphere = random_in_unit_sphere()

    if dot(in_unit_sphere, normal) > 0
        in_unit_sphere
    else
        -in_unit_sphere
    end
end

function random_in_unit_disk()
    while true
        p = Vec3(rand(-1:eps():1), rand(-1:eps():1), 0)
        if length_squared(p) < 1
            return p
        end
    end
end

reflect(v::Vec3, n::Vec3) = v - 2 * dot(v, n) * n

function refract(uv::Vec3, n::Vec3, etai_over_etat::Float64)
    cos_theta = dot(-uv, n)
    r_out_parallel = etai_over_etat * (uv + cos_theta * n)
    r_out_perp = -sqrt(1 - length_squared(r_out_parallel)) * n
    r_out_parallel + r_out_perp
end
