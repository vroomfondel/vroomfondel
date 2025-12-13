#!/bin/bash

cd $(dirname $0)
if [ $? -ne 0 ] ; then
	echo failed to change dir to $(dirname $0)
	exit 123
fi

outdir=$(realpath ../render.local)
if ! [ -e "${outdir}" ] ; then
  mkdir ${outdir}
fi
echo outdir: $outdir

source ./include.sh


# https://github.com/lowlighter/metrics/blob/master/source/plugins/core/README.md
CONFIG_OUPUT=svg
# CONFIG_OUPUT=json
# CONFIG_OUPUT=svg
# CONFIG_OUPUT=png
#CONFIG_OUPUT=insights

# https://github.com/lowlighter/metrics/blob/master/source/plugins/base/README.md
# base_indepth
# repositories_affiliations owner,collaborator,organization_member
# commits_authoring
# https://github.com/lowlighter/metrics/blob/master/source/plugins/languages/README.md
# --env INPUT_PLUGIN_LANGUAGES=no \
# --env INPUT_PLUGIN_LANGUAGES_IGNORED="html, css"
# --env INPUT_PLUGIN_LANGUAGES_SECTIONS="most-used,recently-used" \

# for PDF: some more options need to be placed:
# CONFIG_OUPUT=markdown-pdf
# INPUT_MARKDOWN=TEMPLATENAME.md
# INPUT_CONFIG_BASE64=yes

RENDEREDFILE=${outdir}/github-metrics.${CONFIG_OUPUT}

if [ -e "${RENDEREDFILE}" ] ; then
  rm "${RENDEREDFILE}" -vf
fi

docker run --rm \
  --env INPUT_TOKEN=${GITHUB_TOKEN} \
  --env INPUT_USER=${GITHUB_USERNAME} \
  --env INPUT_TEMPLATE=classic \
  --env INPUT_BASE="header,activity,community,repositories,metadata" \
  --env INPUT_CONFIG_TIMEZONE="Europe/Berlin" \
  --env INPUT_BASE_INDEPTH=yes \
  --env INPUT_REPOSITORIES_AFFILIATIONS=owner \
  --env INPUT_PLUGIN_LANGUAGES=yes \
  --env INPUT_PLUGIN_LANGUAGES_INDEPTH=yes \
  --env INPUT_PLUGIN_LANGUAGES_IGNORED="html, css" \
  --env INPUT_PLUGIN_LANGUAGES_RECENT_LOAD=400 \
  --env INPUT_PLUGIN_LANGUAGES_RECENT_DAYS=73 \
  --env INPUT_CONFIG_OUTPUT=${CONFIG_OUPUT} \
  --volume=${outdir}:/renders \
  ghcr.io/lowlighter/metrics:latest

if [ -e "${RENDEREDFILE}" ] ; then
  cd .. && git pull && \
  cp "${RENDEREDFILE}" . -v && \
  git commit github-metrics.${CONFIG_OUPUT} -m "updated metrics from $(hostname)" -m "[skip actions]" && \
  git push
else
  echo creating ${RENDEREDFILE} seemingly failed.
fi


