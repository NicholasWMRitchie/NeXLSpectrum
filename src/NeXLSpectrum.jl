module NeXLSpectrum

using Reexport
using Requires

@reexport using NeXLCore

include("features.jl")
include("detector.jl")
export EnergyScale # Abstract: Detector energy calibration function
export LinearEnergyScale # A linear detector energy calibration function
export Resolution # Abstract: Detector resolution function
export MnKaResolution # Fiori function resolution function
export Detector # Abstract: X-ray detector
export EscapeArtifact # An escape peak
export SpectrumFeature # A CharXRay or EscapeArtifact (ComptonArtifact)
export EDSDetector # Abstract base for BasicEDS and other EDS detector-like things
export BasicEDS # A basic EDS detector with min visibility by line family
export channel # energy to channel
export visible # Is a SpectrumFeature visible in the spectrum??
export linewidth # energy to linewidth
export channelcount # Detector channel count
export scale # Detector EnergyScale
export resolution # Detector Resolution
export simpleEDS # Create a basic EDS detector
export simpleEDSwICC # Create a basic EDS detector with a naive incomplete charge collection model
export extent # Determine the energy extent of an x-ray line on a detector ( Emin, Emax )
export extents # Determine the energy extents of many x-ray lines on a detector
export matching # Build a detector to match a spectrum
export lld # Low-level discriminator in eV

# Items defined in NeXL/spectrum.jl
include("spectrum.jl")
export Spectrum
#export NeXLCore.name # A human friendly name for the spectrum
export channel # channel for energy
export rangeofenergies # range of energies for channel `ch`
export channelwidth # width of channel ch
#export NeXLCore.energy # energy for channel
export dose # Spectrum probe dose
export counts # Spectrum channel data
export integrate # Integrate range of channels
export kratio # Naive peak integration estimate of the k-ratio
export energyscale # Energy scale function
export subsample # Sub-sample a spectrum
export subdivide # Divide the counts among n spectra
export modelbackground # Model a background region
export modelBackground
export extractcharacteristic # Extract the characteristic intensity
export details # Outputs useful details about a spectrum
export peak # Estimates the peak intensity
export background # Estimates the background intensity
export estkratio # Estimate the k-ratio from two spectra for a ROI
export normalizedosewidth # Normalize intensity data to 1 nA⋅s⋅eV
export commonproperties # Properties that a collection of spectra share in common
export maxspectrum # Dave Bright's max spectra derived spectrum

export maxproperty, minproperty # Min value of a property over a vector of spectra
export sameproperty # Returns the property value if all the spectra share the same value, errors otherwise

include("emsa.jl")
export readEMSA # Read an EMSA file
export writeEMSA # Write an EMSA file
# Also implements FileIO save(...) and load(...) for "ISO EMSA"
include("aspextiff.jl")
export readAspexTIFF
# Also implements FileIO save(...) and load(...) for "ASPEX TIFF"

include("brukerpdz.jl")
export readbrukerpdz

include("hyperspectrum.jl")
export Signal  # The base class that makes hyperspectral data look like an Array of Real
export HyperSpectrum # The wrapper that makes a Signal look like an Array of Spectrum
export ashyperspectrum # Converts a Signal into a HyperSpectrum
export plane # Sum planes in a HyperSpectrum
export roiimage # Convert a range of data channels into a Gray-scale image
export roiimages # Convert a vector of ranges-of-channels into Gray-scale images
export compressed # Compresses Integer type data down to the smallest integer type that that will hold the max value.
export maxpixel # Bright's max-pixel derived spectrum
export indexofmaxpixel # Index producing the max pixel

include("rplraw.jl")
export RPLHeader
export readrplraw # Read a RPL/RAW file into a Signal
export readrpl # Read the RPL file into a RPLHeader
export writerplraw # Write a Signal into a RPL/RAW

include("fitlabels.jl")
export ReferenceLabel
export UnknownLabel#(spec) <: ReferenceLabel
export CharXRayLabel#(spec,roi,xrays) <: ReferenceLabel
export EscapeLabel#(spec,roi,xrays) <: ReferenceLabel
export charXRayLabels # Constructs CharXRayLabel(s) <: ReferenceLabel

include("filter.jl")
export TopHatFilter # Struct representing a fitting filter
export VariableWidthFilter # The default filter definition that varies the filter width with x-ray energy
export ConstantWidthFilter # An alternative filter definition that holds the filter width constant
export GaussianFilter # An alternative filter definition based on an offset Gaussian
export tophatfilter # Apply a top-hat filter to produce a FilteredReference
export FilteredReference # A filtered datum representing a contiguous region of filtered reference data

export buildfilter
export estimatebackground
export ascontiguous
#export fitcontiguousg, fitcontiguousp, fitcontiguousw, fitcontiguouso
export filterfit
export filteredresidual
export filterreference

include("fitresult.jl")
export FilterFitResult
export findlabel
export fit
export heterogeneity
export peaktobackground
export characteristiccounts
export residual
export spectrum
export unknown
export kratios
export kratio

include("qquant.jl")
export VectorQuant

include("llsq.jl")
# The implementation for weighted filter-fit.
include("filterfit_wls.jl")
export FilteredUnknownW # A filtered datum representing an unknown spectrum (for weighted least squares fitting)
# The implementation for generalized filter-fit.
include("filterfit_gls.jl")
export FilteredUnknownG # A filtered datum representing an unknown spectrum (for generalized least squares fitting)

function __init__()
    @require Gadfly = "c91e804a-d5a3-530f-b6f0-dfbca275c004" include("gadflysupport.jl")
end

end
