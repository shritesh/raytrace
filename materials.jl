struct Lambertian <: Material
    albedo::Vec3
end

function scatter(
    lambertian::Lambertian,
    r_in::Ray,
    rec::HitRecord,
)::Tuple{Bool,Vec3,Ray}
    scatter_direction = rec.normal + random_unit_vector()
    scattered = Ray(rec.p, scatter_direction)
    attenuation = lambertian.albedo
    true, attenuation, scattered
end

struct Metal <: Material
    albedo::Vec3
    fuzz::Float64

    Metal(albedo::Vec3, fuzz::Float64) = new(albedo, fuzz < 1 ? fuzz : 1)
end


function scatter(metal::Metal, r_in::Ray, rec::HitRecord)::Tuple{Bool,Vec3,Ray}
    reflected = reflect(normalize(r_in.direction), rec.normal)
    scattered = Ray(rec.p, reflected)
    attenuation = metal.albedo
    dot(scattered.direction, rec.normal) > 0, attenuation, scattered
end
