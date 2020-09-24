#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool
requirements:
  EnvVarRequirement:
    envDef:
      TRACKDIR: $(runtime.outdir)/cyclone_workflow*
      RESULTSDIR: $(runtime.outdir)/cyclone_workflow*/output/data/results

  InitialWorkDirRequirement:
    listing:
      - entry: $(inputs.cyclone_workflow)
        writable: true


baseCommand: [sh]
inputs:
- id: script
  type: File
  inputBinding:
    position: 0
- id: cyclone_workflow
  type: Directory

outputs:
  output:
    type: Directory
    outputBinding:
        glob: "cyclone_workflow_*"
        

