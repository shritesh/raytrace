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

function hit_sphere(center::Vec3, radius::Float64, r::Ray)::Bool
   oc = r.origin - center
   a = dot(r.direction, r.direction)
   b = 2 * dot(oc, r.direction)
   c = dot(oc, oc) - radius * radius
   discriminant = b * b - 4 * a * c
   discriminant > 0
end

function ray_color(r::Ray)::Vec3
   if hit_sphere(Vec3(0, 0, -1), 0.5, r)
      Vec3(1, 0, 0)
   else
      unit_direction = normalize(r.direction)
      t = 0.5 * (unit_direction[2] + 1)
      (1 - t) * Vec3(1, 1, 1) + t * Vec3(0.5, 0.7, 1)
   end
end

function color(i::Int, j::Int)::Vec3
   u = i / image_width
   v = j / image_height

   r = Ray(origin, lower_left_corner + u * horizontal + v * vertical)
   ray_color(r)
end

function render()
   [RGB(color(i, j)...) for j = image_height:-1:1, i = 1:image_width]
end

@time render()
