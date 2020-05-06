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


function schlick(cosine::Float64, ref_idx::Float64)
    r0 = (1 - ref_idx) / (1 + ref_idx)
    r0 *= r0
    r0 + (1 - r0) * (1 - cosine)^5
end

struct Dielectric <: Material
    ref_idx::Float64
end


function scatter(
    dielectric::Dielectric,
    r_in::Ray,
    rec::HitRecord,
)::Tuple{Bool,Vec3,Ray}
    attenuation = Vec3(1, 1, 1)
    etai_over_etat =
        rec.front_face ? 1 / dielectric.ref_idx : dielectric.ref_idx

    unit_direction = normalize(r_in.direction)

    cos_theta = min(dot(-unit_direction, rec.normal), 1)
    sin_theta = sqrt(1 - cos_theta * cos_theta)

    if etai_over_etat * sin_theta > 1
        reflected = reflect(unit_direction, rec.normal)
        scattered = Ray(rec.p, reflected)
        true, attenuation, scattered
    else
        reflect_prob = schlick(cos_theta, etai_over_etat)
        if rand() < reflect_prob
            reflected = reflect(unit_direction, rec.normal)
            scattered = Ray(rec.p, reflected)
            true, attenuation, scattered
        else
            refracted = refract(unit_direction, rec.normal, etai_over_etat)
            scattered = Ray(rec.p, refracted)
            true, attenuation, scattered
        end
    end
end
