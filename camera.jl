struct Camera
    origin::Vec3
    lower_left_corner::Vec3
    horizontal::Vec3
    vertical::Vec3
    u::Vec3
    v::Vec3
    w::Vec3
    lens_radius::Float64

    function Camera(
        lookfrom::Vec3,
        lookat::Vec3,
        vup::Vec3,
        vfov::Float64,
        aspect_ratio::Float64,
        aperture::Float64,
        focus_dist::Float64,
    )
        origin = lookfrom
        lens_radius = aperture / 2

        theta = deg2rad(vfov)
        half_height = tan(theta / 2)
        half_width = aspect_ratio * half_height

        w = normalize(lookfrom - lookat)
        u = normalize(cross(vup, w))
        v = cross(w, u)


        lower_left_corner =
            origin - half_width * focus_dist * u -
            half_height * focus_dist * v - focus_dist * w

        horizontal = 2 * half_width * focus_dist * u
        vertical = 2 * half_height * focus_dist * v

        new(
            origin,
            lower_left_corner,
            horizontal,
            vertical,
            u,
            v,
            w,
            lens_radius,
        )
    end
end

function get_ray(camera::Camera, s::Float64, t::Float64)::Ray
    rd = camera.lens_radius * random_in_unit_disk()
    offset = camera.u .* rd[1] + camera.v .* rd[2]

    Ray(
        camera.origin + offset,
        camera.lower_left_corner + s * camera.horizontal + t * camera.vertical -
        camera.origin - offset,
    )

end
