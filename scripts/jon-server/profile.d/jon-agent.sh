#!/usr/bin/env bash
export RHQ_JAVA_HOME="/usr/lib/jvm/jre"
export RHQ_AGENT_USER="jon"
export RHQ_AGENT_HOME="/apps/jon/rhq-agent"
export RHQ_AGENT_START_COMMAND="su -m ${RHQ_AGENT_USER} -c '${RHQ_AGENT_HOME}/bin/rhq-agent.sh'"
export RHQ_AGENT_ADDITIONAL_JAVA_OPTS="-Djava.util.prefs.userRoot=${RHQ_AGENT_HOME}"
export RHQ_CONTROL_ADDITIONAL_JAVA_OPTS="-Djava.util.prefs.userRoot=${RHQ_AGENT_HOME}"
