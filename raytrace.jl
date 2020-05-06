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

function random_scene()
   world = HittableList([])
   push!(
      world.objects,
      Sphere(Vec3(0, -1000, 0), 1000, Lambertian(Vec3(0.5, 0.5, 0.5))),
   )

   for a = -11:10, b = -11:10
      choose_mat = rand()

      center = Vec3(a + 0.9 * rand(), 0.2, b + 0.9 * rand())

      if norm(center - Vec3(4, 0.2, 0)) > 0.9
         if choose_mat < 0.8
            # diffuse
            albedo = convert(Vec3, rand(3) .* rand(3))
            push!(world.objects, Sphere(center, 0.2, Lambertian(albedo)))
         elseif choose_mat < 0.95
            # metal
            albedo = convert(Vec3, rand(0.5:eps():1, 3))
            fuzz = rand(0:eps():0.5)
            push!(world.objects, Sphere(center, 0.2, Metal(albedo, fuzz)))
         else
            # glass
            push!(world.objects, Sphere(center, 0.2, Dielectric(1.5)))
         end
      end
   end

   push!(world.objects, Sphere(Vec3(0, 1, 0), 1, Dielectric(1.5)))
   push!(
      world.objects,
      Sphere(Vec3(-4, 1, 0), 1, Lambertian(Vec3(0.4, 0.2, 0.1))),
   )
   push!(
      world.objects,
      Sphere(Vec3(4, 1, 0), 1, Metal(Vec3(0.7, 0.6, 0.5), 0.0)),
   )

   world
end

function render()
   world = random_scene()
   lookfrom = Vec3(13, 2, 3)
   lookat = Vec3(0, 0, 0)
   vup = Vec3(0, 1, 0)
   dist_to_focus = 10.0
   aperture = 0.1

   cam =
      Camera(lookfrom, lookat, vup, 20.0, aspect_ratio, aperture, dist_to_focus)


   [
      RGB(color(world, cam, i, j)...)
      for j = image_height:-1:1, i = 1:image_width
   ]
end

img = @time render()
save("image.png", img)
