using Images, LinearAlgebra

include("vec3.jl")
include("ray.jl")

const aspect_ratio = 16 / 9
const image_width = 384
const image_height = Int(image_width ÷ aspect_ratio)

const origin = Vec3(0, 0, 0)
const horizontal = Vec3(4, 0, 0)
const vertical = Vec3(0, 2.25, 0)
const lower_left_corner = origin - horizontal / 2 - vertical / 2 - Vec3(0, 0, 1)

function ray_color(ray::Ray)
   unit_direction = normalize(ray.direction)
   t = 0.5 * (unit_direction[2] + 1)
   (1 - t) * Vec3(1, 1, 1) + t * Vec3(0.5, 0.7, 1)
end

function color(i::Int, j::Int)
   u = i / image_width
   v = j / image_height

   r = Ray(origin, lower_left_corner + u * horizontal + v * vertical)
   ray_color(r)
end

function render()
   [RGB(color(i, j)...) for j = image_height:-1:1, i = 1:image_width]
end

@time render()
