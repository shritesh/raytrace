struct Camera
    origin::Vec3
    lower_left_corner::Vec3
    horizontal::Vec3
    vertical::Vec3

    function Camera(
        lookfrom::Vec3,
        lookat::Vec3,
        vup::Vec3,
        vfov::Float64,
        aspect_ratio::Float64,
    )
        origin = lookfrom

        theta = deg2rad(vfov)
        half_height = tan(theta / 2)
        half_width = aspect_ratio * half_height

        w = normalize(lookfrom - lookat)
        u = normalize(cross(vup, w))
        v = cross(w, u)

        lower_left_corner = origin - half_width * u - half_height * v - w

        horizontal = 2 * half_width * u
        vertical = 2 * half_height * v

        new(origin, lower_left_corner, horizontal, vertical)
    end
end

get_ray(c::Camera, u::Float64, v::Float64)::Ray = Ray(
    c.origin,
    c.lower_left_corner + u * c.horizontal + v * c.vertical - c.origin,
)
