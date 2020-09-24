#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: Workflow

requirements:
  ScatterFeatureRequirement: {}

inputs:
   script_environment: File
   script_processfiles: File
   script_transferfiles: File
   script_extractnc: File
   script_make_tracks: File
   script_xml2ascii: File
   script_postprocess: File
   script_plots: File
   inputfile_array: File[]

outputs:
    output:
        type: Directory
        outputSource: plots/output

steps:
  create_environment:
    run: env_preparation.cwl
    scatter: inputfile
    in:
      script: script_environment
      inputfile: inputfile_array
    out: [output]

  processfiles:
    run: processfiles.cwl
    scatter: cyclone_workflow
    in:
      script: script_processfiles
      cyclone_workflow: create_environment/output
    out: [output]

  transferfiles:
    run: transferfiles.cwl
    scatter: cyclone_workflow
    in:
      script: script_transferfiles
      cyclone_workflow: processfiles/output
    out: [output]

  extractnc:
    run: extractnc.cwl
    scatter: cyclone_workflow
    in:
      script: script_extractnc
      cyclone_workflow: transferfiles/output
    out: [output]

  make_tracks:
    run: make_tracks.cwl
    scatter: cyclone_workflow
    in:
      script: script_make_tracks
      cyclone_workflow: extractnc/output
    out: [output]

  xml2ascii:
    run: xml2ascii.cwl
    scatter: cyclone_workflow
    in:
      script: script_xml2ascii
      cyclone_workflow: make_tracks/output
    out: [output]

  postprocess:
    run: postprocess.cwl
    scatter: cyclone_workflow
    in:
      script: script_postprocess
      cyclone_workflow: xml2ascii/output
    out: [output]

  plots:
    run: plots.cwl
    in:
      script: script_plots
      cyclone_workflow: postprocess/output
    out: [output]
