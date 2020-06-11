#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool
requirements:
  EnvVarRequirement:
    envDef:
      TRACKDIR: $(runtime.outdir)/cyclon
      RESULTSDIR: $(runtime.outdir)/cyclon/results/data/results

  InitialWorkDirRequirement:
    listing:
      - entry: $(inputs.cyclon)
        writable: true


baseCommand: [sh]
inputs:
- id: script
  type: File
  inputBinding:
    position: 0
- id: cyclon
  type: Directory

outputs:
  output:
    type: Directory
    outputBinding:
        glob: "cyclon"

