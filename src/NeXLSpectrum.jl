module NeXLSpectrum

using NeXLCore
using Requires

include("detector.jl")
export EnergyScale # Abstract: Detector energy calibration function
export LinearEnergyScale # A linear detector energy calibration function
export Resolution # Abstract: Detector resolution function
export MnKaResolution # Fiori function resolution function
export Detector # Abstract: X-ray detector
export SimpleEDS # A simple EDS detector model
export channel # energy to channel
#export NeXLCore.energy # channel to energy
export linewidth # energy to linewidth
export channelcount # Detector channel count
export scale # Detector EnergyScale
export resolution # Detector Resolution
export basicEDS # Create a basic EDS detector
export basicEDSwICC # Create a basic EDS detector with incomplete charge collection
export extent # Determine the energy extent of x-ray lines on a detector ( Emin, Emax )
export extents # Determines contiguous channel extents from a set of characteristic lines or an element
export labeledextents # Like extents but labeled with a vector of the characteristic x-ray lines in each extent

# Items defined in NeXL/spectrum.jl
include("spectrum.jl")
export Spectrum
export name # A human friendly name for the spectrum
export channel # channel for energy
#export NeXLCore.energy # energy for channel
export readEMSA # Read an EMSA file
export dose # Spectrum probe dose
export counts # Spectrum channel data
export integrate # Integrate range of channels
export energyscale # Energy scale function
export subsample # Sub-sample a spectrum
export modelbackground # Model a background region
export modelBackground
export extractcharacteristic # Extract the characteristic intensity
export tabulate # Converts a Spectrum to a DataFrame
export details # Outputs useful details about a spectrum
export peak # Estimates the peak intensity
export back # Estimates the background intensity
export estkratio # Estimate the k-ratio from two spectra for a ROI

include("llsq.jl")
include("filterfit.jl")
export buildfilter
export estimateBackground
export extract
export covariance
export ascontiguous
export fitcontiguousg, fitcontiguousp, fitcontiguousw, fitcontiguouso
export filterfit
export filteredresidual
export FilterFitResult

function __init__()
    @require Gadfly = "c91e804a-d5a3-530f-b6f0-dfbca275c004" include("gadflysupport.jl")
end

end
