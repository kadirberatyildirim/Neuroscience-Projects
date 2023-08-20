#!/bin/bash

: <<'HELP'
Usage: wm_gm_csf_masker.sh [-id ID_NAME] [-help]

Description:
This script is designed to automate the process of creating white matter, gray matter and CSF masks and extracting average signals from those regions in fMRI brain imaging data.

Steps:
1. The script identifies 'anat_final...' and 'pb05...' files in the current directory.
2. Applies the 3dSeg command on the 'anat_final...' file to segment it.
3. Transfers the 'pb05...' files into the 'Segsy' directory.
4. Within the 'Segsy' directory, for each tissue type (WM, GM, CSF):
   a. Mask files are created using 3dcalc.
   b. These masks are then resampled using 3dresample.
   c. Signal averages are extracted from the resampled masks using 3dmaskave.
5. The script organizes the outputs by moving mask files into a 'masks' directory and average signals into 'ave_signals'.

Directory Structure After Script Execution:
Current Directory
|-- Segsy
|-- masks
|   |-- mask_WM+tlrc.*
|   |-- mask_GM+tlrc.*
|   |-- mask_CSF+tlrc.*
|   |-- mask_epi_WM+tlrc.*
|   |-- mask_epi_GM+tlrc.*
|   `-- mask_epi_CSF+tlrc.*
|-- ave_signals
|   |-- [ID_PREFIX]WM_ave.txt
|   |-- [ID_PREFIX]GM_ave.txt
|   `-- [ID_PREFIX]CSF_ave.txt
|-- [Other original files in the directory]

Options:
    -id ID_NAME    : (Optional) Specify an ID that will prefix the output filenames.
    -help          : Display this help message.

Example:
    bash wm_gm_csf_masker.sh -id task_run1

Note:
Ensure you have both 'anat_final...' and 'pb05...' files in the same directory 
as this script. Navigate to that directory and execute this script from there.
HELP

# Check for -help option
for arg in "$@"; do
    if [[ "$arg" == "-help" ]]; then
        # Display the help comment block and exit
        sed -n '/^: <<'\''HELP'\''$/,/^HELP/p' "$0" | sed '1d;$d'
        exit 0
    fi
done


# Default ID prefix is empty
ID_PREFIX=""

# Manually parse the command-line arguments
if [ "$1" = "-id" ]; then
    if [ -z "$2" ]; then
        echo "Error: Expected argument after -id"
        echo "Usage: $0 [-id ID_NAME]"
        exit 1
    fi
    ID_PREFIX="${2}_"
    shift 2  # Shift away the parsed arguments
fi

# Find the anat_final and pb05 files
ANAT_FILE=$(ls anat_final*+tlrc.HEAD | sed 's/\.HEAD$//' | head -n 1)
PB05_BASE=$(ls pb05*+tlrc.HEAD | sed 's/\.HEAD$//' | head -n 1)

# Check if files were found
if [[ ! -f "${ANAT_FILE}.HEAD" ]]; then
    echo "anat_final file not found!"
    exit 1
fi

if [[ ! -f "${PB05_BASE}.HEAD" ]]; then
    echo "pb05 file not found!"
    exit 1
fi

# Apply the 3dSeg command on the anat_final file
3dSeg -anat "$ANAT_FILE" -mask AUTO

# Move the pb05 files (.HEAD and .BRIK) into Segsy/
mv "${PB05_BASE}.HEAD" Segsy/
mv "${PB05_BASE}.BRIK" Segsy/

# Move to the Segsy directory
cd Segsy/ || { echo "Error navigating to Segsy/"; exit 1; }

# For loop for WM, GM, and CSF
for tissue in WM GM CSF; do
    echo "Starting masking for $tissue"
    value=0
    case $tissue in
        WM)  value=3 ;;
        GM)  value=2 ;;
        CSF) value=1 ;;
    esac

    # Run 3dcalc
    3dcalc -a Classes+tlrc -expr "equals(a,$value)" -prefix "mask_${ID_PREFIX}${tissue}"

    # Run 3dresample
    3dresample -master "$PB05_BASE" -inset "mask_${ID_PREFIX}${tissue}+tlrc" -prefix "mask_epi_${ID_PREFIX}${tissue}"

    # Run 3dmaskave and save the output
    3dmaskave -mask "mask_epi_${ID_PREFIX}${tissue}+tlrc" "$PB05_BASE" > "${ID_PREFIX}${tissue}_ave.txt"
done

# Create directories for ave_signals and masks if they don't exist
mkdir -p ../ave_signals
mkdir -p ../masks

# Move the ave.txt files to ave_signals and masks to masks
for tissue in WM GM CSF; do
    mv "${ID_PREFIX}${tissue}_ave.txt" ../ave_signals/
    mv "mask_${ID_PREFIX}${tissue}+tlrc.HEAD" ../masks/
    mv "mask_${ID_PREFIX}${tissue}+tlrc.BRIK.gz" ../masks/
    mv "mask_epi_${ID_PREFIX}${tissue}+tlrc.HEAD" ../masks/
    mv "mask_epi_${ID_PREFIX}${tissue}+tlrc.BRIK.gz" ../masks/
done

# Move the pb05 files back to the original directory
mv "${PB05_BASE}.HEAD" ../
mv "${PB05_BASE}.BRIK" ../

# Return to the original directory
cd ..

