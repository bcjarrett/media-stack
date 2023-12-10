{{/*
Expand the name of the chart.
*/}}
{{- define "media-stack.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "media-stack.app.name" -}}
{{- $name := default "" .name }}
{{- $baseName := default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- printf "%s-%s" $baseName $name }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "media-stack.fullname" -}}
{{- if .Values.global.fullnameOverride }}
{{- .Values.global.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{- define "media-stack.app.fullname" -}}
{{- $name := default "" .name }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "media-stack.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "media-stack.labels" -}}
{{- $name := .name }}
helm.sh/chart: {{ include "media-stack.chart" . }}
{{ include "media-stack.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{- define "media-stack.selectorLabels" -}}
{{- $name := .name }}
app.kubernetes.io/name: {{ include "media-stack.name" . }}
app.kubernetes.io/app-name: {{ include "media-stack.app.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "media-stack.serviceAccountName" -}}
{{- if .Values.global.serviceAccount.create }}
{{- default (include "media-stack.fullname" .) .Values.global.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.global.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
See related Helm3 issues:
- https://github.com/openshift/origin/issues/24060
- https://github.com/helm/helm/issues/6830
*/}}
{{- define "chart.helmRouteFix" -}}
status:
  ingress:
    - host: ""
{{- end -}}

{{- define "media-stack.apps" -}}
bazarr,jackett,overseerr,radarr,sonarr
{{- end }}

{{/*
Generate a list of keys where `enabled` is true.
*/}}
{{- define "media-stack.enabledApps" -}}
{{- $enabledList := list }}
{{- $apps := include "media-stack.apps" . | splitList "," }}
{{- range $app := $apps }}
  {{- $appValues := index $.Values $app }}
  {{- if eq $appValues.enabled true }}
    {{- $enabledList = append $enabledList $app }}
  {{- end }}
{{- end }}
{{- $enabledList | join "," }}
{{- end }}


{{- define "media-stack.app.host"}}
{{- $name := .name }}
{{- if eq .Values.global.route.enabled true }}
{{- printf "%s.%s" $name .Values.global.route.host }}
{{- end }}
{{- if eq .Values.global.ingress.enabled true }}
{{- printf "%s.%s" $name .Values.global.ingress.host }}
{{- end}}
{{- end }}

{{/*
Extend NFS path and return the entire NFS dictionary
*/}}
{{- define "media-stack.extendNfsPath" -}}
{{- $nfs := .Values.global.mediaStorage.nfs -}}
{{- $newPath := printf "%s%s" $nfs.path .appendPath -}}
{{- $newNfs := dict "server" $nfs.server "path" $newPath -}}
{{- dict "nfs" $newNfs -}}
{{/*{{- toYaml (dict "nfs" $newNfs) -}}*/}}
{{- end -}}
