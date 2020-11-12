using SpectralVis
using Test

@testset "Block spectrum generator mode 0 (block_spec) test" begin
    m = 0
    λmin=380.0
    λmax=780.0
    Δλ  =  1.0
    # 1.0 @ 381.0:382.0
    λs=381.0
    λe=382.0
    refl=zeros(length(collect(λmin:Δλ:λmax)))
    refl[2:3].=1.0
    gt=i_reflectance_spec(collect(λmin:Δλ:λmax),refl)
    @test block_spec(λmin,λmax,Δλ,λs,λe,m).r == gt.r
    # 1.0 @ 781.0
    λs=778.0
    λe=779.0
    refl=zeros(length(collect(λmin:Δλ:λmax)))
    refl[end-2:end-1].=1.0
    gt=i_reflectance_spec(collect(λmin:Δλ:λmax),refl)
    @test block_spec(λmin,λmax,Δλ,λs,λe,m).r == gt.r
end    

@testset "Block spectrum generator mode 1 (block_spec) test" begin
    #Inverse block spectrum
    m = 1
    λmin=380.0
    λmax=780.0
    Δλ  =  1.0
    # 1.0 @ 381.0:382.0
    λs=381.0
    λe=382.0
    # 0.0 @ 381.0
    refl=ones(length(collect(λmin:Δλ:λmax)))
    refl[2:3].=0.0
    gt=i_reflectance_spec(collect(λmin:Δλ:λmax),refl)
    @test block_spec(λmin,λmax,Δλ,λs,λe,m).r == gt.r

    # 0.0 @ 781.0
    λs=778.0
    λe=779.0
    refl=ones(length(collect(λmin:Δλ:λmax)))
    refl[end-2:end-1].=0.0
    gt=i_reflectance_spec(collect(λmin:Δλ:λmax),refl)
    @test block_spec(λmin,λmax,Δλ,λs,λe,m).r == gt.r
end

# test of convert(::Type{CIE12_2},mf::LMS06_2)
@testset "LMS06_2 to CIE12_2 conversion" begin
    test02 = cmf(CMF2012_2)
    res02  = convert(CIE12_2,cmf(LMS2006_2))

    eps=5.0E-7

    delta2_1=test02.x.-res02.x
    delta2_2=test02.y.-res02.y
    delta2_3=test02.z.-res02.z

    @test maximum(broadcast(abs,(delta2_1))) ≈ 0 atol=eps
    @test maximum(broadcast(abs,(delta2_2))) ≈ 0 atol=eps
    @test maximum(broadcast(abs,(delta2_3))) ≈ 0 atol=eps
end

# test of convert(::Type{CIE12_10},mf::LMS06_10)
@testset "LMS06_10 to CIE12_10 conversion" begin
    test10 = cmf(CMF2012_10)
    res10  = convert(CIE12_10,cmf(LMS2006_10))

    eps=5.0E-7

    delta10_1=test10.x.-res10.x
    delta10_2=test10.y.-res10.y
    delta10_3=test10.z.-res10.z

    @test maximum(broadcast(abs,(delta10_1))) ≈ 0 atol=eps
    @test maximum(broadcast(abs,(delta10_2))) ≈ 0 atol=eps
    @test maximum(broadcast(abs,(delta10_3))) ≈ 0 atol=eps
end

@testset "Spectral operators test" begin
    @test 1==1    


end