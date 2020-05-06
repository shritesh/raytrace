abstract type Hittable end

struct HitRecord
    p::Vec3
    normal::Vec3
    mat::Material
    t::Float64
    front_face::Bool

    function HitRecord(
        p::Vec3,
        t::Float64,
        mat::Material,
        r::Ray,
        outward_normal::Vec3,
    )
        front_face = dot(r.direction, outward_normal) < 0
        normal = front_face ? outward_normal : -outward_normal
        new(p, normal, mat, t, front_face)
    end
end

struct HittableList <: Hittable
    objects::Vector{Hittable}
end

function hit(
    hl::HittableList,
    r::Ray,
    t_min::Float64,
    t_max::Float64,
)::Union{HitRecord,Nothing}
    closest_so_far = t_max

    hr::Union{HitRecord,Nothing} = nothing

    for obj in hl.objects
        temp_hr = hit(obj, r, t_min, closest_so_far)
        if temp_hr != nothing
            closest_so_far = temp_hr.t
            hr = temp_hr
        end
    end

    hr
end
