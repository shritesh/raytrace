struct Sphere <: Hittable
   center::Vec3
   radius::Float64
end

function hit(
   sphere::Sphere,
   r::Ray,
   t_min::Float64,
   t_max::Float64,
)::Union{HitRecord,Nothing}
   oc = r.origin - sphere.center
   a = length_squared(r.direction)
   half_b = dot(oc, r.direction)
   c = length_squared(oc) - sphere.radius * sphere.radius
   discriminant = half_b * half_b - a * c

   if discriminant > 0
      root = sqrt(discriminant)
      temp = (-half_b - root) / a
      if t_min < temp < t_max
         p = at(r, temp)
         outward_normal = (p - sphere.center) / sphere.radius
         HitRecord(p, temp, r, outward_normal)
      else
         temp = (-half_b + root) / a
         if t_min < temp < t_max
            p = at(r, temp)
            outward_normal = (p - sphere.center) / sphere.radius
            HitRecord(p, temp, r, outward_normal)
         end
      end
   end
end
