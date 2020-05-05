struct Ray
    origin::Vec3
    direction::Vec3
end

at(ray::Ray, t::Float64) = ray.origin + t * ray.direction
