#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: Workflow

inputs:
   script_environment: File
   script_processfiles: File
   script_transferfiles: File
   script_extractnc: File
   script_make_tracks: File
   script_xml2ascii: File
   script_postprocess: File

outputs:
    results:
        type: Directory
        outputSource: postprocess/output

steps:
  create_environment:
    run: env_preparation.cwl
    in:
      script: script_environment
    out: [output]
  
  processfiles:
    run: processfiles.cwl
    in:
      script: script_processfiles
      cyclon: create_environment/output
    out: [output]
  
  transferfiles:
    run: transferfiles.cwl
    in:
      script: script_transferfiles
      cyclon: processfiles/output
    out: [output]

  extractnc:
    run: extractnc.cwl
    in:
      script: script_extractnc
      cyclon: transferfiles/output
    out: [output]

  make_tracks:
    run: make_tracks.cwl
    in:
      script: script_make_tracks
      cyclon: extractnc/output
    out: [output]

  xml2ascii:
    run: xml2ascii.cwl
    in:
      script: script_xml2ascii
      cyclon: make_tracks/output
    out: [output]

  postprocess:
    run: postprocess.cwl
    in:
      script: script_postprocess
      cyclon: xml2ascii/output
    out: [output]
