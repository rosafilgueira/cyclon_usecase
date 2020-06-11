#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool
requirements:
  EnvVarRequirement:
    envDef:
      TRACKDIR: $(runtime.outdir)/cyclon
      WORKDIR: $(runtime.outdir)/cyclon/results
      DATADIR: $(runtime.outdir)/cyclon/results/data

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

