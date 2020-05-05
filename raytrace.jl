using Images, LinearAlgebra

include("vec3.jl")
include("ray.jl")
include("hittable.jl")
include("sphere.jl")

const aspect_ratio = 16 / 9
const image_width = 384
const image_height = Int(image_width ÷ aspect_ratio)

const lower_left_corner = Vec3(-2, -1, -1)
const horizontal = Vec3(4, 0, 0)
const vertical = Vec3(0, 2, 0)
const origin = Vec3(0, 0, 0)

function ray_color(r::Ray, world::HittableList)::Vec3

   hr = hit(world, r, 0.0, Inf)

   if hr != nothing
      0.5 * (hr.normal .+ 1)
   else
      unit_direction = normalize(r.direction)
      t = 0.5 * (unit_direction[2] + 1)
      (1 - t) * Vec3(1, 1, 1) + t * Vec3(0.5, 0.7, 1)
   end
end

function color(world::HittableList, i::Int, j::Int)::Vec3
   u = i / image_width
   v = j / image_height

   r = Ray(origin, lower_left_corner + u * horizontal + v * vertical)
   ray_color(r, world)
end

function render()
   world = HittableList([
      Sphere(Vec3(0, 0, -1), 0.5),
      Sphere(Vec3(0, -100.5, -1), 100),
   ])

   [RGB(color(world, i, j)...) for j = image_height:-1:1, i = 1:image_width]
end

@time render()
