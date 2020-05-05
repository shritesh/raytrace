struct Camera
    origin::Vec3
    lower_left_corner::Vec3
    horizontal::Vec3
    vertical::Vec3

    Camera() =
        new(Vec3(0, 0, 0), Vec3(-2, -1, -1), Vec3(4, 0, 0), Vec3(0, 2, 0))
end

get_ray(c::Camera, u::Float64, v::Float64)::Ray = Ray(
    c.origin,
    c.lower_left_corner + u * c.horizontal + v * c.vertical - c.origin,
)
