using Images, LinearAlgebra

include("vec3.jl")
include("ray.jl")
abstract type Material end
include("hittable.jl")
include("materials.jl")
include("sphere.jl")
include("camera.jl")

const aspect_ratio = 16 / 9
const image_width = 384
const image_height = Int(image_width ÷ aspect_ratio)
const samples_per_pixel = 100
const max_depth = 50

function ray_color(r::Ray, world::HittableList, depth::Int)::Vec3

   if depth <= 0
      return Vec3(0, 0, 0)
   end

   hr = hit(world, r, 0.001, Inf)

   if hr != nothing

      did_scatter, attenuation, scattered = scatter(hr.mat, r, hr)
      if did_scatter
         attenuation .* ray_color(scattered, world, depth - 1)
      else
         Vec3(0, 0, 0)
      end
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
      c += ray_color(r, world, max_depth)
   end

   sqrt.(c / samples_per_pixel)
end

function render()
   world = HittableList([
      Sphere(Vec3(0, 0, -1), 0.5, Lambertian(Vec3(0.1, 0.2, 0.5))),
      Sphere(Vec3(0, -100.5, -1), 100, Lambertian(Vec3(0.8, 0.8, 0))),
      Sphere(Vec3(1, 0, -1), 0.5, Metal(Vec3(0.8, 0.6, 0.2), 0.3)),
      Sphere(Vec3(-1, 0, -1), 0.5, Dielectric(1.5)),
      Sphere(Vec3(-1, 0, -1), -0.45, Dielectric(1.5)),
   ])

   cam = Camera()

   [
      RGB(color(world, cam, i, j)...)
      for j = image_height:-1:1, i = 1:image_width
   ]
end

@time render()
