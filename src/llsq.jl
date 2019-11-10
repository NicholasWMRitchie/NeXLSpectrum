using MultivariateStats
using NeXLUncertainties

"""
    olssvd(y::AbstractVector{N}, a::AbstractMatrix{N}, sigma::N, xLabels::Vector{<:Label}, tol::N=convert(N,1.0e-10))::UncertainValues where N <: AbstractFloat

Solves the ordinary least squares problem a⋅x = y for x using singular value decomposition for AbstractFloat-based types.
"""
function olssvd(y::AbstractVector{N}, a::AbstractMatrix{N}, sigma::N, xLabels::Vector{<:Label}, tol::N=convert(N,1.0e-10))::UncertainValues where N <: AbstractFloat
    f = svd(a)
    mins = tol*maximum(f.S)
    fs = [s > mins ? one(N)/s : zero(N) for s in f.S]
    # Note: w*a = f.U * Diagonal(f.S) * f.Vt
    genInv = f.V*Diagonal(fs)*transpose(f.U)
    #cov = sigma^2*f.V*(Diagonal(fs)*Diagonal(fs))*Transpose(f.V)
    cov = sigma^2*genInv*transpose(genInv)
    return uvs(xLabels, genInv*y, cov)
end

function olspinv(y::AbstractVector{N}, a::AbstractMatrix{N}, sigma::N, xLabels::Vector{<:Label}, tol::N=convert(N,1.0e-10))::UncertainValues where N <: AbstractFloat
    genInv = pinv(a, rtol=1.0e-6)
    return uvs(xLabels, genInv*y, sigma*genInv*transpose(genInv))
end

"""
    glspinv(y::AbstractVector{N}, a::AbstractMatrix{N}, v::Matrix{N}, xlabels::Vector{<:Label}, tol::N=convert(N,1.0e-10))::UncertainValues

Solves the generalized least squares problem a⋅x = y for b using the pseudo-inverse for AbstractFloat-based types.
"""
function glspinv(y::AbstractVector{N}, a::AbstractMatrix{N}, v::AbstractMatrix{N}, xLabels::Vector{<:Label}, tol::N=convert(N,1.0e-10))::UncertainValues where N <: AbstractFloat
    xtiv=transpose(a)*pinv(v, tol)
    xtivx = pinv(xtiv*a, tol)
    return uvs(xLabels, xtivx*xtiv*y, xtivx)
end

"""
    glssvd(y::AbstractVector{N}, a::AbstractMatrix{N}, cov::Matrix{N}, xlabels::Vector{<:Label}, tol::N=convert(N,1.0e-10))::UncertainValues

Solves the generalized least squares problem a⋅x = y for x using singular value decomposition for AbstractFloat-based types.
"""
function glssvd(y::AbstractVector{N}, a::AbstractMatrix{N}, cov::AbstractMatrix{N}, xLabels::Vector{<:Label}, tol::N=convert(N,1.0e-10))::UncertainValues where N <: AbstractFloat
    checkcovariance!(cov)
    w = cov_whitening(cov)
    olssvd(w*y, w*a, 1.0, xLabels, tol)
end


"""
    glssvd(y::AbstractVector{N}, a::AbstractMatrix{N}, cov::AbstractVector{N}, xlabels::Vector{<:Label}, tol::N=convert(N,1.0e-10))::UncertainValues

Solves the weighted least squares problem a⋅x = y for x using singular value decomposition for AbstractFloat-based types.
"""
function wlssvd(y::AbstractVector{N}, a::AbstractMatrix{N}, cov::AbstractVector{N}, xLabels::Vector{<:Label}, tol::N=convert(N,1.0e-10))::UncertainValues where N <: AbstractFloat
    w = Diagonal([sqrt(1.0/cv) for cv in cov])
    olssvd(w*y, w*a, 1.0, xLabels, tol)
end

"""
    glssvd(y::AbstractVector{N}, a::AbstractMatrix{N}, cov::AbstractVector{N}, xlabels::Vector{<:Label}, tol::N=convert(N,1.0e-10))::UncertainValues

Solves the weighted least squares problem a⋅x = y for x using singular value decomposition for AbstractFloat-based types.
"""
function wlspinv(y::AbstractVector{N}, a::AbstractMatrix{N}, cov::AbstractVector{N}, xLabels::Vector{<:Label}, tol::N=convert(N,1.0e-10))::UncertainValues where N <: AbstractFloat
    w = Diagonal([sqrt(1.0/cv) for cv in cov])
    olspinv(w*y, w*a, 1.0, xLabels, tol)
end

"""
    glssvd(y::AbstractVector{N}, a::AbstractMatrix{N}, cov::AbstractVector{N}, xlabels::Vector{<:Label}, tol::N=convert(N,1.0e-10))::UncertainValues

Solves the weighted least squares problem a⋅x = y for x using singular value decomposition for AbstractFloat-based types.
"""
function wlspinv(y::AbstractVector{N}, a::AbstractMatrix{N}, cov::AbstractVector{N}, wgts::AbstractVector{N}, xLabels::Vector{<:Label}, tol::N=convert(N,1.0e-10))::UncertainValues where N <: AbstractFloat
    function rescaleCovariances(uvs::UncertainValues, wgts::AbstractVector{N})::UncertainValues
        cov = copy(uvs.covariance)
        rwgts = map(sqrt,wgts)
        a = axes(cov)
        for r in a[1]
            for c in a[2]
                cov[r,c]*=rwgts[r]*rwgts[c]
            end
        end
        return UncertainValues(uvs.labels, uvs.values, cov)
    end
    w = Diagonal([sqrt(1.0/cv) for cv in cov])
    return rescaleCovariances(olspinv(w*y, w*a, 1.0, xLabels, tol),0.5*wgts)
end
