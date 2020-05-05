using Images, LinearAlgebra

include("vec3.jl")
include("ray.jl")
include("hittable.jl")
include("sphere.jl")
include("camera.jl")

const aspect_ratio = 16 / 9
const image_width = 384
const image_height = Int(image_width ÷ aspect_ratio)
const samples_per_pixel = 100

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

function color(world::HittableList, cam::Camera, i::Int, j::Int)::Vec3
   c = Vec3(0, 0, 0)
   for _ = 1:samples_per_pixel
      u = (i + rand()) / image_width
      v = (j + rand()) / image_height
      r = get_ray(cam, u, v)
      c += ray_color(r, world)
   end
   c / samples_per_pixel

end

function render()
   world = HittableList([
      Sphere(Vec3(0, 0, -1), 0.5),
      Sphere(Vec3(0, -100.5, -1), 100),
   ])

   cam = Camera()

   [
      RGB(color(world, cam, i, j)...)
      for j = image_height:-1:1, i = 1:image_width
   ]
end

@time render()
